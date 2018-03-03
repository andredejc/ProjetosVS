USE master
GO

DECLARE		@banco VARCHAR(100),
			@tabela VARCHAR(100),
			@sql VARCHAR(8000)  

-- Alterar o nome da tabela procurada:
SET @tabela = 'PJ'

BEGIN

	DECLARE cur CURSOR FOR
	SELECT name 
	FROM sys.databases 
	WHERE HAS_DBACCESS(name) = 1
	AND name NOT IN('master','tempdb','msdb'); 

	OPEN cur

	FETCH NEXT FROM cur INTO @banco
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql =  ' USE '+ @banco +
					' IF EXISTS(' +
					'	SELECT name FROM sys.tables WHERE name LIKE ' +'''%'+ @tabela +'%'''+
					' )' +
					' SELECT '+
					''''+ @banco +''''+' AS Banco ' + 
					',name AS NomeTabela' + 
					' FROM sys.tables' + 
					' WHERE name LIKE ' +'''%'+ @tabela +'%'''
				
		EXECUTE( @sql )
				
		FETCH NEXT FROM cur INTO @banco
	END
	CLOSE cur
	DEALLOCATE cur

END