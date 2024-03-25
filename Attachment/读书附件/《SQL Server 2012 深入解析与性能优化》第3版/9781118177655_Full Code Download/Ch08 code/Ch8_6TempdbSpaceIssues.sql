-- Tempdb space usage by file
SELECT SUM(total_page_count)*8/1024 AS 'tempdb size (MB)',
       SUM(total_page_count) AS 'tempdb pages',
       SUM(allocated_extent_page_count) AS 'in use pages',
       SUM(user_object_reserved_page_count) AS 'user object pages',
       SUM(internal_object_reserved_page_count) AS 'internal object pages',
       SUM(mixed_extent_page_count) AS 'Total Mixed Extent Pages'
FROM   sys.dm_db_file_space_usage ;
GO

-- Tempdb space usage by task
SELECT TOP 5 *
FROM sys.dm_db_task_space_usage
WHERE session_id > 50
ORDER BY user_objects_alloc_page_count + internal_objects_alloc_page_count ;
GO

-- Tempdb space by session
SELECT *
FROM sys.dm_db_session_space_usage
WHERE session_id > 50
ORDER BY user_objects_alloc_page_count + internal_objects_alloc_page_count DESC ;
GO