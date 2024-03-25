-- Create stored procedure that creates a temp table, a clustered index and populates with 10 rows
-- The script expects a database called tempdbdemo to exist
USE [tempdbdemo] ;
GO
CREATE PROCEDURE [dbo].[usp_temp_table]
AS
CREATE TABLE #tmpTable
(
c1 INT,
c2 INT,
c3 CHAR(5000)
) ;
CREATE UNIQUE CLUSTERED INDEX cix_c1 ON #tmptable ( c1 ) ;
DECLARE @i INT = 0 ;
WHILE ( @i < 10 )
BEGIN
INSERT INTO #tmpTable ( c1, c2, c3 )
VALUES ( @i, @i + 100, 'coeo' ) ;
SET @i += 1 ;
END ;
GO
-- Create stored procedure that runs usp_temp_table 50 times
CREATE PROCEDURE [dbo].[usp_loop_temp_table]
AS
SET nocount ON ;
DECLARE @i INT = 0 ;
WHILE ( @i < 100 )
BEGIN
EXEC tempdbdemo.dbo.usp_temp_table ;
SET @i += 1 ;
END ;

-- Run ostress from a cmd prompt
-- C:\"Program Files\Microsoft Corporation"\RMLUtils\ostress -Schristianvaio\NTK12 -E -Q"EXEC demo.dbo.usp_loop_temp_table;" -ooutput.txt -n300

-- Detecting tempdb allocation contention. Reproduce with permission from http://www.sqlsoldier.com/wp/sqlserver/breakingdowntempdbcontentionpart2
WITH TASKS
AS (SELECT session_id,
    wait_type,
    wait_duration_ms,
    blocking_session_id,
    resource_description,
    PageID = Cast(Right(resource_description, Len(resource_description)- Charindex(':', resource_description, 3)) As Int)
  From sys.dm_os_waiting_tasks
  Where wait_type Like 'PAGE%LATCH_%'
  And resource_description Like '2:%')
SELECT session_id,
  wait_type,
  wait_duration_ms,
  blocking_session_id,
  resource_description,
 ResourceType = Case
  When PageID = 1 Or PageID % 8088 = 0 Then 'Is PFS Page'
  When PageID = 2 Or PageID % 511232 = 0 Then 'Is GAM Page'
  When PageID = 3 Or (PageID - 1) % 511232 = 0 Then 'Is SGAM Page'
  Else 'Is Not PFS, GAM, or SGAM page'
 End
From Tasks ;

