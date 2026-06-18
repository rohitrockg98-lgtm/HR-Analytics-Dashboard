CREATE DATABASE IF NOT EXISTS hr_analytics_dashboard;
USE hr_analytics_dashboard;

DROP TABLE IF EXISTS attrition_reasons;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS performance;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    Department VARCHAR(100) NOT NULL,
    Manager VARCHAR(100),
    Location VARCHAR(100)
);

CREATE TABLE employees (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    EmployeeName VARCHAR(120) NOT NULL,
    Gender VARCHAR(20),
    Age INT,
    DepartmentID VARCHAR(10),
    JobRole VARCHAR(120),
    HireDate DATE,
    Salary DECIMAL(12,2),
    Attrition VARCHAR(10),
    FOREIGN KEY (DepartmentID) REFERENCES departments(DepartmentID)
);

CREATE TABLE attendance (
    AttendanceID VARCHAR(20) PRIMARY KEY,
    EmployeeID VARCHAR(10),
    AttendanceDate DATE,
    Status VARCHAR(20),
    WorkingHours DECIMAL(4,1),
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);

CREATE TABLE performance (
    PerformanceID VARCHAR(20) PRIMARY KEY,
    EmployeeID VARCHAR(10),
    ReviewYear INT,
    PerformanceRating DECIMAL(3,1),
    PromotionStatus VARCHAR(30),
    TrainingHours INT,
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);

CREATE TABLE attrition_reasons (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    AttritionReason VARCHAR(150),
    FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID)
);
