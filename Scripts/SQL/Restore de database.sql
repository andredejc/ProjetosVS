-- Se o usuário não tiver privilégios suficientes para atachar o banco, é possível fazer o restore via arquivo de backup:

-- Aqui recupera-se os nomes lógicos para o .mdf e o .ldf
RESTORE FILELISTONLY
FROM DISK = 'E:\Andre\Databases\AdventureWorks2008.bak'
GO

-- Depois é possível fazer o restore apontando para o caminho desejado
RESTORE DATABASE AdventureWorks
FROM DISK = 'E:\Andre\Databases\AdventureWorks2008.bak'
WITH MOVE 'AdventureWorks_Data' TO 'E:\Andre\Databases\AdventureWorks_Data.mdf',
MOVE 'AdventureWorks_Log' TO 'E:\Andre\Databases\AdventureWorks_Log.ldf'