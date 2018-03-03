-- #############################################################################
-- Procedure que gera arquivo csv a partir de uma query passada como parâmetro:
-- #############################################################################




-- #############################################################################
-- Procedure que gera arquivo csv a partir de uma tabela passada como parâmetro:
-- #############################################################################

IF OBJECT_ID('tempdb..##teste','U') IS NOT NULL DROP TABLE ##teste

DECLARE 
	@coluna VARCHAR(50), 
	@sql VARCHAR(8000) = 'SELECT ', 
	@count  INT = 1,
	@select VARCHAR(500) = 'SELECT ' + CHAR(13),
	@tabela VARCHAR(30) = 'TEMP_FLAT_PJ_MVMT',
	@bcp VARCHAR(500) = '',
	@caminhoArquivo VARCHAR(500) = '',
	@nomeArquivo VARCHAR(100) = 'QueryOut_' + CONVERT(VARCHAR(10), GETDATE(), 112)+ '.csv',
	@banco VARCHAR(50) = 'TESTES',
	@usuario VARCHAR(50) = 'sa',
	@senha VARCHAR(50) = 'P@ssw0rd',
	@delimitador CHAR(2) = ';'

	PRINT @nomeArquivo

DECLARE cur CURSOR FOR
SELECT column_name
FROM information_schema.columns
WHERE table_name = @tabela

OPEN cur
FETCH NEXT FROM cur INTO @coluna

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sql += QUOTENAME(@coluna ,'''') + ' AS ' + QUOTENAME(CAST(@count AS VARCHAR(2))) + ','
	FETCH NEXT FROM cur INTO @coluna
	SET @count += 1
END
CLOSE cur 
DEALLOCATE cur

SET @sql = REVERSE(SUBSTRING(REVERSE(@sql),2,8000))

SET @sql += ' INTO ##teste'

EXECUTE ( @sql )

SELECT 	@select +=
	'CAST(' + column_name + ' AS VARCHAR(500)),' + CHAR(13)
FROM information_schema.columns
WHERE table_name = @tabela

SET @select = REVERSE(SUBSTRING(REVERSE(@select),3,8000)) + CHAR(13) + 'FROM ' + @tabela

SET @bcp = 'bcp "SELECT * FROM ##teste UNION ALL ' + @select + '" queryout "C:\Temp\' + @nomeArquivo + '" -U' + @usuario + ' -P' + @senha + ' -c -C1252 -t ' + @delimitador + ' -d' + @banco + ''

EXEC xp_cmdshell @bcp

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Move-Item -Path C:\Temp\*Out*.csv -Destination C:\Users\A0066013\Documents\ANDRE\Destino\
-- '"Get-ChildItem -Path C:\Temp\*Out*.csv | Where-Object {$_.LastWriteTime.Date -eq (Get-Date -Format d)}"' 

DECLARE 
	@powerParam VARCHAR(100) = 'powershell.exe -noprofile -command ',
	@powerCommand VARCHAR(500) = 'Copy-Item -Path C:\Temp\*Out*.csv -Destination C:\Users\A0066013\Documents\ANDRE\Destino\' 

SET @powerParam = @powerParam + @powerCommand

EXECUTE xp_cmdshell @powerParam

EXECUTE xp_cmdshell 'powershell.exe -noprofile "C:\Users\A0066013\Documents\ANDRE\MoveArquivo.ps1"'

DECLARE @arquivo VARCHAR(200) = 'QueryOut_' + CONVERT(VARCHAR(10), GETDATE(), 112)+ '.csv', 
	@origem VARCHAR(200),
	@destino VARCHAR(200)

SET @origem = 'copy C:\Temp\' + @arquivo + ' '
SET @destino = 'C:\Users\A0066013\Documents\ANDRE\Destino'
SET @origem = @origem + @destino

EXEC xp_cmdshell @origem;  

EXEC xp_cmdshell 'copy c:\SQLbcks\AdvWorks.bck  \\server2\backups\SQLbcks, NO_OUTPUT';  

select value_in_use from sys.configurations 
where name = 'xp_cmdshell'



