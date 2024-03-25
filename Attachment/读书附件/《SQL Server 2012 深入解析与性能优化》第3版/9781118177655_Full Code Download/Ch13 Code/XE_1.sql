
--event/data[@name="statement"]/value)[1]




select	event_data.value('(event/@timestamp)[1]', 'datetime2') as [Event_Time_UTC], 
		event_data.value('(event/action[@name="nt_username"]/value)[1]', 'varchar(100)') as [NT_Username],
		event_data.value('(event/action[@name="client_hostname"]/value)[1]', 'varchar(100)') as [Client_Hostname],
		event_data.value('(event/action[@name="client_app_name"]/value)[1]', 'varchar(100)') as [Client_Appname]

from    (	select cast(event_data as xml)
			from sys.fn_xe_file_target_read_file('C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\Log\Logins_0_129805987593580000.xel', null, null, null)
		 ) as results(event_data)
order by [Event_Time_UTC]
		 



/*
		 SELECT     xdata.value('(/event/data[4]/value)[1]', 'varchar(100)') AS [error],     
					xdata.value('(/event/data[@name="severity"]/value)[1]', 'int') AS [severity],
					xdata.value('(/event/action[@name="sql_text"]/value)[1]', 'varchar(max)') AS [sql_text]       FROM         (             select CAST(event_data as XML)             from sys.fn_xe_file_target_read_file             (             'C:\temp\ArithmeticErrors_0_128981071730370000.xet',              'C:\temp\ArithmeticErrors_0_128981071730390000.xem',              null,              null             )         ) as xmlr(xdata)


					*/