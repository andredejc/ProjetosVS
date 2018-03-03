create table layoutArquivoNASA
(
	Inicio int,
	Largura int,
	NomeColuna varchar(30) 
)

-- INSERE A LARGURA DA COLUNA E O NOME
insert into layoutArquivoNASA(Largura,NomeColuna) values
 (1,'MODALIDADE')
,(4,'CD_CIA')
,(30,'NM_CIA')
,(3,'CD_SUCURSAL')
,(10,'NR_PROPOSTA')
,(4,'NR_ITEM')
,(1,'TP_SISTEMA')
,(2,'CD_ORIGEM')
,(4,'CD_USUARIO')
,(4,'CD_CIA_RENOVA')
,(5,'CD_SUCURSAL_RENOVA')
,(16,'NR_APOLICE_RENOVA')
,(5,'NR_ITEM_RENOVA')

-- FAZ O UPDATE DA COLUNA ONDE FICA O VALOR COM O INICIO DE CADA CAMPO COM O VALOR DA SOMA DO LARGURA E INICIO DA COLUNA ANTERIOR
DECLARE 
	 @count INT = 2
	,@Inicio INT
	,@Largura INT
DECLARE cur CURSOR FOR
SELECT 	 
	 Inicio
	,Largura	
FROM layoutArquivoNASA

OPEN cur
FETCH NEXT FROM cur INTO @inicio,@largura
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE layoutArquivoNASA
	SET Inicio = @inicio + @largura
	WHERE id = @count	
	SET @count += 1
	FETCH NEXT FROM cur INTO @inicio,@largura
END
CLOSE cur 
DEALLOCATE cur

SELECT 'SELECT '
UNION ALL
SELECT 	 	 
	 ',SUBSTRING(REPLACE(dados,'';'',''''),' + cast(Inicio as VARCHAR(10)) +','+ cast(Largura as VARCHAR(10))+') AS '+ NomeColuna	 
FROM layoutArquivoNASA
UNION ALL
SELECT 'FROM LarguraFixaNasa'