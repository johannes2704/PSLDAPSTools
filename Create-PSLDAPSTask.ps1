$jobname = "N16 LDAP unsignierte Events"
$action = New-ScheduledTaskAction –Execute 'powershell.exe' -Argument '-file C:\LDAP\Create-PSLDAPSLogging.ps1'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours "1")
$Description='Dieser Task sammelt automatisiert die unverschlüsselten LDAP Aufrufe auf allen Domain Controller ein'
$credential = Get-Credential
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
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

If(Get-ScheduledTask -TaskName 'N16 LDAP unsignierte Events' -ErrorAction SilentlyContinue){
    Write-Host 'Task has been created sucessfully' -BackgroundColor DarkBlue
} else {
    Write-Host 'Task konnte nicht erstellt werden'
}