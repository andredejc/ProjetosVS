IF OBJECT_ID('tempdb..##Informacoes_Gerenciais','U') IS NOT NULL DROP TABLE ##Informacoes_Gerenciais

CREATE TABLE ##Informacoes_Gerenciais(
	Tipo VARCHAR(100),
	Elo_Nacional VARCHAR(100),
	Elo_Internacional VARCHAR(100),
	Internacional VARCHAR(100),
	Internacional_Funcionario VARCHAR(100),
	Gold VARCHAR(100),
	Gold_Funcionario VARCHAR(100),
	Platinum VARCHAR(100),
	Total VARCHAR(100)
)

-- ##################################################################################
-- SALVAR O ARQUIVO COM O NOME 'gerenciais' NO DIRETORIO DESCRITO NO BULK INSERT
-- ##################################################################################

BULK INSERT ##Informacoes_Gerenciais
FROM '\\D5668m001e035\operacoes\Andre\gerenciais.txt'
WITH (	 
	 FIELDTERMINATOR = ';'
	,ROWTERMINATOR = '\n'
	,CODEPAGE = 'ACP'
)	

-- ##################################################################################
-- GERA OS INSERTS COM OS VALORES:
-- ##################################################################################

SELECT 'INSERT INTO [tbBA_tab_InformacoesGerenciais](' +
			+'aa_Ano,mm_Mes'
			+',cs_Bandeira'
			+',ds_Tipo'
			+',qt_BaseTotal'
			+',qt_CartoesAtivos'
			+',qt_CartoesDesbloqueados'
			+',qt_CartoesEmitidos'
			+',vl_Faturamento)' 
		+'VALUES(' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + 
		',' + CAST(MONTH(DATEADD(MONTH, -1,GETDATE())) AS VARCHAR(2)) + 
		',' + QUOTENAME('Visa e Elo','''') +
		',' + QUOTENAME(Tipo,'''') +
		',' + CAST([1] AS VARCHAR(10)) +
		',' + CAST([2] AS VARCHAR(10)) +
		',' + CAST([3] AS VARCHAR(10)) +
		',' + CAST([4] AS VARCHAR(10)) +
		',' + CAST([5] AS VARCHAR(10)) + ')'		
FROM (
	SELECT 'Elo Nacional' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Elo_Nacional,'.','') AS INT) AS Elo_Nacional	
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Elo_Nacional) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT

	UNION ALL
	
	SELECT 'Elo Internacional' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Elo_Internacional,'.','') AS INT) AS Elo_Internacional
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Elo_Internacional) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT
	
	UNION ALL

	SELECT 'Internacional' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Internacional,'.','') AS INT) AS Internacional	
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Internacional) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT

	UNION ALL

	SELECT 'Internacional Funcionário' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Internacional_FuncionArio,'.','') AS INT) AS Internacional_FuncionArio	
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Internacional_FuncionArio) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT

	UNION ALL

	SELECT 'Gold' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Gold,'.','') AS INT) AS Gold	
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Gold) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT

	UNION ALL

	SELECT 'Gold Funcionário' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Gold_Funcionario,'.','') AS INT) AS Gold_Funcionario	
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Gold_Funcionario) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT

	UNION ALL

	SELECT 'Platinum' AS Tipo,[1],[2],[3],[4],[5]
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Linha, 
		CAST(REPLACE(Platinum,'.','') AS INT) AS Platinum	
		FROM ##Informacoes_Gerenciais
	) AS A
	PIVOT(SUM(Platinum) FOR Linha IN([1],[2],[3],[4],[5])) AS _PIVOT
) AS A	

-- ##################################################################################
-- BATER O VALOR TOTAL NO BANCO dbBA_Cartoes no servidor de produção:
-- ##################################################################################
USE dbBA_Cartoes
GO

SELECT 
	SUM(qt_BaseTotal) as qt_BaseTotal,
	SUM(qt_CartoesAtivos) as qt_CartoesAtivos,
	SUM(qt_CartoesDesbloqueados) as qt_CartoesDesbloqueados,
	SUM(qt_CartoesEmitidos) as qt_CartoesEmitidos,		
	SUM(vl_Faturamento)  as vl_Faturamento
FROM [tbBA_tab_InformacoesGerenciais] 
WHERE aa_ano = CASE WHEN MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR, -1,GETDATE())) ELSE YEAR(GETDATE()) END 
AND mm_mes = MONTH(DATEADD(MONTH, -1,GETDATE()))
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
SELECT Quantidade as Total
FROM (
	SELECT 
		CAST(SUM(qt_BaseTotal) AS VARCHAR(20)) AS [Base Total],
		CAST(SUM(qt_CartoesAtivos) AS VARCHAR(20)) AS [Cartões Ativos],
		CAST(SUM(qt_CartoesDesbloqueados) AS VARCHAR(20)) AS [Cartões Desbloqueados],
		CAST(SUM(qt_CartoesEmitidos) AS VARCHAR(20)) AS [Cartões Emitidos],		
		CAST(SUM(vl_Faturamento) AS VARCHAR(20)) AS [Faturamento]
	FROM [tbBA_tab_InformacoesGerenciais] 
	WHERE aa_ano = CASE WHEN MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR, -1,GETDATE())) ELSE YEAR(GETDATE()) END 
	AND mm_mes = MONTH(DATEADD(MONTH, -1,GETDATE()))
) AS A
UNPIVOT( Quantidade FOR Tipos IN( [Base Total],[Cartões Ativos],[Cartões Desbloqueados],[Cartões Emitidos],[Faturamento]) ) AS _Unpivot


		