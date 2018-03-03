CREATE FUNCTION dbo.fn_TrataMoney(@Valor VARCHAR(15))
RETURNS MONEY
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @ValorFormat MONEY;
	SET @ValorFormat = 
		CAST(
			 CASE 
				WHEN SUBSTRING(REVERSE(@Valor),1,1) = '-' THEN '-' + REPLACE(STUFF(@Valor,LEN(@Valor) - 2,0,'.'),'-','')
				WHEN SUBSTRING(REVERSE(@Valor),1,1) = '+' THEN REPLACE(STUFF(@Valor,LEN(@Valor) - 2,0,'.'),'+','')  
				ELSE STUFF(@Valor,LEN(@Valor) - 1,0,'.')
			 END AS MONEY
			 )
	RETURN (@ValorFormat)
END;