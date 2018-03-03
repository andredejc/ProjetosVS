-------------------------------------------------------------------------------------
-- Utilizando a procedure sp_executesql
-------------------------------------------------------------------------------------
USE master
GO

DECLARE 
	@sql NVARCHAR(500) = N'',
	@objeto NVARCHAR(100) = N'sp_exe_CriaEstruturaTabela',
	@objetoOUT NVARCHAR(100) = NULL,
	@parametros NVARCHAR(100) = N'@objetoIN NVARCHAR(100), @retorno NVARCHAR(100) OUTPUT',
	@banco NVARCHAR(50)
	
DECLARE CUR CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN (
	'master','tempdb','model','msdb','ReportServer','ReportServerTempDB','ESMBD000','ESMBD001',
	'dbES_Estatistica','dbBR_TempDB','dbBR_PortalProtecao','dbBUC','dbBR_GerenciadorVS','dbBR_CadastroProd',
	'dbCD_CanaisDigitais'
)

OPEN CUR
FETCH NEXT FROM CUR INTO @banco
WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @sql = N'USE ' + @banco + ' SELECT @retorno = name FROM sys.objects WHERE name = @objetoIN';

	EXECUTE sp_executesql @sql, @parametros, @objetoIN = @objeto, @retorno = @objetoOUT OUTPUT

	IF @objetoOUT IS NOT NULL BEGIN	
		SELECT @banco AS Banco		
	END
	
	SET @objetoOUT = NULL
	
	FETCH NEXT FROM CUR INTO @banco

END 
CLOSE CUR
DEALLOCATE CUR

-------------------------------------------------------------------------------------
-- Utilizando apenas o EXECUTE
-------------------------------------------------------------------------------------

USE master
GO

DECLARE 
	@banco VARCHAR(100),
	@objeto VARCHAR(100),
	@sql VARCHAR(8000)  

SET @objeto = 'sp_exe_CriaEstruturaTabela'

DECLARE cur CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN('master','tempdb','model','msdb','ESMBD000','ESMBD001','ReportServer'
				 ,'ReportServerTempDB','dbBR_RUB','dbES_Estatistica','dbBR_TempDB'
				 ,'dbBR_PortalProtecao','dbBUC','dbBR_GerenciadorVS','dbBR_OV','dbBR_CadastroProd','dbCD_CanaisDigitais')

OPEN cur

FETCH NEXT FROM cur INTO @banco
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sql =  ' USE '+ @banco +
				' IF EXISTS(' +
				'	SELECT name FROM sys.objects WHERE name LIKE ' +'''%'+ @objeto +'%'''+
				' )' +
				' SELECT '+
				''''+ @banco +''''+' AS Banco ' + 
				',name AS NomeObjeto' + 
				' FROM sys.objects' + 
				' WHERE name LIKE ' +'''%'+ @objeto +'%'''
				
	EXEC(@sql)
				
	FETCH NEXT FROM cur INTO @banco
END
CLOSE cur
DEALLOCATE cur


