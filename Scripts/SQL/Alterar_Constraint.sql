-- Uma CONSTRAINT não pode ser alterada. Deve-se dropar a existente e criá-la novamente

ALTER TABLE [dbo].[tbBR_tab_Arquivo] DROP CONSTRAINT [ck01_tbBR_tab_Arquivo] 

ALTER TABLE [dbo].[tbBR_tab_Arquivo]  WITH CHECK ADD  CONSTRAINT [ck01_tbBR_tab_Arquivo] 
CHECK  (([cs_Tipo]='RICMM_VLR' OR 
		 [cs_Tipo]='RICMM_QTD' OR 
		 [cs_Tipo]='DevPostagem' OR 
		 [cs_Tipo]='WebSis' OR 
		 [cs_Tipo]='Vendas' OR 
		 [cs_Tipo]='MovCancel' OR 
		 [cs_Tipo]='Log_FechamentoGSC' OR
		 [cs_Tipo]='CANCELADOS' OR
		 [cs_Tipo]='RECUPERADOS'OR
		 [cs_Tipo]='CANCELAMENTO ILHA BRADESCO'))