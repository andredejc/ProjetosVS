WITH cte_CARTOES 
(nr_CPF,nr_Cartao,ds_Bandeira,cs_StatusCartAo,ds_Tipo,CartaoPrioridade,dt_Emissao) AS
(
	SELECT DISTINCT
			nr_CPF,
			nr_Cartao,
			ds_Bandeira,
			cs_StatusCartAo, 
			ds_Tipo,
			CASE
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'PLATINUM'		AND cs_StatusCartAo = 'Ativado'			THEN 21				
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'GOLD'			AND cs_StatusCartAo = 'Ativado'			THEN 20
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'INTERNACIONAL' AND cs_StatusCartAo = 'Ativado'			THEN 19
				WHEN ds_Bandeira = 'ELO'  AND ds_Tipo = 'NACIONAL'		AND cs_StatusCartAo = 'Ativado'			THEN 18
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'PLATINUM'		AND cs_StatusCartAo = 'Ativado'			THEN 17
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'GOLD'			AND cs_StatusCartAo = 'Ativado'			THEN 16
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'INTERNACIONAL' AND cs_StatusCartAo = 'Ativado'			THEN 15
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'PLATINUM'		AND cs_StatusCartAo = 'Desbloqueado'	THEN 14
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'GOLD'			AND cs_StatusCartAo = 'Desbloqueado'	THEN 13
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'INTERNACIONAL' AND cs_StatusCartAo = 'Desbloqueado'	THEN 12
				WHEN ds_Bandeira = 'ELO'  AND ds_Tipo = 'NACIONAL'		AND cs_StatusCartAo = 'Desbloqueado'	THEN 11
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'PLATINUM'		AND cs_StatusCartAo = 'Desbloqueado'	THEN 10
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'GOLD'			AND cs_StatusCartAo = 'Desbloqueado'	THEN 9
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'INTERNACIONAL' AND cs_StatusCartAo = 'Desbloqueado'	THEN 8
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'PLATINUM'		AND cs_StatusCartAo = 'Emitido'			THEN 7				
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'GOLD'			AND cs_StatusCartAo = 'Emitido'			THEN 6
				WHEN ds_Bandeira = 'VISA' AND ds_Tipo = 'INTERNACIONAL' AND cs_StatusCartAo = 'Emitido'			THEN 5
				WHEN ds_Bandeira = 'ELO'  AND ds_Tipo = 'NACIONAL'		AND cs_StatusCartAo = 'Emitido'			THEN 4
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'PLATINUM'		AND cs_StatusCartAo = 'Emitido'			THEN 3
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'GOLD'			AND cs_StatusCartAo = 'Emitido'			THEN 2
				WHEN ds_Bandeira = 'AMEX' AND ds_Tipo = 'INTERNACIONAL' AND cs_StatusCartAo = 'Emitido'			THEN 1
			END CartaoPrioridade,
			dt_Emissao					
	FROM VW_RELPRODUCAOGCCS
	WHERE cs_SituacaoCartao IN('Ativado','Desbloqueado','Emitido')
) 


SELECT  DISTINCT
		nr_CPF,
		ds_Bandeira,
		ds_Tipo,
		cs_StatusCartAo,
		dt_Emissao
FROM cte_CARTOES AS A
WHERE CartaoPrioridade = (SELECT MAX(B.CartaoPrioridade) 
						  FROM cte_CARTOES AS B 
						  WHERE A.nr_CPF = B.nr_CPF)
AND dt_Emissao = (SELECT MAX(B.dt_Emissao) 
				  FROM cte_CARTOES AS B 
				  WHERE B.nr_CPF = A.nr_CPF 
				  AND B.CartaoPrioridade = A.CartaoPrioridade)
ORDER BY nr_CPF