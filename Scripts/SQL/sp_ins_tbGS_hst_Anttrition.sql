USE [dbGS_GSC] -- CRIADO
GO

/****** Object:  StoredProcedure [dbo].[sp_ins_tbGS_hst_Anttrition]    Script Date: 02/03/2016 17:09:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROC [dbo].[sp_ins_tbGS_hst_Anttrition]    
AS    
DECLARE    
  @id_Arquivo INT     
 ,@ds_Periodo VARCHAR(30)    
 ,@ds_TipoArquivo VARCHAR(30)         
     
SET @id_Arquivo = (ISNULL((SELECT MAX(id_Arquivo) FROM [tbBR_tab_Arquivo]),1))    
SET @ds_Periodo = (SELECT COLUNA1 FROM tmp_Att1 WHERE COLUNA1 LIKE 'de:%')    
SET @ds_TipoArquivo = (SELECT COLUNA1 FROM tmp_Att1 WHERE COLUNA1 IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO'))    
    
BEGIN     
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA2 LIKE '%Total de Solicita%'    
    
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA2 LIKE '%Quantidade%'    
     
    
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA1 LIKE '%de:%'    
    
    
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA1 = 'CANCELADOS'    
     
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA1 = 'RECUPERADOS'    
 
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA1 = 'CANCELAMENTO ILHA BRADESCO' 
     
 DELETE FROM tbGS_tmp_Attrition02    
 WHERE COLUNA1 LIKE '%TOTAL EM PORCENTAGEM%'    
END    
    
BEGIN    
 INSERT INTO [dbo].[tbGS_hst_Anttrition](    
     [id_Arquivo]    
    ,[ds_Periodo]    
    ,[ds_TipoArq]    
    ,[ds_TipoSeg]    
    ,[qt_QtdeTotalSolicitacaoCancel]    
    ,[qt_TotalPremio_1]    
    ,[qt_QtdeTotalCancel]    
    ,[qt_TotalPremio_2]    
    ,[qt_TotalRecuperados]    
    ,[qt_TotalPremio_3]    
    ,[qt_Qtde_A]    
    ,[qt_TotalPremio_A]    
    ,[qt_Qtde_B]    
    ,[qt_TotalPremio_B]    
    ,[qt_Qtde_C]    
    ,[qt_TotalPremio_C]    
    ,[qt_Qtde_D]    
    ,[qt_TotalPremio_D]    
    ,[qt_Qtde_E]    
    ,[qt_TotalPremio_E]    
    ,[qt_Qtde_F]    
    ,[qt_TotalPremio_F]    
    ,[qt_Qtde_G]    
    ,[qt_TotalPremio_G]    
    ,[qt_Qtde_H]    
    ,[qt_TotalPremio_H]    
    ,[qt_Qtde_I]    
    ,[qt_TotalPremio_I]    
    ,[qt_Qtde_J]    
    ,[qt_TotalPremio_J]    
    ,[qt_Qtde_K]    
    ,[qt_TotalPremio_K]    
    ,[qt_Qtde_L]    
    ,[qt_TotalPremio_L]    
    ,[qt_Qtde_M]    
    ,[qt_TotalPremio_M]    
    ,[qt_Qtde_N]    
    ,[qt_TotalPremio_N]    
    ,[qt_Qtde_O]    
    ,[qt_TotalPremio_O]    
    ,[qt_Qtde_P]    
    ,[qt_TotalPremio_P]    
    ,[qt_Qtde_Q]    
    ,[qt_TotalPremio_Q]    
    ,[qt_Qtde_R]    
    ,[qt_TotalPremio_R]    
    ,[qt_Qtde_S]    
    ,[qt_TotalPremio_S]    
    ,[qt_Qtde_T]    
    ,[qt_TotalPremio_T]    
    ,[qt_Qtde_U]    
    ,[qt_TotalPremio_U]    
    ,[qt_Qtde_V]    
    ,[qt_TotalPremio_V]    
    ,[qt_Qtde_W]    
    ,[qt_TotalPremio_W]    
    ,[qt_Qtde_X]    
    ,[qt_TotalPremio_X]    
    ,[qt_Qtde_Y]    
    ,[qt_TotalPremio_Y]    
    ,[qt_Qtde_Z]    
    ,[qt_TotalPremio_Z]    
    ,[qt_Qtde_AA]    
    ,[qt_TotalPremio_AA]    
    ,[qt_Qtde_AB]    
    ,[qt_TotalPremio_AB]    
    ,[qt_Qtde_AC]    
    ,[qt_TotalPremio_AC]    
    ,[qt_Qtde_AD]    
    ,[qt_TotalPremio_AD]    
    ,[qt_Qtde_AE]    
    ,[qt_TotalPremio_AE]    
    ,[qt_Qtde_AF]    
    ,[qt_TotalPremio_AF]    
    ,[qt_Qtde_AG]    
    ,[qt_TotalPremio_AG]    
    ,[qt_Qtde_AH]    
    ,[qt_TotalPremio_AH]    
    ,[qt_Qtde_AI]    
    ,[qt_TotalPremio_AI]    
    ,[qt_Qtde_AJ]    
    ,[qt_TotalPremio_AJ]    
    ,[qt_Qtde_AK]    
    ,[qt_TotalPremio_AK]    
    ,[qt_Qtde_AL]    
    ,[qt_TotalPremio_AL]    
    ,[qt_Qtde_AM]    
    ,[qt_TotalPremio_AM]    
    ,[qt_Qtde_AN]    
    ,[qt_TotalPremio_AN]    
    ,[qt_Qtde_AO]    
    ,[qt_TotalPremio_AO]    
    ,[qt_Qtde_AP]    
    ,[qt_TotalPremio_AP]    
    ,[qt_Qtde_AQ]    
    ,[qt_TotalPremio_AQ]    
    ,[qt_Qtde_AR]    
    ,[qt_TotalPremio_AR]    
    ,[qt_Qtde_AS]    
    ,[qt_TotalPremio_AS]    
    ,[qt_Qtde_AT]    
    ,[qt_TotalPremio_AT]    
    ,[qt_Qtde_AU]    
    ,[qt_TotalPremio_AU]    
    ,[qt_Qtde_AV]    
    ,[qt_TotalPremio_AV]    
    ,[qt_Qtde_AW]    
    ,[qt_TotalPremio_AW]    
    ,[qt_Qtde_AX]    
    ,[qt_TotalPremio_AX]    
    ,[qt_Qtde_AY]    
    ,[qt_TotalPremio_AY]    
    ,[qt_Qtde_AZ]    
    ,[qt_TotalPremio_AZ]    
    ,[qt_Qtde_BA]    
    ,[qt_TotalPremio_BA]    
    ,[qt_Qtde_BB]    
    ,[qt_TotalPremio_BB]    
    ,[qt_Qtde_BC]    
    ,[qt_TotalPremio_BC]    
    ,[qt_Qtde_BD]    
    ,[qt_TotalPremio_BD]    
    ,[qt_Qtde_BE]    
    ,[qt_TotalPremio_BE]    
    ,[qt_Qtde_BF]    
    ,[qt_TotalPremio_BF]    
    ,[qt_Qtde_BG]    
    ,[qt_TotalPremio_BG]    
    ,[qt_Qtde_BH]    
    ,[qt_TotalPremio_BH]    
    ,[qt_Qtde_BI]    
    ,[qt_TotalPremio_BI]    
    
 )    
 SELECT @id_Arquivo    
    ,@ds_Periodo     
    ,@ds_TipoArquivo    
    ,[Coluna1]    
    ,CAST([Coluna2] AS INT)    
    ,CAST(REPLACE([Coluna3],',','.') AS MONEY)    
    ,CAST([Coluna4] AS INT)    
    ,CAST(REPLACE([Coluna5],',','.') AS MONEY)    
    ,CAST([Coluna6] AS INT)    
    ,CAST(REPLACE([Coluna7],',','.') AS MONEY)    
    ,CAST([Coluna8] AS INT)    
    ,CAST(REPLACE([Coluna9],',','.') AS MONEY)    
    ,CAST([Coluna10] AS INT)    
    ,CAST(REPLACE([Coluna11],',','.') AS MONEY)    
    ,CAST([Coluna12] AS INT)    
    ,CAST(REPLACE([Coluna13],',','.') AS MONEY)    
    ,CAST([Coluna14] AS INT)    
    ,CAST(REPLACE([Coluna15],',','.') AS MONEY)    
    ,CAST([Coluna16] AS INT)    
    ,CAST(REPLACE([Coluna17],',','.') AS MONEY)    
    ,CAST([Coluna18] AS INT)    
    ,CAST(REPLACE([Coluna19],',','.') AS MONEY)    
    ,CAST([Coluna20] AS INT)    
    ,CAST(REPLACE([Coluna21],',','.') AS MONEY)    
    ,CAST([Coluna22] AS INT)    
    ,CAST(REPLACE([Coluna23],',','.') AS MONEY)    
    ,CAST([Coluna24] AS INT)    
    ,CAST(REPLACE([Coluna25],',','.') AS MONEY)    
    ,CAST([Coluna26] AS INT)    
    ,CAST(REPLACE([Coluna27],',','.') AS MONEY)    
    ,CAST([Coluna28] AS INT)    
    ,CAST(REPLACE([Coluna29],',','.') AS MONEY)    
    ,CAST([Coluna30] AS INT)    
    ,CAST(REPLACE([Coluna31] ,',','.') AS MONEY)    
    ,CAST([Coluna32] AS INT)    
    ,CAST(REPLACE([Coluna33],',','.') AS MONEY)    
    ,CAST([Coluna34] AS INT)    
    ,CAST(REPLACE([Coluna35],',','.') AS MONEY)    
    ,CAST([Coluna36] AS INT)    
    ,CAST(REPLACE([Coluna37],',','.') AS MONEY)    
    ,CAST([Coluna38] AS INT)    
    ,CAST(REPLACE([Coluna39],',','.') AS MONEY)    
    ,CAST([Coluna40] AS INT)    
    ,CAST(REPLACE([Coluna41],',','.') AS MONEY)    
    ,CAST([Coluna42] AS INT)    
    ,CAST(REPLACE([Coluna43],',','.') AS MONEY)    
    ,CAST([Coluna44] AS INT)    
    ,CAST(REPLACE([Coluna45],',','.') AS MONEY)    
    ,CAST([Coluna46] AS INT)    
    ,CAST(REPLACE([Coluna47],',','.') AS MONEY)    
    ,CAST([Coluna48] AS INT)    
    ,CAST(REPLACE([Coluna49],',','.') AS MONEY)    
    ,CAST([Coluna50] AS INT)    
    ,CAST(REPLACE([Coluna51],',','.') AS MONEY)    
    ,CAST([Coluna52] AS INT)    
    ,CAST(REPLACE([Coluna53],',','.') AS MONEY)    
    ,CAST([Coluna54] AS INT)    
    ,CAST(REPLACE([Coluna55],',','.') AS MONEY)    
    ,CAST([Coluna56] AS INT)    
    ,CAST(REPLACE([Coluna57],',','.') AS MONEY)    
    ,CAST([Coluna58] AS INT)    
    ,CAST(REPLACE([Coluna59],',','.') AS MONEY)    
    ,CAST([Coluna60] AS INT)    
    ,CAST(REPLACE([Coluna61],',','.') AS MONEY)    
    ,CAST([Coluna62] AS INT)    
    ,CAST(REPLACE([Coluna63],',','.') AS MONEY)    
    ,CAST([Coluna64] AS INT)    
    ,CAST(REPLACE([Coluna65],',','.') AS MONEY)    
    ,CAST([Coluna66] AS INT)    
    ,CAST(REPLACE([Coluna67],',','.') AS MONEY)    
    ,CAST([Coluna68] AS INT)    
    ,CAST(REPLACE([Coluna69],',','.') AS MONEY)    
    ,CAST([Coluna70] AS INT)    
    ,CAST(REPLACE([Coluna71],',','.') AS MONEY)    
    ,CAST([Coluna72] AS INT)    
    ,CAST(REPLACE([Coluna73],',','.') AS MONEY)    
    ,CAST([Coluna74] AS INT)    
    ,CAST(REPLACE([Coluna75],',','.') AS MONEY)    
    ,CAST([Coluna76] AS INT)    
    ,CAST(REPLACE([Coluna77],',','.') AS MONEY)    
    ,CAST([Coluna78] AS INT)    
    ,CAST(REPLACE([Coluna79],',','.') AS MONEY)    
    ,CAST([Coluna80] AS INT)    
    ,CAST(REPLACE([Coluna81],',','.') AS MONEY)    
    ,CAST([Coluna82] AS INT)    
    ,CAST(REPLACE([Coluna83],',','.') AS MONEY)    
    ,CAST([Coluna84] AS INT)    
    ,CAST(REPLACE([Coluna85],',','.') AS MONEY)    
    ,CAST([Coluna86] AS INT)    
    ,CAST(REPLACE([Coluna87],',','.') AS MONEY)    
    ,CAST([Coluna88] AS INT)    
    ,CAST(REPLACE([Coluna89],',','.') AS MONEY)    
    ,CAST([Coluna90] AS INT)    
    ,CAST(REPLACE([Coluna91],',','.') AS MONEY)    
    ,CAST([Coluna92] AS INT)    
    ,CAST(REPLACE([Coluna93],',','.') AS MONEY)    
    ,CAST([Coluna94] AS INT)    
    ,CAST(REPLACE([Coluna95],',','.') AS MONEY)    
    ,CAST([Coluna96] AS INT)    
    ,CAST(REPLACE([Coluna97],',','.') AS MONEY)    
    ,CAST([Coluna98] AS INT)    
    ,CAST(REPLACE([Coluna99],',','.') AS MONEY)    
    ,CAST([Coluna100] AS INT)    
    ,CAST(REPLACE([Coluna101],',','.') AS MONEY)    
    ,CAST([Coluna102] AS INT)    
    ,CAST(REPLACE([Coluna103],',','.') AS MONEY)    
    ,CAST([Coluna104] AS INT)    
    ,CAST(REPLACE([Coluna105],',','.') AS MONEY)    
    ,CAST([Coluna106] AS INT)    
    ,CAST(REPLACE([Coluna107],',','.') AS MONEY)    
    ,CAST([Coluna108] AS INT)    
    ,CAST(REPLACE([Coluna109],',','.') AS MONEY)    
    ,CAST([Coluna110] AS INT)    
    ,CAST(REPLACE([Coluna111],',','.') AS MONEY)    
    ,CAST([Coluna112] AS INT)    
    ,CAST(REPLACE([Coluna113],',','.') AS MONEY)    
    ,CAST([Coluna114] AS INT)    
    ,CAST(REPLACE([Coluna115],',','.') AS MONEY)    
    ,CAST([Coluna116] AS INT)    
    ,CAST(REPLACE([Coluna117],',','.') AS MONEY)    
    ,CAST([Coluna118] AS INT)    
    ,CAST(REPLACE([Coluna119],',','.') AS MONEY)    
    ,CAST([Coluna120] AS INT)    
    ,CAST(REPLACE([Coluna121],',','.') AS MONEY)    
    ,CAST([Coluna122] AS INT)    
    ,CAST(REPLACE([Coluna123],',','.') AS MONEY)    
    ,CAST([Coluna124] AS INT)    
    ,CAST(REPLACE([Coluna125],',','.') AS MONEY)    
    ,CAST([Coluna126] AS INT)    
    ,CAST(REPLACE([Coluna127],',','.') AS MONEY)    
    ,CAST([Coluna128] AS INT)    
    ,CAST(REPLACE([Coluna129],',','.') AS MONEY)     
 FROM [dbo].[tbGS_tmp_Attrition02]    
END       

GO


