IF(OBJECT_ID(N'TesteIdent') IS NOT NULL)
	DROP TABLE TesteIdent;
GO
	
CREATE TABLE TesteIdent
(
	id INT IDENTITY(1,1),
	nome VARCHAR(100)
)

INSERT INTO TesteIdent(nome) VALUES('André');
GO
SELECT SCOPE_IDENTITY()				--> Retorna o último valor de IDENTITY inserido em uma coluna no mesmo escopo. 
										--  Um escopo é um módulo: um procedimento armazenado, gatilho, função ou lote. Portanto, 
										--  duas instruções estarão no mesmo escopo se eles estiverem no mesmo procedimento armazenado, função ou lote.
									
SELECT @@IDENTITY						--> Retornam o último valor de IDENTITY gerado em qualquer tabela da sessão atual.O @@IDENTITY não é limitada a um escopo específico.
SELECT IDENT_CURRENT(N'TesteIdent') 	--> Retorna o último valor IDENTITY gerado na tabela especificada idependente da conexão.