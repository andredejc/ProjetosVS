ALTER PROCEDURE sp_Split(
	@string NVARCHAR(MAX),
	@delimiter NCHAR(1)
)
AS

SET NOCOUNT ON
BEGIN

	IF OBJECT_ID('tempdb..#Colunas','U') IS NOT NULL BEGIN DROP TABLE #Colunas END
	CREATE TABLE #Colunas(id INT IDENTITY(1,1),coluna NVARCHAR(60))

	DECLARE @split NVARCHAR(200) = '',	
			@count INT,
			@incr INT = 1,
			@index INT,
			@indexAnt INT,
			@i INT = 1	

	SET @count = LEN(@string)

	INSERT INTO #Colunas(coluna) VALUES( SUBSTRING(@string,1,CHARINDEX(@delimiter,@string)) )

	WHILE @incr <= @count BEGIN

		SET @split = SUBSTRING(@string,@incr,1)	

		IF @delimiter = @split BEGIN
			SET @indexAnt = @index
			SET @index = @incr
			INSERT INTO #Colunas(coluna) VALUES(SUBSTRING(@string,@indexAnt + 1,@i))		
			SET @i = 0
		END

		SET @incr += 1
		SET @i += 1
	END

	INSERT INTO #Colunas(coluna) VALUES( REVERSE(SUBSTRING(REVERSE(@string),1,CHARINDEX(@delimiter,REVERSE(@string)))) )

	UPDATE #Colunas
	SET coluna = REPLACE(coluna,@delimiter,'')

	DELETE FROM #Colunas WHERE coluna IS NULL

	SELECT coluna FROM #Colunas

	IF OBJECT_ID('tempdb..#Colunas','U') IS NOT NULL BEGIN DROP TABLE #Colunas END

END