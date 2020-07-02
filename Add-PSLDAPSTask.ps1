$jobname = "N16 LDAP unsignierte Events"
$action = New-ScheduledTaskAction –Execute 'powershell.exe' -Argument '-file C:\LDAP\Get-PSLDAPSConnections.ps1' -WorkingDirectory 'C:\LDAP\'
$trigger = New-ScheduledTaskTrigger -Daily -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours "1") -RepetitionDuration "1"
$Description='Dieser Task sammelt automatisiert die unverschlüsselten LDAP Aufrufe auf allen Domain Controller ein'
$credential = Get-Credential
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
if (Get-ScheduledTask -TaskName $jobname -ErrorAction SilentlyContinue){
    Write-Host "Task existiert bereits. Lösche den vorhanden Task"
    Unregister-ScheduledTask -TaskName $jobname
}
Try{
    $ErrorActionPreference='stop'
    Register-ScheduledTask  -TaskName $jobname `
                            -Action $action `
                            -Trigger $trigger `
                            -RunLevel Highest `
                            -User $credential.UserName `
                            -Password $credential.GetNetworkCredential().Password `
                            -Settings  $settings `
                            -Description $Description `
                            |Out-Null
}
Catch{
    Write-Warning $_
}

If(Get-ScheduledTask -TaskName $jobname -ErrorAction SilentlyContinue){
    Write-Host 'Task has been created sucessfully' -BackgroundColor DarkBlue
} else {
    Write-Host 'Task konnte nicht erstellt werden'
}

Start-ScheduledTask -TaskName $jobname