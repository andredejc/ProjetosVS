SET DATEFORMAT dmy

IF OBJECT_ID(N'tempdb..#SAIDA', N'U') IS NOT NULL
DROP TABLE #SAIDA;
	
CREATE TABLE #SAIDA(COLUNA VARCHAR(10))

DECLARE @qtde_insert INT,
		 @qtde_upd INT,
		 @qtde_del INT,
		 @msg VARCHAR(8000)

MERGE tbPL_MesAtual_PrivateLabel AS TARGET
USING tbPL_hst_PrivateLabel AS SOURCE
	ON (TARGET.id_Base = SOURCE.id_Base)
WHEN MATCHED THEN
UPDATE SET	
	 TARGET.id_Arquivo = SOURCE.id_Arquivo
	,TARGET.cd_cLjVdaCatao = SOURCE.cd_cLjVdaCatao
	,TARGET.cd_cVddorVdaCatao = SOURCE.cd_cVddorVdaCatao
	,TARGET.cd_cCellaOrigeCatao = SOURCE.cd_cCellaOrigeCatao
WHEN NOT MATCHED BY TARGET THEN
INSERT VALUES
(	 
	 id_Arquivo
	,nr_Id
	,nr_Reg
	,nr_cOrgnz
	,nr_Logo
	,dt_Movto
	,cd_cLjVdaCatao
	,cd_cVddorVdaCatao
	,cd_cCellaOrigeCatao
	,ds_lCellaOrigeCatao
	,nr_Prod
	,ds_lProd
	,nr_PcelaSegur
	,vl_PcelaSegur
	,dt_AdsaoProdtPpc
	,nr_cTpoVda
	,ds_lTpoVda
	,nr_cCatao
	,nr_Titularidade
	,nr_cCta
	,dt_CtaAbert
	,dt_PrimEmisCatao
	,nr_Cpf
	,dt_NasTtlar
	,ds_lCli
	,ds_cCliSttus
	,ds_cCtaBloq1
	,ds_cCtaBloq2
	,nr_cAdsaoSegur
	,ds_cIdVendedor
	,ds_cCelula
	,ds_Sexo
	,ds_Endereco
	,ds_End_Num
	,ds_End_Compl
	,ds_End_Bairro
	,ds_End_Cidade
	,ds_End_UF
	,nr_CEP
	,dt_Abert_Conta
	,dt_DataVenc
	,vl_SaldoFinal
)
WHEN NOT MATCHED BY SOURCE THEN DELETE

OUTPUT $ACTION INTO #SAIDA;

SET @qtde_insert 	= (SELECT COUNT(*) FROM #SAIDA WHERE COLUNA='INSERT')
SET @qtde_upd 		= (SELECT COUNT(*) FROM #SAIDA WHERE COLUNA='UPDATE')
SET @qtde_del 		= (SELECT COUNT(*) FROM #SAIDA WHERE COLUNA='DELETE')

SET @msg =	' -------------------------------------------------------'						 + CHAR(13) +
			'| Protocolo processo Base Expresso 					 '						 + CHAR(13) +
			' -------------------------------------------------------'						 + CHAR(13) +
			'| - Quantidade de registros atualizados.: ' + CAST(@qtde_upd AS VARCHAR)		 + CHAR(13) +
			'| - Quantidade de registros inseridos.: '	 + CAST(@qtde_insert AS VARCHAR)	 + CHAR(13) + 		
			'| - Quantidade de registros deletados.: '	 + CAST(@qtde_del AS VARCHAR)		 + CHAR(13) + 		
			' -------------------------------------------------------'						 + CHAR(13)  
        
SELECT @msg AS 'corpoEmail';
DROP TABLE #SAIDA;

