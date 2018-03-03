-- Tratamento de erros:
-- Nessa Procedure, sem a instru��o XACT_ABORT setada para ON, o SELECT na tabela inexistente vai gerar um erro, mas n�o vai vai fazer o ROLLBACK
-- da transa��o. Com o XACT_ABORT em ON, a transa��o vai ser revertida e nenhuma altera��o ser� efetivada caso seja UPDATE, INSERT ou DELETE.

CREATE PROCEDURE sp_TESTE
AS
-- SET XACT_ABORT ON

BEGIN TRY
	BEGIN TRAN
		SELECT 1 FROM TABELA
	COMMIT TRAN
END TRY
BEGIN CATCH	
	IF (@@TRANCOUNT > 0)
	ROLLBACK TRAN
	RAISERROR('Falha na proc!',16,1)
END CATCH	

EXECUTE sp_TESTE;
GO

SELECT @@TRANCOUNT;
GO
