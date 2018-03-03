-- ###################################################################################
-- Procedure que gera arquivo delimitado a partir de uma query passada como parâmetro
-- ###################################################################################
--------------------------------------------------------------------------------------
--		- Criado por: André Cordeiro
--		- Data: 11/05/2017
--------------------------------------------------------------------------------------
--		- Pode ser executado no SQL Server 2005 ou superior
--------------------------------------------------------------------------------------
--		- Por razões de permissão o arquivo é gerado em C:\Temp\
--------------------------------------------------------------------------------------
--		- O parâmetro @opcao = 1 gera o arquivo com o header, = 0 sem header. Não vale
--		  para arquivo largura fixa pois sempre é gerado sem o header. Caso a opção de
--		  largura fixa seja selecionada e a opção estiver como 1, gerará uma exception		  
--------------------------------------------------------------------------------------
--		- A procedure gera arquivos nas extensões .txt, .csv e .dat
--------------------------------------------------------------------------------------
--		- Se o valor passado como delimitador for um VARCHAR vazio '' o arquivo será 
--		  delimitado por TAB.
--------------------------------------------------------------------------------------
--
-- ###################################################################################

ALTER PROCEDURE sp_GeraArquivoDelimitado(	
	@usuario VARCHAR(50),
	@senha VARCHAR(50), 	
	@nomeArquivo VARCHAR(100),
	@delimitador VARCHAR(6),
	@extensao CHAR(4),
	@opcao BIT,
	@query VARCHAR(8000)
)
AS
SET NOCOUNT ON

BEGIN TRY
	-------------------------------------------
	-- Se o xp_cmdshell não estiver habilitado:
	-------------------------------------------
	IF NOT EXISTS ( SELECT 1 FROM sys.configurations WHERE name = 'xp_cmdshell' AND value = 1 ) BEGIN
		-- Permite que as opções avançadas sejam alteradas:
		EXEC sp_configure 'show advanced options', 1;  	
		-- Atualiza o valor de configuração:  
		RECONFIGURE;
		-- Habilita o xp_cmdshell:
		EXEC sp_configure 'xp_cmdshell', 1;  	
		-- Atualiza o valor de configuração:  
		RECONFIGURE;
	END

	IF OBJECT_ID('tempdb..##tempdados','U') IS NOT NULL DROP TABLE ##tempdados
	IF OBJECT_ID('tempdb..##tempcolunas','U') IS NOT NULL DROP TABLE ##tempcolunas

	DECLARE 
		@count INT = 1,
		@sql VARCHAR(8000) = '',
		@coluna VARCHAR(50),
		@cabecalho VARCHAR(50) = 'SELECT * FROM ##tempcolunas UNION ALL ',
		@bcp VARCHAR(8000) = '',
		@banco VARCHAR(30) = DB_NAME(),
		@caminhoArquivo VARCHAR(500) = 'C:\Temp\'
	
	---------------------------------
	-- Se o arquivo for largura fixa:
	---------------------------------
	IF @delimitador = 'lf' BEGIN	
	
		IF @opcao = 1 BEGIN
			RAISERROR('Arquivo largura fixa não gera header! Favor alterar a opção para 0.',16,1)
		END

		SET @nomeArquivo += @extensao

		-- Insere todos os dados um uma tabela temp:
		SET @query = STUFF(@query,PATINDEX('%FROM%',@query),0,' INTO ##tempdados ')		

		EXECUTE ( @query )

		SET @sql = 'SELECT '
	
		SELECT @sql +=
			'ISNULL(CAST(' + A.name + ' AS VARCHAR('+ CASE WHEN B.name NOT LIKE '%CHAR%' THEN CAST(A.precision AS VARCHAR(4)) + ')),''NULL'') + ' ELSE  CAST(A.max_length AS VARCHAR(4))+')),''NULL'') + ' END +
			'REPLICATE('' '', ' + CASE WHEN B.name NOT LIKE '%CHAR%' THEN CAST(A.precision AS VARCHAR(4)) ELSE CAST(A.max_length AS VARCHAR(4)) +' ' END + 
			'-LEN(ISNULL(CAST(' + A.name + ' AS VARCHAR('+ CASE WHEN B.name NOT LIKE '%CHAR%' THEN CAST(A.precision AS VARCHAR(4)) + ')),''NULL''))),' ELSE CAST(A.max_length AS VARCHAR(4))+')),''NULL''))), ' END
		FROM tempdb.sys.columns AS A
			INNER JOIN tempdb.sys.types AS B
				ON A.system_type_id = B.system_type_id
		WHERE object_id = OBJECT_ID(N'tempdb..##tempdados');

		SET @sql = REVERSE(SUBSTRING(REVERSE(@sql),3,8000)) + ' FROM ##tempdados'								

		SET @bcp = 'bcp "' + @sql + '" queryout "' + @caminhoArquivo + @nomeArquivo + '" -U' + @usuario + ' -P' + @senha + ' -c -C1252' + ' -d' + @banco + ''		

		EXEC xp_cmdshell @bcp , NO_OUTPUT	

	END
	---------------------------------
	-- Demais delimitadores:
	---------------------------------
	ELSE BEGIN

		IF @delimitador != '' BEGIN
				SET @delimitador = ' -t ' + @delimitador
		END

		SET @nomeArquivo += @extensao
	
		-- Insere todos os dados um uma tabela temp:
		SET @query = STUFF(@query,PATINDEX('%FROM%',@query),0,' INTO ##tempdados ')
		EXECUTE ( @query )

		-- Gera uma tabela temp com os nomes das colunas:
		DECLARE cur CURSOR LOCAL FOR 
		SELECT name
		FROM tempdb.sys.columns 
		WHERE [object_id] = OBJECT_ID('tempdb..##tempdados');

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

		SET @sql = 'SELECT ' + REVERSE(SUBSTRING(REVERSE(@sql),2,8000)) + ' INTO ##tempcolunas'
		EXECUTE ( @sql )

		SET @sql = 'SELECT '

		-- Monta o SELECT a partir da tabela temp com as colunas como VARCHAR pois na hora de executar o UNION ALL, colunas que não forem VARCHAR vão apresentar erro:
		SELECT 	@sql += 'CAST(' + name + ' AS VARCHAR(500)), ' 
		FROM tempdb.sys.columns
		WHERE object_id = OBJECT_ID(N'tempdb..##tempdados');

		SET @sql = REVERSE(SUBSTRING(REVERSE(@sql),3,8000)) + ' FROM ##tempdados' 

		IF @opcao = 1 BEGIN
			SET @sql = @cabecalho + @sql						
		END 

		SET @bcp = 'bcp "' + @sql + '" queryout "' + @caminhoArquivo + @nomeArquivo + '" -U' + @usuario + ' -P' + @senha + ' -c -C1252' + @delimitador + ' -d' + @banco + ''	

		EXEC xp_cmdshell @bcp , NO_OUTPUT

		IF OBJECT_ID('tempdb..##tempdados','U') IS NOT NULL DROP TABLE ##tempdados
		IF OBJECT_ID('tempdb..##tempcolunas','U') IS NOT NULL DROP TABLE ##tempcolunas

	END

END TRY
BEGIN CATCH
	
	DECLARE @error_message VARCHAR(8000), @error_severity INT, @error_state INT

	SELECT @error_message = ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE() 

	RAISERROR( @error_message, @error_severity, @error_state )

END CATCH