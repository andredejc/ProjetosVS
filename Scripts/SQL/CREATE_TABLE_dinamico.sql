SELECT B.name,C.name
FROM SYS.tables AS A
	INNER JOIN SYS.columns AS B
		ON A.object_id = B.object_id
	INNER JOIN sys.types AS C
		ON B.system_type_id = C.system_type_id
WHERE A.name LIKE '%tbEX_tmp_Extrato%'	


----------------------
DECLARE @str VARCHAR(255),
		@create VARCHAR(8000)

SET	@create = 'CREATE TABLE tbEX_tmp_Extrato('	


DECLARE curTab CURSOR FOR
(SELECT B.name
 FROM SYS.tables AS A
 INNER JOIN SYS.columns AS B
     ON A.object_id = B.object_id	
 WHERE A.name LIKE '%tbEX_tmp_Extrato%')	

OPEN curTab
FETCH NEXT FROM curTab INTO @str
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @create +=  @str + ' VARCHAR(255),' + CHAR(13)
	FETCH NEXT FROM curTab INTO @str;
END;
CLOSE curTab;
DEALLOCATE curTab;

SET @create += ')'

SELECT @create
	