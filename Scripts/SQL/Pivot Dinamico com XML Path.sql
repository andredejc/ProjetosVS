DECLARE @SQL NVARCHAR(4000)
SET @SQL = N'SELECT ' +
	SUBSTRING(
		(SELECT DISTINCT TOP 10 N', SUM(CASE WHEN nm_MunicipioRisco = ' + 
		 QUOTENAME(LTRIM(RTRIM(nm_MunicipioRisco)),'''') + N' THEN 1 ELSE 0 END) AS ' + 
		 QUOTENAME(LTRIM(RTRIM(nm_MunicipioRisco))) AS "*" 
	FROM tbBR_tab_NASA_01_Mov_Reno_Tele_Propo2015
	WHERE nm_MunicipioRisco NOT LIKE '%[0-9]%'
	AND nm_MunicipioRisco != ''
	AND nm_MunicipioRisco != 'A'
	ORDER BY 1
	FOR XML PATH('')),2,4000
	)
SET @SQL += + N' FROM tbBR_tab_NASA_01_Mov_Reno_Tele_Propo2015'
PRINT @SQL 
