import pytest
import pyodbc
import pymssql
import re
@pytest.fixture(scope='module')
def db_connection():
    # conn = pyodbc.connect(
    #     'DRIVER={ODBC Driver 17 for SQL Server};'
    #     'SERVER=EPGETBIW01C2\SQLEXPRESS;'
    #     'DATABASE=trn;'
    #     'UID=task_4_py;'
    #     'PWD=Z9r!wH@xL1z#vQ80'
    # )
    conn = pymssql.connect(
        server='EPGETBIW01C2\LOCALHOST',  # SQL Server instance
        user='task_4',  # Database username
        password='Z9r!wH@xL1z#vQ8p',  # Database password
        database='trn',  # Database name
        port=55128  # Port number (default for SQL Server is 1433)
    )
    yield conn
    conn.close()


def test_phone_number_validity(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT phone_number FROM hr.employees")
    phone_numbers = cursor.fetchall()

    for phone_number in phone_numbers:
        phone = phone_number[0]

        if phone is None:
            continue

        sanitized_phone = re.sub(r'[^\d+().\s]', '', phone)  # Remove anything that's not a digit, +, (, ), or .

        sanitized_phone = re.sub(r'[^\d]', '', sanitized_phone)  # Keep only digits

        if not sanitized_phone.isdigit():
            pytest.fail(f"Invalid phone number format: {phone} contains letters or unsupported symbols.")


def test_phone_number_uniqueness(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT phone_number, COUNT(*) 
        FROM hr.employees 
        GROUP BY phone_number 
        HAVING COUNT(*) > 1 AND phone_number IS NOT NULL
    """)
    duplicate_numbers = cursor.fetchall()

    if len(duplicate_numbers) > 0:
        pytest.fail(f"Duplicate phone numbers found: {duplicate_numbers}")


def test_department_location_validity(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT location_id 
        FROM hr.departments 
        WHERE location_id NOT IN (SELECT location_id FROM hr.locations)
    """)
    orphan_locations = cursor.fetchall()

    if len(orphan_locations) > 0:
        pytest.fail(f"Orphan location IDs found: {orphan_locations}")


def test_department_location_existence(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT location_id FROM hr.departments WHERE location_id IS NULL")
    missing_locations = cursor.fetchall()

    if len(missing_locations) > 0:
        pytest.fail("Some departments are missing location information.")


def test_country_name_accuracy(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT country_name FROM hr.countries")
    countries = cursor.fetchall()

    for country in countries:
        country_name = country[0]

        # Check if the country name contains only letters and spaces
        if not re.match("^[A-Za-z\s]+$", country_name):
            pytest.fail(f"Invalid country name: {country_name}. It contains non-letter symbols.")


def test_country_id_uniqueness(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT country_id, COUNT(*) 
        FROM hr.countries 
        GROUP BY country_id 
        HAVING COUNT(*) > 1
    """)
    duplicate_country_ids = cursor.fetchall()

    if len(duplicate_country_ids) > 0:
        pytest.fail(f"Duplicate country IDs found: {duplicate_country_ids}")


def run_tests():
    pytest.main([
        "--html=report.html",
        "--maxfail=6",
        "--disable-warnings",
    ])


if __name__ == "__main__":
    run_tests()
