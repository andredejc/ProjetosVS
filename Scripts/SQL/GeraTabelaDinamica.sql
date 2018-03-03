USE [TesteCarga]
GO

ALTER PROC [dbo].[sp_GeraTabelaDinamica](@colunas BIGINT = 0)
AS
-- DROP IF EXISTS
IF OBJECT_ID('dbo.tmp_AttritionDinamica','U') IS NOT NULL
	DROP TABLE dbo.tmp_AttritionDinamica
	
	

DECLARE 
	@str VARCHAR(MAX) = 'CREATE TABLE tmp_AttritionDinamica (',
	@count INT = 1,
	@comando VARCHAR(MAX)
	
BEGIN	

	WHILE @count <= @colunas
	BEGIN
		SET @str = @str+'Coluna'+CAST(@count AS VARCHAR(30))+' VARCHAR(255)'+','
		SET @count = @count + 1
	END	
	SET @comando = (SELECT SUBSTRING(@str,1,LEN(@str)-1)+')')
	--SELECT @comando

	EXEC (@comando);

END

-- DROP IF EXISTS
IF OBJECT_ID('dbo.tmp_AttritionDinamica2','U') IS NOT NULL
	DROP TABLE dbo.tmp_AttritionDinamica2


SET @count = 1
SET @str = 'CREATE TABLE tmp_AttritionDinamica2 ('

BEGIN	

	WHILE @count <= @colunas
	BEGIN
		SET @str = @str+'Coluna'+CAST(@count AS VARCHAR(30))+' VARCHAR(255)'+','
		SET @count = @count + 1
	END	
	SET @comando = (SELECT SUBSTRING(@str,1,LEN(@str)-1)+')')
	--SELECT @comando

	EXEC (@comando);

END



































