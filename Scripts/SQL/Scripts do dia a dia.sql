-- Extrai arquivo com senha. Depois do '-p' vem a senha
e -o+ "C:\Users\M135038\Desktop\PL\BSP_REG1.zip" -pbsp112

bsp_reg1.zip / 159.573 / bsp112
bsp_reg2.zip / 1.492.974 / bsp212
bsp_reg3.zip / 141.344 / bsp312
bsp101
bsp201
bsp301
------------------------------------------------
-- Anti Attrition
SELECT A.id_Arquivo,C.ds_TipoSeg,C.qt_QtdeTotalSolicitacaoCancel,B.ds_Motivo
FROM dbo.tbBR_tab_Arquivo AS A
	INNER JOIN tbGS_hst_TipoMotivos_Attrition AS B
		ON A.id_Arquivo = B.id_Arquivo
	INNER JOIN tbGS_hst_Anttrition AS C
		ON B.id_Arquivo = C.id_Arquivo
WHERE A.cs_Tipo IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO')
AND CONVERT(CHAR(10),A.dh_Ins,112) = '20160212'
------------------------------------------------
USE dbBA_Cartoes
GO
-- quando a rosana falar a data do fechamento, atualizar
-- se a data for maior que dia 11 alterar a data e rodar o processo novamente
UPDATE tbBA_tab_Fechamento 
SET dt_FechEnvioEmail = '2016-03-11',dt_FechProcArquivo = '2016-03-11'
WHERE id_AnoMesFech = 201602;
GO

INSERT INTO tbBA_tab_Fechamento VALUES(201603,'2016-04-11','2016-04-11',7);
GO
SELECT *
FROM tbBA_tab_Fechamento
-------------------------------
-- Tamanho dos databases:
-------------------------------
SELECT 
	 d.NAME AS DB_Nome
    ,ROUND(SUM(mf.size) * 8 / 1024, 0) AS Tamanho_MBs
    ,(SUM(mf.size) * 8 / 1024) / 1024 AS Tamanho_GBs
FROM sys.master_files mf
	INNER JOIN sys.databases d 
		ON d.database_id = mf.database_id
WHERE d.database_id > 4 -- Skip system databases
GROUP BY d.NAME
ORDER BY d.NAME
-------------------------------
-- Cria tabela dinamicamente: 
-------------------------------
IF OBJECT_ID('CargaTeste','U') IS NOT NULL DROP TABLE CargaTeste
DECLARE
	 @count INT = 1
	,@create VARCHAR(MAX) = 'CREATE TABLE CargaTeste('
BEGIN
	WHILE @count <= 35
	BEGIN
		SET @create = @create +'Coluna'+CAST(@count AS CHAR(2))+' VARCHAR(255)'+','
		SET @count = @count + 1
	END	
	SET @create = (SELECT SUBSTRING(@create,1,LEN(@create)-1)+')')	
	EXEC (@create)
END
-------------------------------
-- Dados Estatisticas:
-------------------------------
SELECT
	I.ID OBJECTID, 
	T.NAME TABLENAME,
	I.INDID INDEX_STAT_ID, 
	I.NAME INDEX_STAT_NAME, 
	I.ROWMODCTR, 
	I.ROWS,
	I.DPAGES
FROM SYSINDEXES I 
	INNER JOIN SYS.TABLES T ON I.ID = T.OBJECT_ID  
	
UPDATE STATISTICS tbPC_tab_Campanha
WITH FULLSCAN, ALL	
--------------------------------
