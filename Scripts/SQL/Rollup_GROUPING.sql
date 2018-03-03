-- O GROUPING na cláusula CASE retorna 1 para total agrupado e zero para demais linhas. Aqui foi utilizado para trazer apenas a primeira
-- linha com o nome da Supex na consulta.

SELECT 	
	CASE WHEN GROUPING(ds_Sucur) = 1 THEN nm_Supex ELSE '' END AS Supex, 	
	ISNULL(ds_Sucur,'Total') AS ds_Sucur,
	COUNT(ds_Tipo) AS Total--,COUNT(ds_Bandeira)
FROM [vw_RelProducaoGCCS]   
WHERE nm_Supex IS NOT NULL   
GROUP BY ROLLUP(nm_Supex,ds_Sucur)
ORDER BY nm_Supex DESC, ISNULL(ds_Sucur,'Total') DESC


Sul										Total	13556
		663 - Joinville	    					814
		662 - Chapecó	    					486
		661 - Florianópolis						2497
		660 - Cascavel	    					738
		659 - Londrina							2219
		658 - Curitiba II						1383
		657 - Curitiba I						1302
		656 - Santa Maria						745
		655 - Caxias do Sul						1371
		654 - Porto Alegre						2001
SP Nova Capital							Total	5
		750 - Prime Faria Lima					3
		731 - Santos							1
		715 - Nova Central						1
SP Interior								Total	19529
		986 - São Carlos						1232
		943 - São J. dos Campos					1519
		939 - São J. do Rio Preto				1752
		935 - Bauru								1657
		931 - Pres. Prudente					2004
		927 - Sorocaba							2582
		918 - Ribeirão Preto					2572
		915 - Campinas Sul/Jundiaí				2662
		910 - Campinas Leste/Oeste				3547
		482 - Jundiaí							1
		458 - São José do Rio Preto				1