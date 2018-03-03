-- Deleta registros duplicados baseando-se em uma coluna IDENTITY

	SELECT nm_Arquivo,CONVERT(CHAR(10),dt_Processo,112),COUNT(*)
	FROM tbGS_tab_AttritionRejeitados
	WHERE CONVERT(CHAR(10),dt_Processo,112) = CONVERT(CHAR(10),GETDATE(),112)
	GROUP BY nm_Arquivo,CONVERT(CHAR(10),dt_Processo,112)
	HAVING COUNT(*) > 1



	DELETE
	FROM tbGS_tab_AttritionRejeitados
	WHERE id_Arquivo NOT IN
	(
		SELECT MAX(id_Arquivo)
		FROM tbGS_tab_AttritionRejeitados
		GROUP BY nm_Arquivo,CONVERT(CHAR(10),dt_Processo,112)
	)


