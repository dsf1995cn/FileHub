-- Add new tempdb data files
ALTER DATABASE tempdb
MODIFY FILE (name=tempdev,size=512MB) ;
GO
ALTER DATABASE tempdb
ADD FILE (name=tempdev2,size=512MB,filename='D:\data\tempdev2.ndf') ;
GO
ALTER DATABASE tempdb
ADD FILE (name=tempdev3,size=512MB,filename='D:\data\tempdev3.ndf') ;
GO
ALTER DATABASE tempdb
ADD FILE (name=tempdev4,size=512MB,filename='D:\data\tempdev4.ndf') ;


-- Checking for temporary object cachiing
SET NOCOUNT ON ;
GO
DECLARE @table_counter_before_test BIGINT ;
SELECT  @table_counter_before_test = cntr_value
FROM    sys.dm_os_performance_counters
WHERE counter_name = 'Temp Tables Creation Rate' ;
DECLARE @i INT = 0 ;
WHILE ( @i < 10 )
    BEGIN
        EXEC tempdbdemo.dbo.usp_loop_temp_table ;
        SELECT @i += 1 ;
    END ;
DECLARE @table_counter_after_test BIGINT ;
SELECT  @table_counter_after_test = cntr_value
FROM    sys.dm_os_performance_counters
WHERE   counter_name = 'Temp Tables Creation Rate' ;
PRINT 'Temp tables created during the test: '
+ CONVERT(VARCHAR(100), @table_counter_after_test
- @table_counter_before_test) ;


-- Modifed sp to use object caching
USE [tempdbdemo] ;
GO
CREATE PROCEDURE [dbo].[usp_temp_table]
AS
CREATE TABLE #tmpTable
(
c1 INT UNIQUE CLUSTERED,
c2 INT,
c3 CHAR(5000)
) ;
--CREATE UNIQUE CLUSTERED INDEX cix_c1 ON #tmptable ( c1 ) ;
DECLARE @i INT = 0 ;
WHILE ( @i < 10 )
BEGIN
INSERT INTO #tmpTable ( c1, c2, c3 )
VALUES ( @i, @i + 100, 'coeo' ) ;
SET @i += 1 ;
END ;
GO

