USE [TesteCarga]
GO
/****** Object:  StoredProcedure [dbo].[sp_LimpaTabelaDinamica]    Script Date: 02/01/2016 09:52:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_ins_tmp_Att2]
AS
DECLARE 
	@str VARCHAR(MAX) = 'INSERT INTO tmp_Att2(',
	@str2 VARCHAR(MAX) = 'SELECT ',
	@count INT = 1,
	@comando VARCHAR(MAX)
	
BEGIN	

	WHILE @count <= 129
	BEGIN
		SET @str = @str+'Coluna'+CAST(@count AS VARCHAR(30))+','
		SET @str2 = @str2 +'ISNULL(Coluna'+CAST(@count AS VARCHAR(30))+','''')'+','
		SET @count = @count + 1
	END	
	SET @comando = (SELECT SUBSTRING(@str,1,LEN(@str)-1)+')') + (SELECT SUBSTRING(@str2,1,LEN(@str2)-1)+' FROM tmp_Att1')
	SELECT @comando

	EXEC (@comando);

END

DROP PROC [sp_ins_tmp_Att2]













