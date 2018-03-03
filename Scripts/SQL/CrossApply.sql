/*
CREATE TABLE Teste01
(
	id UNIQUEIDENTIFIER DEFAULT NEWID(),
	num INT
)

CREATE TABLE Teste02
(
	id VARCHAR(36),
	num INT
)

DECLARE @INT INT = 1
WHILE @INT <= 10
BEGIN
	INSERT INTO Teste01(num)  VALUES(@INT)
	SET @INT += 1
END

INSERT INTO Teste02(num) VALUES(1),(3),(4),(8)

INSERT INTO Teste02(id,num) VALUES(NEWID(),11),(NEWID(),12)

UPDATE A
SET A.id = B.id
FROM Teste02 AS A
	INNER JOIN Teste01 AS B
	ON A.num = B.num

*/


SET STATISTICS IO ON

SELECT *
FROM Teste01 AS A
	LEFT JOIN Teste02 AS B
	ON A.num = B.num	
	
SELECT *
FROM Teste01 AS A
OUTER APPLY (SELECT * FROM Teste02 AS B WHERE A.num = B.num) AS B


IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id(N'dbo.fn_TesteCross') AND type IN (N'IF'))
BEGIN 
	DROP FUNCTION dbo.fn_TesteCross 
END
GO

CREATE FUNCTION dbo.fn_TesteCross(@num AS INT)
RETURNS TABLE AS
RETURN 
(
	SELECT *
	FROM Teste02 AS A 
	WHERE A.num = @num	
)
GO

SELECT *
FROM Teste01 AS A
CROSS APPLY dbo.fn_TesteCross(A.num)


