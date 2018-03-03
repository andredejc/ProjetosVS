IF(OBJECT_ID(N'TesteIdent') IS NOT NULL)
	DROP TABLE TesteIdent;
GO
	
CREATE TABLE TesteIdent
(
	id INT IDENTITY(1,1),
	nome VARCHAR(100)
)

-- Com o XACT_ABORT em ON, como não há nenhuma transação aberta, serão inseridas as duas primeiras linhas antes da terceira linha que vai gerar 
-- um erro. Se o XACT_ABORT estiver em OFF, que é o padrão, serão inseridas as duas primeiras e a última linha, e a terceira linha vai gerar o erro.
SET XACT_ABORT ON
INSERT INTO TesteIdent(nome) VALUES('André');
INSERT INTO TesteIdent(nome) VALUES('André');
INSERT INTO TesteIdent(id,nome) VALUES(9,'André'); 
INSERT INTO TesteIdent(nome) VALUES('André');


-- Aqui como a transação está aberta o lote inteiro será revertido devido o erro de inserção da terceira linha.
SET XACT_ABORT ON
BEGIN TRAN
	INSERT INTO TesteIdent(nome) VALUES('André');
	INSERT INTO TesteIdent(nome) VALUES('André');
	INSERT INTO TesteIdent(id,nome) VALUES(9,'André'); 
	INSERT INTO TesteIdent(nome) VALUES('André');
COMMIT TRAN