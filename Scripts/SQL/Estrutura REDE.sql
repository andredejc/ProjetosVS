

\\d5668m001e108\OPERACOES\CARTAO_BSP\ESTRUTURA_REDE


USE dbBR_PainelControle
GO

="INSERT INTO #AGENCIA VALUES('"&A2&"','"&B2&"','"&C2&"','"&D2&"','"&E2&"','"&F2&"','"&G2&"','"&H2&"','"&I2&"','"&J2&"','"&K2&"','"&L2&"','"&M2&"')"


CREATE TABLE #AGENCIA (
      COD_SUPERINT      VARCHAR(255),
      SUPERINTENDENTE   VARCHAR(255),
      EMAIL_SUPERINT    VARCHAR(255),
      COD_GECOM   VARCHAR(255),
      NOME_GECOM  VARCHAR(255),
      EMAIL_GECOM VARCHAR(255),
      SEGMTO      VARCHAR(255),
      COD_AG      VARCHAR(255),
      NOME_AGENCIA      VARCHAR(255),
      COD_GR      VARCHAR(255),
      NOME_GERENCIA     VARCHAR(255),
      COD_DR      VARCHAR(255),
      NOME_DIRETORIA    VARCHAR(255)
)

UPDATE A SET
A.nm_SupComercial = B.SUPERINTENDENTE
,A.nr_MatriculaSupComercial = B.COD_SUPERINT
,A.nr_MatriculaGerComercial = B.COD_GECOM
,A.nm_GerComercial = B.NOME_GECOM
,A.nr_JuncSeg = LEFT(B.SEGMTO,1)
,A.nm_Segmento = B.SEGMTO
,A.nr_JuncGr = B.COD_GR
,A.nm_Gerencia = B.NOME_GERENCIA
,A.nr_JuncDr = B.COD_DR
,A.nm_Diretoria = B.NOME_DIRETORIA
,A.st_Ativo = 1
FROM [tbPC_tab_Agencia] A
INNER JOIN #AGENCIA B ON CAST(B.COD_AG AS INT) = A.nr_AgJunc



UPDATE A SET nm_SupComercial = NULL, nr_MatriculaSupComercial = NULL
--SELECT *,nm_SupComercial,nr_MatriculaSupComercial
FROM [tbPC_tab_Agencia] A WHERE nm_SupComercial LIKE '%VAGO%'


UPDATE A SET nm_GerComercial = NULL, nr_MatriculaGerComercial = NULL
--SELECT *,nm_GerComercial,nr_MatriculaGerComercial
FROM [tbPC_tab_Agencia] A WHERE nm_GerComercial LIKE '%VAGO%'


UPDATE A SET nm_Gerencia = NULL, nr_JuncGr = NULL
--SELECT *,nm_Gerencia,nr_JuncGr
FROM [tbPC_tab_Agencia] A WHERE nm_Gerencia LIKE '%VAGO%'


UPDATE A SET nm_Diretoria = NULL, nr_JuncDr = NULL
--SELECT *,nm_Diretoria,nr_JuncDr
FROM [tbPC_tab_Agencia] A WHERE nm_Diretoria LIKE '%VAGO%'


SELECT nr_JuncSeg,nm_Segmento,COUNT(*) FROM [tbPC_tab_Agencia] GROUP BY nr_JuncSeg,nm_Segmento ORDER BY 1,2

SELECT nr_MatriculaSupComercial,nm_SupComercial,COUNT(*) FROM [tbPC_tab_Agencia] GROUP BY nr_MatriculaSupComercial,nm_SupComercial ORDER BY 1,2

SELECT nr_MatriculaGerComercial,nm_GerComercial,COUNT(*) FROM [tbPC_tab_Agencia] GROUP BY nr_MatriculaGerComercial,nm_GerComercial ORDER BY 1,2

SELECT nr_JuncGr,nm_Gerencia,COUNT(*) FROM [tbPC_tab_Agencia] GROUP BY nr_JuncGr,nm_Gerencia ORDER BY 1,2

SELECT nr_JuncDr,nm_Diretoria,COUNT(*) FROM [tbPC_tab_Agencia] GROUP BY nr_JuncDr,nm_Diretoria ORDER BY 1,2








