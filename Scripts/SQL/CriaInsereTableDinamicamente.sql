ALTER PROC CriaTableTipo
AS
IF OBJECT_ID('dbo.Tipo','U') IS NOT NULL
	DROP TABLE dbo.Tipo


DECLARE
	 @count INT = 1
	,@columns VARCHAR(MAX) = 'INSERT INTO Tipo('
	,@values VARCHAR(MAX) = 'VALUES('
	,@SQL VARCHAR(MAX) = ''
	,@create VARCHAR(MAX) = 'CREATE TABLE Tipo('

-- CRIA A TABELA	
BEGIN
	WHILE @COUNT <= (SELECT MAX(ID) FROM PIV)
	BEGIN
		SET @create = @create+'Coluna'+CAST(@count AS VARCHAR(30))+' VARCHAR(255)'+','
		SET @count = @count + 1
	END	
	SET @create = (SELECT SUBSTRING(@create,1,LEN(@create)-1)+')')
	
	EXEC (@create)
END
SET @count = 1

-- INSERE OS DADOS
BEGIN
	WHILE @count <= (SELECT MAX(ID) FROM PIV)
	BEGIN
		SET @values = @values +''''+ (SELECT CAST((SELECT TOP 1 RTRIM(LTRIM(COLUNA1)) FROM PIV WHERE ID=@count)AS VARCHAR))+''''+','
		SET @columns = @columns + 'Coluna' + CAST(@count AS VARCHAR)+','
		SET @count = @count + 1
	END
	SET @columns = (SELECT SUBSTRING(@columns,1,LEN(@columns)-1)+')')
	SET	@values = (SELECT SUBSTRING(@values,1,LEN(@values)-1)+')')
	SET @SQL = @SQL + @columns + @values

	EXEC (@SQL)
END



