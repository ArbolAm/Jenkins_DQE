*** Settings ***
Resource    ../Resources/settings.robot
Resource    ../Resources/variables.robot
Suite Setup    Connect To Database    pymssql    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
Suite Teardown    Disconnect From Database

*** Test Cases ***
Check Employee Email Uniqueness
    [Documentation]    Check that employee emails are unique.
    ${query}=    Set Variable    SELECT email, count(*) FROM hr.employees GROUP BY email HAVING COUNT(*) > 1
    ${emails}=    DatabaseLibrary.Query  ${query}
    Should Be Empty    ${emails}    There are duplicate emails.

Check Employee Hire Date Validity
    [Documentation]    Check if the employee hire date is valid.
    ${query}=    Set Variable    SELECT hire_date FROM hr.employees WHERE hire_date NOT LIKE '____-__-__'
    ${hire_dates}=    DatabaseLibrary.Query  ${query}
    Should Be Empty  ${hire_dates}  All hire date is valid

Check Postal Code Existence
    [Documentation]    Ensure every location has a postal code.
    ${query}=    Set Variable    SELECT postal_code FROM hr.locations WHERE postal_code IS NULL
    ${missing_postal_codes}=    DatabaseLibrary.Query  ${query}
    Should Be Empty    ${missing_postal_codes}    Some locations are missing postal codes.

Check Country ID Validity
    [Documentation]    Ensure country_id is in expected 2 uppercase letter format.
    ${query}=    Set Variable    SELECT country_id FROM hr.locations
    ${country_ids}=    DatabaseLibrary.Query  ${query}
    FOR    ${country_id}    IN    @{country_ids}
        Should Match Regexp    ${country_id}[0]    ^[A-Z]{2}$
    END

Check Job Min Salary Accuracy
    [Documentation]    Ensure job minimum salary is in a logical range.
    ${query}=    Set Variable    SELECT min_salary FROM hr.jobs WHERE min_salary NOT BETWEEN 0 AND 100000
    ${min_salaries}=    DatabaseLibrary.Query  ${query}
    Should Be Empty    ${min_salaries}    Min salaries are accurate.

Check Min-Max Salary Consistency
    [Documentation]    Ensure min salary is less than max salary.
    ${query}=    Set Variable    SELECT min_salary, max_salary FROM hr.jobs WHERE min_salary > max_salary
    ${salaries}=    DatabaseLibrary.Query  ${query}
    Should Be Empty    ${salaries}  Min & Max salaries are consistent