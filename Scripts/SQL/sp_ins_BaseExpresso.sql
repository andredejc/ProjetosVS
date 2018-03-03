USE [dbEX_Expresso]
GO
/****** Object:  StoredProcedure [dbo].[sp_ins_BaseExpresso]    Script Date: 02/02/2016 15:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_ins_BaseExpresso](    
  @str_Arquivo   VARCHAR(150) = NULL    
 ,@int_QtdeReg   INT    = NULL    
 ,@str_DirArquivo  VARCHAR(250) = NULL    
 ,@dh_arquivo   datetime = null    
)    
AS    
    
-- =================================================    
-- CLIENTE........: BSP AFFINITY    
-- PROJETO........: IMPORT BASE EXPRESSO    
-- SERVIDOR.......: MZ-VV-BD-015    
-- BANCO DE DADOS.: dbEX_Expresso    
-- AUTOR..........: HENRIQUE CARVALHO     
-- DATA...........: 02/02/2015    
-- DESCRIÇÃO......: INSERT DA BASE PRINCIPAL DO EXPRESSO    
    
-- ALTERAÇÃO 1    
 -- AUTOR......:     
 -- DATA.......:     
 -- DESCRIÇÃO..:     
-- =================================================     
    
-- =================================================     
-- DOCUMENTAÇÃO DOS OBJETOS    
    
-- TABELAS:    
 --     
     
-- VIEWS:    
 --     
     
-- PROCEDURES:    
 --     
    
-- =================================================     
    
-- =================================================     
-- LISTA DE ERROS    
    
    
-- =================================================     
    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET DATEFORMAT DMY    
set ansi_warnings off    
SET LANGUAGE us_english    
SET CONCAT_NULL_YIELDS_NULL ON    
SET NOCOUNT ON    
    
    
DECLARE    
  @str_ErrorMessage NVARCHAR(4000)    
 ,@int_ErrorSeverity INT    
 ,@MSG  VARCHAR(8000) =''    
 ,@int_ErrorState INT    
 ,@str_MsgErro VARCHAR(8000)    
 ,@big_Base BIGINT    
 ,@big_Arquivo BIGINT    
 ,@int_Operacao INT    
 ,@str_Qry NVARCHAR(4000)    
 ,@sml_Tel SMALLINT    
 ,@int_EPS INT    
 ,@str_cdCampanha VARCHAR(30)    
 ,@int_Arquivo int    
 ,@int_upd int    
 ,@int_ins int    
     
BEGIN TRY    
    
 BEGIN TRANSACTION;    
     
     
   SET @int_Arquivo = ISNULL((SELECT MAX(id_Arquivo)+1 FROM TBEX_tab_Arquivo),1);                                          
      SET @dh_arquivo =  ISNULL((SELECT MAX(DT_ARQUIVO) FROM TBEX_TMP_BASEEXPRESSO),NULL);                                       
                                                
      INSERT INTO TBEX_tab_Arquivo(id_Arquivo,nm_Arquivo,dh_Ins,cs_Tipo,qt_Reg,pt_Arquivo,dh_Arquivo)                                          
      VALUES(@int_Arquivo,@str_Arquivo,GETDATE(),'Base Expresso',@int_QtdeReg,@str_DirArquivo,@dh_arquivo);         
    
     
     
UPDATE [tbEX_tab_CorrespondenteFULL] SET ST_ATIVO = 0;    
    
    
    
    
UPDATE A SET    
A.cd_ChaveLoja = B.cd_ChaveLoja    
,A.nm_RazaoSocialEmp = B.nm_RazaoSocialEmp    
,A.nm_Empresa = B.nm_Empresa    
,A.cd_loja = B.cd_loja    
,A.nm_Loja = B.nm_Loja     
,A.cd_AgRel = cast(B.cd_AgRel as int)    
,A.nm_AgRelac = B.nm_AgRelac    
,A.ds_EndUFAgRelac = B.ds_UFAg    
,A.nr_PACB = cast(B.nr_PACB as int)    
,A.nr_AgPACB = cast(B.nr_PACBAg as int)    
,A.dt_Inauguracao = B.dt_Inauguracao    
,A.ds_EndLogr = cast(ltrim(rtrim(B.ds_EndLogr)) as varchar(180))    
,A.ds_EndNumero = cast(ltrim(rtrim(B.ds_EndNumero)) as varchar(40))    
,A.ds_EndBairro = cast(ltrim(rtrim(B.ds_EndBairro)) as varchar(100))    
,A.ds_EndCEP = B.ds_EndCEP    
,A.ds_EndCidade = B.ds_EndCidade    
,A.ds_EndUF = B.ds_EndUF    
,A.nr_DDD = cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDD,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDD,'-',''),'/',''),' ','')
,'NÃOINFORMADO',''),'V',''),'''','')) = 1 
							AND B.nr_Tel NOT LIKE '%,%' AND ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1 THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDD,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as smallint)    
,A.nr_Tel = cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ','')
,'NÃOINFORMADO',''),'V',''),'''','')) = 1     
                           AND B.nr_Tel NOT LIKE '%,%' THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as bigint)    
,A.nr_CNPJ = cast(CASE WHEN ISNULL(B.nr_CNPJ,0) <> 0  THEN B.nr_cnpj+right('0000'+B.nr_cnpj_filial,4)+right('00'+B.nr_CNPJ_Controle,2) END as bigint)    
,A.cd_Mult = cast(CASE WHEN ISNULL(B.cd_Mult,'') <> '' THEN B.cd_Mult END as bigint)    
,A.nm_RazaoSocial = B.nm_RazaoSocialEmp    
,A.nm_Fantasia = B.nm_Fantasia    
,A.nr_CNPJ_Multiplicador = CASE WHEN ISNULL(B.nr_CNPJ_Multiplicador,0) <> 0  THEN B.nr_CNPJ_Multiplicador+right('0000'+B.nr_CNPJ_Filial_Multiplicador,4)+right('00'+B.nr_CNPJ_Controle_Multiplicador,2) END    
,A.nm_Contato = B.nm_Contato    
,A.nr_DDDContato = cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1    
                                  AND ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDDContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDDContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1 THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDDContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as smallint)    
,A.nr_TelContato = cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1 THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as bigint)    
,A.qt_Trans = cast(B.Qt_Trans as int)    
,A.qt_Contas = cast(B.qt_Contas as int)    
,A.qt_Lime = cast(B.qt_Lime as int)    
,A.qt_Cartao = cast(B.qt_Cartao as int)    
,A.cd_GerREg = cast(B.cd_GerREg as bigint)    
,A.cd_IBGE = cast(B.cd_IBGE as bigint)    
,A.ds_GerRegional = B.ds_GerReg    
,A.cd_DirReg = cast(B.cd_DirReg as bigint)    
,A.ds_DirRegional = B.ds_DirReg    
,A.cd_Supervisao = cast(B.cd_Supervisao as bigint)    
,A.ds_Supervisao = B.ds_Supervisao    
,A.cd_Coordenacao = cast(B.cd_Coordenacao as bigint)    
,A.ds_Coordenacao = B.ds_Supervisao    
,A.cd_GerenciaArea = cast(B.cd_GerenciaArea as bigint)    
,A.ds_GerenciaArea = B.ds_GerenciaArea    
,A.ds_CbVinculadaPA = B.ds_CbVinculadaPA    
,A.ds_CbOrgaoPagadorINSS = B.ds_CbOrgaoPagadorINSS    
,A.st_Multiplicador = B.st_Multiplicador    
,A.nm_EmpresaTEF = B.nm_EmpresaTEF    
,A.dt_MesRef = B.dt_MesRef    
       ,A.nm_Arquivo = ''    
       ,A.st_Ativo = 1    
       ,A.dh_Upd = @dh_arquivo    
FROM [tbEX_tab_CorrespondenteFULL] A    
INNER JOIN TBEX_TMP_BASEEXPRESSO B ON B.cd_Empresa = A.cd_Empresa AND cast(B.cd_Loja as bigint) = A.cd_Loja    
    
    
set @int_upd = @@rowcount    
    
    
----------------------------------------    
----------------------------------------    
----------------------------------------    
INSERT INTO [tbEX_tab_CorrespondenteFULL](    
cd_ChaveLoja    
,nm_RazaoSocialEmp    
,cd_Loja    
,nm_Loja    
,nm_Empresa    
,cd_AgRel    
,nm_AgRelac    
,ds_EndUFAgRelac    
,nr_PACB    
,nr_AgPACB    
,dt_Inauguracao    
,ds_EndLogr    
,ds_EndNumero    
,ds_EndBairro    
,ds_EndCEP    
,ds_EndCidade    
,ds_EndUF    
,nr_DDD    
,nr_Tel    
,nr_CNPJ    
,cd_Mult    
,nm_RazaoSocial     
,nm_Fantasia    
,nr_CNPJ_Multiplicador    
,nm_Contato    
,nr_DDDContato    
,nr_TelContato    
,qt_Trans    
,qt_Contas    
,qt_Lime    
,qt_Cartao    
,cd_GerREg    
,cd_IBGE    
,ds_GerRegional    
,cd_DirReg    
,ds_DirRegional    
,cd_Supervisao    
,ds_Supervisao    
,cd_Coordenacao    
,ds_Coordenacao    
,cd_GerenciaArea    
,ds_GerenciaArea    
,ds_CbVinculadaPA    
,ds_CbOrgaoPagadorINSS    
,st_Multiplicador    
,nm_EmpresaTEF    
,dt_MesRef    
,nm_Arquivo    
,st_Ativo    
,dh_INS    
,cd_Empresa    
)    
SELECT    
B.cd_ChaveLoja    
,B.nm_Empresa    
,ISNULL(B.cd_Loja,'')    
,ISNULL(B.nm_Loja,'')    
,ISNULL(B.nm_Empresa,'')
,cast(B.cd_AgRel as int)    
,ISNULL(B.nm_AgRelac,'')
,ISNULL(B.ds_UFAg,'')    
,cast(B.nr_PACB as int)    
,cast(B.nr_PACBAg as int)    
,ISNULL(B.dt_Inauguracao,'')
,cast(ltrim(rtrim(B.ds_EndLogr)) as varchar(180))    
,cast(ltrim(rtrim(B.ds_EndNumero)) as varchar(40))    
,cast(ltrim(rtrim(B.ds_EndBairro)) as varchar(100))    
,ISNULL(B.ds_EndCEP,'')
,ISNULL(B.ds_EndCidade,'')   
,ISNULL(B.ds_EndUF,'')    
,cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDD,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDD,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1    
                           AND B.nr_Tel NOT LIKE '%,%' AND ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1 THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDD,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as smallint)    
,cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1     
                           AND B.nr_Tel NOT LIKE '%,%' THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_Tel,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as bigint)    
,cast(CASE WHEN ISNULL(B.nr_CNPJ,0) <> 0  THEN B.nr_cnpj+right('0000'+B.nr_cnpj_filial,4)+right('00'+B.nr_CNPJ_Controle,2) END as bigint)    
,cast(CASE WHEN ISNULL(B.cd_Mult,'') <> '' THEN B.cd_Mult END as bigint)    
,ISNULL(B.nm_RazaoSocialEmp,'')    
,ISNULL(B.nm_Fantasia,'')    
,CASE WHEN ISNULL(B.nr_CNPJ_Multiplicador,0) <> 0  THEN B.nr_CNPJ_Multiplicador+right('0000'+B.nr_CNPJ_Filial_Multiplicador,4)+right('00'+B.nr_CNPJ_Controle_Multiplicador,2) END    
,ISNULL(B.nm_Contato,'')    
,cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1    
                                  AND ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDDContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDDContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1 THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_DDDContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as smallint)    
,cast(CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''',''),'') <> '' AND ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','')) = 1 THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.nr_TelContato,'-',''),'/',''),' ',''),'NÃOINFORMADO',''),'V',''),'''','') END as bigint)    
,cast(B.Qt_Trans as int)    
,cast(B.qt_Contas as int)    
,cast(B.qt_Lime as int)    
,cast(B.qt_Cartao as int)    
,cast(B.cd_GerReg as bigint)    
,cast(B.cd_IBGE as bigint)    
,B.ds_GerReg    
,cast(B.cd_DirReg as bigint)    
,B.ds_DirReg    
,cast(B.cd_Supervisao as bigint)    
,B.ds_Supervisao    
,cast(B.cd_Coordenacao as bigint)    
,B.ds_Supervisao    
,cast(B.cd_GerenciaArea as bigint)    
, B.ds_GerenciaArea    
, B.ds_CbVinculadaPA    
, B.ds_CbOrgaoPagadorINSS    
,B.st_Multiplicador    
,B.nm_EmpresaTef    
,B.dt_MesRef    
,''    
, 1    
,@dh_arquivo    
,B.cd_Empresa    
FROM TBEX_TMP_BASEEXPRESSO B    
LEFT JOIN [tbEX_tab_CorrespondenteFULL] A ON B.cd_Empresa = A.cd_Empresa AND cast(B.cd_Loja as bigint) = A.cd_Loja    
WHERE A.id_Correspondente IS NULL;    
    
    
set @int_ins = @@ROWCOUNT        
    
    
SET @MSG = 'PROCESSAMENTO BASE EXPRESSO ' +CHAR(11)+ '-------------------------------------------'+CHAR(11)    
SET @MSG += 'DATA DO PROCESSAMENTO.: '+CONVERT(VARCHAR(10),GETDATE(),103) +CHAR(11)    
SET @MSG += 'QUANTIDADE INSERIDOS.: '+CAST(@int_ins AS VARCHAR) +CHAR(11)    
SET @MSG += 'QUANTIDADE UPDATES.: '+CAST(@int_upd AS VARCHAR) +CHAR(11)+ '-------------------------------------------'+CHAR(11)    
    
    
SELECT @MSG as 'ds_CorpoEmail'     
    
 -- ======================================================    
 -- CONFIRMAR E SAI DA PROC    
 -- ======================================================    
    COMMIT TRANSACTION;    
    
        
    fn_ProcErro:    
        
  -- GRAVAR LOG DE ERRO    
  IF @str_MsgErro IS NULL    
   SET @str_MsgErro = 'Erro não especificado fn_ProcErro <sp_ins_BaseExpresso>.'    
       
  EXEC [sp_ins_GravaLog] NULL,NULL,null,'Erro','sp_ins_BaseExpresso'    
       ,@int_ErrorState,@int_ErrorSeverity,@str_ErrorMessage,NULL;    
        
END TRY    
BEGIN CATCH    
     
 ROLLBACK TRANSACTION;    
     
 SELECT     
  @str_ErrorMessage = ERROR_MESSAGE(),    
  @int_ErrorSeverity = ERROR_SEVERITY(),    
  @int_ErrorState = ERROR_STATE();    
       
 -- GRAVAR LOG DE ERRO    
 EXEC [sp_ins_GravaLog] NULL,NULL,null,'Erro','sp_ins_BaseExpresso'    
       ,@int_ErrorState,@int_ErrorSeverity,@str_ErrorMessage,NULL;    
            
    RETURN;    
        
END CATCH;    
        
-- SELECT MAX(dh_Arquivo),MAX(dh_Ins) as dh_Arquivo FROM [tbEX_tab_Arquivo]    
--WHERE NM_ARQUIVO LIKE 'Base_BradescoExpresso.xls%'
