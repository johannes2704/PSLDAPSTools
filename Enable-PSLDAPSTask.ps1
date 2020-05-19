param(
    $ComputerName = "$env:COMPUTERNAME.$env:UserDNSDomain,test"
)

$actions = @()

Foreach ($Computer in $ComputerName){
    $argument = "-Command `"& 'C:\LDAP\Get-InsecureBinds.ps1' -p1 '$($Computer)' `""
    $actions += New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument $argument
}

$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Task wird zur aktuellen Uhrzeit erstellt und jede Stunde wiederholt
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
$task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger
Register-ScheduledTask -TaskName "N16 LDAP unsignierte Events" -InputObject $task -Force

# Ausführen des Tasks
Start-ScheduledTask -TaskName "N16 LDAP unsignierte Events"