-- Se o usu�rio n�o tiver privil�gios suficientes para atachar o banco, � poss�vel fazer o restore via arquivo de backup:

-- Aqui recupera-se os nomes l�gicos para o .mdf e o .ldf
RESTORE FILELISTONLY
FROM DISK = 'E:\Andre\Databases\AdventureWorks2008.bak'
GO

-- Depois � poss�vel fazer o restore apontando para o caminho desejado
RESTORE DATABASE AdventureWorks
FROM DISK = 'E:\Andre\Databases\AdventureWorks2008.bak'
WITH MOVE 'AdventureWorks_Data' TO 'E:\Andre\Databases\AdventureWorks_Data.mdf',
MOVE 'AdventureWorks_Log' TO 'E:\Andre\Databases\AdventureWorks_Log.ldf'