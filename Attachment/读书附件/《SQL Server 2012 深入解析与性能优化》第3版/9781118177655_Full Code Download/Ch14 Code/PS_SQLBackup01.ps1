Import-Module SQLPS

$ComputerName = HostName

#Assuming localmachin and default instance. Change if necessary
cd "SQLSERVER:\SQL\$ComputerName\DEFAULT\DATABASES"

foreach($database in (Get-ChildItem))
{
	$dbName = $database.Name
	$timeStamp = Get-Date -FORMAT yyyyMMddHHmmss
	$backupFolder = “c:\backups\$dbName”
	
	if((Test-Path $backupFolder) -eq $False)
	{
		New-Item -type directory -path $backupFolder
	}
	
	Backup-SqlDatabase -Database $dbName -BackupFile “$backupFolder\$dbName-$timeStamp.bak”
}