-- Local temporary table
CREATE TABLE #TempTable ( ID INT, NAME CHAR(3) ) ;
INSERT  INTO #TempTable ( ID, NAME )
VALUES  ( 1, 'abc' ) ;
GO
SELECT  *
FROM    #TempTable ;
GO
DROP TABLE #TempTable ;
GO

-- Global temporary table
CREATE TABLE ##TempTable ( ID INT, NAME CHAR(3) ) ;
INSERT INTO ##TempTable ( ID, NAME )
VALUES ( 1, 'abc' ) ;
GO
SELECT *
FROM ##TempTable ;
GO
DROP TABLE ##TempTable ;

-- Table variable
DECLARE @TempTable TABLE ( ID INT, NAME CHAR(3) ) ;
INSERT INTO @TempTable ( ID, NAME )
VALUES ( 1, 'abc' ) ;
SELECT *
FROM @TempTable ;

