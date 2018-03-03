USE [dbGS_GSC] -- CRIADO
GO

/****** Object:  StoredProcedure [dbo].[sp_ins_ArquivoAttrition]    Script Date: 02/03/2016 17:07:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[sp_ins_tbGS_ArquivoAttrition](    
  @str_Arquivo  VARCHAR(150) = NULL    
 ,@str_DirArquivo VARCHAR(255) = NULL    
 ,@int_QtImport  INT = 0   
 ,@dh_Ins   DATETIME = NULL      
)   
AS  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
 SET DATEFORMAT YMD    
 SET LANGUAGE us_english    
 SET CONCAT_NULL_YIELDS_NULL OFF    
 SET NOCOUNT ON    
DECLARE  
 @int_Arquivo INT    
 ,@str_csTipo VARCHAR(30)   
 ,@str_hostname VARCHAR(30)  
  
SET @int_Arquivo = ISNULL((SELECT MAX(id_Arquivo)+1 FROM [tbBR_tab_Arquivo]),1);    
SET @str_csTipo = (SELECT COLUNA1 FROM tbGS_tmp_Attrition01 WHERE COLUNA1 IN ('CANCELADOS','RECUPERADOS','CANCELAMENTO ILHA BRADESCO'))  
SET @str_hostname = (SELECT HOST_NAME())  
     
INSERT INTO [tbBR_tab_Arquivo]  
(  
 id_Arquivo  
 ,nm_Arquivo  
 ,pt_Arquivo  
 ,dh_Ins  
 ,ds_HostName  
 ,dh_Carga  
 ,qt_RegImport  
 ,qt_RegRecusa  
 ,st_Proc  
 ,cs_Tipo  
)    
VALUES  
(  
 @int_Arquivo  
 ,@str_Arquivo  
 ,@str_DirArquivo  
 ,CONVERT(DATETIME,@dh_Ins)  
 ,@str_hostname  
 ,GETDATE()  
 ,@int_QtImport  
 ,0  
 ,1  
 ,@str_csTipo  
);   
  
GO


