--	##########################################
--	Comandos úteis SQL Server
--	##########################################

-- Relaciona tabelas com tipo de coluna
select 
	b.name as coluna,
	c.name as tipo_coluna,
	b.max_length as tamanho
from sys.tables as a
	inner join sys.columns as b
		on a.object_id = b.object_id
	inner join sys.types as c
		on b.user_type_id = c.user_type_id
where a.name = N'tbSP_tab_Ses_Administradores'	
and a.type = N'U'

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Exporta query para arquivo texto:
EXEC xp_cmdshell 'bcp "SELECT * FROM [tbPC_tmp_Layoutvendas01]" queryout "E:\Andre\0002ENVIO26042016_01.txt" -T -c -t -dTesteCarga'

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Executa pacote SSIS via BAT:
REM executa pacote 'pkg_dbCA_CapitalZ.dtsx'
cd C:\Program Files\Microsoft SQL Server\100\DTS\Binn -- Caminho do executável 'DTExec.exe'
DTExec.exe /F "C:\Andre\Projetos\ETLs_Execucao\ETLs_Execucao\pkg_dbCA_CapitalZ.dtsx"

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- BULK INSERT insere na base de um arquivo txt:
BULK INSERT tbPL_TMP_PrivateLabel
FROM '\\d5668m001e108\OPERACOES\PL\Carregados\TXT\18-04-2016\bsp_reg1.txt'
WITH
(
	FIRSTROW=2, 			-- Pula o header do arquivo
	FIELDTERMINATOR = ';',	-- Delimitador: \t é para largura fixa
	ROWTERMINATOR = '\n'	-- Quebra de linha
);
GO

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Restore de Database:
-- Aqui recupera-se os nomes lógicos para o .mdf e o .ldf
RESTORE FILELISTONLY
FROM DISK = 'E:\Andre\Databases\AdventureWorks2008.bak'
GO
-- Depois é possível fazer o restore apontando para o caminho desejado
RESTORE DATABASE AdventureWorks
FROM DISK = 'E:\Andre\Databases\AdventureWorks2008.bak'
WITH MOVE 'AdventureWorks_Data' TO 'E:\Andre\Databases\AdventureWorks_Data.mdf',
MOVE 'AdventureWorks_Log' TO 'E:\Andre\Databases\AdventureWorks_Log.ldf'

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Dropa e recria CONSTRAINT:
-- Uma CONSTRAINT não pode ser alterada. Deve-se dropar a existente e criá-la novamente
ALTER TABLE [dbo].[tbBR_tab_Arquivo] DROP CONSTRAINT [ck01_tbBR_tab_Arquivo] 

ALTER TABLE [dbo].[tbBR_tab_Arquivo]  WITH CHECK ADD  CONSTRAINT [ck01_tbBR_tab_Arquivo] 
CHECK  (([cs_Tipo]='RICMM_VLR' OR 
		 [cs_Tipo]='RICMM_QTD'))

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Verifica transações no banco:
SELECT DB_NAME(dbid) AS dbname,
		cmd,
		nt_domain,
		nt_username,
		hostname,
		program_name
FROM master..sysprocesses 
WHERE open_tran > 0

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- DROP de objetos no banco. Dessa maneira é possível verificar PROCS, TABLE, TEMP TABLES, PKs e etc:
IF (OBJECT_ID(N'CriaTableTipo') IS NOT NULL)
	DROP PROCEDURE CriaTableTipo;
GO

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- DROP e CREATE indices:
IF EXISTS(SELECT NAME FROM SYS.indexes WHERE name = N'') 
DROP INDEX idx_teste ON tbPL_tab_MesAtualPLTESTE;
GO

CREATE UNIQUE CLUSTERED INDEX idx_teste ON tbPL_tab_MesAtualPLTESTE(nr_Id)
-- CREATE INDEX idx_teste ON tbPL_tab_MesAtualPLTESTE(nr_Id)

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Exemplos de PIVOT;
SELECT
	ds_lProd AS Produto,
	[PRE-PREENCHIDA],
	[OUTROS CANAIS],
	[PRE-APROVADA]
FROM
(
	SELECT ds_lProd,ds_lCellaOrigeCatao,vl_PcelaSegur
	FROM tbPL_tab_MesAtualPLTESTE
) AS A
PIVOT(SUM(vl_PcelaSegur) FOR ds_lCellaOrigeCatao IN([PRE-PREENCHIDA],[OUTROS CANAIS],[PRE-APROVADA])) AS P

SELECT	
	[PRE-PREENCHIDA],
	[OUTROS CANAIS],
	[PRE-APROVADA]
FROM
(
	SELECT ds_lCellaOrigeCatao,vl_PcelaSegur
	FROM tbPL_tab_MesAtualPLTESTE
) AS A
PIVOT(SUM(vl_PcelaSegur) FOR ds_lCellaOrigeCatao IN([PRE-PREENCHIDA],[OUTROS CANAIS],[PRE-APROVADA])) AS P

-- Com CTE:
WITH CTE(ds_lProd,ds_lCellaOrigeCatao,vl_PcelaSegur) AS
(
	SELECT ds_lProd,ds_lCellaOrigeCatao,vl_PcelaSegur
	FROM tbPL_tab_MesAtualPLTESTE	
)
SELECT	
	ds_lProd AS Produto,
	[PRE-PREENCHIDA],
	[OUTROS CANAIS],
	[PRE-APROVADA]
FROM CTE
PIVOT(SUM(vl_PcelaSegur) FOR ds_lCellaOrigeCatao IN([PRE-PREENCHIDA],[OUTROS CANAIS],[PRE-APROVADA])) AS P












