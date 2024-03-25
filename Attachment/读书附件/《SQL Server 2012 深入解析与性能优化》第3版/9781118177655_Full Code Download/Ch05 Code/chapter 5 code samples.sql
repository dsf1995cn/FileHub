select *
from person.address

dbcc show_statistics ("person.address", PK_Address_addressid)


select top 10 *
from sys.dm_os_memory_cache_entries

select type, name, count (*)
from sys.dm_os_memory_cache_entries
group by type, name
order by 3 desc

select *
from sys.dm_os_memory_cache_entries
where type = 'CACHESTORE_PHDR'

