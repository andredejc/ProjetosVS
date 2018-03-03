/* ************************************************************************************************/
/* *********************************   INFORMAÇÕES DE TABELA    ********************************* */
/* ************************************************************************************************/

--------------------------------------------
-- Total de linhas da tabela sem COUNT(*)
--------------------------------------------
SELECT DISTINCT obj.name, prt.rows
FROM sys.objects obj	
	INNER JOIN sys.partitions prt ON obj.object_id= prt.object_id	
WHERE obj.type= 'U'
AND obj.object_id = object_id('FLAT_PJ_PRQE_TEMP')  

--------------------------------------------------------
-- Epaço usado em MB, total de linhas, data pages e etc.
--------------------------------------------------------

SELECT 
	t.NAME AS TableName,
	i.name AS indexName,
	SUM(p.rows) AS RowCounts,
	SUM(a.total_pages) AS TotalPages, 
	SUM(a.used_pages) AS UsedPages, 
	SUM(a.data_pages) AS DataPages,
	(SUM(a.total_pages) * 8) / 1024 AS TotalSpaceMB, 
	(SUM(a.used_pages) * 8) / 1024 AS UsedSpaceMB, 
	(SUM(a.data_pages) * 8) / 1024 AS DataSpaceMB
FROM sys.tables t
	INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
	INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
	INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.name = 'PARQUE_FAT_TEMP'
AND i.OBJECT_ID > 255 
AND i.index_id <= 1
GROUP BY t.NAME, i.object_id, i.index_id, i.name 
ORDER BY OBJECT_NAME(i.object_id)


/* ************************************************************************************************/
/* *********************************        ESTATÍSTICAS        ********************************* */
/* ************************************************************************************************/
/* 	
	OBSERVAÇÕES
		* As estatísticas só serão atualizadas automaticamente se a opção AUTO_CREATE_STATISTICS 
		  estiver como ON.
		* Estatísticas só serão atualizdas automaticamente quando a tabela atingir o limite de 500
		  linhas + 20% da tabela. Se a tabela for muito grande, isso pode ser um problema, deve-se 
		  considerar um plano de atualização manualmente. Não é recomendado, porém, atualizá-las 
		  com muita frequência pois o custo é muito grande para o banco.
		* Querys utilizadas apenas uma vez também podem gerar estatísticas, deixando a tabela em 
		  questão com uma quantidade grande de estatísticas não utilizadas.
		  
	ERROS COMUNS
		- Atualização de estatísticas após REBUILD de índice:
			Quando é feito um REBUILD nos índices, também é feita uma atualização full scan de para 
			os índices, se um plano de manutenção de estatísticas após o de índices, vai gerar um 
			retrabalho no servidor. No entanto não há problema se tiver feito apenas um REORG nos
			índices.
		- Confiar nas atualizações automáticas:
			Atualização automática pode ser bom para tabelas pequenas, mas para tabelas grandes pode 
			ser um problema, tento em vista que a atualização só vai ser feita quando a tabela tiver
			um aumento de 500 linhas mais 20% do total de linhas da tabela.
		- Não especificar o sample size:
			Ao atualizar, escolher o tamanho certo da amostra é importante para manter as estatísticas 
			precisas. Embora o custo da utilização de varredura completa seja maior, em algumas 
			situações é necessário, especialmente para bancos de dados muito grandes. Executando 
			EXEC sp_updatestats @resample = 'resample' atualizará todas as estatísticas usando a 
			última amostra usada. Se você não especificar um resample, ele irá atualizá-los usando a 
			amostra padrão. O exemplo padrão é determinado pelo SQL e é uma fração da contagem total de 
			linhas em uma tabela. Recentemente, encontramos um problema em que um DBA executou 
			"EXEC sp_updatestats" em um banco de dados de 1 terabyte, o que fez com que todas as 
			estatísticas fossem atualizadas com a amostra padrão. Devido ao tamanho do banco de dados, 
			o exemplo padrão simplesmente não é suficiente para representar a distribuição de dados no 
			banco de dados e ocasionou que todas as consultas usassem planos de execução incorretos que 
			causassem grandes problemas de desempenho. Apenas um FULL SCAN UPDATE das estatísticas 
			forneceu estatísticas precisas para este banco de dados, mas leva muito tempo para ser 
			executado. Felizmente, havia um servidor de QA onde o banco de dados foi restaurado antes 
			da atualização das estatísticas e com dados quase idênticos. Conseguimos rotear as estatísticas 
			do servidor de QA e recriá-las na produção usando sua representação binária 
			(consulte WITH STATS_STREAM). Esta solução não é recomendada e foi usada apenas como último 
			recurso. Este incidente mostra a importância das estatísticas e a implementação de manutenção 
			adequada adequada ambiente.
		- Atualizar muitas vezes:
			A cada atualização, além do custo, as querys são recompiladas.
	
*/

---------------------------------------------------------------------------------------------------
-- Atualiza todas as estatísticas do banco
---------------------------------------------------------------------------------------------------
EXECUTE sp_updatestats


---------------------------------------------------------------------------------------------------
-- Mostra informações detalhadas sobre as statísticas de uma tabela e um índice específico
---------------------------------------------------------------------------------------------------
-- Parâmetros: 
--		nome da tabela  
--		índice
---------------------------------------------------------------------------------------------------
DBCC SHOW_STATISTICS('FLAT_PJ_PRQE_TEMP', ix_fl_ociosidade)
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- Mostra data da última atualização das statísticas de uma tabela
---------------------------------------------------------------------------------------------------
-- Parâmetros da função STATS_DATE(): 
--		id  
--		indid
---------------------------------------------------------------------------------------------------
SELECT name, STATS_DATE(id, indid) DataAtualizacao
FROM sysindexes
WHERE id = Object_id('FLAT_PJ_PRQE_TEMP')


---------------------------------------------------------------------------------------------------
-- identifica as estatísticas de coluna única que são cobertas por uma estatística de índice
---------------------------------------------------------------------------------------------------
-- Autor: Kendal Van Dyke
---------------------------------------------------------------------------------------------------

WITH autostats ( object_id, stats_id, name, column_id ) AS ( 
	SELECT   
		sys.stats.object_id ,
		sys.stats.stats_id ,
		sys.stats.name ,
		sys.stats_columns.column_id
	FROM sys.stats
		INNER JOIN sys.stats_columns ON sys.stats.object_id = sys.stats_columns.object_id
		AND sys.stats.stats_id = sys.stats_columns.stats_id
	WHERE    sys.stats.auto_created = 1
	AND sys.stats_columns.stats_column_id = 1
)
 
SELECT  
	OBJECT_NAME(sys.stats.object_id) AS [Table] ,
	sys.columns.name AS [Column] ,
	sys.stats.name AS [Overlapped] ,
	autostats.name AS [Overlapping] ,
	'DROP STATISTICS [' + OBJECT_SCHEMA_NAME(sys.stats.object_id)
	+ '].[' + OBJECT_NAME(sys.stats.object_id) + '].['
	+ autostats.name + ']'
FROM sys.stats
	INNER JOIN sys.stats_columns ON sys.stats.object_id = sys.stats_columns.object_id
		AND sys.stats.stats_id = sys.stats_columns.stats_id
	INNER JOIN autostats ON sys.stats_columns.object_id = autostats.object_id
		AND sys.stats_columns.column_id = autostats.column_id
	INNER JOIN sys.columns ON sys.stats.object_id = sys.columns.object_id
		AND sys.stats_columns.column_id = sys.columns.column_id
WHERE sys.stats.auto_created = 0
AND sys.stats_columns.stats_column_id = 1
AND sys.stats_columns.stats_id != autostats.stats_id
AND OBJECTPROPERTY(sys.stats.object_id, 'IsMsShipped') = 0