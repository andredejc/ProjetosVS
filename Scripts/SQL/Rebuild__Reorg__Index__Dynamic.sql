DECLARE 
	@Tabela NVARCHAR(100),
	@Fragmentacao FLOAT,
	@Indice VARCHAR(100),
	@Sql VARCHAR(8000),
	@Relatorio VARCHAR(8000) = ''

DECLARE CurTabelas CURSOR FOR
SELECT name
FROM sys.tables
WHERE name LIKE 'tbBR_tab_AUTO_%'
OR name LIKE 'tbBR_tab_RE_%'
OR name LIKE 'tbBR_tab_NASA_%'
OR name LIKE 'tbBR_tab_VisaoUnica%'
AND name NOT LIKE 'tbBR_tab_NASA_Tel%'

OPEN CurTabelas
FETCH NEXT FROM CurTabelas INTO @Tabela

WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE CurRebuildReorg CURSOR FOR
	SELECT 
		B.name, 
		A.avg_fragmentation_in_percent  
	FROM sys.dm_db_index_physical_stats (DB_ID(N'dbBR_BARE'), OBJECT_ID(@Tabela), NULL, NULL, NULL) AS A  
		INNER JOIN sys.indexes AS B 
			ON A.object_id = B.object_id 
			AND A.index_id = B.index_id
	WHERE A.avg_fragmentation_in_percent >= 5.0
	AND index_type_desc != 'HEAP'
			
	OPEN CurRebuildReorg
	FETCH NEXT FROM CurRebuildReorg INTO @Indice, @Fragmentacao
			
	WHILE @@FETCH_STATUS = 0
	BEGIN			
		IF @Fragmentacao BETWEEN 5.0 AND  30.0 	
		BEGIN
		
			SET @Sql = 'ALTER INDEX ' + @Indice  + ' ON ' + QUOTENAME(@Tabela) + ' REORGANIZE'		
			
			SET @Relatorio += @Tabela + ' || ' + @Indice + ' -- ' + CAST(@Fragmentacao AS VARCHAR(15)) + CHAR(13)						
			
			EXECUTE ( @Sql );					
			
		END
		ELSE IF @Fragmentacao >= 30.0
		BEGIN
		
			SET @Sql = 'ALTER INDEX ' + @Indice  + ' ON ' + QUOTENAME(@Tabela) + ' REBUILD'	
			
			SET @Relatorio += @Tabela + ' || ' + @Indice + ' -- ' + CAST(@Fragmentacao AS VARCHAR(15)) + CHAR(13)						
				
			EXECUTE ( @Sql );				
			
		END	
		
		FETCH NEXT FROM CurRebuildReorg INTO @Indice, @Fragmentacao
		
	END
	
	CLOSE CurRebuildReorg
	DEALLOCATE CurRebuildReorg
	
	FETCH NEXT FROM CurTabelas INTO @Tabela
			
END

CLOSE CurTabelas
DEALLOCATE CurTabelas

PRINT @Relatorio

/*
SELECT 
	B.name, 
	A.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(N'dbBR_BARE'), NULL, NULL, NULL, NULL) AS A  
	INNER JOIN sys.indexes AS B 
		ON A.object_id = B.object_id 
		AND A.index_id = B.index_id
--WHERE A.avg_fragmentation_in_percent > 5
WHERE index_type_desc != 'HEAP'
ORDER BY 1		
*/