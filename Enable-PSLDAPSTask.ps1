$argument = "-Command `"& 'C:\LDAP\Get-InsecureBinds.ps1' -p1 'Computername' `""
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument $argument
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger
Register-ScheduledTask -TaskName "N16 LDAP unsignierte Events" -InputObject $task -Force
Start-ScheduledTask -TaskName "N16 LDAP unsignierte Events"