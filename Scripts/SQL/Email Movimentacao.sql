SELECT DISTINCT 
	 ISNULL(nr_Cli_SIS,'') AS [Num Parceria]
	,ISNULL(nm_Cli_SIS,'') AS [Parceria]	
	,CAST(ISNULL(CASE WHEN SUBSTRING(CAST(A.nr_Cli_SIS AS VARCHAR(10)),1,1) = 1 
					THEN (SELECT ISNULL(nm_Arquivo,'') 
						  FROM [tbBR_tab_ArquivoComp]
						  WHERE CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE)
						  AND nm_Arquivo LIKE '%Bradesco%')				
					ELSE (SELECT ISNULL(nm_Arquivo,'') 
						  FROM [tbBR_tab_ArquivoComp]
						  WHERE CAST(dh_Ins AS DATE) = CAST(GETDATE() AS DATE)
						  AND nm_Arquivo LIKE '%Amex%')
				 END,'') AS VARCHAR(150)) AS [Arquivo Zip]
FROM tbBR_hst_MovCancelamento AS A
	INNER JOIN tbBR_tab_Arquivo AS B
		ON A.id_Arquivo = B.id_Arquivo	
WHERE YEAR(B.dh_Carga) = 2016
AND MONTH(B.dh_Carga) = 08
AND NOT EXISTS (SELECT DISTINCT C.nr_Cli_SIS
				FROM tbBR_hst_MovCancelamento AS C
					INNER JOIN tbBR_tab_Arquivo AS D
						ON C.id_Arquivo = D.id_Arquivo
				WHERE D.cs_Tipo = 'MovCancel'
				AND CAST(D.dh_Carga AS DATE) = CAST(GETDATE() AS DATE)
				AND A.nr_Cli_SIS = C.nr_Cli_SIS)
ORDER BY 1	