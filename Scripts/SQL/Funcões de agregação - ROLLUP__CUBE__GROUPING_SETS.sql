------------------------------
-- ROLLUP
------------------------------
SELECT 	 
	 SUM(vl_SaldoFinal) AS TOTAL
	,DATEPART(YYYY,dt_Movto) AS ANO
	,DATEPART(MM,dt_Movto) AS MES
	,DATEPART(DD,dt_Movto) AS DIA
FROM tbPL_hst_PrivateLabel
GROUP BY	
	ROLLUP(DATEPART(YYYY,dt_Movto)
		  ,DATEPART(MM,dt_Movto)
		  ,DATEPART(DD,dt_Movto))

SELECT 
	 nr_Logo
	,SUM(vl_SaldoFinal) AS TOTAL
	,DATEPART(YYYY,dt_Movto) AS ANO
	,DATEPART(MM,dt_Movto) AS MES
	,DATEPART(DD,dt_Movto) AS DIA
FROM tbPL_hst_PrivateLabel
GROUP BY
	 ROLLUP(nr_Logo) 
	,ROLLUP(DATEPART(YYYY,dt_Movto)
		  ,DATEPART(MM,dt_Movto)
		  ,DATEPART(DD,dt_Movto))
------------------------------		  		  		  
-- CUBE	
------------------------------
SELECT 	 
	 SUM(vl_SaldoFinal) AS TOTAL
	,DATEPART(YYYY,dt_Movto) AS ANO
	,DATEPART(MM,dt_Movto) AS MES
	,DATEPART(DD,dt_Movto) AS DIA
FROM tbPL_hst_PrivateLabel
GROUP BY CUBE(DATEPART(YYYY,dt_Movto)
			 ,DATEPART(MM,dt_Movto)
		     ,DATEPART(DD,dt_Movto))
	  
SELECT 
	 nr_Logo
	,SUM(vl_SaldoFinal) AS TOTAL
	,DATEPART(YYYY,dt_Movto) AS ANO
	,DATEPART(MM,dt_Movto) AS MES
	,DATEPART(DD,dt_Movto) AS DIA
FROM tbPL_hst_PrivateLabel
GROUP BY CUBE(nr_Logo
			 ,DATEPART(YYYY,dt_Movto)
			 ,DATEPART(MM,dt_Movto)
		     ,DATEPART(DD,dt_Movto))
------------------------------		  		  		  
-- GROUPING SETS	
------------------------------	
SELECT 
	 nr_Logo			
	,DATEPART(MM,dt_Movto) AS MES	
	,SUM(vl_SaldoFinal) AS TOTAL
FROM tbPL_hst_PrivateLabel	
GROUP BY GROUPING SETS((DATEPART(MM,dt_Movto),nr_Logo))  

SELECT 
	 nr_Logo			
	,DATEPART(MM,dt_Movto) AS MES
	,DATEPART(DD,dt_Movto) AS DIA	
	,SUM(vl_SaldoFinal) AS TOTAL
FROM tbPL_hst_PrivateLabel	
GROUP BY GROUPING SETS((DATEPART(MM,dt_Movto),nr_Logo),(DATEPART(DD,dt_Movto),nr_Logo))     

-- A PRIMEIRA QUERY EQUIVALENTE LOGICAMENTE A SEGUINTE QUERY:

SELECT 
	 NULL AS nr_Logo				
	,DATEPART(MM,dt_Movto) AS MES	
	,SUM(vl_SaldoFinal) AS TOTAL
FROM tbPL_hst_PrivateLabel	
GROUP BY DATEPART(MM,dt_Movto)

UNION ALL

SELECT 	
	 nr_Logo			
	,NULL AS MES
	,SUM(vl_SaldoFinal) AS TOTAL
FROM tbPL_hst_PrivateLabel	
GROUP BY nr_Logo