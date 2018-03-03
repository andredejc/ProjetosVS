  
CREATE PROC [dbo].[sp_ins_tmp_TipoMotivos_Attrition]  
AS  
-- Trunca a table tmp_Trata_MotivosCancel  
BEGIN  
 TRUNCATE TABLE [tbGS_tmp_Trata_TipoMotivos_Attrition]  
END  
-- Insere somente os Motivos de cancelamento na tabela com os valores de tmp_AttritionDinamica  
BEGIN   
 INSERT INTO [tbGS_tmp_Trata_TipoMotivos_Attrition](ds_Motivo)  
 SELECT COLUNA1  
 FROM tmp_Att1   
 WHERE COLUNA1 IS NOT NULL  
 AND COLUNA1 LIKE '% - %'  
 AND COLUNA2 IS NULL  
END   
  
-- Insere na tabela tbGS_tmp_TipoMotivos_Attrition  
BEGIN  
 DECLARE  
   @count INT = 1  
  ,@columns VARCHAR(MAX) = 'INSERT INTO [tbGS_tmp_TipoMotivos_Attrition]'                            
  ,@values VARCHAR(MAX) = 'VALUES('  
  ,@SQL VARCHAR(MAX) = ''   
    
 BEGIN  
  WHILE @count <= 61  
  BEGIN  
   IF (SELECT ds_Motivo FROM [tbGS_tmp_Trata_TipoMotivos_Attrition] WHERE id=@count) IS NOT NULL  
    BEGIN           
     SET @values = @values +''''+(SELECT CAST((SELECT RTRIM(LTRIM(ds_Motivo)) FROM [tbGS_tmp_Trata_TipoMotivos_Attrition] WHERE id=@count)AS VARCHAR))+''''+','          
    END   
     
   ELSE  
    BEGIN    
     SET @values = @values +''''+''''+','  
    END   
  SET @count = @count + 1  
  END -- END WHILE    
   SET @values = (SELECT SUBSTRING(@values,1,LEN(@values)-1)+')')     
   SET @SQL = @SQL + @columns + @values  
  
  EXEC(@SQL)  
 END  
END   
  