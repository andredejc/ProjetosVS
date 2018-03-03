
/*
	Levar em consideração na criação de um índice cluster

	Únicos:
	Se o índice cluster não unique, o SQL Server irá adicionar um INTEGER de 4 bytes para que ele se torne único na tabela. Isso, além de consumir
	recursos (para cada insert ou update ele terá que verificar se esta informação já existe para saber se ele tem que incluir os 4 bytes ou não) irá
	ocupar mais espaço para armazenar o 4 bytes gerados.
	
	Pequenos:
	Sabendo que a chave do índice cluster é salvo em todos índices non-cluster significa que quanto menor ele for menos espaço você irá utilizar para guardar esta 
	informação no índice non-clustered. Por exemplo imagine que você possui uma tabela com uma chave primária com as colunas ID, Ano, Mes, Dia e possúi vários índices 
	non-cluster em outras colunas, o SQL irá gravar os dados de ID, Ano, Mês, Dia em cada índice non-clustered de sua tabela. Então se ele for muito grande você 
	terá uma grande perda de espaço e custo para seus selects(pois ele terá que ler mais páginas de dados para retornar sua informação), inserts e updates…
	Quanto maior for seu índice cluster mais espaço seus índices non-clusters irão ocupar.
	
	Estáticos:
	Deve ser estático porque se você alterar seu valor ele terá que alem de alterar o valor na tabela alterar todos os índices non-clustered lembra que ele também 
	fica gravado nos índices non-clustered?. Outra coisa importante é que como o índice está ordenado pela chave caso o valor mude ele irá causar fragmentação na sua tabela.
 */


-- Teste que gera três tabelas com a mesma quantidade de dados para desmonstrar a diferença de tamanho quando comparadas três tabelas, sendo uma sem índice cluster, 
-- outra com índice cluster unique e uma terceira com índice cluster nonunique:
 
-- Cria tabela com índice clustered unique:
IF OBJECT_ID('tab_index_unique') IS NOT NULL BEGIN DROP TABLE tab_index_unique END
CREATE TABLE tab_index_unique(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	CODIGO VARCHAR(40)
)
-- Cria tabela para o índice clustered não unique:
IF OBJECT_ID('tab_index_nao_unique') IS NOT NULL BEGIN DROP TABLE tab_index_nao_unique END
CREATE TABLE tab_index_nao_unique(
	ID INT,
	CODIGO VARCHAR(40)
)
-- Cria o índice clustered não unique:
CREATE CLUSTERED INDEX ixc ON tab_index_nao_unique(ID)

-- Preenche as tabelas com 100k registros cada:
DECLARE @ID INT, @COUNT INT = 1

WHILE @COUNT <= 1000000
BEGIN				
	INSERT INTO tab_index_unique(CODIGO)VALUES(NEWID())
	SET @COUNT = @COUNT + 1
END

SET @COUNT = 5
WHILE @COUNT <= 1000004
BEGIN
	SET @ID = @COUNT / 5		
	INSERT INTO tab_index_nao_unique(ID,CODIGO)VALUES(@ID,NEWID())
	SET @COUNT = @COUNT + 1
END
GO
-- Verifica o espaço das tabelas e dos índices:

sp_spaceused tab_index_unique -- DATA - 52632 KB | INDEX SIZE - 216 KB
GO
sp_spaceused tab_index_nao_unique -- DATA - 57560 KB | INDEX SIZE - 368 KB
GO

-- Cria os índices nonclustered para comparar o tamanho do espaço alocado:
CREATE NONCLUSTERED INDEX ix01 ON tab_index_unique(CODIGO)
GO
CREATE NONCLUSTERED INDEX ix01 ON tab_index_nao_unique(CODIGO)
GO

sp_spaceused tab_index_unique -- DATA - 52632 KB | INDEX SIZE - 50376 KB
GO
sp_spaceused tab_index_nao_unique -- DATA - 57560 KB | INDEX SIZE - 55200 KB
GO

SELECT 50376 / 1024
SELECT 55200 / 1024paceused tab_index_nao_unique 
GO