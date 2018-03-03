WITH CTE AS(
	SELECT 
		U.Numeros,
		MAX(U.Total) as Total,
		ROW_NUMBER() OVER(PARTITION BY U.Numeros ORDER BY U.Numeros,U.Total) Linha
	FROM(
		SELECT *
		FROM(
			SELECT Num01 FROM ConLF
		) AS A
		PIVOT(COUNT(Num01) FOR Num01 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num02 FROM ConLF
		) AS A
		PIVOT(COUNT(Num02) FOR Num02 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num03 FROM ConLF
		) AS A
		PIVOT(COUNT(Num03) FOR Num03 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num04 FROM ConLF
		) AS A
		PIVOT(COUNT(Num04) FOR Num04 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num05 FROM ConLF
		) AS A
		PIVOT(COUNT(Num05) FOR Num05 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num06 FROM ConLF
		) AS A
		PIVOT(COUNT(Num06) FOR Num06 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num07 FROM ConLF
		) AS A
		PIVOT(COUNT(Num07) FOR Num07 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num08 FROM ConLF
		) AS A
		PIVOT(COUNT(Num08) FOR Num08 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num09 FROM ConLF
		) AS A
		PIVOT(COUNT(Num09) FOR Num09 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num10 FROM ConLF
		) AS A
		PIVOT(COUNT(Num10) FOR Num10 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num11 FROM ConLF
		) AS A
		PIVOT(COUNT(Num11) FOR Num11 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num12 FROM ConLF
		) AS A
		PIVOT(COUNT(Num12) FOR Num12 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num13 FROM ConLF
		) AS A
		PIVOT(COUNT(Num13) FOR Num13 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num14 FROM ConLF
		) AS A
		PIVOT(COUNT(Num14) FOR Num14 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
		
		UNION ALL
		
		SELECT *
		FROM(
			SELECT Num15 FROM ConLF
		) AS A
		PIVOT(COUNT(Num15) FOR Num15 IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS  _PIVOT
	) AS CTE
	UNPIVOT(Total FOR Numeros IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS U
	GROUP BY U.Numeros,U.Total
--ORDER BY U.Numeros
)
SELECT CAST(A.Numeros AS INT) AS Numeros,A.Total
FROM CTE AS A
WHERE A.Linha = (SELECT MAX(B.Linha) FROM CTE AS B WHERE B.Numeros = A.Numeros)
ORDER BY Numeros 
