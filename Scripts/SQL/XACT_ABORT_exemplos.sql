IF(OBJECT_ID(N'TesteIdent') IS NOT NULL)
	DROP TABLE TesteIdent;
GO
	
CREATE TABLE TesteIdent
(
	id INT IDENTITY(1,1),
	nome VARCHAR(100)
)

-- Com o XACT_ABORT em ON, como n�o h� nenhuma transa��o aberta, ser�o inseridas as duas primeiras linhas antes da terceira linha que vai gerar 
-- um erro. Se o XACT_ABORT estiver em OFF, que � o padr�o, ser�o inseridas as duas primeiras e a �ltima linha, e a terceira linha vai gerar o erro.
SET XACT_ABORT ON
INSERT INTO TesteIdent(nome) VALUES('Andr�');
INSERT INTO TesteIdent(nome) VALUES('Andr�');
INSERT INTO TesteIdent(id,nome) VALUES(9,'Andr�'); 
INSERT INTO TesteIdent(nome) VALUES('Andr�');


-- Aqui como a transa��o est� aberta o lote inteiro ser� revertido devido o erro de inser��o da terceira linha.
SET XACT_ABORT ON
BEGIN TRAN
	INSERT INTO TesteIdent(nome) VALUES('Andr�');
	INSERT INTO TesteIdent(nome) VALUES('Andr�');
	INSERT INTO TesteIdent(id,nome) VALUES(9,'Andr�'); 
	INSERT INTO TesteIdent(nome) VALUES('Andr�');
COMMIT TRAN