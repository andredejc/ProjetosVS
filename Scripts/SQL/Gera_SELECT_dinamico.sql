DECLARE 
	@select VARCHAR(8000)
   ,@nameColuna VARCHAR(100)
   ,@nameTabela VARCHAR(100)
   
SET @select = 'SELECT ' + CHAR(10)
SET @nameTabela = 'tbBR_tab_NASA_01_Mov_Reno_Tele_Propo2015'

DECLARE cur CURSOR FOR
SELECT B.name
FROM sys.tables AS A
	INNER JOIN sys.columns AS B
		ON A.object_id = B.object_id
WHERE A.name = @nameTabela
AND B.name NOT IN('id_Arquivo','id_BaseCarga')
ORDER BY B.column_id

OPEN cur
FETCH NEXT FROM cur INTO @nameColuna
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @select += '	' + @nameColuna + ',' + CHAR(10)	
	FETCH NEXT FROM cur INTO @nameColuna
END
CLOSE cur
DEALLOCATE cur

SET @select += 'FROM ' + @nameTabela
SET @select = STUFF(REVERSE(@select),CHARINDEX(',',REVERSE(@select)),1,'')
SET @select = REVERSE(@select)

PRINT @select