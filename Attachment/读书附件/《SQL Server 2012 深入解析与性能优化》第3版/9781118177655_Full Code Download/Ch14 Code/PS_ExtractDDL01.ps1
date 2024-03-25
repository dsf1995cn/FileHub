#Helper function to script the DDL Object to disk
function Write-DDLOutput ($filename, $object)
{
    New-Item $filename -type file -force | Out-Null
    #Specify the filename
    $ScriptingOptions.FileName = $filename
    #Assign the scripting options to the Scripter
    $Scripter.Options = $ScriptingOptions
    #Script the index
    $Scripter.Script($object)
}

#Load the SMO assembly
[reflection.assembly]::LoadWithPartialName(“Microsoft.SqlServer.Smo”) | out-null

#Create all the global vars we need
$Server = New-Object (“Microsoft.SqlServer.Management.Smo.Server”)
$Scripter = New-Object (“Microsoft.SqlServer.Management.Smo.Scripter”)
$ScriptingOptions = New-Object (“Microsoft.SqlServer.Management.SMO.ScriptingOptions”)
$Scripter.Server = $Server
#Specifies the root folder that we’ll store the Scripts into This will probably become a param in future
$RootBackupFolder = “C:\SqlBackups\DDL”
#Get the day of the week so that we can create a folder for each day
$Today = [System.DateTime]::Today.DayOfWeek
#Store today’s backup folder
$DDLBackupFolder = Join-Path -Path $RootBackupFolder -ChildPath $Today

#Check if today’s folder exists
if ([System.IO.Directory]::Exists($DDLBackupFolder))
{
    #If it does delete it’s contents
    Remove-Item (Join-Path -Path $DDLBackupFolder -ChildPath *) -Recurse
}
else
{
    #Otherwise create it
    [System.IO.Directory]::CreateDirectory($DDLBackupFolder) | Out-Null
}

#Setup the scripting options
$ScriptingOptions.AppendToFile = $true
$ScriptingOptions.FileName = $filename
$ScriptingOptions.ToFileOnly = $true
$ScriptingOptions.ScriptData = $false

#Loop through all the databases to script them out
foreach ($database in ($Server.databases | where {$_.IsSystemObject -eq $false -and $_.IsDatabaseSnapshot -eq $false}))
{
    $databaseBackupFolder = Join-Path -Path $DDLBackupFolder -ChildPath $Database.Name
    #This will be the database create script
    Write-DDLOutput (Join-Path -Path ($databaseBackupFolder) -ChildPath ($Database.Name + “.sql”)) $database
    $ProgrammabilityBackupFolder = Join-Path -Path $databaseBackupFolder -ChildPath “Programmability”
    $DefaultsBackupFolder = Join-Path -Path $ProgrammabilityBackupFolder -ChildPath “Defaults”

    foreach ($default in $database.Defaults)
    {
        #Generate a filename for the default
        Write-DDLOutput (Join-Path -Path ($DefaultsBackupFolder) -ChildPath ($default.Schema + “.” + $default.Name + “.sql”)) $default
    }

    #Create a folders to store the functions in
    $FunctionsBackupFolder = Join-Path -Path $ProgrammabilityBackupFolder -ChildPath “Functions”
    $ScalarFunctionsBackupFolder = Join-Path -Path $FunctionsBackupFolder -ChildPath “Scalar-valued Functions”
    $TableValuedFunctionsBackupFolder = Join-Path -Path $FunctionsBackupFolder -ChildPath “Table-valued Functions”

    foreach ($function in $database.UserDefinedFunctions | where {$_.IsSystemObject -eq $false})
    {
        #script the functions into folders depending upon type. We’re only interested in scalar and table
        switch ($function.FunctionType)
        {
            scalar
            {
                #Generate a filename for the scalar function
                $filename = Join-Path -Path ($ScalarFunctionsBackupFolder) -ChildPath ($function.Schema + “.” + $function.Name + “.sql”)
            }
            table
            {
                #Generate a filename for the table value function
                $filename = Join-Path -Path ($TableValuedFunctionsBackupFolder) -ChildPath ($function.Schema + “.” + $function.Name + “.sql”)
            }
            default { continue }
        }

        #Script the function
        Write-DDLOutput $filename $function
    }

    $RulesBackupFolder = Join-Path -Path $ProgrammabilityBackupFolder -ChildPath “Rules”
    
    foreach ($rule in $database.Rules)
    {
        #Script the rule
        Write-DDLOutput (Join-Path -Path ($RulesBackupFolder) -ChildPath ($rule.Schema + “.” + $rule.Name + “.sql”)) $rule
    }

    #Create a folder to store the Sprocs in
    $StoredProceduresBackupFolder = Join-Path -Path $ProgrammabilityBackupFolder -ChildPath “Stored Procedures”
    #Loop through the sprocs to script them out
    foreach ($storedProcedure in $database.StoredProcedures | where {$_.IsSystemObject -eq $false})
    {
        #script the sproc
        Write-DDLOutput ($filename = Join-Path -Path ($StoredProceduresBackupFolder) -ChildPath ($storedProcedure.Schema + “.” + $storedProcedure.Name + “.sql”)) $storedProcedure
    }
    
    #Create a folder to store the table scripts
    $TablesBackupFolder = Join-Path -Path $databaseBackupFolder -ChildPath “Tables”
    $TableIndexesBackupFolder = Join-Path -Path $TablesBackupFolder -ChildPath “Indexes”
    $TableKeysBackupFolder = Join-Path -Path $TablesBackupFolder -ChildPath “Keys”
    $TableConstraintsBackupFolder = Join-Path -Path $TablesBackupFolder -ChildPath “Constraints”
    $TableTriggersBackupFolder = Join-Path -Path $TablesBackupFolder -ChildPath “Triggers”

    #Loop through the tables to script them out
    foreach ($table in $database.Tables | where {$_.IsSystemObject -eq $false})
    {
        #Script the Table
        Write-DDLOutput (Join-Path -Path ($TablesBackupFolder) -ChildPath ($table.Schema + “.” + $table.Name + “.sql”)) $table

        foreach($Constraint in $table.Checks)
        {
            #Script the Constraint
            Write-DDLOutput (Join-Path -Path ($TableConstraintsBackupFolder) -ChildPath ($table.Schema + “.” + $table.Name + “.” + $Constraint.Name + “.sql”)) $Constraint
        }

        foreach ($index in $table.Indexes)
        {
            #Generate a filename for the table
            switch($index.IndexKeyType)
            {
                DriPrimaryKey
                {
                    $filename = Join-Path -Path ($TableKeysBackupFolder) -ChildPath ($table.Schema + “.” + $table.Name + “.” + $index.Name + “.sql”)
                }
                default
                {
                    $filename = Join-Path -Path ($TableIndexesBackupFolder) -ChildPath ($table.Schema + “.” + $table.Name + “.” + $index.Name + “.sql”)
                }
            }

            #Script the index
            Write-DDLOutput $filename $index
        }

        foreach ($trigger in $table.Triggers)
        {
            #Script the trigger
            Write-DDLOutput (Join-Path -Path ($TableTriggersBackupFolder) -ChildPath ($table.Schema + “.” + $table.Name + “.” + $trigger.Name + “.sql”)) $trigger
        }
    }

    #Create a folder to store the view scripts
    $ViewsBackupFolder = Join-Path -Path $databaseBackupFolder -ChildPath “Views”
    $ViewKeysBackupFolder = Join-Path -Path $ViewsBackupFolder -ChildPath “Keys”
    $ViewIndexesBackupFolder = Join-Path -Path $ViewsBackupFolder -ChildPath “Indexes”
    $ViewTriggersBackupFolder = Join-Path -Path $ViewsBackupFolder -ChildPath “Triggers”

    #Loop through the views to script them out
    foreach ($view in $database.Views | where {$_.IsSystemObject -eq $false})
    {
        #Script the view
        Write-DDLOutput (Join-Path -Path ($ViewsBackupFolder) -ChildPath ($view.Schema + “.” + $view.Name + “.sql”)) $view
        
        foreach ($index in $view.Indexes)
        {
            #Generate a filename for the table
            switch($index.IndexKeyType)
            {
                DriPrimaryKey
                {
                    $filename = Join-Path -Path ($ViewKeysBackupFolder) -ChildPath ($view.Schema + “.” + $view.Name + “.” + $index.Name + “.sql”)
                }
                default
                {
                    $filename = Join-Path -Path ($ViewIndexesBackupFolder) -ChildPath ($view.Schema + “.” + $view.Name + “.” + $index.Name + “.sql”)
                }
            }

            Write-DDLOutput $filename $index
        }

        foreach ($trigger in $view.Triggers)
        {
            #Script the trigger
            Write-DDLOutput (Join-Path -Path ($ViewTriggersBackupFolder) -ChildPath ($view.Schema + “.” + $view.Name + “.” + $trigger.Name + “.sql”)) $trigger
        }
    }
}