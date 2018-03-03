SELECT 	
	LTRIM(RTRIM(A.nm_MunicipioRisco)) AS nm_MunicipioRisco,
	B.ds_Combustivel,
	SUM(B.vl_isCasco) AS vl_Total
FROM tbBR_tab_NASA_01_Mov_Reno_Tele_Propo2015 AS A
	INNER JOIN tbBR_tab_NASA_02_ObjSeg_Opci_Cobert_LMI2015 AS B
		ON A.id_BaseCarga = B.id_BaseCarga
		AND A.id_Arquivo = B.id_Arquivo
WHERE B.vl_isCasco IS NOT NULL	
AND A.nm_MunicipioRisco	!= ''
AND A.nm_MunicipioRisco	NOT LIKE '%[0-9]%'
GROUP BY GROUPING SETS 
	(
		( A.nm_MunicipioRisco,B.ds_Combustivel ),
		( A.nm_MunicipioRisco ),
		( )
	)
ORDER BY 1 DESC,2 DESC

SELECT 
	LTRIM(RTRIM(nm_Municipio)) AS nm_Municipio,
	YEAR(dt_FinalVigencia) AS dt_FinalVigencia_Ano,	
	MONTH(dt_FinalVigencia) AS dt_FinalVigencia_Mes,	
	COUNT(*) Total
FROM tbBR_tab_NASA_01_Mov_Reno_Tele_Propo2015
WHERE nm_Municipio != ''
AND nm_Municipio NOT LIKE '%[0-9]%'
GROUP BY GROUPING SETS 
	(
		( LTRIM(RTRIM(nm_Municipio)),YEAR(dt_FinalVigencia),MONTH(dt_FinalVigencia) ),
		( LTRIM(RTRIM(nm_Municipio)),YEAR(dt_FinalVigencia) ),
		( LTRIM(RTRIM(nm_Municipio)) ),
		( )
	)
ORDER BY 1 DESC,2 DESC,3 DESC