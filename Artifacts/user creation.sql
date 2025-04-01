CREATE LOGIN task_4 WITH PASSWORD = 'Z9r!wH@xL1z#vQ8p';

CREATE LOGIN task_4_py WITH PASSWORD = 'Z9r!wH@xL1z#vQ80';

USE TRN;

CREATE ROLE trn_hr_select;

GRANT SELECT ON SCHEMA::hr TO trn_hr_select;

CREATE USER robot_user FOR LOGIN task_4;

CREATE USER pytest_user FOR LOGIN task_4_py;

ALTER ROLE trn_hr_select ADD MEMBER robot_user;

ALTER ROLE trn_hr_select ADD MEMBER pytest_user;

