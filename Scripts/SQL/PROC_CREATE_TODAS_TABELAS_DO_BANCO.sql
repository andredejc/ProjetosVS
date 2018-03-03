DECLARE
	@stringCreate VARCHAR(8000) = 'CREATE TABLE ',		
	@tabela VARCHAR(50),
	@coluna VARCHAR(50),
	@tipo VARCHAR(50),
	@tamanho VARCHAR(50)
	
-- INÍCIO CURSOR 1
DECLARE curTabela CURSOR FOR(SELECT name FROM SYS.tables)
OPEN curTabela
FETCH NEXT FROM curTabela INTO @tabela
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @stringCreate += @tabela + '(' 
	
	-- INÍCIO CURSOR 2
	DECLARE curColuna CURSOR FOR (SELECT 
										B.name,
										C.name,
										CASE	
											WHEN C.name = 'varchar' OR C.name = 'char' OR C.name = 'nvarchar' THEN '('+ CAST(B.max_length AS VARCHAR) +')' 
											ELSE '' END max_length
									FROM SYS.tables AS A
										INNER JOIN SYS.columns AS B ON A.object_id = B.object_id
										INNER JOIN SYS.types AS C ON B.system_type_id = C.system_type_id
								  WHERE A.name = @tabela)
	OPEN curColuna 
	FETCH NEXT FROM curColuna INTO @coluna,@tipo,@tamanho
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @stringCreate += @coluna +' '+ @tipo + @tamanho +','
		FETCH NEXT FROM curColuna INTO @coluna,@tipo,@tamanho
		
	END
	CLOSE curColuna;
	DEALLOCATE curColuna;
	-- FIM CURSOR 2
	
	--SET @stringCreate += ')'
	SET @stringCreate = (SELECT SUBSTRING(@stringCreate,1,LEN(@stringCreate)-1)+')')
	PRINT @stringCreate
	SET @stringCreate = 'CREATE TABLE '
	FETCH NEXT FROM curTabela INTO @tabela
END;
CLOSE curTabela;
DEALLOCATE curTabela; 
-- FIM CURSOR 1	