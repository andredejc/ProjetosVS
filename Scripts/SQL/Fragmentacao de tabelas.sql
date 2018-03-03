CREATE TABLE [dbo].[Hitorico_Fragmentacao_Indice](
[Id_Hitorico_Fragmentacao_Indice] [int] IDENTITY(1,1) NOT NULL,
[Dt_Referencia] [datetime] NULL,
[Nm_Servidor] [varchar](20) NULL,
[Nm_Database] [varchar](20) NULL,
[Nm_Tabela] [varchar](50) NULL,
[Nm_Indice] [varchar](70) NULL,
[Avg_Fragmentation_In_Percent] [numeric](5, 2) NULL,
[Page_Count] [int] NULL,
[Fill_Factor] [tinyint] NULL)

TRUNCATE TABLE Hitorico_Fragmentacao_Indice

INSERT INTO Hitorico_Fragmentacao_Indice(Dt_Referencia,Nm_Servidor,Nm_Database,Nm_Tabela,Nm_Indice,Avg_Fragmentation_In_Percent,
Page_Count,Fill_Factor)
SELECT getdate(), @@servername,  db_name(db_id()), object_name(B.Object_id), B.Name,  avg_fragmentation_in_percent,page_Count,fill_factor
FROM sys.dm_db_index_physical_stats(db_id(),null,null,null,null) A
join sys.indexes B on a.object_id = B.Object_id and A.index_id = B.index_id
ORDER BY object_name(B.Object_id), B.index_id

declare @Dt_Referencia datetime
set @Dt_Referencia = cast(floor(cast( getdate() as float)) as datetime)

SELECT Nm_Servidor, Nm_Database, Nm_Tabela, Nm_Indice, Avg_Fragmentation_In_Percent, Page_Count, Fill_Factor
FROM Hitorico_Fragmentacao_Indice (nolock)
WHERE Avg_Fragmentation_In_Percent > 5
AND page_count > 1000   -- Eliminar índices pequenos
AND Dt_Referencia >= @Dt_Referencia

ALTER INDEX ALL ON tbGS_hst_RICMM REBUILD



SELECT object_name(IPS.object_id) AS [TableName], 
   SI.name AS [IndexName], 
   IPS.Index_type_desc, 
   ROUND(IPS.avg_fragmentation_in_percent,2) AS [avg_fragmentation_in_percent], 
   ROUND(IPS.avg_fragment_size_in_pages,2) AS [avg_fragment_size_in_pages], 
   ROUND(IPS.avg_page_space_used_in_percent,2) AS [avg_page_space_used_in_percent], 
   IPS.record_count, 
   IPS.ghost_record_count,
   IPS.fragment_count, 
   IPS.avg_fragment_size_in_pages
FROM sys.dm_db_index_physical_stats(db_id(N'AdventureWorks'), NULL, NULL, NULL , 'DETAILED') IPS
   JOIN sys.tables ST WITH (nolock) ON IPS.object_id = ST.object_id
   JOIN sys.indexes SI WITH (nolock) ON IPS.object_id = SI.object_id AND IPS.index_id = SI.index_id
WHERE ST.is_ms_shipped = 0
AND ROUND(IPS.avg_fragmentation_in_percent,2) > 5
ORDER BY 1,5
GO


ALTER INDEX ALL ON tbGS_hst_RICMM
REORGANIZE
GO

use dbGS_GSC
GO
DECLARE @TableName VARCHAR(255)f
DECLARE @sql NVARCHAR(500)
DECLARE @fillfactor INT
SET @fillfactor = 80
DECLARE TableCursor CURSOR FOR
SELECT OBJECT_SCHEMA_NAME([object_id])+'.'+name AS TableName
FROM sys.tables
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
SET @sql = 'ALTER INDEX ALL ON ' + @TableName +' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')'
EXEC (@sql)
FETCH NEXT FROM TableCursor INTO @TableName
END
CLOSE TableCursor
DEALLOCATE TableCursor
GO
