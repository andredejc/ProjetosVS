-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- CARREGA ARQUIVO
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

USE TesteCarga;
GO
TRUNCATE TABLE tmp_Layout_vendas;
TRUNCATE TABLE tbPC_tmp_Layoutvendas01;
GO

DECLARE @path VARCHAR(200) = 'C:\Users\M135038\Downloads\0002ENVIO26042016_01.txt',
		 @sql VARCHAR(MAX)

SET @sql =  'BULK INSERT tmp_Layout_vendas 
			 FROM '''+@path+'''
			 WITH 
			 (
				FIRSTROW=1, 		
				ROWTERMINATOR = ''\n''
			 )'	
EXEC (@sql);
GO

INSERT INTO tbPC_tmp_Layoutvendas01
SELECT
	 SUBSTRING(dados,	1	,2	)
	,SUBSTRING(dados,	3	,15	)
	,SUBSTRING(dados,	18	,14	)
	,SUBSTRING(dados,	32	,50	)
	,SUBSTRING(dados,	82	,4	)
	,SUBSTRING(dados,	86	,8	)
	,SUBSTRING(dados,	94	,50	)
	,SUBSTRING(dados,	144	,15	)
	,SUBSTRING(dados,	159	,15	)
	,SUBSTRING(dados,	174	,2	)
	,SUBSTRING(dados,	176	,4	)
	,SUBSTRING(dados,	180	,10	)
	,SUBSTRING(dados,	190	,10	)
	,SUBSTRING(dados,	200	,4	)
	,SUBSTRING(dados,	204	,10	)
	,SUBSTRING(dados,	214	,100)
	,SUBSTRING(dados,	314	,10	)
	,SUBSTRING(dados,	324	,1	)
	,SUBSTRING(dados,	325	,11	)
	,SUBSTRING(dados,	336	,10	)
	,SUBSTRING(dados,	346	,10	)
	,SUBSTRING(dados,	356	,10	)
	,SUBSTRING(dados,	366	,100)
	,SUBSTRING(dados,	466	,10	)
	,SUBSTRING(dados,	476	,30	)
	,SUBSTRING(dados,	506	,8	)
	,SUBSTRING(dados,	514	,70	)
	,SUBSTRING(dados,	584	,50	)
	,SUBSTRING(dados,	634	,2	)
	,SUBSTRING(dados,	636	,3	)
	,SUBSTRING(dados,	639	,10	)
	,SUBSTRING(dados,	649	,3	)
	,SUBSTRING(dados,	652	,10	)
	,SUBSTRING(dados,	662	,5	)
	,SUBSTRING(dados,	667	,50	)
	,SUBSTRING(dados,	717	,30	)
	,SUBSTRING(dados,	747	,7	)
	,SUBSTRING(dados,	754	,10	)
	,SUBSTRING(dados,	764	,24	)
	,SUBSTRING(dados,	788	,24	)
	,SUBSTRING(dados,	812	,24	)
	,SUBSTRING(dados,	836	,24	)
	,SUBSTRING(dados,	860	,7	)
	,SUBSTRING(dados,	867	,50	)
	,SUBSTRING(dados,	917	,20	)
	,SUBSTRING(dados,	937	,19	)
	,SUBSTRING(dados,	956	,1	)
	,SUBSTRING(dados,	957	,1	)
	,SUBSTRING(dados,	958	,43	)
FROM tmp_Layout_vendas

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- ENRIQUECE
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-------------------
-- Primeira opção
-------------------

SELECT *
FROM tbPC_tmp_Layoutvendas01
WHERE [tipo de registro] = 'D'
AND [endereço]=''

SELECT 
	A.Nome,B.ds_EndCEP,B.ds_EndLogr,B.ds_EndNumero,B.ds_EndBairro,B.ds_EndCidade,B.ds_EndUF,B.ds_EndLogr
FROM tbPC_tmp_Layoutvendas01 AS A
	INNER JOIN [MZ-VV-BD-015].[dbBA_BasesNegocio].[dbo].[tbBA_tab_ExperianPF] AS B
		ON A.[Número do CPF] = B.nr_CPF
WHERE A.[Tipo de registro] = 'D'	
AND A.[Endereço] =''

BEGIN TRAN

UPDATE A
	SET A.[Número do Endereço] = REPLICATE('0',(10-LEN(B.ds_EndNumero)))+ B.ds_EndNumero,
		A.[Bairro] = CASE WHEN B.ds_EndBairro = '' THEN 'CENTRO' ELSE B.ds_EndBairro END,
		A.[Cidade] = B.ds_EndCidade,
		A.[Uf] = B.ds_EndUF,
		A.[Endereço] = B.ds_EndLogr,
		A.[complemento do endereço] = B.ds_EndCompl
FROM tbPC_tmp_Layoutvendas01 AS A
	INNER JOIN [MZ-VV-BD-015].[dbBA_BasesNegocio].[dbo].[tbBA_tab_ExperianPF] AS B
	ON A.[Número do CPF] = B.nr_CPF
WHERE A.[Endereço]=''	
AND A.[Tipo de registro] = 'D'

ROLLBACK TRAN
	--COMMIT TRAN

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- EXPORTA ARQUIVO
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

EXEC xp_cmdshell 'bcp "SELECT * FROM [tbPC_tmp_Layoutvendas01]" queryout "E:\Andre\0002ENVIO26042016_01.txt" -T -c -t -dTesteCarga'

-- ###################################################################################################################################

-- Tabelas
SELECT TOP 2 * FROM tbPC_tmp_Layoutvendas02
SELECT TOP 1 * FROM dbBA_BasesNegocio..tbBA_tab_ExperianPF
SELECT TOP 1 * FROM dbo.tbPC_tab_Cliente
SELECT * FROM dbBA_Cartoes..tbBA_tab_ContaCorrente
SELECT * FROM dbBR_PainelControle..tbPC_tab_Endereco

------------------
-- Segunda opção
------------------
SELECT 
	A.Nome,B.ds_EndCEP,B.ds_EndLogr,B.ds_EndNumero,B.ds_EndBairro,B.ds_EndCidade
FROM tbPC_tmp_Layoutvendas02 AS A
	INNER JOIN dbEX_Expresso..tbEX_tab_CorrespondenteFULL AS B
	ON A.[CNPJ do Estipulante] = nr_CNPJ 
WHERE A.[Tipo de registro] = 'D'

BEGIN TRAN
UPDATE A
	SET A.[Número do Endereço] = REPLICATE('0',(10-LEN(B.ds_EndNumero)))+ B.ds_EndNumero,
		A.[Bairro] = CASE WHEN B.ds_EndBairro = '' THEN 'CENTRO' ELSE B.ds_EndBairro END,
		A.[Cidade] = B.ds_EndCidade,
		A.[Uf] = B.ds_EndUF,
		A.[Endereço] = B.ds_EndLogr 
FROM tbPC_tmp_Layoutvendas01 AS A
	INNER JOIN [MZ-VV-BD-015].[dbEX_Expresso].[dbo].[tbEX_tab_CorrespondenteFULL] AS B
	ON A.[CNPJ do Estipulante] = nr_CNPJ 
WHERE A.[Endereço]=''	
AND A.[Tipo de registro] = 'D'

ROLLBACK TRAN
		
