-- Depois de rodar, clicar no botão cancelar e dar um SELECT no @@TRACOUNT

SET XACT_ABORT OFF;
BEGIN TRY ;
  PRINT 'Beginning TRY block' ;
  BEGIN TRANSACTION ;
  WAITFOR DELAY '00:10:00' ;
  COMMIT ;
  PRINT 'Ending TRY block' ;
END TRY
BEGIN CATCH ;
  PRINT 'Entering CATCH block' ;
END CATCH ;
PRINT 'After the end of the CATCH block' ; 


SELECT @@TRANCOUNT
