USE TesteCarga;
GO

IF OBJECTPROPERTY(OBJECT_ID('dbo.sp_InsertArquivo'), N'IsProcedure') = 1
DROP PROCEDURE dbo.sp_InsertArquivo
GO

CREATE PROCEDURE sp_InsertArquivo(@path VARCHAR(200) = NULL)
AS

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
	SET DATEFORMAT YMD          
	SET LANGUAGE us_english          
	SET CONCAT_NULL_YIELDS_NULL OFF          
	SET NOCOUNT ON  	

BEGIN

	TRUNCATE TABLE tmp_Layout_vendas;
	TRUNCATE TABLE tbPC_tmpTeste_Layoutvendas02;

	DECLARE	@sql VARCHAR(MAX)

	SET @sql =  'BULK INSERT tmp_Layout_vendas 
				 FROM '''+@path+'''
				 WITH 
				 (
					FIRSTROW=1, 		
					ROWTERMINATOR = ''\n''
				 )'	
	EXECUTE (@sql);
	
	INSERT INTO tbPC_tmpTeste_Layoutvendas02
	SELECT
		 SUBSTRING(dados,	1	,2	)
		,SUBSTRING(dados,	3	,15	)
		,SUBSTRING(dados,	18	,14	)
		,SUBSTRING(dados,	32	,50	)
		,SUBSTRING(dados,	82	,4	)
		,SUBSTRING(dados,	86	,8	)
		,SUBSTRING(dados,	94	,50	)
		,SUBSTRING(dados,	144	,15	)
		,SUBSTRING(dados,	159	,15	)
		,SUBSTRING(dados,	174	,2	)
		,SUBSTRING(dados,	176	,4	)
		,SUBSTRING(dados,	180	,10	)
		,SUBSTRING(dados,	190	,10	)
		,SUBSTRING(dados,	200	,4	)
		,SUBSTRING(dados,	204	,10	)
		,SUBSTRING(dados,	214	,100)
		,SUBSTRING(dados,	314	,10	)
		,SUBSTRING(dados,	324	,1	)
		,SUBSTRING(dados,	325	,11	)
		,SUBSTRING(dados,	336	,10	)
		,SUBSTRING(dados,	346	,10	)
		,SUBSTRING(dados,	356	,10	)
		,SUBSTRING(dados,	366	,100)
		,SUBSTRING(dados,	466	,10	)
		,SUBSTRING(dados,	476	,30	)
		,SUBSTRING(dados,	506	,8	)
		,SUBSTRING(dados,	514	,70	)
		,SUBSTRING(dados,	584	,50	)
		,SUBSTRING(dados,	634	,2	)
		,SUBSTRING(dados,	636	,3	)
		,SUBSTRING(dados,	639	,10	)
		,SUBSTRING(dados,	649	,3	)
		,SUBSTRING(dados,	652	,10	)
		,SUBSTRING(dados,	662	,5	)
		,SUBSTRING(dados,	667	,50	)
		,SUBSTRING(dados,	717	,30	)
		,SUBSTRING(dados,	747	,7	)
		,SUBSTRING(dados,	754	,10	)
		,SUBSTRING(dados,	764	,24	)
		,SUBSTRING(dados,	788	,24	)
		,SUBSTRING(dados,	812	,24	)
		,SUBSTRING(dados,	836	,24	)
		,SUBSTRING(dados,	860	,7	)
		,SUBSTRING(dados,	867	,50	)
		,SUBSTRING(dados,	917	,20	)
		,SUBSTRING(dados,	937	,19	)
		,SUBSTRING(dados,	956	,1	)
		,SUBSTRING(dados,	957	,1	)
		,SUBSTRING(dados,	958	,43	)
	FROM tmp_Layout_vendas;	
END	


-- EXECUTE dbo.sp_InsertArquivo @path = 'C:\Users\M135038\Desktop\Solicitacao Maucio\Enriquecimento_Endereços.txt' 