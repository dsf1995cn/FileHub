

select	events.value('(event/@timestamp)[1]', 'datetime2') as [Event_Time_UTC], 
		events.value('(event/action[@name="nt_username"]/value)[1]', 'varchar(100)') as [NT_Username],
		events.value('(event/action[@name="client_hostname"]/value)[1]', 'varchar(100)') as [Client_Hostname],
		events.value('(event/action[@name="client_app_name"]/value)[1]', 'varchar(100)') as [Client_Appname]
from 

(    select event_data.query('.') as events
    from 
    (   select	cast(target_data as xml) as target_data 
        from	sys.dm_xe_session_targets xt 
        join	sys.dm_xe_sessions xs 
        on		xs.address = xt.event_session_address 
        where	xs.name = 'Logins' 
        and		xt.target_name = 'ring_buffer'
    ) as data 
     cross apply target_data.nodes ('RingBufferTarget/event') as results(event_data)   
) as tab (events)

order by [Event_Time_UTC]
