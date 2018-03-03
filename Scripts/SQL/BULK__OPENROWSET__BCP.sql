-- BULK INSERT insere na base de um arquivo txt:
BULK INSERT tbPL_TMP_PrivateLabel
FROM '\\d5668m001e108\OPERACOES\PL\Carregados\TXT\18-04-2016\bsp_reg1.txt'
WITH
(
	FIRSTROW = 2, 			-- Pula o header do arquivo
	FIELDTERMINATOR = ';',	-- Delimitador: \t é para largura fixa
	ROWTERMINATOR = '\n',	-- Quebra linha -> As vezes, dependendo do arquivo(geralmente arquivos UNIX), o '\n' não funciona e pode ser substituído por '0x0a'
	CODEPAGE = 'ACP',		-- O parâmetro 'ACP' é utilizado para que na hora do import sejam mantidas as acentuações de strings
	LASTROW = 1001,			-- Insere até a linha 1000. Lembrando que no FIRSTROW pulamos o header
	TABLOCK
);
GO

-- BULK INSERT dinâmico:
DECLARE @path VARCHAR(200) = 'C:\Users\M135038\Desktop\Solicitacao Maucio\Enriquecimento_Endereços.txt',
		 @sql VARCHAR(MAX)

SET @sql =  'BULK INSERT tmp_Layout_vendas 
			 FROM ''' + @path + '''
			 WITH 
			 (
				FIRSTROW=1, 		
				ROWTERMINATOR = ''\n''
			 )'	
EXEC (@sql);
GO

-- BULK INSERT dinâmico em mais de um arquivo:

--DECLARE @arquivo VARCHAR(10) = 'bsp_reg',
--		@int INT = 1,	
--		@caminho VARCHAR(200) = 'E:\Andre\Testes\',		
--		@sql VARCHAR(MAX)

--WHILE @int <= 3
--BEGIN	
--	SET @caminho += @arquivo + CAST(@int AS VARCHAR) + '.txt'
--	SET @sql =  'BULK INSERT tbPL_tab_MesAtualPLTESTE 
--				 FROM '''+@caminho+'''
--				 WITH 
--				 (
--					FIRSTROW=2, 		
--					FIELDTERMINATOR='';'',
--					ROWTERMINATOR = ''\n''
--				 )'	
--	EXEC (@sql);	
--	SET @caminho = 'E:\Andre\Testes\';
--	SET @int = @int + 1;	
--END


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- PEGA O CABEÇALHO DO ARQUIVO
SELECT TOP 1 SUBSTRING(BulkColumn,1,CHARINDEX(CHAR(13),BulkColumn))
FROM OPENROWSET(
BULK 'C:\Temp\BASE_VIVO_FIXA.csv',SINGLE_CLOB) AS DATA;
 
-- SELECT EM SERVIDOR REMOTO
 SELECT *
 INTO ##teste
 FROM OPENROWSET (
	'SQLOLEDB', -- Provider
	'10.128.223.40'; -- Servidor
	'andre.cordeiro'; -- User
	'vivo@123', -- Pass
	'SELECT TOP 10 * FROM DB.dbo.PORTIN_AGEND_MOVEL' -- Query
)

 SELECT *
 FROM ##teste AS A
 RIGHT JOIN OPENROWSET (
	'SQLNCLI', -- Provider
	'10.128.223.40'; -- Servidor
	'andre.cordeiro'; -- User
	'vivo@123', -- Pass
	'SELECT * FROM dbo.PORTIN_AGEND_MOVEL' -- Query
) AS B ON A.NUMERO_BP = B.NUMERO_BP

-- OPENROWSET carrega arquivos xls e xlsx. Se o SQL Server for 64 bits e o Office for 32 vai gerar um erro:
SELECT * 
INTO Teste_INSERT 
FROM OPENROWSET('MICROSOFT.JET.OLEDB.4.0', 'EXCEL 08.0;DATABASE=E:\Teste_ROWSET.xlsx;HDR=YES', 'SELECT * FROM [Plan1$]');

SELECT * 
INTO Teste_INSERT 
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 12.0;Database=E:\Teste_ROWSET.xlsx','SELECT * FROM [Plan1$]');

-- Cannot create an instance of OLE DB provider "Microsoft.ACE.OLEDB.12.0" for linked server "(null)".
USE master;
GO

EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Exporta para arquivo com o BCP. Executar o RECONFIGURE se o utilitário não estiver habilitado:
EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE

-- Parametros:
--		-t   	= Tabulação padrão
--		-t , 	= Por vírgula
--		-t ; 	= Por ponto e vírgula
--		-c	 	= Especifica que os campos de dados sejam carregados como dados de caracteres.
--		-T	 	= Conecta ao SQL com uma conexão confiável. Se -T não for especificado, especifique -Uuser e -Psenha para o logon ser efetuado com êxito.
--		-C1252 	= preserva as acentuações

EXEC xp_cmdshell 'bcp "SELECT * FROM Teste_INSERT" queryout "E:\Andre\Teste.txt" -T -c -t ; -dTesteCarga'

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Cria e Insere via LinkedServer em uma nova tabela tabela. Tentei fazer com tabela tmp mas não deu certo:
SELECT * 
INTO [tbPC_tmpTeste_Layoutvendas02]
FROM [MZ-VV-BD-015].[dbBR_PainelControle].[dbo].tbPC_tmp_Layoutvendas02

-- Exporta os dados para o arquivo:
EXEC xp_cmdshell 'bcp "SELECT * FROM [tbPC_tmpTeste_Layoutvendas02]" queryout "E:\Andre\Teste.txt" -T -c -t -dTesteCarga'

-- Se der erro na exportação, tentar exportar o arquivo no diretório C:\Temp\:
EXEC xp_cmdshell 'bcp "SELECT * FROM [TEMP_FLAT_PJ_MVMT]" queryout "C:\Temp\QueryOut.csv" -Usa -PP@ssw0rd -c -C1252 -t ; -dTESTES'


