WITH RECURSIVE Subordinates AS (
    SELECT 
        EmployeeID, 
        Name, 
        ManagerID, 
        DepartmentID, 
        RoleID,
        0 AS Level
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    SELECT 
        e.EmployeeID, 
        e.Name, 
        e.ManagerID, 
        e.DepartmentID, 
        e.RoleID,
        s.Level + 1
    FROM Employees e
    INNER JOIN Subordinates s 
        ON e.ManagerID = s.EmployeeID
)
SELECT 
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT GROUP_CONCAT(p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') 
     FROM Projects p 
     WHERE p.DepartmentID = s.DepartmentID) AS ProjectNames,
    (SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskID SEPARATOR ', ') 
     FROM Tasks t 
     WHERE t.AssignedTo = s.EmployeeID) AS TaskNames,
    (SELECT COUNT(*) 
     FROM Tasks t 
     WHERE t.AssignedTo = s.EmployeeID) AS TotalTasks,
    (SELECT COUNT(*) 
     FROM Employees e 
     WHERE e.ManagerID = s.EmployeeID) AS TotalSubordinates
FROM Subordinates s
JOIN Departments d 
    ON s.DepartmentID = d.DepartmentID
JOIN Roles r 
    ON s.RoleID = r.RoleID
ORDER BY s.Name;