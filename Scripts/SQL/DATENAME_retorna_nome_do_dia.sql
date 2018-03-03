SET LANGUAGE Brazilian

SELECT 
	DATENAME(DW,dt_Transacao) AS [Dia da Semana],
	DAY(dt_Transacao) AS [Dia],
	MONTH(dt_Transacao) AS [Mês],
	COUNT(*) AS [Total dia]
FROM dbo.vw_Mapa
WHERE YEAR(dt_Transacao) = 2016
GROUP BY dt_Transacao
ORDER BY dt_Transacao