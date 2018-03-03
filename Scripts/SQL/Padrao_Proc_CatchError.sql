-- Padrão de Proc com tratamento de erro:

CREATE PROCEDURE sp_ins_TabelaHistorica
AS
DECLARE @qtdeImport BIGINT

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION			
			  
			SET @qtdeImport = @@ROWCOUNT;
			
		COMMIT TRANSACTION
	END TRY	 
	
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		
		DECLARE @ErrorNumber INT = ERROR_NUMBER();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_STATE();
		
		PRINT 'Numero erro: ' + CAST(@ErrorNumber AS VARCHAR(10));
		PRINT 'Linha erro: ' + CAST(@ErrorLine AS VARCHAR(10));
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	
	END CATCH 
	  
END; 