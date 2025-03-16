WITH RECURSIVE Subordinates AS (
    SELECT 
        EmployeeID, 
        Name, 
        ManagerID, 
        DepartmentID, 
        RoleID
    FROM 
        Employees
    WHERE 
        EmployeeID = 1
    UNION ALL
    SELECT 
        e.EmployeeID, 
        e.Name, 
        e.ManagerID, 
        e.DepartmentID, 
        e.RoleID
    FROM 
        Employees e
    INNER JOIN 
        Subordinates s 
    ON 
        e.ManagerID = s.EmployeeID
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
    (SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ') 
     FROM Tasks t 
     WHERE t.AssignedTo = s.EmployeeID) AS TaskNames
FROM 
    Subordinates s
JOIN 
    Departments d 
ON 
    s.DepartmentID = d.DepartmentID
JOIN 
    Roles r 
ON 
    s.RoleID = r.RoleID
ORDER BY 
    EmployeeName;