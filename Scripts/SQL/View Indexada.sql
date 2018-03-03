USE AdventureWorks; 
GO--Set the options to support indexed views. 

SET NUMERIC_ROUNDABORT OFF; 
SET ANSI_PADDING, ANSI_WARNINGS, 
CONCAT_NULL_YIELDS_NULL, 
ARITHABORT, 
QUOTED_IDENTIFIER, 
ANSI_NULLS ON; 
GO 
--Create view with schemabinding. 
IF OBJECT_ID ('TesteSCHEMA', 'view') IS NOT NULL DROP VIEW TesteSCHEMA; 
GO 
CREATE VIEW TesteSCHEMA WITH SCHEMABINDING 
AS
	SELECT 
		A.SalesOrderID,
		A.ProductID,
		A.UnitPrice,
		B.Name
	FROM Sales.SalesOrderDetail AS A
		INNER JOIN Production.Product AS B
			ON A.ProductID = B.ProductID 

GO 
--Create an index on the view. 
CREATE UNIQUE CLUSTERED INDEX IDX_V1 ON TesteSCHEMA(SalesOrderID, ProductID);
GO 

--This query can use the indexed view even though the view is --not specified in the FROM clause. 
SELECT 
	SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev, 
	OrderDate, ProductID 
FROM Sales.SalesOrderDetail 
	AS od JOIN Sales.SalesOrderHeader AS o 
		ON od.SalesOrderID=o.SalesOrderID 
		AND ProductID BETWEEN 700 and 800 
		AND OrderDate >= CONVERT(datetime,'05/01/2002',101) 
GROUP BY OrderDate, ProductID 
ORDER BY Rev DESC; 
GO 

--This query can use the above indexed view. 
SELECT  
	OrderDate, 
	SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev 
FROM Sales.SalesOrderDetail AS od 
	JOIN Sales.SalesOrderHeader AS o 
	ON od.SalesOrderID=o.SalesOrderID 
	AND DATEPART(mm,OrderDate)= 3 
	AND DATEPART(yy,OrderDate) = 2002 
GROUP BY OrderDate 
ORDER BY OrderDate ASC; 
GO
