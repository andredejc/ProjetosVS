SELECT * FROM [csvFinal02] WHERE Concurso = 1
SELECT * FROM csvFinal WHERE Concurso = 1

-----------------------------------------------------------

DECLARE @cont INT = 1

WHILE(@cont <= (SELECT COUNT(*) FROM csvFinal))
BEGIN
	DECLARE @conc INT = @cont, @1 INT ,@data VARCHAR(100),@2  INT,@3  INT,@4  INT,@5  INT,@6  INT,@7  INT,@8  INT,@9  INT,@10  INT,@11  INT,@12  INT,@13  INT,@14  INT,@15 INT
	
	DECLARE cur CURSOR FOR
	SELECT *
	FROM(
		SELECT ROW_NUMBER() OVER(ORDER BY B1) AS Linha,*
		FROM(
            SELECT Concurso, Data, B1 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                           
			SELECT Concurso, Data, B2 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                           
			SELECT Concurso, Data, B3 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                           
			SELECT Concurso, Data, B4 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                     
			SELECT Concurso, Data, B5 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                     
			SELECT Concurso, Data, B6 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                     
			SELECT Concurso, Data, B7 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                     
			SELECT Concurso, Data, B8 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                     
			SELECT Concurso, Data, B9 FROM csvFinal WHERE Concurso =  @conc
			UNION  ALL                     
			SELECT Concurso, Data, B10 FROM csvFinal WHERE Concurso = @conc
			UNION  ALL                     
			SELECT Concurso, Data, B11 FROM csvFinal WHERE Concurso = @conc
			UNION  ALL                     
			SELECT Concurso, Data, B12 FROM csvFinal WHERE Concurso = @conc
			UNION  ALL                     
			SELECT Concurso, Data, B13 FROM csvFinal WHERE Concurso = @conc
			UNION  ALL                     
			SELECT Concurso, Data, B14 FROM csvFinal WHERE Concurso = @conc
			UNION  ALL                     
			SELECT Concurso, Data, B15 FROM csvFinal WHERE Concurso = @conc
		) AS A	
	) AS A
	PIVOT(MAX(B1) FOR Linha IN([1] ,[2] ,[3] ,[4] ,[5] ,[6] ,[7] ,[8] ,[9] ,[10] ,[11] ,[12] ,[13] ,[14] ,[15])) AS _Pivot

	OPEN cur
	FETCH NEXT FROM cur INTO @Conc, @data, @1 ,@2 ,@3 ,@4 ,@5 ,@6 ,@7 ,@8 ,@9 ,@10 ,@11 ,@12 ,@13 ,@14 ,@15
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [csvFinal02]([Concurso],[Data],[B1],[B2],[B3],[B4],[B5],[B6],[B7],[B8],[B9],[B10],[B11],[B12],[B13],[B14],[B15])
		VALUES(@Conc, @data, @1 ,@2 ,@3 ,@4 ,@5 ,@6 ,@7 ,@8 ,@9 ,@10 ,@11 ,@12 ,@13 ,@14 ,@15)          
		
		FETCH NEXT FROM cur INTO @Conc, @data, @1 ,@2 ,@3 ,@4 ,@5 ,@6 ,@7 ,@8 ,@9 ,@10 ,@11 ,@12 ,@13 ,@14 ,@15
	END
	CLOSE cur
	DEALLOCATE cur
	
	SET @cont += 1
END
