*** Settings ***
Resource    ../Resources/settings.robot
Resource    ../Resources/variables.robot
Suite Setup    Connect To Database    pymssql    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
Suite Teardown    Disconnect From Database

*** Test Cases ***
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
