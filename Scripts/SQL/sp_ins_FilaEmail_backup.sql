USE [dbBA_Cartoes]
GO

/****** Object:  StoredProcedure [dbo].[sp_ins_FilaEmail]    Script Date: 05/25/2016 12:15:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[sp_ins_FilaEmail](
	@str_Retorno VARCHAR(255) = '' OUTPUT 
)
AS

-- =================================================
-- CLIENTE........: BSP AFFINITY
-- PROJETO........: CARGA BASE HISTÓRICA DE PRODUÇÃO GCCS
-- SERVIDOR.......: MZ-VV-BD-015
-- BANCO DE DADOS.: dbBA_Cartoes
-- AUTOR..........: ALEXANDRE ROMACHO
-- DATA...........: 29/02/2012
-- DESCRIÇÃO......: CARGA DA FILA DE E-MAIL

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
	-- -21981 -> ERRO GENÉRICO

-- ================================================= 


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET DATEFORMAT YMD
SET LANGUAGE us_english
SET CONCAT_NULL_YIELDS_NULL ON
SET NOCOUNT ON

DECLARE
	 @str_ErrorMessage NVARCHAR(4000)
	,@int_ErrorSeverity INT
	,@int_ErrorState INT
	,@str_MsgErro VARCHAR(8000)
	,@str_MsgValidacao VARCHAR(8000)

	,@aa_Base SMALLINT
	,@mm_Base SMALLINT
	,@dd_Base SMALLINT
	,@nr_Seguradora VARCHAR(150)
	,@nr_Supex VARCHAR(150)
	,@nr_Sucur VARCHAR(150)
	,@ds_EmailSeguradora VARCHAR(600)
	,@ds_EmailSupex VARCHAR(600)
	,@ds_EmailSucur VARCHAR(600)
	,@big_Fila BIGINT
	,@dt_Base DATE
	,@dt_Atual DATE
	,@dt_BaseM04Ini DATE
	,@dt_BaseM04Fim DATE
	,@bit_Mapa05 BIT
	
DECLARE @tbBA_tmp_CorpoEmail TABLE (id_Ordem INT NOT NULL PRIMARY KEY, ds_EmailCorpo VARCHAR(8000));	

BEGIN TRY

	BEGIN TRANSACTION;
	
	-- =====================================================
	-- VERIFICA SE O ARQUIVO FOI CARREGADO COM A PRODUÇÃO DO CARTÃO
	-- =====================================================
	IF (SELECT COUNT(*) FROM [tbBA_tab_Arquivo] A
		WHERE A.cs_Tipo IN ('GCCS 800','GCCS 801') AND CAST(ISNULL(dh_EnvioEmail,GETDATE()) AS DATE) = CAST(GETDATE() AS DATE)
				AND dh_Ins > DATEADD(DAY,-5,GETDATE())
		) <> 2
	BEGIN
		SET @str_MsgErro = 'Arquivo GCCS 800 e 801 não foi carregado'
		GOTO fn_ProcErro
	END;
		
	UPDATE A SET A.dh_EnvioEmail = GETDATE()
	FROM [tbBA_tab_Arquivo] A
	INNER JOIN [vw_RelProducaoGCCS] B ON B.id_Arquivo = A.id_Arquivo
	WHERE A.cs_Tipo IN ('GCCS 800','GCCS 801') AND A.dh_EnvioEmail IS NULL;
	
	
	-- =====================================================
	-- DATA BASE
	-- =====================================================
	SET @dt_Atual = GETDATE();
	SET @dt_Base = [dbo].[fn_Fechamento]('dt_FechEnvioEmail',GETDATE());
	
	IF @dt_Atual <= @dt_Base AND LEFT(CONVERT(VARCHAR,@dt_Atual,112),6) < LEFT(CONVERT(VARCHAR,@dt_Base,112),6) BEGIN
		SET @dt_Base = DATEADD(MONTH,1,@dt_Atual)
		SET @dt_Base = CAST(CAST(YEAR(@dt_Base) AS VARCHAR) + '-' + CAST(MONTH(@dt_Base) AS VARCHAR) + '-01' AS DATE)
	END ELSE BEGIN		
		IF @dt_Atual <= @dt_Base AND LEFT(CONVERT(VARCHAR,@dt_Atual,112),6) = LEFT(CONVERT(VARCHAR,@dt_Base,112),6)
			SET @dt_Base = CAST(CAST(YEAR(@dt_Atual) AS VARCHAR) + '-' + CAST(MONTH(@dt_Atual) AS VARCHAR) + '-01' AS DATE)
		ELSE BEGIN
			--SELECT 1/0
			SET @str_MsgErro = 'Erro: data de fechamento não localizada, tabela tbBA_tab_Fechamento';
			GOTO fn_ProcErro;
		END
	END
	
	
		
	SELECT @dt_Base = MAX(dt_Apuracao)
	FROM "dbBA_Cartoes"."dbo"."vw_RelProducaoGCCS" 
	WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N')
	AND ((cd_Origem = 800 AND nr_Evento = 1))
	AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
	AND dt_Apuracao < @dt_Base
	
	SET @aa_Base = YEAR(@dt_Base);
	SET @mm_Base = MONTH(@dt_Base);
	SET @dd_Base = DAY(@dt_Base);
	
	
	-- =====================================================
	-- CARREGAR TABELA TEMP DE CANCELAMENTO (TRAVAR NO MÊS) PRODUÇÃO DOS ÚLTIMOS 3 MESES COM O CANCELAMENTO NO MÊS ANTERIOR
	-- =====================================================
	IF NOT EXISTS(SELECT 1 FROM [tbBA_tmp_ApuracaoCancelMesFilaEmail] WHERE nr_AnoMes = LEFT(CONVERT(VARCHAR,@dt_Base,112),6)) BEGIN
	
		INSERT INTO [tbBA_tmp_ApuracaoCancelMesFilaEmail](nr_AnoMes,ds_Gestao,ds_Supex,nr_Sucur,ds_Sucur,ds_Agencia,ds_Corretor,nr_Agencia,nr_CPD,qt_Cancelamento)
		SELECT LEFT(CONVERT(VARCHAR,@dt_Base,112),6) AS nr_AnoMes
			,A.nm_Gestao,A.nm_Supex,A.nr_Sucur,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor,A.nr_AgenciaOrig,A.nr_CPD
			,COUNT(*) AS qt_Cancelamento
		FROM [vw_RelProducaoGCCS] A
		INNER JOIN (
					SELECT X.id_Chave
					FROM (
							SELECT A.ds_ChaveCli,MIN(A.id_Chave) AS id_Chave,MIN(B.dt_Evento) AS dt_Evento
							FROM [vw_RelProducaoGCCS] A
							INNER JOIN [tbBA_tab_CliEvento800] B ON B.ds_ChaveCli = A.ds_ChaveCli AND B.ds_ChaveSts LIKE '%#07'
							WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N')
							AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
							AND ((cd_Origem = 800 AND nr_Evento = 1))
							AND CAST(LEFT(CONVERT(VARCHAR,dt_Apuracao,112),6) AS INT) BETWEEN
								CAST(LEFT(CONVERT(VARCHAR,DATEADD(MONTH,-3,@dt_Base),112),6) AS INT) AND
								CAST(LEFT(CONVERT(VARCHAR,DATEADD(MONTH,-1,@dt_Base),112),6) AS INT)
							GROUP BY A.ds_ChaveCli
						) X WHERE CAST(LEFT(CONVERT(VARCHAR,dt_Evento,112),6) AS INT) = CAST(LEFT(CONVERT(VARCHAR,DATEADD(MONTH,-1,@dt_Base),112),6) AS INT)
					) X ON X.id_Chave = A.id_Chave
		WHERE ISNULL(A.nm_Gestao,'') <> ''
		GROUP BY A.nm_Gestao,A.nm_Supex,A.nr_Sucur,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor,A.nr_AgenciaOrig,A.nr_CPD
		
		-- AJUSTES OV
		IF OBJECT_ID (N'tempDB..#tbBA_tmp_AjusteCancelOV', N'U') IS NOT NULL		
			DROP TABLE dbo.#tbBA_tmp_AjusteCancelOV;
						
			
		SELECT A.id_Base,A.nr_AnoMes,C.nm_Gestao,C.nm_Supex,C.nr_Sucur,C.nr_Sucur + ' - ' + C.nm_Sucur	AS ds_Sucur
			,A.ds_Agencia,A.ds_Corretor,A.qt_Cancelamento,A.nr_Agencia,A.nr_CPD
		INTO #tbBA_tmp_AjusteCancelOV
		FROM [tbBA_tmp_ApuracaoCancelMesFilaEmail] A
		INNER JOIN dbBR_PainelControle..tbPC_tab_Agencia B ON B.nr_AgJunc = CAST(A.nr_Agencia AS INT)
		INNER JOIN tbBA_tab_Sucursal C ON CAST(C.nr_Sucur AS INT) = B.nr_JuncVida
		WHERE A.nr_AnoMes = LEFT(CONVERT(VARCHAR,@dt_Base,112),6) 
			AND (CAST(C.nr_Sucur AS INT) >= 900 OR CAST(C.nr_Sucur AS INT) BETWEEN 800 AND 899 OR CAST(C.nr_Sucur AS INT) BETWEEN 600 AND 699)
			AND A.ds_Gestao <> 'Organização de Vendas'
			AND C.nm_Gestao = 'Organização de Vendas';	
				
		UPDATE A SET A.qt_Cancelamento += B.qt_Cancelamento
		FROM [tbBA_tmp_ApuracaoCancelMesFilaEmail] A
		INNER JOIN #tbBA_tmp_AjusteCancelOV B ON B.nm_Gestao = A.ds_Gestao AND B.nm_Supex = A.ds_Supex AND B.ds_Sucur = A.ds_Sucur
			AND B.ds_Agencia = A.ds_Agencia AND B.ds_Corretor = A.ds_Corretor
			AND B.nr_Sucur = A.nr_Sucur AND B.nr_Agencia = A.nr_Agencia AND B.nr_CPD = A.nr_CPD
			AND B.nr_AnoMes = A.nr_AnoMes;
				
		INSERT INTO [tbBA_tmp_ApuracaoCancelMesFilaEmail](nr_AnoMes,ds_Gestao,ds_Supex,nr_Sucur,ds_Sucur,ds_Agencia,ds_Corretor,qt_Cancelamento,nr_Agencia,nr_CPD)
		SELECT B.nr_AnoMes,B.nm_Gestao,B.nm_Supex,B.nr_Sucur,B.ds_Sucur,B.ds_Agencia,B.ds_Corretor,B.qt_Cancelamento,B.nr_Agencia,B.nr_CPD
		FROM #tbBA_tmp_AjusteCancelOV B
		LEFT JOIN [tbBA_tmp_ApuracaoCancelMesFilaEmail] A ON B.nm_Gestao = A.ds_Gestao AND B.nm_Supex = A.ds_Supex AND B.ds_Sucur = A.ds_Sucur
			AND B.ds_Agencia = A.ds_Agencia AND B.ds_Corretor = A.ds_Corretor
			AND B.nr_Sucur = A.nr_Sucur AND B.nr_Agencia = A.nr_Agencia AND B.nr_CPD = A.nr_CPD
			AND B.nr_AnoMes = A.nr_AnoMes
		WHERE A.id_Base IS NULL;
				
		DELETE A FROM [tbBA_tmp_ApuracaoCancelMesFilaEmail] A
		INNER JOIN #tbBA_tmp_AjusteCancelOV B ON B.id_Base = A.id_Base;		
		
	END;
	
		
	-- =====================================================
	-- CARREGAR TABELA TEMP PRODUÇÃO MÊS 
	-- =====================================================
	IF NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE)) BEGIN
		
		IF OBJECT_ID (N'tempDB..#tbBA_tmp_ProdEmail', N'U') IS NOT NULL
			DROP TABLE [#tbBA_tmp_ProdEmail];
					
		SELECT nm_Gestao,nm_Supex,nr_Sucur,MAX(ds_EmailSeguradora) AS ds_EmailSeguradora,MAX(ds_EmailTitularRegional) AS ds_EmailTitularRegional
			,MAX(ds_EmailTitularSucur) AS ds_EmailTitularSucur
		INTO [dbo].[#tbBA_tmp_ProdEmail]
		FROM [vw_RelProducaoGCCS] WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') GROUP BY nm_Gestao,nm_Supex,nr_Sucur
							   
		CREATE NONCLUSTERED INDEX ix01_#tbBA_tmp_ProdEmail ON [#tbBA_tmp_ProdEmail](nm_Gestao,nm_Supex,nr_Sucur);
		
				
		TRUNCATE TABLE [tbBA_tmp_ApuracaoProdMesFilaEmail];

		INSERT INTO [tbBA_tmp_ApuracaoProdMesFilaEmail](ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_Propostas,qt_Cancelamento
														,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur
														,qt_Elo_Inter,qt_Gold,qt_Platinum,qt_Total)
		SELECT
			 ISNULL(A.nm_Gestao,B.ds_Gestao) AS nm_Gestao
			,ISNULL(A.nm_Supex,B.ds_Supex) AS nm_Supex
			,ISNULL(A.ds_Sucur,B.ds_Sucur) AS ds_Sucur
			,ISNULL(A.ds_Agencia,B.ds_Agencia) AS ds_Agencia
			,ISNULL(A.ds_Corretor,B.ds_Corretor) AS ds_Corretor
			,ISNULL(A.qt_Propostas,0) AS qt_Propostas
			,ISNULL(B.qt_Cancelamento,0) AS qt_Cancelamento
			,ISNULL(A.ds_EmailSeguradora,B.ds_EmailSeguradora) AS ds_EmailSeguradora
			,ISNULL(A.ds_EmailTitularRegional,B.ds_EmailTitularRegional) AS ds_EmailTitularRegional
			,ISNULL(A.ds_EmailTitularSucur,B.ds_EmailTitularSucur) AS ds_EmailTitularSucur
			,ISNULL(A.qt_Elo_Inter,0) AS qt_Elo_Inter
			,ISNULL(A.qt_Gold,0) AS qt_Gold
			,ISNULL(A.qt_Platinum,0) AS qt_Platinum
			,(ISNULL(A.qt_Elo_Inter,0) * 1) + (ISNULL(A.qt_Gold,0) * 2) + (ISNULL(A.qt_Platinum,0) * 3) AS qt_Total
		FROM (			  	
				SELECT nm_Gestao,nm_Supex,ds_Sucur,ds_Agencia,ds_Corretor
						,COUNT(*) AS qt_Propostas
						,MAX(dt_Apuracao) AS dt_Apuracao
						,MAX(ds_EmailSeguradora) AS ds_EmailSeguradora
						,MAX(ds_EmailTitularRegional) AS ds_EmailTitularRegional
						,MAX(ds_EmailTitularSucur) AS ds_EmailTitularSucur
						,COUNT(CASE WHEN ds_Tipo = 'NACIONAL' OR ds_Tipo = 'INTERNACIONAL' THEN 1 END) AS qt_Elo_Inter
						,COUNT(CASE WHEN ds_Tipo = 'GOLD' THEN 1 END) AS qt_Gold
						,COUNT(CASE WHEN ds_Tipo = 'PLATINUM' THEN 1 END) AS qt_Platinum
				FROM (
					SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor,dt_Apuracao
							,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur,ds_Tipo
					FROM [vw_RelProducaoGCCS] A
					WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 800 AND nr_Evento = 1
						AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
						AND YEAR(dt_Apuracao) = @aa_Base
						AND MONTH(dt_Apuracao) = @mm_Base
					UNION ALL -- IMPLEMENTADO EM 06/05/2016 FECHAMENTO MAPA ABRIL/16 CONSIDERAR OS CARTÕES EMITIDOS E NÃO DIGITADOS SOLICITAÇÃO ANDERSON
					SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor,dt_Apuracao
							,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur,ds_Tipo
					FROM [vw_RelProducaoGCCS] A
					WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 801
						AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
						AND YEAR(dt_Apuracao) = @aa_Base
						AND MONTH(dt_Apuracao) = @mm_Base
						AND st_EmiENaoDigiMapa = 1	
					) A GROUP BY nm_Gestao,nm_Supex,ds_Sucur,ds_Agencia,ds_Corretor
			 ) A
		FULL JOIN (
					SELECT A.*,B.ds_EmailSeguradora,B.ds_EmailTitularRegional,B.ds_EmailTitularSucur 
					FROM [tbBA_tmp_ApuracaoCancelMesFilaEmail] A
					INNER JOIN [#tbBA_tmp_ProdEmail] B ON B.nm_Gestao = A.ds_Gestao AND B.nm_Supex = A.ds_Supex AND B.nr_Sucur = A.nr_Sucur	
					WHERE A.nr_AnoMes = LEFT(CONVERT(VARCHAR,@dt_Base,112),6)  
				  ) B ON B.ds_Gestao = A.nm_Gestao AND B.ds_Supex = A.nm_Supex AND B.ds_Sucur = A.ds_Sucur
							AND B.ds_Agencia = A.ds_Agencia AND B.ds_Corretor = A.ds_Corretor;
							
		
		---- ======================================================================				   			
		---- AGÊNCIAS ZERADAS BVP
		---- ======================================================================
		--INSERT INTO [tbBA_tmp_ApuracaoProdMesFilaEmail](ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_Propostas,qt_Cancelamento
		--												,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur)		
		--SELECT S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
		--	,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia
		--	,'' AS ds_Corretor,0 AS qt_Propostas,0 AS qt_Cancelamento,S.ds_EmailSeguradora,S.ds_EmailTitularRegional,S.ds_EmailTitularSucur
		--FROM dbBR_PainelControle..tbPC_tab_Agencia A
		--LEFT JOIN tbBA_tmp_ApuracaoProdMesFilaEmail B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
		--	AND B.ds_Gestao = 'Bradesco Vida e Previdência'
		--INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		--WHERE B.ds_Agencia IS NULL 
		--	AND (CAST(S.nr_Sucur AS INT) < 900 AND CAST(S.nr_Sucur AS INT) NOT BETWEEN 800 AND 899 AND CAST(S.nr_Sucur AS INT) NOT BETWEEN 600 AND 699);
		
		
		---- ======================================================================				   			
		---- AGÊNCIAS ZERADAS BARE
		---- ======================================================================
		--INSERT INTO [tbBA_tmp_ApuracaoProdMesFilaEmail](ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_Propostas,qt_Cancelamento
		--												,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur)		
		--SELECT S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
		--	,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia
		--	,'' AS ds_Corretor,0 AS qt_Propostas,0 AS qt_Cancelamento,S.ds_EmailSeguradora,S.ds_EmailTitularRegional,S.ds_EmailTitularSucur
		--FROM dbBR_PainelControle..tbPC_tab_AgenciaBARE A
		--LEFT JOIN tbBA_tmp_ApuracaoProdMesFilaEmail B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
		--	AND B.ds_Gestao = 'Bradesco Auto/RE'
		--LEFT JOIN dbBR_PainelControle..tbPC_tab_Agencia AB ON AB.nr_AgJunc = A.nr_AgJunc 
		--	AND (AB.nr_JuncVida >= 900 OR AB.nr_JuncVida BETWEEN 800 AND 899 OR AB.nr_JuncVida BETWEEN 600 AND 699)
		--INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		--WHERE B.ds_Agencia IS NULL 
		--	AND (CAST(S.nr_Sucur AS INT) < 900 AND CAST(S.nr_Sucur AS INT) NOT BETWEEN 800 AND 899 AND CAST(S.nr_Sucur AS INT) NOT BETWEEN 600 AND 699)
		--	AND AB.nr_AgJunc IS NULL;
			
			
		-- ======================================================================				   			
		-- AGÊNCIAS ZERADAS OV
		-- ======================================================================
		INSERT INTO [tbBA_tmp_ApuracaoProdMesFilaEmail](ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_Propostas,qt_Cancelamento
														,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur
														,qt_Elo_Inter,qt_Gold,qt_Platinum,qt_Total)		
		SELECT S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
			,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia
			,'' AS ds_Corretor,0 AS qt_Propostas,0 AS qt_Cancelamento,S.ds_EmailSeguradora,S.ds_EmailTitularRegional,S.ds_EmailTitularSucur
			,0,0,0,0
		FROM dbBR_PainelControle..tbPC_tab_Agencia A
		LEFT JOIN tbBA_tmp_ApuracaoProdMesFilaEmail B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
			AND B.ds_Gestao = 'Organização de Vendas'
		INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		WHERE B.ds_Agencia IS NULL 
			AND (CAST(S.nr_Sucur AS INT) >= 900 OR CAST(S.nr_Sucur AS INT) BETWEEN 800 AND 899 OR CAST(S.nr_Sucur AS INT) BETWEEN 600 AND 699);			
		
		

		-- ======================================================================	
		-- CAMPANHA MILHARES DE PONTOS PARA CAMPEÕES 01/SET/2014 ATÉ 31/OUT/2014
		-- ======================================================================
		--IF YEAR(GETDATE()) = 2014 AND MONTH(GETDATE()) IN (9,10,11) BEGIN
			
		--	TRUNCATE TABLE [tbBA_tmp_CampMilharesPtsCampeoes];

		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoes](
		--		 st_SucursalVarejo,st_SucursalPrime
		--		,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor
		--		,qt_PropVisaGold201409,qt_PropVisaPlatinum201409,qt_Prop201409
		--		,qt_PropVisaGold201410,qt_PropVisaPlatinum201410,qt_Prop201410
		--		,qt_PropVisaGold2014SetOut,qt_PropVisaPlatinum2014SetOut,qt_Prop2014SetOut
		--		,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur
		--	)
		--	SELECT 
		--			 CASE WHEN ds_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--			,CASE WHEN ds_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--			,A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor
		--			,COUNT(CASE WHEN A.ds_Tipo = 'GOLD' AND MONTH(dt_Emissao) = 9 THEN 1 END) AS qt_PropVisaGold201409
		--			,COUNT(CASE WHEN A.ds_Tipo = 'PLATINUM' AND MONTH(dt_Emissao) = 9 THEN 1 END) AS qt_PropVisaPlatinum201409
		--			,COUNT(CASE WHEN MONTH(dt_Emissao) = 9 THEN 1 END) AS qt_Prop201409

		--			,COUNT(CASE WHEN A.ds_Tipo = 'GOLD' AND (MONTH(dt_Emissao) = 10 OR (MONTH(dt_Emissao) = 11 AND DAY(dt_Emissao) <= 13)) THEN 1 END) AS qt_PropVisaGold201410
		--			,COUNT(CASE WHEN A.ds_Tipo = 'PLATINUM' AND (MONTH(dt_Emissao) = 10 OR (MONTH(dt_Emissao) = 11 AND DAY(dt_Emissao) <= 13)) THEN 1 END) AS qt_PropVisaPlatinum201410
		--			,COUNT(CASE WHEN (MONTH(dt_Emissao) = 10 OR (MONTH(dt_Emissao) = 11 AND DAY(dt_Emissao) <= 13)) THEN 1 END) AS qt_Prop201410
					
		--			,COUNT(CASE WHEN A.ds_Tipo = 'GOLD' AND MONTH(dt_Emissao) IN (9,10) THEN 1 END) AS qt_PropVisaGold2014SetOut
		--			,COUNT(CASE WHEN A.ds_Tipo = 'PLATINUM' AND MONTH(dt_Emissao) IN (9,10) THEN 1 END) AS qt_PropVisaPlatinum2014SetOut
		--			,COUNT(CASE WHEN MONTH(dt_Emissao) IN (9,10) THEN 1 END) AS qt_Prop2014SetOut					
					
		--			,MAX(A.ds_EmailSeguradora) AS ds_EmailSeguradora
		--			,MAX(A.ds_EmailTitularRegional) AS ds_EmailTitularRegional
		--			,MAX(A.ds_EmailTitularSucur) AS ds_EmailTitularSucur
		--	FROM [vw_RelProducaoGCCS] A
		--	WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND ((cd_Origem = 800 AND nr_Evento = 1))
		--		AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--		AND YEAR(dt_Emissao) = 2014
		--		AND MONTH(dt_Emissao) IN (8,9,10,11)
		--	GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor;


		--	-- AGÊNCIAS ZERADAS OV
		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoes](
		--		 st_SucursalVarejo,st_SucursalPrime
		--		,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor
		--		,qt_PropVisaGold201409,qt_PropVisaPlatinum201409,qt_Prop201409
		--		,qt_PropVisaGold201410,qt_PropVisaPlatinum201410,qt_Prop201410
		--		,qt_PropVisaGold2014SetOut,qt_PropVisaPlatinum2014SetOut,qt_Prop2014SetOut
		--		,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur
		--	)
		--	SELECT 
		--		 CASE WHEN S.nm_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--		,CASE WHEN S.nm_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--		,S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
		--		,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia,'' AS ds_Corretor
		--		,0 AS qt_PropVisaGold201409,0 AS qt_PropVisaPlatinum201409,0 AS qt_Prop201409
		--		,0 AS qt_PropVisaGold201410,0 AS qt_PropVisaPlatinum201410,0 AS qt_Prop201410
		--		,0 AS qt_PropVisaGold2014SetOut,0 AS qt_PropVisaPlatinum2014SetOut,0 AS qt_Prop2014SetOut
		--		,S.ds_EmailSeguradora,S.ds_EmailTitularRegional,S.ds_EmailTitularSucur
		--	FROM dbBR_PainelControle..tbPC_tab_Agencia A
		--	LEFT JOIN [tbBA_tmp_CampMilharesPtsCampeoes] B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
		--		AND B.ds_Gestao = 'Organização de Vendas'
		--	INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		--	WHERE B.ds_Agencia IS NULL 
		--		AND (CAST(S.nr_Sucur AS INT) >= 900 OR CAST(S.nr_Sucur AS INT) BETWEEN 800 AND 899 OR CAST(S.nr_Sucur AS INT) BETWEEN 600 AND 699);	
						
		--END;

		-- ======================================================================	
		-- CAMPANHA MILHARES DE PONTOS PARA CAMPEÕES 02/01/2015 à 31/03/2015
		-- ======================================================================
		--IF YEAR(GETDATE()) = 2015 AND MONTH(GETDATE()) IN (1,2,3,4) BEGIN
			
		--	TRUNCATE TABLE [tbBA_tmp_CampMilharesPtsCampeoesJanMar15];

		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoesJanMar15](
		--		st_SucursalVarejo,st_SucursalPrime,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_PropVisaGold,qt_PropVisaPlatinum
		--	)
		--	SELECT 
		--			 CASE WHEN ds_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--			,CASE WHEN ds_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--			,A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor
		--			,COUNT(CASE WHEN A.ds_Tipo = 'GOLD' AND YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (1,2,3) THEN 1 END) AS qt_PropVisaGold
		--			,COUNT(CASE WHEN A.ds_Tipo = 'PLATINUM' AND YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (1,2,3) THEN 1 END) AS qt_PropVisaPlatinum
		--	FROM [vw_RelProducaoGCCS] A
		--	WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND ((cd_Origem = 800 AND nr_Evento = 1))
		--		AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--		AND (
		--				   (YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (1,2,3))
		--				OR (YEAR(dt_Emissao) = 2014 AND MONTH(dt_Emissao) = 12)
		--			)
		--	GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor;


		--	-- AGÊNCIAS ZERADAS OV
		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoesJanMar15](
		--		 st_SucursalVarejo,st_SucursalPrime,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_PropVisaGold,qt_PropVisaPlatinum
		--	)
		--	SELECT 
		--		 CASE WHEN S.nm_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--		,CASE WHEN S.nm_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--		,S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
		--		,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia,'' AS ds_Corretor
		--		,0 AS qt_PropVisaGold,0 AS qt_PropVisaPlatinum
		--	FROM dbBR_PainelControle..tbPC_tab_Agencia A
		--	LEFT JOIN [tbBA_tmp_CampMilharesPtsCampeoesJanMar15] B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
		--		AND B.ds_Gestao = 'Organização de Vendas'
		--	INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		--	WHERE B.ds_Agencia IS NULL 
		--		AND (CAST(S.nr_Sucur AS INT) >= 900 OR CAST(S.nr_Sucur AS INT) BETWEEN 800 AND 899 OR CAST(S.nr_Sucur AS INT) BETWEEN 600 AND 699);	
						
		--END;
		
		
		---- ======================================================================	
		---- CAMPANHA MILHARES DE PONTOS PARA CAMPEÕES 01/04/2015 à 30/06/2015
		---- ======================================================================
		--IF YEAR(GETDATE()) = 2015 AND MONTH(GETDATE()) IN (4,5,6,7) BEGIN
			
		--	TRUNCATE TABLE [tbBA_tmp_CampMilharesPtsCampeoesAbrJun15];

		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoesAbrJun15](
		--		st_SucursalVarejo,st_SucursalPrime,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_PropVisaGold,qt_PropVisaPlatinum
		--	)
		--	SELECT 
		--			 CASE WHEN ds_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--			,CASE WHEN ds_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--			,A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor
		--			,COUNT(CASE WHEN A.ds_Tipo = 'GOLD' AND YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (4,5,6) THEN 1 END) AS qt_PropVisaGold
		--			,COUNT(CASE WHEN A.ds_Tipo = 'PLATINUM' AND YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (4,5,6) THEN 1 END) AS qt_PropVisaPlatinum
		--	FROM [vw_RelProducaoGCCS] A
		--	WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND ((cd_Origem = 800 AND nr_Evento = 1))
		--		AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--		AND YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (4,5,6)
		--		AND A.ds_Tipo IN ('GOLD','PLATINUM')
		--	GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,A.ds_Corretor;


		--	-- AGÊNCIAS ZERADAS OV
		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoesAbrJun15](
		--		 st_SucursalVarejo,st_SucursalPrime,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_PropVisaGold,qt_PropVisaPlatinum
		--	)
		--	SELECT 
		--		 CASE WHEN S.nm_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--		,CASE WHEN S.nm_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--		,S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
		--		,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia,'' AS ds_Corretor
		--		,0 AS qt_PropVisaGold,0 AS qt_PropVisaPlatinum
		--	FROM dbBR_PainelControle..tbPC_tab_Agencia A
		--	LEFT JOIN [tbBA_tmp_CampMilharesPtsCampeoesAbrJun15] B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
		--		AND B.ds_Gestao = 'Organização de Vendas'
		--	INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		--	WHERE B.ds_Agencia IS NULL 
		--		AND (CAST(S.nr_Sucur AS INT) >= 900 OR CAST(S.nr_Sucur AS INT) BETWEEN 800 AND 899 OR CAST(S.nr_Sucur AS INT) BETWEEN 600 AND 699);	
						
		--END;
		
		
		---- ======================================================================	
		---- CAMPANHA MILHARES DE PONTOS PARA CAMPEÕES 01/07/2015 à 30/09/2015
		---- ======================================================================
		--IF YEAR(GETDATE()) = 2015 AND MONTH(GETDATE()) IN (7,8,9,10) BEGIN
		
		--	IF OBJECT_ID (N'dbo.tbBA_tmp_BaseCampMilharesPtsCampeoesJulSet15', N'U') IS NOT NULL
		--		DROP TABLE [dbo].[tbBA_tmp_BaseCampMilharesPtsCampeoesJulSet15];
							
		--	SELECT * INTO [dbo].[tbBA_tmp_BaseCampMilharesPtsCampeoesJulSet15] 
		--	FROM [vw_RelProducaoGCCS]
		--	WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND ((cd_Origem = 800 AND nr_Evento = 1))
		--		AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--		AND YEAR(dt_Emissao) = 2015 AND MONTH(dt_Emissao) IN (7,8,9)
		--		AND ds_Tipo IN ('GOLD','PLATINUM');				
		
			
		--	TRUNCATE TABLE [tbBA_tmp_CampMilharesPtsCampeoesJulSet15];

		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoesJulSet15](
		--		st_SucursalVarejo,st_SucursalPrime,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_PropVisaGold,qt_PropVisaPlatinum
		--	)
		--	SELECT 
		--			 CASE WHEN ds_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--			,CASE WHEN ds_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--			,nm_Gestao,nm_Supex,ds_Sucur,ds_Agencia,ds_Corretor
		--			,COUNT(CASE WHEN ds_Tipo = 'GOLD' THEN 1 END) AS qt_PropVisaGold
		--			,COUNT(CASE WHEN ds_Tipo = 'PLATINUM' THEN 1 END) AS qt_PropVisaPlatinum
		--	FROM [tbBA_tmp_BaseCampMilharesPtsCampeoesJulSet15]
		--	GROUP BY nm_Gestao,nm_Supex,ds_Sucur,ds_Agencia,ds_Corretor;


		--	-- AGÊNCIAS ZERADAS OV
		--	INSERT INTO [tbBA_tmp_CampMilharesPtsCampeoesJulSet15](
		--		 st_SucursalVarejo,st_SucursalPrime,ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_PropVisaGold,qt_PropVisaPlatinum
		--	)
		--	SELECT 
		--		 CASE WHEN S.nm_Sucur NOT LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalVarejo
		--		,CASE WHEN S.nm_Sucur LIKE '%PRIME%' THEN 1 ELSE 0 END AS st_SucursalPrime
		--		,S.nm_Gestao,S.nm_Supex,S.nr_Sucur + ' - ' + S.nm_Sucur AS ds_Sucur
		--		,RIGHT('0000' + CAST(A.nr_AgJunc AS VARCHAR),4) + ' - ' + A.nm_Agencia AS ds_Agencia,'' AS ds_Corretor
		--		,0 AS qt_PropVisaGold,0 AS qt_PropVisaPlatinum
		--	FROM dbBR_PainelControle..tbPC_tab_Agencia A
		--	LEFT JOIN [tbBA_tmp_CampMilharesPtsCampeoesJulSet15] B ON CAST(LEFT(B.ds_Agencia,4) AS INT) = A.nr_AgJunc 
		--		AND B.ds_Gestao = 'Organização de Vendas'
		--	INNER JOIN tbBA_tab_Sucursal S ON CAST(S.nr_Sucur AS INT) = A.nr_JuncVida
		--	WHERE B.ds_Agencia IS NULL 
		--		AND (CAST(S.nr_Sucur AS INT) >= 900 OR CAST(S.nr_Sucur AS INT) BETWEEN 800 AND 899 OR CAST(S.nr_Sucur AS INT) BETWEEN 600 AND 699);	
						
		--END;					


		
		-- =================================================
		-- TABELA FILA E-MAIL MAPA 04
		-- =================================================
		SET @dt_BaseM04Ini = (SELECT dt_FechEnvioEmail FROM [tbBA_tab_Fechamento] WHERE id_AnoMesFech = 111111);	
		SET @dt_BaseM04Fim = DATEADD(MONTH,-1,GETDATE());
		
		TRUNCATE TABLE [tbBA_tmp_ApuracaoProdMesFilaEmail04];
		
		INSERT INTO [tbBA_tmp_ApuracaoProdMesFilaEmail04](
			ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Corretor,qt_Propostas,qt_Desbloqueados
			,qt_Ativados,qt_Cancelamento,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur
			,dt_PeriodoIni,dt_PeriodoFim	
		)
		SELECT nm_Gestao,nm_Supex,ds_Sucur,ds_Agencia,ds_Corretor
			,COUNT(*) AS qt_Emitidos
			,COUNT(CASE WHEN nr_SitDocto IN (05,59) THEN 1 END) AS qt_Desbloqueados
			,COUNT(CASE WHEN nr_SitDocto IN (06,69) THEN 1 END) AS qt_Ativados
			,COUNT(CASE WHEN nr_SitDocto = 07 THEN 1 END) AS qt_Cancelados
			,MAX(ds_EmailSeguradora) AS ds_EmailSeguradora,MAX(ds_EmailTitularRegional) AS ds_EmailTitularRegional
			,MAX(ds_EmailTitularSucur) AS ds_EmailTitularSucur,@dt_BaseM04Ini,@dt_BaseM04Fim
		FROM [vw_RelProducaoGCCS]
		WHERE ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND ((cd_Origem = 800 AND nr_Evento = 1))
		AND CAST(dt_Apuracao AS DATE) BETWEEN @dt_BaseM04Ini AND @dt_BaseM04Fim
		AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		GROUP BY nm_Gestao,nm_Supex,ds_Sucur,ds_Agencia,ds_Corretor;
		
		
		
		-- =================================================
		-- TABELA FILA E-MAIL MAPA 05 (CARTÕES EMITIDOS E NÃO DIGITADOS PELO CORRETOR)
		-- =================================================
		-- IDENTIFICA SE DEVE ENVIAR O E-MAIL DO MAPA 05 (ENVIO APENAS NA SEGUNDA OU NO PRÓXIMO DIA ÚTIL CASO SEJA FERIADO)	
		IF (DATEPART(WEEK,(SELECT MAX(dh_Ins) FROM (
			SELECT MAX(dh_Ins) AS dh_Ins FROM tbBA_tab_FilaEmail WHERE cs_Mapa = 'Mapa 05'
			UNION ALL
			SELECT MAX(dh_Ins) AS dh_Ins FROM tbBA_hst_FilaEmail WHERE cs_Mapa = 'Mapa 05'
			) X)) < DATEPART(WEEK,GETDATE()) AND DATEPART(WEEKDAY,GETDATE()) > 2) 
		OR 
			DATEPART(WEEKDAY,GETDATE()) = 2
		  SET @bit_Mapa05 = 1
		ELSE 
		  SET @bit_Mapa05 = 0;		
		
		
		
		-- SOLICITAÇÃO ANDERSON 27/11/2015 (ENVIAR O MAPA DIARIAMENTE NOV/15 E DEZ/15 A PARTIR DO DIA 10)
		IF (CAST(GETDATE() AS DATE) >= CAST('2015-11-27' AS DATE) AND CAST(GETDATE() AS DATE) < (SELECT dt_FechEnvioEmail FROM tbBA_tab_Fechamento WHERE id_AnoMesFech = 201511))
			OR 
		   (CAST(GETDATE() AS DATE) >= CAST('2015-12-10' AS DATE) AND CAST(GETDATE() AS DATE) < (SELECT dt_FechEnvioEmail FROM tbBA_tab_Fechamento WHERE id_AnoMesFech = 201512))
			OR 
		   (CAST(GETDATE() AS DATE) >= CAST('2016-04-01' AS DATE) AND CAST(GETDATE() AS DATE) < (SELECT dt_FechEnvioEmail FROM tbBA_tab_Fechamento WHERE id_AnoMesFech = 201603))		   
				SET @bit_Mapa05 = 1;
		
		
		-- A PARTIR DO DIA 1 DO MÊS ENVIAR O MAPA 05 TODOS OS DIAS ATÉ O FECHAMENTO (28/04/2016 - SOLICITAÇÃO ANDERSON)
		IF @bit_Mapa05 = 0 AND YEAR(GETDATE()) = YEAR(dbo.[fn_Fechamento]('dt_FechEnvioEmail',GETDATE())) AND MONTH(GETDATE()) = MONTH(dbo.[fn_Fechamento]('dt_FechEnvioEmail',GETDATE()))
			SET @bit_Mapa05 = 1;

		
		-- O MAPA 05 NÃO DEVE SER ENVIADO NO DIA DE FECHAMENTO
		IF @bit_Mapa05 = 1 AND dbo.[fn_Fechamento]('dt_FechEnvioEmail',GETDATE()) <> CAST(GETDATE() AS DATE)
			SET @bit_Mapa05 = 1
		ELSE
			SET @bit_Mapa05 = 0;
			
			
		-- REEMISSÃO
		SELECT CAST(nr_CPF AS VARCHAR) + '#' + ds_Bandeira + '#' + ds_Tipo AS ds_ChaveExcl
			INTO #tbBa_tmp_Exc
		FROM tbBA_hst_ArqGCCS800S --WHERE nr_Evento = 1;			
		CREATE NONCLUSTERED INDEX ix01_tbBa_tmp_Exc ON #tbBa_tmp_Exc(ds_ChaveExcl);
				
		-- REMOVER REEMISSÃO 801 IMPLEMENTADO 08/04/2015 SOLICITAÇÃO ANDERSON
		SELECT CAST(nr_CPF AS VARCHAR) + '#' + ds_Bandeira + '#' + ds_Tipo AS ds_ChaveExcl,MIN(id_Chave) AS id_Chave
			INTO #tbBa_tmp_Exc801
		FROM tbBA_hst_ArqGCCS801S
		GROUP BY CAST(nr_CPF AS VARCHAR) + '#' + ds_Bandeira + '#' + ds_Tipo
		HAVING COUNT(*) > 1				
		CREATE NONCLUSTERED INDEX ix01_tbBa_tmp_Exc801 ON #tbBa_tmp_Exc801(ds_ChaveExcl);			
			

		TRUNCATE TABLE [tbBA_tmp_ApuracaoCartEmitNDigiFilaEmail];
		
		INSERT INTO [tbBA_tmp_ApuracaoCartEmitNDigiFilaEmail](
			ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Bandeira,ds_Tipo,qt_Propostas
			,ds_EmailSeguradora,ds_EmailTitularRegional,ds_EmailTitularSucur
		)		
		SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo,COUNT(*) AS qt_Propostas
				,MAX(A.ds_EmailSeguradora) AS ds_EmailSeguradora,MAX(A.ds_EmailTitularRegional) AS ds_EmailTitularRegional
				,MAX(A.ds_EmailTitularSucur) AS ds_EmailTitularSucur
		FROM [vw_RelProducaoGCCS] A
		LEFT JOIN #tbBa_tmp_Exc B ON B.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		LEFT JOIN #tbBa_tmp_Exc801 C ON C.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
			AND C.id_Chave <> A.id_Chave
		WHERE B.ds_ChaveExcl IS NULL AND C.ds_ChaveExcl IS NULL
			AND ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 801 
			--AND nr_SitDoctoStCartao IN (01,05,06)
			AND nr_SitDoctoStCartao IN (01,05,06,07,08,09) --ANDERSON PEDIU PARA INCLUIR OS CARTÕES CANCELADOS 08/04/2015, DEVIDO PROBLEMAS COM A SUPEX MINAS GERAIS
			AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
			AND YEAR(dt_Apuracao) = @aa_Base
			AND MONTH(dt_Apuracao) = @mm_Base
		GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo;


		-- CAMPANHA MILHARES DE PTS PARA CAMPEÕES 
		--TRUNCATE TABLE [tbBA_tmp_CartEmitNDigiCampMilharesPtsCampeoes];


		----01/SET/2014 ATÉ 31/OUT/2014
		--INSERT INTO [tbBA_tmp_CartEmitNDigiCampMilharesPtsCampeoes](
		--	ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Bandeira,ds_Tipo,qt_Propostas
		--)		
		--SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo,COUNT(*) AS qt_Propostas
		--FROM [vw_RelProducaoGCCS] A
		--LEFT JOIN #tbBa_tmp_Exc B ON B.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--WHERE B.ds_ChaveExcl IS NULL
		--	AND ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 801 AND nr_SitDoctoStCartao IN (01,05,06)
		--	AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--	AND YEAR(dt_Apuracao) = 2014
		--	AND (MONTH(dt_Apuracao) IN (9,10) OR (MONTH(dt_Apuracao) = 11 AND DAY(dt_Apuracao) <= 17))
		--GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo;


		----02/01/2015 à 31/03/2015
		--INSERT INTO [tbBA_tmp_CartEmitNDigiCampMilharesPtsCampeoes](
		--	ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Bandeira,ds_Tipo,qt_Propostas
		--)		
		--SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo,COUNT(*) AS qt_Propostas
		--FROM [vw_RelProducaoGCCS] A
		--LEFT JOIN #tbBa_tmp_Exc B ON B.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--LEFT JOIN #tbBa_tmp_Exc801 C ON C.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--	AND C.id_Chave <> A.id_Chave		
		--WHERE B.ds_ChaveExcl IS NULL AND C.ds_ChaveExcl IS NULL
		--	AND ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 801 
		--	AND nr_SitDoctoStCartao IN (01,05,06)
		--	AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--	AND ds_Tipo IN ('GOLD','PLATINUM')
		--	AND YEAR(dt_Apuracao) = 2015
		--	AND MONTH(dt_Apuracao) IN (1,2,3)
		--GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo;
		
		
		----01/04/2015 à 30/06/2015
		--INSERT INTO [tbBA_tmp_CartEmitNDigiCampMilharesPtsCampeoes](
		--	ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Bandeira,ds_Tipo,qt_Propostas
		--)		
		--SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo,COUNT(*) AS qt_Propostas
		--FROM [vw_RelProducaoGCCS] A
		--LEFT JOIN #tbBa_tmp_Exc B ON B.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--LEFT JOIN #tbBa_tmp_Exc801 C ON C.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--	AND C.id_Chave <> A.id_Chave		
		--WHERE B.ds_ChaveExcl IS NULL AND C.ds_ChaveExcl IS NULL
		--	AND ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 801 
		--	AND nr_SitDoctoStCartao IN (01,05,06,07,08,09) --ANDERSON PEDIU PARA INCLUIR OS CARTÕES CANCELADOS 08/04/2015, DEVIDO PROBLEMAS COM A SUPEX MINAS GERAIS
		--	AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--	AND ds_Tipo IN ('GOLD','PLATINUM')
		--	AND YEAR(dt_Apuracao) = 2015
		--	AND MONTH(dt_Apuracao) IN (4,5,6)
		--GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo;
		
		
		----01/07/2015 à 30/09/2015					
		--INSERT INTO [tbBA_tmp_CartEmitNDigiCampMilharesPtsCampeoes](
		--	ds_Gestao,ds_Supex,ds_Sucur,ds_Agencia,ds_Bandeira,ds_Tipo,qt_Propostas
		--)		
		--SELECT A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo,COUNT(*) AS qt_Propostas
		--FROM [vw_RelProducaoGCCS] A
		--LEFT JOIN #tbBa_tmp_Exc B ON B.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--LEFT JOIN #tbBa_tmp_Exc801 C ON C.ds_ChaveExcl = (CAST(A.nr_CPF AS VARCHAR) + '#' + A.ds_Bandeira + '#' + A.ds_Tipo)
		--	AND C.id_Chave <> A.id_Chave		
		--WHERE B.ds_ChaveExcl IS NULL AND C.ds_ChaveExcl IS NULL
		--	AND ISNULL(nr_Sucur,'000') NOT IN ('','000','N') AND cd_Origem = 801 
		--	AND nr_SitDoctoStCartao IN (01,05,06,07,08,09) --ANDERSON PEDIU PARA INCLUIR OS CARTÕES CANCELADOS 08/04/2015, DEVIDO PROBLEMAS COM A SUPEX MINAS GERAIS
		--	AND ds_Sucur IS NOT NULL AND nm_Supex IS NOT NULL AND nm_Gestao IS NOT NULL
		--	AND ds_Tipo IN ('GOLD','PLATINUM')
		--	AND YEAR(dt_Apuracao) = 2015
		--	AND MONTH(dt_Apuracao) IN (7,8,9)
		--GROUP BY A.nm_Gestao,A.nm_Supex,A.ds_Sucur,A.ds_Agencia,ds_Bandeira,ds_Tipo;			
										
				
	END;
	
	
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 02) -> SEGURADORA
	-- =====================================================
	DECLARE curFilaEmailMapa02_Seguradora CURSOR FOR
		SELECT DISTINCT ds_Gestao,ds_EmailSeguradora
		FROM [tbBA_tmp_ApuracaoProdMesFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailSeguradora IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 02' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Seguradora IS NOT NULL)
		ORDER BY 1;

	OPEN curFilaEmailMapa02_Seguradora;

	FETCH NEXT FROM curFilaEmailMapa02_Seguradora INTO @nr_Seguradora,@ds_EmailSeguradora;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSeguradora = CASE WHEN ISNULL(@ds_EmailSeguradora,'') <> '' THEN @ds_EmailSeguradora ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
	
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
		
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa02Corretor_Seguradoravs4] @nr_Seguradora,@aa_Base,@mm_Base,@dd_Base;		
			
		
		
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Seguradora
			)
			VALUES('Mapa 02','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSeguradora,'Relatório Cartão BS mapa Sucursal x Corretor',@nr_Seguradora);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END
				
		FETCH NEXT FROM curFilaEmailMapa02_Seguradora INTO @nr_Seguradora,@ds_EmailSeguradora;

	END;

	CLOSE curFilaEmailMapa02_Seguradora;
	DEALLOCATE curFilaEmailMapa02_Seguradora;
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 03) -> SEGURADORA
	-- =====================================================
	DECLARE curFilaEmailMapa03_Seguradora CURSOR FOR
		SELECT DISTINCT ds_Gestao,ds_EmailSeguradora
		FROM [tbBA_tmp_ApuracaoProdMesFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailSeguradora IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 03' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Seguradora IS NOT NULL)
		ORDER BY 1;

	OPEN curFilaEmailMapa03_Seguradora;

	FETCH NEXT FROM curFilaEmailMapa03_Seguradora INTO @nr_Seguradora,@ds_EmailSeguradora;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSeguradora = CASE WHEN ISNULL(@ds_EmailSeguradora,'') <> '' THEN @ds_EmailSeguradora ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
	
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
		
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa03Agencia_Seguradoravs4] @nr_Seguradora,@aa_Base,@mm_Base,@dd_Base;
			
		
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Seguradora
			)
			VALUES('Mapa 03','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSeguradora,'Relatório Cartão BS mapa Sucursal x Agência',@nr_Seguradora);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END
				
		FETCH NEXT FROM curFilaEmailMapa03_Seguradora INTO @nr_Seguradora,@ds_EmailSeguradora;

	END;

	CLOSE curFilaEmailMapa03_Seguradora;
	DEALLOCATE curFilaEmailMapa03_Seguradora;
	
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 05) -> SEGURADORA
	-- =====================================================
	DECLARE curFilaEmailMapa05_Seguradora CURSOR FOR
		SELECT DISTINCT ds_Gestao,ds_EmailSeguradora
		FROM [tbBA_tmp_ApuracaoCartEmitNDigiFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailSeguradora IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 05' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Seguradora IS NOT NULL)
			AND @bit_Mapa05 = 1
		ORDER BY 1;

	OPEN curFilaEmailMapa05_Seguradora;

	FETCH NEXT FROM curFilaEmailMapa05_Seguradora INTO @nr_Seguradora,@ds_EmailSeguradora;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSeguradora = CASE WHEN ISNULL(@ds_EmailSeguradora,'') <> '' THEN @ds_EmailSeguradora ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
	
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
		
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa05Agencia_Seguradoravs1] @nr_Seguradora,@aa_Base,@mm_Base,@dd_Base;
			
		
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Seguradora
			)
			VALUES('Mapa 05','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSeguradora,'Relatório cartões emitidos e não digitados mapa Agência',@nr_Seguradora);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END
				
		FETCH NEXT FROM curFilaEmailMapa05_Seguradora INTO @nr_Seguradora,@ds_EmailSeguradora;

	END;

	CLOSE curFilaEmailMapa05_Seguradora;
	DEALLOCATE curFilaEmailMapa05_Seguradora;
					
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 02) -> SUPEX
	-- =====================================================
	DECLARE curFilaEmailMapa02_Supex CURSOR FOR
		SELECT DISTINCT ds_Gestao,ds_Supex,ds_EmailTitularRegional
		FROM [tbBA_tmp_ApuracaoProdMesFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailTitularRegional IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 02' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Supex IS NOT NULL)
		

	OPEN curFilaEmailMapa02_Supex;

	FETCH NEXT FROM curFilaEmailMapa02_Supex INTO @nr_Seguradora,@nr_Supex,@ds_EmailSupex;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSupex = CASE WHEN ISNULL(@ds_EmailSupex,'') <> '' THEN @ds_EmailSupex ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
		
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
			
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa02Corretor_Supexvs4] @nr_Seguradora,@nr_Supex,@aa_Base,@mm_Base,@dd_Base;	
			
				
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Supex
			)
			VALUES('Mapa 02','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSupex,'Relatório Cartão BS mapa Sucursal x Corretor',@nr_Supex);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END;
				
		FETCH NEXT FROM curFilaEmailMapa02_Supex INTO @nr_Seguradora,@nr_Supex,@ds_EmailSupex;

	END;

	CLOSE curFilaEmailMapa02_Supex;
	DEALLOCATE curFilaEmailMapa02_Supex;
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 03) -> SUPEX
	-- =====================================================
	DECLARE curFilaEmailMapa03_Supex CURSOR FOR
		SELECT DISTINCT ds_Gestao, ds_Supex,ds_EmailTitularRegional
		FROM [tbBA_tmp_ApuracaoProdMesFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailTitularRegional IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 03' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Supex IS NOT NULL)

	OPEN curFilaEmailMapa03_Supex;

	FETCH NEXT FROM curFilaEmailMapa03_Supex INTO @nr_Seguradora,@nr_Supex,@ds_EmailSupex;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSupex = CASE WHEN ISNULL(@ds_EmailSupex,'') <> '' THEN @ds_EmailSupex ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
		
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
		
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa03Agencia_Supexvs4] @nr_Seguradora, @nr_Supex,@aa_Base,@mm_Base,@dd_Base;
									
		
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Supex
			)
			VALUES('Mapa 03','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSupex,'Relatório Cartão BS mapa Sucursal x Agência',@nr_Supex);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END
				
		FETCH NEXT FROM curFilaEmailMapa03_Supex INTO @nr_Seguradora,@nr_Supex,@ds_EmailSupex;

	END;

	CLOSE curFilaEmailMapa03_Supex;
	DEALLOCATE curFilaEmailMapa03_Supex;
	
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 05) -> SUPEX
	-- =====================================================
	DECLARE curFilaEmailMapa05_Supex CURSOR FOR
		SELECT DISTINCT ds_Gestao,ds_Supex,ds_EmailTitularRegional
		FROM [tbBA_tmp_ApuracaoCartEmitNDigiFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailTitularRegional IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 05' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Supex IS NOT NULL)
			AND @bit_Mapa05 = 1
		ORDER BY 1;

	OPEN curFilaEmailMapa05_Supex;

	FETCH NEXT FROM curFilaEmailMapa05_Supex INTO @nr_Seguradora,@nr_Supex,@ds_EmailSupex;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSupex = CASE WHEN ISNULL(@ds_EmailSupex,'') <> '' THEN @ds_EmailSupex ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
		
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
			
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa05Agencia_Supexvs1] @nr_Seguradora,@nr_Supex,@aa_Base,@mm_Base,@dd_Base;	
			
				
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Supex
			)
			VALUES('Mapa 05','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSupex,'Relatório cartões emitidos e não digitados mapa Agência',@nr_Supex);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END;
				
		FETCH NEXT FROM curFilaEmailMapa05_Supex INTO @nr_Seguradora,@nr_Supex,@ds_EmailSupex;

	END;

	CLOSE curFilaEmailMapa05_Supex;
	DEALLOCATE curFilaEmailMapa05_Supex;	
		
		
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 02) -> SUCURSAL
	-- =====================================================
	DECLARE curFilaEmailMapa02_Sucursal CURSOR FOR
		SELECT DISTINCT '' AS ds_Gestao,ds_Sucur,ds_EmailTitularSucur
		FROM [tbBA_tmp_ApuracaoProdMesFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailTitularSucur IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 02' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Sucursal IS NOT NULL)
		ORDER BY 1;

	OPEN curFilaEmailMapa02_Sucursal;

	FETCH NEXT FROM curFilaEmailMapa02_Sucursal INTO @nr_Seguradora,@nr_Sucur,@ds_EmailSucur;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSucur = CASE WHEN ISNULL(@ds_EmailSucur,'') <> '' THEN @ds_EmailSucur ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
	
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
	
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa02Corretor_Sucursalvs4] @nr_Sucur,@aa_Base,@mm_Base,@dd_Base;
			
				
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Sucursal
			)
			VALUES('Mapa 02','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSucur,'Relatório Cartão BS mapa Sucursal x Corretor',@nr_Sucur);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END;
				
		FETCH NEXT FROM curFilaEmailMapa02_Sucursal INTO @nr_Seguradora,@nr_Sucur,@ds_EmailSucur;

	END;

	CLOSE curFilaEmailMapa02_Sucursal;
	DEALLOCATE curFilaEmailMapa02_Sucursal;	
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 03) -> SUCURSAL
	-- =====================================================
	DECLARE curFilaEmailMapa03_Sucursal CURSOR FOR
		SELECT DISTINCT '' AS ds_Gestao,ds_Sucur,ds_EmailTitularSucur
		FROM [tbBA_tmp_ApuracaoProdMesFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailTitularSucur IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 03' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Sucursal IS NOT NULL)
		ORDER BY 1;

	OPEN curFilaEmailMapa03_Sucursal;

	FETCH NEXT FROM curFilaEmailMapa03_Sucursal INTO @nr_Seguradora,@nr_Sucur,@ds_EmailSucur;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSucur = CASE WHEN ISNULL(@ds_EmailSucur,'') <> '' THEN @ds_EmailSucur ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
	
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
		
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa03Agencia_Sucursalvs4] @nr_Sucur,@aa_Base,@mm_Base,@dd_Base;
					
				
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Sucursal
			)
			VALUES('Mapa 03','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSucur,'Relatório Cartão BS mapa Sucursal x Agência',@nr_Sucur);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END
				
		FETCH NEXT FROM curFilaEmailMapa03_Sucursal INTO @nr_Seguradora,@nr_Sucur,@ds_EmailSucur;

	END;

	CLOSE curFilaEmailMapa03_Sucursal;
	DEALLOCATE curFilaEmailMapa03_Sucursal;	
	
	
	
	-- =====================================================
	-- CARREGAR A FILA DE DISPARO DE E-MAIL (MAPA 05) -> SUCURSAL
	-- =====================================================
	DECLARE curFilaEmailMapa05_Sucursal CURSOR FOR
		SELECT DISTINCT ds_Gestao,ds_Sucur,ds_EmailTitularSucur
		FROM [tbBA_tmp_ApuracaoCartEmitNDigiFilaEmail] WHERE ds_Gestao IN ('Organização de Vendas')
			AND ds_EmailTitularSucur IS NOT NULL
			AND NOT EXISTS(SELECT 1 FROM [tbBA_tab_FilaEmail] WHERE cs_Mapa = 'Mapa 05' AND CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE) AND nr_Sucursal IS NOT NULL)
			AND @bit_Mapa05 = 1
		ORDER BY 1;

	OPEN curFilaEmailMapa05_Sucursal;

	FETCH NEXT FROM curFilaEmailMapa05_Sucursal INTO @nr_Seguradora,@nr_Sucur,@ds_EmailSucur;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- TRATAR E-MAIL
		SET @ds_EmailSucur = CASE WHEN ISNULL(@ds_EmailSucur,'') <> '' THEN @ds_EmailSucur ELSE 'alexandre.romacho@bspa.bradesco.com.br; alexandre.romacho@bradescoseguros.com.br' END;
	
		-- GERAR CORPO DO E-MAIL
		DELETE FROM @tbBA_tmp_CorpoEmail;
	
		
		INSERT INTO @tbBA_tmp_CorpoEmail(id_Ordem,ds_EmailCorpo)
		EXEC [sp_sel_Mapa05Agencia_Sucursalvs1] @nr_Sucur,@aa_Base,@mm_Base,@dd_Base;
			
				
		-- CARREGAR FILA DE DISPARO DE E-MAIL
		IF EXISTS(SELECT 1 FROM @tbBA_tmp_CorpoEmail) BEGIN
		
			INSERT INTO [tbBA_tab_FilaEmail](
				cs_Mapa,cs_Status,dh_Ins,ds_EmailDe,ds_EmailPara,ds_EmailAssunto,nr_Sucursal
			)
			VALUES('Mapa 05','Pendente',GETDATE(),'cartaobsp@bspa.bradesco.com.br;cartaobsp@bradescoseguros.com.br'
					,@ds_EmailSucur,'Relatório cartões emitidos e não digitados mapa Agência',@nr_Sucur);
			
			SET @big_Fila = SCOPE_IDENTITY();
			
			-- CARREGAR CORPO DO E-MAIL
			INSERT INTO [tbBA_tab_CorpoEmail](id_Ordem,id_Fila,ds_EmailCorpo)
			SELECT id_Ordem,@big_Fila,ds_EmailCorpo
			FROM @tbBA_tmp_CorpoEmail;
		
		END;
				
		FETCH NEXT FROM curFilaEmailMapa05_Sucursal INTO @nr_Seguradora,@nr_Sucur,@ds_EmailSucur;

	END;

	CLOSE curFilaEmailMapa05_Sucursal;
	DEALLOCATE curFilaEmailMapa05_Sucursal;		
			
			
	
    COMMIT TRANSACTION;
    SET @str_Retorno = '';
    RETURN;
    
    fn_ProcErro:
		ROLLBACK TRANSACTION;
		
		-- GRAVAR LOG DE ERRO
		IF @str_MsgErro IS NULL
			SET @str_MsgErro = 'Erro não especificado fn_ProcErro <sp_ins_FilaEmail>.'
			
		EXEC [sp_ins_GravaLog] NULL,NULL,NULL,'Erro','sp_ins_FilaEmail'
								,NULL,NULL,@str_MsgErro,NULL;
		
        SET @str_Retorno = @str_MsgErro;
		RETURN;
    
END TRY
BEGIN CATCH
	
	ROLLBACK TRANSACTION;
	
	SELECT 
		@str_ErrorMessage = ERROR_MESSAGE(),
		@int_ErrorSeverity = ERROR_SEVERITY(),
		@int_ErrorState = ERROR_STATE();
			
	-- GRAVAR LOG DE ERRO
	EXEC [sp_ins_GravaLog] NULL,NULL,NULL,'Erro','sp_ins_FilaEmail'
							,@int_ErrorState,@int_ErrorSeverity,@str_ErrorMessage,NULL;

    SET @str_Retorno = @str_ErrorMessage;
    RETURN;
    
END CATCH;
    

GO


