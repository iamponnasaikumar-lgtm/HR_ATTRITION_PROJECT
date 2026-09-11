
-- HR ATTRITION PROJECT
-- PART B - MYSQL ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================
-- Creates a new database named hr_attrition.
-- This database will store the HR employee attrition data.

CREATE DATABASE hr_attrition;


-- ============================================================
-- 2. SHOW DATABASES
-- ============================================================
-- Displays all databases available in MySQL.
-- Used to verify that hr_attrition was created successfully.

SHOW DATABASES;


-- ============================================================
-- 3. SELECT THE DATABASE
-- ============================================================
-- Makes hr_attrition the active database.
-- All tables created after this command will be created
-- inside the hr_attrition database.

USE hr_attrition;


-- ============================================================
-- 4. SHOW TABLES
-- ============================================================
-- Displays all tables currently available in the selected
-- hr_attrition database.

SHOW TABLES;


-- ============================================================
-- 5. CREATE HR CLEAN TABLE
-- ============================================================
-- Creates a table named hr_clean to store the cleaned HR data.
--
-- EmployeeID      : Unique employee identifier and Primary Key
-- Age             : Employee age
-- Gender          : Employee gender
-- Department      : Employee department
-- JobRole         : Employee job role
-- MonthlyIncome   : Employee monthly salary/income
-- YearsAtCompany  : Number of years employee has worked
-- JobSatisfaction : Job satisfaction score
-- OverTime        : Whether employee works overtime
-- Attrition       : Whether employee left the organization
-- AttriationFlag   : 1 = Left, 0 = Active
-- TenureGroup     : Employee tenure category
-- IncomeGroup     : Employee income category
-- EstimatedAttritionCost : Estimated cost associated with
--                          employee attrition

CREATE TABLE hr_clean(
    EmployeeID int primary key,
    Age int,
    Gender varchar(20),
    Department varchar(100),
    JobRole varchar(100),
    MonthlyIncome decimal(10,2),
    YearsAtCompany int,
    JobSatisfaction int,
    OverTime varchar(10),
    Attrition varchar(5),
    AttriationFlag tinyint,
    TenureGroup varchar(20),
    IncomeGroup varchar(20),
    EstimatedAttritionCost decimal(12,2)
);


-- ============================================================
-- 6. VERIFY TABLE CREATION
-- ============================================================
-- Displays the tables in the database.
-- Used to confirm that hr_clean was created successfully.

SHOW TABLES;


-- ============================================================
-- 7. IMPORT CSV FILE INTO MYSQL
-- ============================================================
-- Loads the cleaned CSV file into the hr_clean table.
--
-- LOCAL INFILE allows MySQL to read a file from the local
-- computer.
--
-- FIELDS TERMINATED BY ',' means columns are separated by
-- commas.
--
-- ENCLOSED BY '"' means text values may be enclosed in
-- double quotation marks.
--
-- LINES TERMINATED BY '\n' means each row ends with a new line.
--
-- IGNORE 1 ROWS skips the CSV header row because the first
-- row contains column names rather than employee data.

LOAD DATA LOCAL INFILE
"C:\Users\DELL\OneDrive\Music\hr_clean.csv"
INTO TABLE hr_clean
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- 8. ENABLE LOCAL INFILE
-- ============================================================
-- Enables LOCAL INFILE at the MySQL server level.
-- This is required when MySQL blocks local CSV file imports.

SET GLOBAL local_infile = 1;


-- ============================================================
-- 9. CHECK GLOBAL LOCAL_INFILE SETTING
-- ============================================================
-- Checks whether LOCAL INFILE is enabled globally.
--
-- Value 1 = Enabled
-- Value 0 = Disabled

SHOW GLOBAL VARIABLES LIKE 'local_infile';


-- ============================================================
-- 10. CHECK SESSION LOCAL_INFILE SETTING
-- ============================================================
-- Checks whether LOCAL INFILE is enabled for the current
-- MySQL session/connection.

SHOW VARIABLES LIKE 'local_infile';


-- ============================================================
-- 11. CHECK TOTAL IMPORTED ROWS
-- ============================================================
-- Counts the total number of records available in hr_clean.
-- This is used to verify that the CSV data was imported
-- successfully.

SELECT COUNT(*) AS Total_Rows
FROM hr_clean;


-- ============================================================
-- 12. VIEW FIRST 10 RECORDS
-- ============================================================
-- Displays the first 10 employee records.
-- This helps verify that the imported data looks correct.

SELECT *
FROM hr_clean
LIMIT 10;


-- ============================================================
-- 13. TOTAL NUMBER OF EMPLOYEES
-- ============================================================
-- Counts the total number of employees in the dataset.
--
-- COUNT(*) counts every row in the hr_clean table.

SELECT COUNT(*) AS total_employees
FROM hr_clean;


-- ============================================================
-- 14. TOTAL NUMBER OF EMPLOYEES WHO LEFT
-- ============================================================
-- Calculates the number of employees who left the organization.
--
-- AttriationFlag:
-- 1 = Employee left
-- 0 = Employee is active
--
-- SUM() adds all the 1 values and therefore gives the total
-- number of employees who left.

SELECT SUM(AttriationFlag) AS Employees_who_left
FROM hr_clean;


-- ============================================================
-- 15. OVERALL ATTRITION RATE
-- ============================================================
-- Calculates the percentage of employees who left.
--
-- Formula:
--
-- Attrition Rate =
-- (Employees Who Left / Total Employees) × 100
--
-- 100.0 is used so that the calculation produces a decimal
-- percentage.
--
-- ROUND(...,2) rounds the result to two decimal places.

SELECT
    ROUND(
        100.0 * SUM(AttriationFlag) / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM hr_clean;


-- ============================================================
-- 16. ATTRITION RATE BY DEPARTMENT
-- ============================================================
-- Calculates employee attrition separately for each department.
--
-- Department:
-- Groups employees according to their department.
--
-- COUNT(*):
-- Calculates total employees in each department.
--
-- SUM(AttriationFlag):
-- Calculates the number of employees who left in each
-- department.
--
-- Attrition Rate:
-- Calculates the percentage of employees who left from
-- each department.
--
-- ORDER BY DESC:
-- Displays the department with the highest attrition rate
-- first.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(AttriationFlag) AS Employees_Who_Left,
    ROUND(
        100.0 * SUM(AttriationFlag) / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM hr_clean
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;


-- ============================================================
-- 17. ATTRITION RATE BY JOB ROLE
-- ============================================================
-- Calculates employee attrition separately for each job role.
--
-- COUNT(*):
-- Total employees in each job role.
--
-- SUM(AttriationFlag):
-- Total employees who left from each job role.
--
-- Attrition Rate:
-- Percentage of employees who left from each job role.
--
-- ORDER BY DESC:
-- Shows the job role with the highest attrition rate first.

SELECT
    JobRole,
    COUNT(*) AS Total_Employees,
    SUM(AttriationFlag) AS Employees_Who_Left,
    ROUND(
        100.0 * SUM(AttriationFlag) / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM hr_clean
GROUP BY JobRole
ORDER BY Attrition_Rate_Percent DESC;


-- ============================================================
-- 18. ATTRITION RATE BY TENURE GROUP
-- ============================================================
-- Calculates employee attrition according to the employee's
-- tenure in the organization.
--
-- TenureGroup categories:
-- 0-2 years
-- 2-5 years
-- 5+ years
--
-- COUNT(*):
-- Total employees in each tenure group.
--
-- SUM(AttriationFlag):
-- Employees who left in each tenure group.
--
-- Attrition Rate:
-- Percentage of employees who left in each tenure group.
--
-- CASE statement:
-- Keeps the tenure groups in a logical order rather than
-- alphabetical order.

SELECT
    TenureGroup,
    COUNT(*) AS Total_Employees,
    SUM(AttriationFlag) AS Employees_Who_Left,
    ROUND(
        100.0 * SUM(AttriationFlag) / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM hr_clean
GROUP BY TenureGroup
ORDER BY
    CASE TenureGroup
        WHEN '0-2 years' THEN 1
        WHEN '2-5 years' THEN 2
        WHEN '5+ years' THEN 3
        ELSE 4
    END;


-- ============================================================
-- 19. AVERAGE MONTHLY INCOME
--    ATTRITION VS ACTIVE EMPLOYEES
-- ============================================================
-- Compares the average monthly income of employees based on
-- their attrition status.
--
-- Attrition = 'Yes':
-- Employees who left the organization.
--
-- Attrition = 'No':
-- Employees who are still active.
--
-- COUNT(*):
-- Number of employees in each attrition category.
--
-- AVG(MonthlyIncome):
-- Calculates the average monthly income.
--
-- ROUND(...,2):
-- Rounds the average income to two decimal places.

SELECT
    Attrition,
    COUNT(*) AS Employee_Count,
    ROUND(
        AVG(MonthlyIncome),
        2
    ) AS Average_Monthly_Income
FROM hr_clean
GROUP BY Attrition;


-- ============================================================
-- 20. TOTAL ESTIMATED ATTRITION COST
-- ============================================================
-- Calculates the total estimated cost caused by employee
-- attrition.
--
-- EstimatedAttritionCost contains the estimated cost for
-- employees who left.
--
-- WHERE AttriationFlag = 1:
-- Includes only employees who left the organization.
--
-- SUM():
-- Adds the estimated attrition cost for all employees who
-- left.
--
-- ROUND(...,2):
-- Rounds the total cost to two decimal places.

SELECT
    ROUND(
        SUM(EstimatedAttritionCost),
        2
    ) AS Total_Estimated_Attrition_Cost
FROM hr_clean
WHERE AttriationFlag = 1;


-- ============================================================
-- END OF HR ATTRITION SQL ANALYSIS
-- ============================================================