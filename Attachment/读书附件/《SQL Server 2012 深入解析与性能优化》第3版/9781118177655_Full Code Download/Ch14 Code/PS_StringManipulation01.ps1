$Statement = “PowerShell Rocks”
$Statement.SubString($Statement.IndexOf(“ “) + 1, $Statement.Length - $Statement.IndexOf(“ “) - 1)