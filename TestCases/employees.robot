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
