-- Table variable statistics
DECLARE @TableVar TABLE ( c1 INT ) ;
INSERT INTO @TableVar
SELECT TOP 1000000 row_number( ) OVER ( ORDER BY t1.number ) AS N
FROM master..spt_values t1
CROSS JOIN master..spt_values t2 ;
SELECT COUNT(*)
FROM @TableVar ;
GO

-- Temporary table
CREATE TABLE #TempTable ( c1 INT ) ;
INSERT INTO #TempTable
SELECT TOP 1000000 row_number( ) OVER ( ORDER BY t1.number ) AS N
FROM master..spt_values t1
CROSS JOIN master..spt_values t2 ;
SELECT COUNT(*)
FROM #TempTable ;
GO

-- Tables variables are not create in memory
SELECT session_id,
database_id,
user_objects_alloc_page_count
FROM sys.dm_db_session_space_usage
WHERE session_id > 50 ;
GO

CREATE TABLE #TempTable ( ID INT ) ;
INSERT INTO #TempTable ( ID )
VALUES ( 1 ) ;
GO
SELECT session_id,
database_id,
user_objects_alloc_page_count
FROM sys.dm_db_session_space_usage
WHERE session_id > 50 ;
GO

DECLARE @TempTable TABLE ( ID INT ) ;
INSERT INTO @TempTable ( ID )
VALUES ( 1 ) ;
GO
SELECT session_id,
database_id,
user_objects_alloc_page_count
FROM sys.dm_db_session_space_usage
WHERE session_id > 50 ;
GO