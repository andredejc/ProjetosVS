
DECLARE 
	@Count INT = 1,
	@MaxColunas INT = 10,
	@AnoFimVigencia NVARCHAR(10) = '2016-11-01',
	@QuerySQL NVARCHAR(MAX) = '',
	@QueryPivot VARCHAR(8000) = ''

SET @QuerySQL = 
'IF OBJECT_ID(''tempdb..##Auto'',''U'') IS NOT NULL DROP TABLE ##Auto;
 WITH CteAuto AS (
	SELECT nm_SeguradoNome,nr_SeguradoCPFCNPJ,dt_ItemDataFimVigencia FROM dbo.tbBR_tab_AUTO_2014 WHERE dt_ItemDataFimVigencia >= '+ QUOTENAME(@AnoFimVigencia,'''') +'
	UNION
	SELECT nm_SeguradoNome,nr_SeguradoCPFCNPJ,dt_ItemDataFimVigencia FROM dbo.tbBR_tab_AUTO_2015 WHERE dt_ItemDataFimVigencia >= '+ QUOTENAME(@AnoFimVigencia,'''') +'
	UNION 
	SELECT nm_SeguradoNome,nr_SeguradoCPFCNPJ,dt_ItemDataFimVigencia FROM dbo.tbBR_tab_AUTO_2016 WHERE dt_ItemDataFimVigencia >= '+ QUOTENAME(@AnoFimVigencia,'''') +'
 ),CteAutoFinal AS (
	SELECT 
		A.nr_SeguradoCPFCNPJ,
		A.dt_ItemDataFimVigencia,
		ROW_NUMBER() OVER(PARTITION BY A.nr_SeguradoCPFCNPJ ORDER BY A.dt_ItemDataFimVigencia) AS Linha
	FROM CteAuto AS A		
 )
 SELECT 
	nr_SeguradoCPFCNPJ,' + CHAR(13) + CHAR(9)

SET @QueryPivot = 'PIVOT( MAX(dt_ItemDataFimVigencia) FOR Linha IN('
					

WHILE @Count <= @MaxColunas
BEGIN	
	SET @QuerySQL += '[' + CAST(@Count AS VARCHAR(10)) +'] AS [dt_vcto_Auto_Apolice_' + CAST(@Count AS VARCHAR(10)) + '],' + CHAR(13) + CHAR(9)
	SET @QueryPivot += '[' + CAST(@Count AS VARCHAR(10)) +'],'
	SET @Count = @Count + 1;
END

-- Remove última vírgula da string
SET @QuerySQL = REVERSE(STUFF(REVERSE(@QuerySQL),1, CHARINDEX(',',REVERSE(@QuerySQL),0),''))
SET @QuerySQL += CHAR(13) + 'INTO ##Auto' + CHAR(13) + 'FROM CteAutoFinal' + CHAR(13)

-- Remove última vírgula da string
SET @QueryPivot = REVERSE(STUFF(REVERSE(@QueryPivot),1, CHARINDEX(',',REVERSE(@QueryPivot),0),''))
SET @QueryPivot += ') ) AS _Pivot' + CHAR(13) + 'ORDER BY 1;'

SET @QuerySQL += @QueryPivot

EXECUTE sp_executesql @QuerySQL

SELECT * 
FROM ##Auto
WHERE dt_vcto_Auto_Apolice_10 IS NOT NULL