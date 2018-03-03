SELECT 
	 ISNULL(CAST(nm_Cliente AS VARCHAR),'') AS nm_Cliente
	,ISNULL(CAST(nr_CPF AS VARCHAR),'') AS nr_CPF
	,ISNULL(CAST(nr_Cartao AS VARCHAR),'') AS nr_Cartao
	,ISNULL(CAST(dt_Aquisicao AS VARCHAR),'') AS dt_Aquisicao
	,ISNULL(CAST(ds_EndLogr AS VARCHAR),'') AS ds_EndLogr
	,ISNULL(CAST(ds_EndBairro AS VARCHAR),'') AS ds_EndBairro
	,ISNULL(CAST(ds_EndCidade AS VARCHAR),'') AS ds_EndCidade
	,ISNULL(CAST(ds_EndCEP AS VARCHAR),'') AS ds_EndCEP
	,ISNULL(CAST(ds_EndUF AS VARCHAR),'') AS ds_EndUF
	,ISNULL(CAST(cs_Status AS VARCHAR),'') AS cs_Status
	,ISNULL(CAST(dt_Cancelamento AS VARCHAR),'') AS dt_Cancelamento
FROM tbBR_tab_BaseSeguradoMaisProtecao 
WHERE cs_Status = 'CANCELADO'
AND YEAR(dt_cancelamento) = YEAR(GETDATE()) 
AND MONTH(dt_cancelamento) = (SELECT MONTH(MAX(dt_cancelamento)) FROM tbBR_tab_BaseSeguradoMaisProtecao)

SELECT @@SERVERNAME
