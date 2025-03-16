WITH RECURSIVE ManagerSubordinates AS (
    SELECT 
        EmployeeID AS ManagerID,
        EmployeeID AS SubordinateID
    FROM Employees
    WHERE RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Менеджер')
    
    UNION ALL
    
    SELECT 
        ms.ManagerID,
        e.EmployeeID AS SubordinateID
    FROM Employees e
    INNER JOIN ManagerSubordinates ms 
        ON e.ManagerID = ms.SubordinateID
)
SELECT 
    m.EmployeeID,
    m.Name AS EmployeeName,
    m.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT GROUP_CONCAT(p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') 
     FROM Projects p 
     WHERE p.DepartmentID = m.DepartmentID) AS ProjectNames,
    (SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskID SEPARATOR ', ') 
     FROM Tasks t 
     WHERE t.AssignedTo = m.EmployeeID) AS TaskNames,
    COUNT(DISTINCT ms.SubordinateID) - 1 AS TotalSubordinates
FROM Employees m
JOIN Departments d ON m.DepartmentID = d.DepartmentID
JOIN Roles r ON m.RoleID = r.RoleID
LEFT JOIN ManagerSubordinates ms ON m.EmployeeID = ms.ManagerID
WHERE r.RoleName = 'Менеджер'
GROUP BY m.EmployeeID, m.Name, m.ManagerID, d.DepartmentName, r.RoleName
HAVING TotalSubordinates > 0
ORDER BY m.Name;