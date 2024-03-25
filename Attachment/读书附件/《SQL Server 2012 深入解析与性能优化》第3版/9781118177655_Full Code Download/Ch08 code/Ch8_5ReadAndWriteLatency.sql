-- Read and wite latency by database file 
SELECT DB_NAME(database_id) AS 'Database Name',
file_id,
io_stall_read_ms / num_of_reads AS 'Avg Read Transfer/ms',
io_stall_write_ms / num_of_writes AS 'Avg Write Transfer/ms'
FROM sys.dm_io_virtual_file_stats(-1, -1)
WHERE num_of_reads > 0
AND num_of_writes > 0 ;
GO

