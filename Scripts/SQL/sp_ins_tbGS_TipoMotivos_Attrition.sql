USE [dbGS_GSC] -- CRIADO
GO

/****** Object:  StoredProcedure [dbo].[sp_ins_tbGS_hst_TipoMotivos_Attrition]    Script Date: 02/03/2016 17:13:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROC [dbo].[sp_ins_TipoMotivos_Attrition]     
AS    
DECLARE    
  @id_Arquivo INT     
 ,@ds_Periodo VARCHAR(30)    
 ,@ds_TipoArquivo VARCHAR(30)         
     
SET @id_Arquivo = (ISNULL((SELECT MAX(id_Arquivo) FROM [tbBR_tab_Arquivo]),1))    
SET @ds_Periodo = (SELECT COLUNA1 FROM tbGS_tmp_Attrition01 WHERE COLUNA1 LIKE 'de:%')    
SET @ds_TipoArquivo = (SELECT COLUNA1 FROM tbGS_tmp_Attrition01 WHERE COLUNA1 IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO'))    
    
BEGIN   
 INSERT INTO [tbGS_hst_TipoMotivos_Attrition]    
 (   
   id_Arquivo    
  ,ds_Periodo  
  ,ds_TipoArquivo  
  ,ds_Motivo   
 )    
 SELECT    
   @id_Arquivo  
  ,@ds_Periodo  
  ,@ds_TipoArquivo  
  ,COLUNA1    
  FROM tbGS_tmp_Attrition01     
  WHERE COLUNA1 IS NOT NULL    
  AND COLUNA1 LIKE '% - %'    
  AND COLUNA2 IS NULL      
END             
  
GO