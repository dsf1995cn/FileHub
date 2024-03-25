$wmiBootTime = (get-wmiobject Win32_OperatingSystem).lastbootuptime;
[DateTime]$lastBootUpTime = [Management.ManagementDateTimeConverter]::ToDateTime($wmiBootTime);
$uptime = (Get-Date) - $lastBootUpTime;
Write-Host $lastBootUpTime;
Write-Host $uptime;