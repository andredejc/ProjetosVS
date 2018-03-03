-- CROSS APPLY X INNER JOIN

-- CROSS APPLY
SELECT 
	A.DepartmentID,
	A.Name,
	B.Total
FROM HumanResources.Department AS A
	CROSS APPLY (SELECT COUNT(B.EmployeeID) AS Total 
				 FROM HumanResources.EmployeeDepartmentHistory AS B
				 WHERE A.DepartmentID = B.DepartmentID) AS B
ORDER BY 2				 				 

-- INNER JOIN
SELECT 
	A.DepartmentID,
	A.Name,
	COUNT(B.EmployeeID)
FROM HumanResources.Department AS A
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS B
	ON A.DepartmentID = B.DepartmentID	
GROUP BY
	A.DepartmentID,
	A.Name	
ORDER BY 2	