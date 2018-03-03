USE [dbGS_GSC] -- CRIADO
GO

/****** Object:  StoredProcedure [dbo].[sp_ins_tbGS_tmp_Attrition02]    Script Date: 02/03/2016 17:16:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ins_tbGS_tmp_Attrition02]
AS
BEGIN
	DELETE 
	FROM tbGS_tmp_Attrition01
	WHERE COLUNA1 IS NULL
	AND COLUNA2 IS NULL
	AND COLUNA3 IS NULL
	AND COLUNA4 IS NULL
	AND COLUNA5 IS NULL
END	

BEGIN
	DELETE
	FROM tbGS_tmp_Attrition01
	WHERE COLUNA1 LIKE '% - %'
	AND COLUNA2 IS NULL
	AND COLUNA3 IS NULL
	AND COLUNA4 IS NULL
	AND COLUNA5 IS NULL
END

BEGIN
	INSERT INTO tbGS_tmp_Attrition02(
	   [Coluna1]
      ,[Coluna2]
      ,[Coluna3]
      ,[Coluna4]
      ,[Coluna5]
      ,[Coluna6]
      ,[Coluna7]
      ,[Coluna8]
      ,[Coluna9]
      ,[Coluna10]
      ,[Coluna11]
      ,[Coluna12]
      ,[Coluna13]
      ,[Coluna14]
      ,[Coluna15]
      ,[Coluna16]
      ,[Coluna17]
      ,[Coluna18]
      ,[Coluna19]
      ,[Coluna20]
      ,[Coluna21]
      ,[Coluna22]
      ,[Coluna23]
      ,[Coluna24]
      ,[Coluna25]
      ,[Coluna26]
      ,[Coluna27]
      ,[Coluna28]
      ,[Coluna29]
      ,[Coluna30]
      ,[Coluna31]
      ,[Coluna32]
      ,[Coluna33]
      ,[Coluna34]
      ,[Coluna35]
      ,[Coluna36]
      ,[Coluna37]
      ,[Coluna38]
      ,[Coluna39]
      ,[Coluna40]
      ,[Coluna41]
      ,[Coluna42]
      ,[Coluna43]
      ,[Coluna44]
      ,[Coluna45]
      ,[Coluna46]
      ,[Coluna47]
      ,[Coluna48]
      ,[Coluna49]
      ,[Coluna50]
      ,[Coluna51]
      ,[Coluna52]
      ,[Coluna53]
      ,[Coluna54]
      ,[Coluna55]
      ,[Coluna56]
      ,[Coluna57]
      ,[Coluna58]
      ,[Coluna59]
      ,[Coluna60]
      ,[Coluna61]
      ,[Coluna62]
      ,[Coluna63]
      ,[Coluna64]
      ,[Coluna65]
      ,[Coluna66]
      ,[Coluna67]
      ,[Coluna68]
      ,[Coluna69]
      ,[Coluna70]
      ,[Coluna71]
      ,[Coluna72]
      ,[Coluna73]
      ,[Coluna74]
      ,[Coluna75]
      ,[Coluna76]
      ,[Coluna77]
      ,[Coluna78]
      ,[Coluna79]
      ,[Coluna80]
      ,[Coluna81]
      ,[Coluna82]
      ,[Coluna83]
      ,[Coluna84]
      ,[Coluna85]
      ,[Coluna86]
      ,[Coluna87]
      ,[Coluna88]
      ,[Coluna89]
      ,[Coluna90]
      ,[Coluna91]
      ,[Coluna92]
      ,[Coluna93]
      ,[Coluna94]
      ,[Coluna95]
      ,[Coluna96]
      ,[Coluna97]
      ,[Coluna98]
      ,[Coluna99]
      ,[Coluna100]
      ,[Coluna101]
      ,[Coluna102]
      ,[Coluna103]
      ,[Coluna104]
      ,[Coluna105]
      ,[Coluna106]
      ,[Coluna107]
      ,[Coluna108]
      ,[Coluna109]
      ,[Coluna110]
      ,[Coluna111]
      ,[Coluna112]
      ,[Coluna113]
      ,[Coluna114]
      ,[Coluna115]
      ,[Coluna116]
      ,[Coluna117]
      ,[Coluna118]
      ,[Coluna119]
      ,[Coluna120]
      ,[Coluna121]
      ,[Coluna122]
      ,[Coluna123]
      ,[Coluna124]
      ,[Coluna125]
      ,[Coluna126]
      ,[Coluna127]
      ,[Coluna128]
      ,[Coluna129]      

)SELECT
	   ISNULL(Coluna1,'')	--,[ds_TipoSeg]  
      ,ISNULL(Coluna2,'0') -- [qt_QtdeTotalSolicitacaoCancel]
      ,ISNULL(Coluna3,'0') -- [qt_TotalPremio_1]
      ,ISNULL(Coluna4,'0') -- [qt_QtdeTotalCancel]
      ,ISNULL(Coluna5,'0') -- [qt_TotalPremio_2]
      ,ISNULL(Coluna6,'0')
      ,ISNULL(Coluna7,'0')
      ,ISNULL(Coluna8,'0')
      ,ISNULL(Coluna9,'0')
      ,ISNULL(Coluna10,'0')
      ,ISNULL(Coluna11,'0')
      ,ISNULL(Coluna12,'0')
      ,ISNULL(Coluna13,'0')
      ,ISNULL(Coluna14,'0')
      ,ISNULL(Coluna15,'0')
      ,ISNULL(Coluna16,'0')
      ,ISNULL(Coluna17,'0')
      ,ISNULL(Coluna18,'0')
      ,ISNULL(Coluna19,'0')
      ,ISNULL(Coluna20,'0')
      ,ISNULL(Coluna21,'0')
      ,ISNULL(Coluna22,'0')
      ,ISNULL(Coluna23,'0')
      ,ISNULL(Coluna24,'0')
      ,ISNULL(Coluna25,'0')
      ,ISNULL(Coluna26,'0')
      ,ISNULL(Coluna27,'0')
      ,ISNULL(Coluna28,'0')
      ,ISNULL(Coluna29,'0')
      ,ISNULL(Coluna30,'0')
      ,ISNULL(Coluna31,'0')
      ,ISNULL(Coluna32,'0')
      ,ISNULL(Coluna33,'0')
      ,ISNULL(Coluna34,'0')
      ,ISNULL(Coluna35,'0')
      ,ISNULL(Coluna36,'0')
      ,ISNULL(Coluna37,'0')
      ,ISNULL(Coluna38,'0')
      ,ISNULL(Coluna39,'0')
      ,ISNULL(Coluna40,'0')
      ,ISNULL(Coluna41,'0')
      ,ISNULL(Coluna42,'0')
      ,ISNULL(Coluna43,'0')
      ,ISNULL(Coluna44,'0')
      ,ISNULL(Coluna45,'0')
      ,ISNULL(Coluna46,'0')
      ,ISNULL(Coluna47,'0')
      ,ISNULL(Coluna48,'0')
      ,ISNULL(Coluna49,'0')
      ,ISNULL(Coluna50,'0')
      ,ISNULL(Coluna51,'0')
      ,ISNULL(Coluna52,'0')
      ,ISNULL(Coluna53,'0')
      ,ISNULL(Coluna54,'0')
      ,ISNULL(Coluna55,'0')
      ,ISNULL(Coluna56,'0')
      ,ISNULL(Coluna57,'0')
      ,ISNULL(Coluna58,'0')
      ,ISNULL(Coluna59,'0')
      ,ISNULL(Coluna60,'0')
      ,ISNULL(Coluna61,'0')
      ,ISNULL(Coluna62,'0')
      ,ISNULL(Coluna63,'0')
      ,ISNULL(Coluna64,'0')
      ,ISNULL(Coluna65,'0')
      ,ISNULL(Coluna66,'0')
      ,ISNULL(Coluna67,'0')
      ,ISNULL(Coluna68,'0')
      ,ISNULL(Coluna69,'0')
      ,ISNULL(Coluna70,'0')
      ,ISNULL(Coluna71,'0')
      ,ISNULL(Coluna72,'0')
      ,ISNULL(Coluna73,'0')
      ,ISNULL(Coluna74,'0')
      ,ISNULL(Coluna75,'0')
      ,ISNULL(Coluna76,'0')
      ,ISNULL(Coluna77,'0')
      ,ISNULL(Coluna78,'0')
      ,ISNULL(Coluna79,'0')
      ,ISNULL(Coluna80,'0')
      ,ISNULL(Coluna81,'0')
      ,ISNULL(Coluna82,'0')
      ,ISNULL(Coluna83,'0')
      ,ISNULL(Coluna84,'0')
      ,ISNULL(Coluna85,'0')
      ,ISNULL(Coluna86,'0')
      ,ISNULL(Coluna87,'0')
      ,ISNULL(Coluna88,'0')
      ,ISNULL(Coluna89,'0')
      ,ISNULL(Coluna90,'0')
      ,ISNULL(Coluna91,'0')
      ,ISNULL(Coluna92,'0')
      ,ISNULL(Coluna93,'0')
      ,ISNULL(Coluna94,'0')
      ,ISNULL(Coluna95,'0')
      ,ISNULL(Coluna96,'0')
      ,ISNULL(Coluna97,'0')
      ,ISNULL(Coluna98,'0')
      ,ISNULL(Coluna99,'0')
      ,ISNULL(Coluna100,'0')
      ,ISNULL(Coluna101,'0')
      ,ISNULL(Coluna102,'0')
      ,ISNULL(Coluna103,'0')
      ,ISNULL(Coluna104,'0')
      ,ISNULL(Coluna105,'0')
      ,ISNULL(Coluna106,'0')
      ,ISNULL(Coluna107,'0')
      ,ISNULL(Coluna108,'0')
      ,ISNULL(Coluna109,'0')
      ,ISNULL(Coluna110,'0')
      ,ISNULL(Coluna111,'0')
      ,ISNULL(Coluna112,'0')
      ,ISNULL(Coluna113,'0')
      ,ISNULL(Coluna114,'0')
      ,ISNULL(Coluna115,'0')
      ,ISNULL(Coluna116,'0')
      ,ISNULL(Coluna117,'0')
      ,ISNULL(Coluna118,'0')
      ,ISNULL(Coluna119,'0')
      ,ISNULL(Coluna120,'0')
      ,ISNULL(Coluna121,'0')
      ,ISNULL(Coluna122,'0')
      ,ISNULL(Coluna123,'0')
      ,ISNULL(Coluna124,'0')
      ,ISNULL(Coluna125,'0')
      ,ISNULL(Coluna126,'0')
      ,ISNULL(Coluna127,'0')
      ,ISNULL(Coluna128,'0')
      ,ISNULL(Coluna129,'0')      
	FROM dbo.tbGS_tmp_Attrition01  
END
GO
