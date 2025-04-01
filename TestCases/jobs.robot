*** Settings ***
Resource    ../Resources/settings.robot
Resource    ../Resources/variables.robot
Suite Setup    Connect To Database    pymssql    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
Suite Teardown    Disconnect From Database

*** Test Cases ***
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
