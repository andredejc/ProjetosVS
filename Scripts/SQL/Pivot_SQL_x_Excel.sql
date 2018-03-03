IF(OBJECT_ID(N'TEMPDB..#TESTE') IS NOT NULL)
	DROP TABLE TEMPDB..#TESTE;
GO	

WITH Cte(ds_lProd,ds_lCellaOrigeCatao,vl_PcelaSegur) AS
(
	SELECT ds_lProd,ds_lCellaOrigeCatao,vl_PcelaSegur
	FROM tbPL_tab_MesAtualPLTESTE	
)
SELECT *
INTO #TESTE
FROM Cte
PIVOT(SUM(vl_PcelaSegur) FOR ds_lCellaOrigeCatao IN([OUTROS CANAIS],[PRE-APROVADA],[PRE-PREENCHIDA])) AS Piv

SELECT 
	ds_lProd,
	[OUTROS CANAIS],
	[PRE-APROVADA],
	[PRE-PREENCHIDA],
	([OUTROS CANAIS]+[PRE-APROVADA]+[PRE-PREENCHIDA]) AS 'Total geral'
FROM #TESTE

UNION ALL

SELECT 
	'Total geral',
	SUM([OUTROS CANAIS]),
	SUM([PRE-APROVADA]),
	SUM([PRE-PREENCHIDA]),
	(SUM([OUTROS CANAIS])+SUM([PRE-APROVADA])+SUM([PRE-PREENCHIDA])) AS 'Total geral'
FROM #TESTE

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT 
	nm_Corretor				AS [Corretor],	
	ISNULL([ELO + INTER],0) AS [ELO + INTER],
	ISNULL([GOLD],0)		AS [GOLD],
	ISNULL([PLATINUM],0)	AS [PLATINUM],
	(ISNULL([ELO + INTER],0) + ISNULL([GOLD],0)+ ISNULL([PLATINUM],0)) AS Total	
FROM (		
		SELECT 	
			nm_Corretor,
			CASE	
				WHEN ds_Bandeira	= 'ELO' OR ds_Tipo = 'INTERNACIONAL'	THEN 1
				WHEN ds_Tipo		= 'GOLD'								THEN 2
				WHEN ds_Tipo		= 'PLATINUM'							THEN 3
			END AS Pontuacao,
			CASE	
				WHEN ds_Bandeira	= 'ELO' OR ds_Tipo = 'INTERNACIONAL'	THEN 'ELO + INTER'
				WHEN ds_Tipo		= 'GOLD'								THEN 'GOLD'
				WHEN ds_Tipo		= 'PLATINUM'							THEN 'PLATINUM'
			END AS Flag		
		FROM vw_Relproducaogccs
		WHERE dt_Transmissao BETWEEN '2015-12-31' AND '2016-12-31'	
	) AS A
PIVOT(SUM(Pontuacao) FOR Flag IN ([ELO + INTER],[GOLD],[PLATINUM])) AS _Pivot

UNION ALL

-- Última linha com a soma das linhas de cada coluna
SELECT 
	'Total Geral',	
	SUM(ISNULL([ELO + INTER],0))	AS [ELO + INTER],
	SUM(ISNULL([GOLD],0))			AS [GOLD],
	SUM(ISNULL([PLATINUM],0))		AS [PLATINUM],
	SUM((ISNULL([ELO + INTER],0) + ISNULL([GOLD],0)+ ISNULL([PLATINUM],0))) AS Total	
FROM (		
		SELECT 	
			nm_Corretor,
			CASE	
				WHEN ds_Bandeira	= 'ELO' OR ds_Tipo = 'INTERNACIONAL'	THEN 1
				WHEN ds_Tipo		= 'GOLD'								THEN 2
				WHEN ds_Tipo		= 'PLATINUM'							THEN 3
			END AS Pontuacao,
			CASE	
				WHEN ds_Bandeira	= 'ELO' OR ds_Tipo = 'INTERNACIONAL'	THEN 'ELO + INTER'
				WHEN ds_Tipo		= 'GOLD'								THEN 'GOLD'
				WHEN ds_Tipo		= 'PLATINUM'							THEN 'PLATINUM'
			END AS Flag		
		FROM vw_Relproducaogccs
		WHERE dt_Transmissao BETWEEN '2015-12-31' AND '2016-12-31'	
	) AS A
PIVOT(SUM(Pontuacao) FOR Flag IN ([ELO + INTER],[GOLD],[PLATINUM])) AS _Pivot

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Bonus: UNPIVOT
----------------------------------------------------------------------------------------------------

SELECT nm_Supex,nm_Sucur,nm_Agencia,Email
FROM (
	SELECT TOP 100
		 nm_Supex
		,nm_Sucur
		,nm_Agencia
		,ds_EmailTitularSucur
		,ds_EmailTitularRegional
		,ds_EmailSeguradora
	FROM vw_RelProducaoGCCS	
) AS A
UNPIVOT(Email FOR Emails IN(ds_EmailTitularSucur,ds_EmailTitularRegional,ds_EmailSeguradora)) AS _Unpivot
ORDER BY 1,2



