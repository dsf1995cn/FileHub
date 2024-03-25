[reflection.assembly]::LoadWithPartialName(“Microsoft.SqlServer.Smo”) | out-null
$server = New-Object “Microsoft.SqlServer.Management.Smo.Server” “(local)”
$server.jobserver.jobs | where-object {$_.lastrunoutcome -eq “Failed” -and
$_.isenabled -eq $TRUE}