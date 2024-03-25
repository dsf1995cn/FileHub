[reflection.assembly]::LoadWithPartialName(“Microsoft.SqlServer.Smo”) | out-null
$server = New-Object “Microsoft.SqlServer.Management.Smo.Server” “(local)”
$server.ReadErrorLog() | Where-Object {$_.Text -like “Error:*”}