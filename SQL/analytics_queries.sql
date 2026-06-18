USE hr_analytics_dashboard;

-- 1. Executive KPIs
SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS ActiveEmployees,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate,
    ROUND(AVG(Salary), 2) AS AverageSalary
FROM employees;

-- 2. Employees by Department
SELECT d.Department, COUNT(e.EmployeeID) AS Employees
FROM employees e
JOIN departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Department
ORDER BY Employees DESC;

-- 3. Attrition by Department
SELECT d.Department,
       COUNT(e.EmployeeID) AS TotalEmployees,
       SUM(CASE WHEN e.Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN e.Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.EmployeeID), 2) AS AttritionRate
FROM employees e
JOIN departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Department
ORDER BY AttritionRate DESC;

-- 4. Attendance Rate by Department
SELECT d.Department,
       ROUND(SUM(CASE WHEN a.Status='Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.AttendanceID), 2) AS AttendanceRate
FROM attendance a
JOIN employees e ON a.EmployeeID = e.EmployeeID
JOIN departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Department
ORDER BY AttendanceRate DESC;

-- 5. Average Performance by Department
SELECT d.Department, ROUND(AVG(p.PerformanceRating),2) AS AvgPerformanceRating
FROM performance p
JOIN employees e ON p.EmployeeID = e.EmployeeID
JOIN departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Department
ORDER BY AvgPerformanceRating DESC;

-- 6. Top Attrition Reasons
SELECT ar.AttritionReason, COUNT(*) AS EmployeesLeft
FROM attrition_reasons ar
GROUP BY ar.AttritionReason
ORDER BY EmployeesLeft DESC;

-- 7. High Risk Employees Logic Base
SELECT e.EmployeeID, e.EmployeeName, d.Department, e.JobRole, e.Salary,
       p.PerformanceRating, p.TrainingHours,
       ROUND(SUM(CASE WHEN a.Status='Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.AttendanceID),2) AS AttendanceRate
FROM employees e
JOIN departments d ON e.DepartmentID = d.DepartmentID
JOIN performance p ON e.EmployeeID = p.EmployeeID
JOIN attendance a ON e.EmployeeID = a.EmployeeID
GROUP BY e.EmployeeID, e.EmployeeName, d.Department, e.JobRole, e.Salary, p.PerformanceRating, p.TrainingHours
HAVING AttendanceRate < 85 OR p.PerformanceRating < 3
ORDER BY AttendanceRate ASC, p.PerformanceRating ASC;

-- 8. Promotion Candidates
SELECT e.EmployeeID, e.EmployeeName, d.Department, e.JobRole, p.PerformanceRating, p.TrainingHours
FROM employees e
JOIN departments d ON e.DepartmentID = d.DepartmentID
JOIN performance p ON e.EmployeeID = p.EmployeeID
WHERE e.Attrition='No' AND p.PerformanceRating >= 4.5 AND p.TrainingHours >= 25
ORDER BY p.PerformanceRating DESC, p.TrainingHours DESC;
