-- Obs: Se o SQL Server for menor que 2012 e o Visual Studio for maior que 2008, tem de alterar no Project Settings o 'Target Plataform'
-- e no 'SQL CLR' alterar o 'Target Framework' para o 2.0

SELECT * FROM sys.assembly_modules

ALTER DATABASE TesteCarga SET TRUSTWORTHY ON

SP_CONFIGURE 'CLR ENABLED', 1
RECONFIGURE


DROP ASSEMBLY DeleteFile

CREATE ASSEMBLY DeleteFile
FROM 'E:\Andre\Projetos VS_2015\TesteCLR\TesteCLR\bin\Debug\TesteCLR.dll'
WITH PERMISSION_SET = EXTERNAL_ACCESS

DROP FUNCTION dbo.fn_DeletaArquivo

CREATE FUNCTION fn_DeletaArquivo(@path NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)  WITH EXECUTE AS CALLER
AS
EXTERNAL NAME DeleteFile.UserDefinedFunctions.DeletaArquivo
GO



SELECT dbo.fn_DeletaArquivo('E:\Andre\Teste.txt')
