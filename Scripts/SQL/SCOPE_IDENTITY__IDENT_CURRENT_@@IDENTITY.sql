IF(OBJECT_ID(N'TesteIdent') IS NOT NULL)
	DROP TABLE TesteIdent;
GO
	
CREATE TABLE TesteIdent
(
	id INT IDENTITY(1,1),
	nome VARCHAR(100)
)

INSERT INTO TesteIdent(nome) VALUES('Andr�');
GO
SELECT SCOPE_IDENTITY()				--> Retorna o �ltimo valor de IDENTITY inserido em uma coluna no mesmo escopo. 
										--  Um escopo � um m�dulo: um procedimento armazenado, gatilho, fun��o ou lote. Portanto, 
										--  duas instru��es estar�o no mesmo escopo se eles estiverem no mesmo procedimento armazenado, fun��o ou lote.
									
SELECT @@IDENTITY						--> Retornam o �ltimo valor de IDENTITY gerado em qualquer tabela da sess�o atual.O @@IDENTITY n�o � limitada a um escopo espec�fico.
SELECT IDENT_CURRENT(N'TesteIdent') 	--> Retorna o �ltimo valor IDENTITY gerado na tabela especificada idependente da conex�o.