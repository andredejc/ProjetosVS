
USE dbBR_PainelControle
SET NOCOUNT ON
SELECT 'INSERT INTO [tbPC_tab_Agencia] VALUES(' +
	CHAR(39)+ LTRIM(RTRIM(CAST([id_Agencia] AS VARCHAR(255))))              + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_AgProdutoVida] AS VARCHAR(255))))        + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_AgJunc] AS VARCHAR(255))))               + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_AgDig] AS VARCHAR(255))))                + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Agencia] AS VARCHAR(255))))              + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Gerente] AS VARCHAR(255))))              + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_EndLogr] AS VARCHAR(255))))              + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_EndCidade] AS VARCHAR(255))))            + CHAR(39)+ ','+  
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_EndUF] AS VARCHAR(255))))                + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_TelDDD] AS VARCHAR(255))))               + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_TelNum] AS VARCHAR(255))))               + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_JuncSeg] AS VARCHAR(255))))              + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Segmento] AS VARCHAR(255))))             + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_JuncDr] AS VARCHAR(255))))               + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Diretoria] AS VARCHAR(255))))            + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_JuncGr] AS VARCHAR(255))))               + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Gerencia] AS VARCHAR(255))))             + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_JuncPrev] AS VARCHAR(255))))             + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Sucursal] AS VARCHAR(255))))             + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_JuncSupex] AS VARCHAR(255))))            + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_Supex] AS VARCHAR(255))))                + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_JuncVida] AS VARCHAR(255))))             + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([dt_Inauguracao] AS VARCHAR(255))))          + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([st_Ativo] AS VARCHAR(255))))                + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_Longitude] AS VARCHAR(255))))            + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_Latitude] AS VARCHAR(255))))             + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_Porte] AS VARCHAR(255))))                + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([ds_EndCEP] AS VARCHAR(255))))               + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_SupComercial] AS VARCHAR(255))))         + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_MatriculaGerComercial] AS VARCHAR(255))))+ CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nm_GerComercial] AS VARCHAR(255))))         + CHAR(39)+ ','+ 
	CHAR(39)+ LTRIM(RTRIM(CAST([nr_MatriculaSupComercial] AS VARCHAR(255))))+ CHAR(39)+ ')'
FROM tbPC_tab_Agencia      
    