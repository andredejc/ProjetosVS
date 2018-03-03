ALTER PROCEDURE sp_CreateTable(	
	@Tabela VARCHAR(150),
	@TabelaEstrutura VARCHAR(8000) OUTPUT	
)
AS
BEGIN

	DECLARE      
		@CreateTable VARCHAR(8000) = '',  	  
		@Sql VARCHAR(8000) = '',  
		@Coluna VARCHAR(100) = '',  
		@ColunaPK VARCHAR(100) = ''  
	 
	----------------------------------------------------------------------------------------------------------------------------  
	-- Gera a base do create table  
	----------------------------------------------------------------------------------------------------------------------------   

	SET @CreateTable = ' CREATE TABLE ' + @Tabela + '(' + CHAR(13) 

	SELECT @CreateTable +=   
		CHAR(9) + ',' + QUOTENAME(B.name) + ' '+ UPPER(C.name) +   
		CASE WHEN COLUMNPROPERTY(OBJECT_ID(@Tabela),B.name,'IsIdentity') = 1 THEN ' IDENTITY(' + CAST(IDENT_SEED(@Tabela) AS CHAR(1)) + ',' + CAST(IDENT_INCR(@Tabela) AS CHAR(1)) + ')' ELSE '' END +  
		CASE WHEN C.name LIKE '%char' THEN  '(' + CAST(B.max_length AS VARCHAR(10)) + ')' ELSE '' END + CHAR(10)  
	FROM sys.tables AS A  
		INNER JOIN sys.columns AS B  
			ON A.object_id = B.object_id  
		INNER JOIN sys.types AS C  
			ON B.system_type_id = C.system_type_id  
	WHERE B.object_id  = object_id(@Tabela)    
	ORDER BY B.column_id  

	----------------------------------------------------------------------------------------------------------------------------  
	-- Gera a CONSTRAINT PK  
	----------------------------------------------------------------------------------------------------------------------------  

	DECLARE CurColumns CURSOR FOR  
	SELECT     
		infSchema.COLUMN_NAME +    
		CASE WHEN indCol.is_descending_key = 1  THEN ' DESC, ' ELSE  ' ASC, ' END  
	FROM sys.tables AS tab  
		INNER JOIN sys.indexes AS ind  
			ON tab.object_id = ind.object_id  
		INNER JOIN sys.index_columns AS indCol  
			ON ind.object_id = indCol.object_id  
			AND ind.index_id = indCol.index_id  
		INNER JOIN information_schema.key_column_usage AS infSchema  
			ON ind.name = infSchema.CONSTRAINT_NAME  
	WHERE ind.type_desc = 'CLUSTERED'  
	AND tab.object_id = object_id(@Tabela)   
	GROUP BY infSchema.COLUMN_NAME,indCol.is_descending_key,infSchema.ORDINAL_POSITION   
	ORDER BY infSchema.ORDINAL_POSITION   

	OPEN CurColumns  
	FETCH NEXT FROM CurColumns INTO @Coluna  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
	 
		SET @ColunaPK += @Coluna  
	 
		FETCH NEXT FROM CurColumns INTO @Coluna  

	END  
	CLOSE CurColumns  
	DEALLOCATE CurColumns  

	SELECT @Sql = 'CONSTRAINT ' + QUOTENAME(ind.name) +
		' PRIMARY KEY CLUSTERED ( ' + REVERSE(STUFF(REVERSE(@ColunaPK),2,1,'')) + ')' + CHAR(13) +  
		'WITH (' + CHAR(13) +  
		CASE WHEN ind.is_padded = 1 THEN '	PAD_INDEX = ON, ' ELSE '	PAD_INDEX = OFF, ' END + CHAR(13) +  
		CASE WHEN INDEXPROPERTY(tab.object_id, ind.name, 'IsStatistics') = 1 THEN '	STATISTICS_NORECOMPUTE = ON, ' ELSE '	STATISTICS_NORECOMPUTE = OFF, ' END + CHAR(13) +  
		CASE WHEN ind.ignore_dup_key = 1 THEN '    IGNORE_DUP_KEY = ON, ' ELSE '    IGNORE_DUP_KEY = OFF, ' END + CHAR(13) +  
		CASE WHEN ind.allow_row_locks = 1 THEN  '	ALLOW_ROW_LOCKS = ON, ' ELSE '	ALLOW_ROW_LOCKS = OFF, ' END + CHAR(13) +   
		CASE WHEN ind.allow_page_locks = 1 THEN '	ALLOW_PAGE_LOCKS = ON ' ELSE '	ALLOW_PAGE_LOCKS = OFF ' END + CHAR(13) +    
		' )' + CHAR(13) + 'ON [PRIMARY]'   
	FROM sys.tables AS tab  
		INNER JOIN sys.indexes AS ind  
			ON tab.object_id = ind.object_id   
	WHERE ind.type_desc = 'CLUSTERED'  
	AND tab.object_id = object_id(@Tabela)   


	SET @CreateTable = STUFF(@CreateTable,CHARINDEX(',',@CreateTable,0),1,' ') + ',' +@Sql + ')'  

	SET @TabelaEstrutura =  @CreateTable

	RETURN

END	

DECLARE @RetornaTable VARCHAR(8000)

EXECUTE sp_CreateTable  'tbBR_tab_AUTO_2015',@TabelaEstrutura = @RetornaTable OUTPUT

PRINT @RetornaTable

-- ***************************************************************************************************************
-- ***************************************************************************************************************
-- Comando BATCH:
-- ***************************************************************************************************************
-- ***************************************************************************************************************
DECLARE      
	@CreateTable VARCHAR(8000) = '',  
	@Tabela VARCHAR(60) = '',  
	@Sql VARCHAR(8000) = '',  
	@Coluna VARCHAR(100) = '',  
	@ColunaPK VARCHAR(100) = '',  
	@TabelaBase NVARCHAR(100) = 'tbBR_tab_RE_',  
	@AnoTabelaNova VARCHAR(4) = '2017' 
 
----------------------------------------------------------------------------------------------------------------------------  
-- Gera a base do create table com INDICES:
----------------------------------------------------------------------------------------------------------------------------   

SET @Tabela = ( SELECT MAX(name) FROM sys.tables WHERE name LIKE @TabelaBase + '%' )  
SET @CreateTable = ' CREATE TABLE ' + @TabelaBase + @AnoTabelaNova + '(' 

SELECT @CreateTable +=   
	',' + QUOTENAME(B.name) + ' '+ UPPER(C.name) +   
	CASE WHEN COLUMNPROPERTY(OBJECT_ID(@Tabela),B.name,'IsIdentity') = 1 THEN ' IDENTITY(' + CAST(IDENT_SEED(@Tabela) AS CHAR(1)) + ',' + CAST(IDENT_INCR(@Tabela) AS CHAR(1)) + ')' ELSE '' END +  
	CASE WHEN C.name LIKE '%char' THEN  '(' + CAST(B.max_length AS VARCHAR(10)) + ')' ELSE '' END + CHAR(10)  
FROM sys.tables AS A  
	INNER JOIN sys.columns AS B  
		ON A.object_id = B.object_id  
	INNER JOIN sys.types AS C  
		ON B.system_type_id = C.system_type_id  
WHERE B.object_id  = object_id(@Tabela)    
ORDER BY B.column_id  

----------------------------------------------------------------------------------------------------------------------------  
-- Gera a CONSTRAINT PK  
----------------------------------------------------------------------------------------------------------------------------  

DECLARE CurColumns CURSOR FOR  
SELECT     
	infSchema.COLUMN_NAME +    
	CASE WHEN indCol.is_descending_key = 1  THEN ' DESC, ' ELSE  ' ASC, ' END  
FROM sys.tables AS tab  
	INNER JOIN sys.indexes AS ind  
		ON tab.object_id = ind.object_id  
	INNER JOIN sys.index_columns AS indCol  
		ON ind.object_id = indCol.object_id  
		AND ind.index_id = indCol.index_id  
	INNER JOIN information_schema.key_column_usage AS infSchema  
		ON ind.name = infSchema.CONSTRAINT_NAME  
WHERE ind.type_desc = 'CLUSTERED'  
AND tab.object_id = object_id(@Tabela)   
GROUP BY infSchema.COLUMN_NAME,indCol.is_descending_key,infSchema.ORDINAL_POSITION   
ORDER BY infSchema.ORDINAL_POSITION   

OPEN CurColumns  
FETCH NEXT FROM CurColumns INTO @Coluna  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 
	SET @ColunaPK += @Coluna  
 
	FETCH NEXT FROM CurColumns INTO @Coluna  

END  
CLOSE CurColumns  
DEALLOCATE CurColumns  

SELECT @Sql = 'CONSTRAINT ' + QUOTENAME(REVERSE(STUFF(REVERSE(ind.name),1,4,REVERSE(@AnoTabelaNova)))) + ' PRIMARY KEY CLUSTERED ( ' + REVERSE(STUFF(REVERSE(@ColunaPK),2,1,'')) + ')' + CHAR(13) +  
	'WITH (' + CHAR(13) +  
	CASE WHEN ind.is_padded = 1 THEN '    PAD_INDEX = ON, ' ELSE '    PAD_INDEX = OFF, ' END + CHAR(13) +  
	CASE WHEN INDEXPROPERTY(tab.object_id, ind.name, 'IsStatistics') = 1 THEN '  STATISTICS_NORECOMPUTE = ON, ' ELSE ' STATISTICS_NORECOMPUTE = OFF, ' END + CHAR(13) +  
	CASE WHEN ind.ignore_dup_key = 1 THEN '    IGNORE_DUP_KEY = ON, ' ELSE '    IGNORE_DUP_KEY = OFF, ' END + CHAR(13) +  
	CASE WHEN ind.allow_row_locks = 1 THEN  ' ALLOW_ROW_LOCKS = ON, ' ELSE ' ALLOW_ROW_LOCKS = OFF, ' END + CHAR(13) +   
	CASE WHEN ind.allow_page_locks = 1 THEN ' ALLOW_PAGE_LOCKS = ON ' ELSE ' ALLOW_PAGE_LOCKS = OFF ' END + CHAR(13) +    
	' )' + CHAR(13) + 'ON [PRIMARY]'   
FROM sys.tables AS tab  
	INNER JOIN sys.indexes AS ind  
		ON tab.object_id = ind.object_id   
WHERE ind.type_desc = 'CLUSTERED'  
AND tab.object_id = object_id(@Tabela)   


SET @CreateTable = STUFF(@CreateTable,CHARINDEX(',',@CreateTable,0),1,' ') + ',' +@Sql + ')'  

PRINT @CreateTable 

----------------------------------------------------------------------------------------------------------------------------  
-- Gera os INDICES  
----------------------------------------------------------------------------------------------------------------------------  

DECLARE   
	@SqlCreateIndexHead VARCHAR(8000) = '',   
	@SqlCreateIndexTail VARCHAR(8000) = '',  
	@SqlColunasIndex VARCHAR(8000) = '',  
	@NomeTabela VARCHAR(60) = '',  
	@NomeIndice VARCHAR(60) = ''  

DECLARE CursorIndice CURSOR FOR  -- cursor 01
SELECT   
	tabela.name,  
	indice.name,   
	'CREATE NONCLUSTERED INDEX ' + QUOTENAME(REVERSE(STUFF(REVERSE(indice.name),1,4,REVERSE(@AnoTabelaNova)))) + ' ON ' + QUOTENAME(SCHEMA_NAME(tabela.schema_id)) + '.' +  
	QUOTENAME(REVERSE(STUFF(REVERSE(tabela.name),1,4,REVERSE(@AnoTabelaNova)))) + CHAR(13),     
	CHAR(13) + 'WITH ('  + CHAR(13) +    
	CASE WHEN is_padded = 1 THEN 'PAD_INDEX = ON, ' ELSE 'PAD_INDEX = OFF, ' END  + CHAR(13) +  
	CASE WHEN INDEXPROPERTY(OBJECT_ID(tabela.name),indice.name,'IsStatistics') = 1 THEN 'STATISTICS_NORECOMPUTE = ON, ' ELSE 'STATISTICS_NORECOMPUTE = OFF, ' END  + CHAR(13) +  
	'SORT_IN_TEMPDB = OFF, ' + CHAR(13) +  
	CASE WHEN indice.ignore_dup_key = 1 THEN 'IGNORE_DUP_KEY = ON, ' ELSE 'IGNORE_DUP_KEY = OFF, ' END  + CHAR(13) +  
	CASE WHEN indice.allow_row_locks = 1 THEN 'ALLOW_ROW_LOCKS = ON, ' ELSE 'ALLOW_ROW_LOCKS = OFF, ' END  + CHAR(13) +  
	CASE WHEN indice.allow_page_locks = 1 THEN 'ALLOW_PAGE_LOCKS = ON, ' ELSE 'ALLOW_PAGE_LOCKS = OFF, 'END  + CHAR(13) +  
	CASE WHEN fill_factor = 0 OR fill_factor = 100 THEN 'FILLFACTOR = 80' ELSE 'FILLFACTOR = ' + CAST(fill_factor AS VARCHAR(3)) END + CHAR(13) +  
	')'  
FROM sys.indexes AS indice  
	INNER JOIN sys.tables AS tabela  
		ON indice.object_id = tabela.object_id  
WHERE tabela.name = @Tabela  
AND indice.type_desc = 'NONCLUSTERED'  

OPEN CursorIndice  
FETCH NEXT FROM CursorIndice INTO @NomeTabela,@NomeIndice,@SqlCreateIndexHead,@SqlCreateIndexTail  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 
	DECLARE   
		@Colunas VARCHAR(8000) = '',   
		@ColunasIncluidas VARCHAR(8000) = '',  
		@SqlColunas VARCHAR(8000) = '',  
		@is_descending_key INT,  
		@is_included_column INT,  
		@name VARCHAR(60)  

	DECLARE Cur CURSOR FOR -- cursor 02
	SELECT    
		indicecoluna.is_descending_key,  
		indicecoluna.is_included_column,  
		CASE   
		WHEN indicecoluna.is_descending_key = 0 AND indicecoluna.is_included_column = 0 THEN coluna.name + ' ASC'   
		WHEN indicecoluna.is_descending_key = 1 AND indicecoluna.is_included_column = 0 THEN coluna.name + ' DESC'   
		ELSE coluna.name  
		END  
	FROM sys.tables AS tabela  
		INNER JOIN sys.indexes AS indice    
			ON tabela.object_id = indice.object_id  
		INNER JOIN sys.index_columns AS indicecoluna 
			ON indice.object_id = indicecoluna.object_id 
			AND indice.index_id = indicecoluna.index_id  
		INNER JOIN sys.columns AS coluna    
			ON indicecoluna.object_id = coluna.object_id 
			AND indicecoluna.column_id = coluna.column_id  
	WHERE tabela.name = @NomeTabela  
	AND indice.name = @NomeIndice  
	ORDER BY indicecoluna.index_column_id  

	OPEN Cur  
	FETCH NEXT FROM Cur INTO @is_descending_key,@is_included_column,@name  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
	  
		IF @is_included_column = 0  SET @Colunas += @name + ','   
		ELSE IF @is_included_column = 1 SET @ColunasIncluidas += @name + ','  
		     
		FETCH NEXT FROM Cur INTO @is_descending_key,@is_included_column,@name  

	END  
	CLOSE Cur  
	DEALLOCATE Cur  
	 
	IF @ColunasIncluidas = ''  
	SET @SqlColunas =  '( ' + REVERSE(STUFF(REVERSE(@Colunas),1,1,'')) + ' )'  
	ELSE      
	SET @SqlColunas =  '( ' + REVERSE(STUFF(REVERSE(@Colunas),1,1,'')) + ' )' + CHAR(13) + 'INCLUDE ( ' + REVERSE(STUFF(REVERSE(@ColunasIncluidas),1,1,'')) + ' )'  
	     
	SET @SqlCreateIndexHead += @SqlColunas  + @SqlCreateIndexTail  
	 
	PRINT @SqlCreateIndexHead 
	   
	FETCH NEXT FROM CursorIndice INTO @NomeTabela,@NomeIndice,@SqlCreateIndexHead,@SqlCreateIndexTail  
 
END  
CLOSE CursorIndice  
DEALLOCATE CursorIndice
