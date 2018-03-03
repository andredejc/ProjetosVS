USE dbSA_Saude
GO

DECLARE 		
	@Count INT,
	@Int INT	
	
EXECUTE sp_executesql
	N'SELECT @Count = COUNT(*) FROM tbSA_tab_Arquivo', -- Query passando o valor para variável
	N'@Count INT OUTPUT',	-- Parametros
	@Count = @Int OUTPUT	-- OUTPUT do @Count para o @Int

SELECT @Int