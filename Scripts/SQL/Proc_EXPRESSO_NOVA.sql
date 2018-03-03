SET DATEFORMAT dmy

IF OBJECT_ID(N'tempdb..#SAIDA', N'U') IS NOT NULL
DROP TABLE #SAIDA;
	
CREATE TABLE #SAIDA(COLUNA VARCHAR(10))

DECLARE           
	@qtde_insert INT,
	@qtde_upd INT,
	@msg VARCHAR(8000)
	
	
	
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	

DELETE FROM tbEX_tmp_BaseExpressoProdutos
WHERE nm_RazaoSocial = 'VOLTAR';

DELETE FROM tbEX_tmp_BaseExpressoProdutos
WHERE nm_RazaoSocial = 'PLANILHA DE CONTROLE DE CORRESPONDENTE - BRADESCO EXPRESSO';

DELETE FROM tbEX_tmp_BaseExpressoProdutos
WHERE nm_RazaoSocial = 'RAZÃO SOCIAL';

DELETE FROM tbEX_tmp_BaseExpressoProdutos
WHERE nm_RazaoSocial IS NULL;


UPDATE A SET A.cd_ChaveLoja = B.cd_ChaveLoja,A.cd_Loja = B.cd_Loja
FROM tbEX_tmp_BaseExpressoProdutos A
INNER JOIN [tbEX_tab_CorrespondenteFULL] B ON B.nr_CNPJ = A.nr_Cnpj;


UPDATE A SET A.cd_ChaveLoja = B.cd_ChaveLoja,A.cd_Loja = B.cd_Loja
FROM tbEX_tab_BaseExpressoProdutos A
INNER JOIN [tbEX_tab_CorrespondenteFULL] B ON B.nr_CNPJ = A.nr_Cnpj
WHERE A.cd_ChaveLoja IS NULL;

UPDATE tbEX_tmp_BaseExpressoProdutos SET cd_ChaveLoja = 136206,cd_Loja = 1
WHERE cd_ChaveLoja IS NULL AND nr_Cnpj = '14301077000103';

UPDATE tbEX_tmp_BaseExpressoProdutos SET cd_ChaveLoja = 62280,cd_Loja = 1
WHERE cd_ChaveLoja IS NULL AND nr_Cnpj = '2529998000108';

UPDATE tbEX_tmp_BaseExpressoProdutos SET cd_ChaveLoja = 41725,cd_Loja = 1
WHERE cd_ChaveLoja IS NULL AND nr_Cnpj = '10721218000199';

UPDATE tbEX_tmp_BaseExpressoProdutos SET cd_ChaveLoja = 22759,cd_Loja = 1
WHERE cd_ChaveLoja IS NULL AND nr_Cnpj = '08701185000137';

---------------------------------------------------------------------------------

DECLARE @var INT = (SELECT TOP 1 COUNT(nr_Cnpj) FROM tbEX_tab_BaseExpressoProdutos GROUP BY nr_Cnpj HAVING COUNT(nr_Cnpj) > 1)

IF @var > 1 BEGIN
	DELETE A
	FROM tbEX_tab_BaseExpressoProdutos AS A
		INNER JOIN (SELECT nr_Cnpj FROM tbEX_tab_BaseExpressoProdutos GROUP BY nr_Cnpj HAVING COUNT(nr_Cnpj) > 1) AS B 
		ON A.nr_Cnpj = B.nr_Cnpj
	WHERE A.dt_RecebProdutos IN (SELECT MIN(CAST(dt_RecebProdutos AS DATE))FROM tbEX_tab_BaseExpressoProdutos GROUP BY nr_Cnpj HAVING COUNT(nr_Cnpj) > 1)
END	

MERGE tbEX_tab_BaseExpressoProdutos AS A
USING tbEX_tmp_BaseExpressoProdutos AS B
	ON (A.cd_ChaveLoja = B.cd_ChaveLoja 
	AND A.cd_Loja = B.cd_Loja)
WHEN MATCHED THEN
UPDATE SET  A.nm_RazaoSocial = CAST(B.nm_RazaoSocial AS VARCHAR(80)) 
			,A.nr_Cnpj = CAST(B.nr_Cnpj AS BIGINT) 
			,A.cd_Van = CAST(B.cd_Van AS INT) 
			,A.ds_Van = CAST(B.ds_Van AS VARCHAR(30)) 
			,A.ds_Email = CAST(B.ds_Email AS VARCHAR(50)) 
			,A.ds_Termo = CAST(UPPER(B.ds_Termo) AS VARCHAR(5)) 
			,A.ds_Status = CAST(B.ds_Status AS VARCHAR(30)) 
			,A.ds_AreaResponsavel = CAST(B.ds_AreaResponsavel AS VARCHAR(15)) 
			,A.dt_RecebProdutos = CAST(B.dt_RecebProdutos AS DATETIME) 
			,A.dt_EnvioDecco = CAST(B.dt_EnvioDecco AS DATETIME) 
			,A.dt_RetornoDecco = CAST(B.dt_RetornoDecco  AS DATETIME) 
			,A.dt_EnvioPOS = CAST(B.dt_EnvioPOS  AS DATETIME) 
			,A.dt_EnvioOrizon = CAST(B.dt_EnvioOrizon AS DATETIME) 
			,A.dt_EnvioTreinamento = CAST(B.dt_EnvioTreinamento AS DATETIME) 
			,A.dt_MesProducao = CAST(B.dt_MesProducao AS VARCHAR(15)) 
			,A.cd_Producao = CAST(B.cd_Producao AS BIGINT) 
			,A.ds_Endereco = CAST(B.ds_Endereco AS VARCHAR(50)) 
			,A.nr_Endereco = CAST(B.nr_Endereco AS VARCHAR(10)) 
			,A.ds_Complemento = CAST(B.ds_Complemento AS VARCHAR(30)) 
			,A.ds_Bairro = CAST(B.ds_Bairro AS VARCHAR(50)) 
			,A.ds_Cidade = CAST(B.ds_Cidade AS VARCHAR(30)) 
			,A.ds_Estado = CAST(B.ds_Estado AS VARCHAR(2)) 
			,A.nr_CEP = CAST(B.nr_CEP AS BIGINT) 
			,A.nr_Telefone = CAST(B.nr_Telefone AS VARCHAR(20)) 
			,A.ds_Ramo = CAST(B.ds_Ramo AS VARCHAR(50)) 
			,A.nr_Agencia = CAST(B.nr_Agencia AS VARCHAR(10)) 
			,A.nr_ContaCorrente = CAST(B.nr_ContaCorrente AS VARCHAR(20)) 
			,A.nr_QtdLojas = CAST(B.nr_QtdLojas AS INT) 
			,A.cd_ChaveLoja = CAST(B.cd_ChaveLoja AS BIGINT) 
			,A.cd_Loja = CAST(B.cd_Loja AS BIGINT) 
			,A.ds_Corretor = CAST(B.ds_Corretor AS VARCHAR(50)) 
			,A.ds_SUSEP = CAST(B.ds_SUSEP AS BIGINT) 
			,A.ds_Ativo = CAST(B.ds_Ativo AS VARCHAR(5)) 
			,A.ds_Bloqueado = CAST(B.ds_Bloqueado AS varchar(5)) 
			,A.dt_Bloqueio = CAST(B.dt_Bloqueio AS datetime) 
			,A.ds_ResponsProdutos = CAST(B.ds_ResponsProdutos AS VARCHAR(20)) 

WHEN NOT MATCHED THEN
INSERT 
VALUES
(
	 CAST(B.nm_RazaoSocial AS VARCHAR(80)) 
	,CAST(B.nr_Cnpj AS BIGINT)
	,CAST(B.cd_Van AS INT)
	,CAST(B.ds_Van AS VARCHAR(30))
	,CAST(B.ds_Email AS VARCHAR(50))
	,CAST(UPPER(B.ds_Termo) AS VARCHAR(5))
	,CAST(B.ds_Status AS VARCHAR(30)) 
	,CAST(B.ds_AreaResponsavel AS VARCHAR(15)) 
	,CAST(B.dt_RecebProdutos AS DATETIME) 
	,CAST(B.dt_EnvioDecco AS DATETIME) 
	,CAST(B.dt_RetornoDecco  AS DATETIME) 
	,CASE WHEN ISDATE(B.dt_EnvioPOS) = 0 THEN '' ELSE CAST(B.dt_EnvioPOS AS DATETIME) END 
	,CAST(B.dt_EnvioOrizon AS DATETIME) 
	,CAST(B.dt_EnvioTreinamento AS DATETIME) 
	,CAST(B.dt_MesProducao AS VARCHAR(15)) 
	,CAST(B.cd_Producao AS BIGINT) 
	,CAST(B.ds_Endereco AS VARCHAR(50)) 
	,CAST(B.nr_Endereco AS VARCHAR(10)) 
	,CAST(B.ds_Complemento AS VARCHAR(30)) 
	,CAST(B.ds_Bairro AS VARCHAR(50)) 
	,CAST(B.ds_Cidade AS VARCHAR(30)) 
	,CAST(B.ds_Estado AS VARCHAR(2)) 
	,CAST(B.nr_CEP AS BIGINT) 
	,CAST(B.nr_Telefone AS VARCHAR(20)) 
	,CAST(B.ds_Ramo AS VARCHAR(50)) 
	,CAST(B.nr_Agencia AS VARCHAR(10)) 
	,CAST(B.nr_ContaCorrente AS VARCHAR(20)) 
	,CAST(B.nr_QtdLojas AS INT) 
	,CAST(B.cd_ChaveLoja AS BIGINT) 
	,CAST(B.cd_Loja AS BIGINT) 
	,CAST(B.ds_Corretor AS VARCHAR(50)) 
	,CAST(B.ds_SUSEP AS BIGINT) 
	,CAST(B.ds_Ativo AS VARCHAR(5)) 
	,CAST(B.ds_Bloqueado AS varchar(5)) 
	,CAST(B.dt_Bloqueio AS datetime) 
	,CAST(B.ds_ResponsProdutos AS VARCHAR(20)) 
)
OUTPUT $ACTION INTO #SAIDA;

SET @QTDE_INSERT = (SELECT COUNT(*) FROM #SAIDA WHERE COLUNA='INSERT' GROUP BY COLUNA)
SET @QTDE_UPD = (SELECT COUNT(*) FROM #SAIDA WHERE COLUNA='UPDATE' GROUP BY COLUNA)

DROP TABLE #SAIDA;

---------------------------------------------------------------------------------

UPDATE A SET A.ds_status = 'CONCLUÍDO'
FROM tbEX_tab_BaseExpressoProdutos A
INNER JOIN vw_Mapa B ON B.cd_ChaveLoja = A.cd_ChaveLoja
WHERE A.ds_status <> 'CONCLUÍDO' AND B.cd_ChaveLoja IS NOT NULL AND A.cd_ChaveLoja IS NOT NULL
AND dt_Transacao > CAST('2015-01-28' AS DATE);


UPDATE tbEX_tab_BaseExpressoProdutos SET dt_EnvioTreinamento = GETDATE()
WHERE ds_Status = 'LIBERADO PARA TREINAMENTO' AND dt_EnvioTreinamento IS NULL;

---------------------------------------------------------------------------------	

SET @msg = 
	' -------------------------------------------------------'						 + CHAR(13) +
	'| Protocolo processo Base Expresso 					 '						 + CHAR(13) +
	' -------------------------------------------------------'						 + CHAR(13) +
	'| - Quantidade de registros atualizados.: ' + CAST(@qtde_upd AS VARCHAR)	 + CHAR(13) +
	'| - Quantidade de registros inseridos.: '	 + CAST(@qtde_insert AS VARCHAR) + CHAR(13) + 		
	' -------------------------------------------------------'						 + CHAR(13)  
        
SELECT @msg AS 'corpoEmail';


