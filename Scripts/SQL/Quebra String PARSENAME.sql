DECLARE 
	@objeto VARCHAR(100),
	@delimiter CHAR(1),
	@tamanho INT

SET @objeto = '1|andre|34|são paulo'

SET @delimiter = SUBSTRING(@objeto,PATINDEX('%[^0-9A-Z]%',@objeto),1)

SET @tamanho = LEN(@objeto) - LEN(REPLACE(@objeto,@delimiter,''))
  
IF @tamanho > 1 BEGIN
	SELECT 
		PARSENAME(REPLACE(@objeto,@delimiter,'.'),4),
		PARSENAME(REPLACE(@objeto,@delimiter,'.'),3),
		PARSENAME(REPLACE(@objeto,@delimiter,'.'),2),
		PARSENAME(REPLACE(@objeto,@delimiter,'.'),1)
END