function Manage-Fragmentation ($ServerName, $TargetDatabaseName)
{
    #[string] $ServerName = $args[0]
    #[string] $TargetDatabaseName = $args[1]
    [Reflection.Assembly]::LoadWithPartialName(“Microsoft.SqlServer.Smo”) | out-null
    $server = New-Object Microsoft.SqlServer.Management.Smo.Server $ServerName
    $targetDB = $server.Databases[$targetDatabaseName]

    foreach ($table in $targetDB.Tables)
    {
        foreach($index in $table.Indexes)
        {
            $fragmentation = $index.EnumFragmentation()
            $averageFragmentation = $fragmentation.Rows[0].AverageFragmentation
        
            if($averageFragmentation -lt .05)
            {
                continue
            }
        
            if($averageFragmentation -ge .05 -and $averageFragmentation -lt .3)
            {
                $index.Reorganize()
                continue
            }
        
            $index.Rebuild()
        }
    }
}