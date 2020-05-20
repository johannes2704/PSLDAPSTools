[String]$LogFile = "C:\LDAP\LDAPLoggedSystems.csv"

Import-Module .\Get-PSLDAPSInsecureBinds.ps1

$LDAPBinds = Get-PSLDAPSInsecureBinds

if (Test-Path $LogFile -ErrorAction "SilentlyContinue"){
    $LDAPBinds += Import-CSV $LogFile
}

$UniqueLDAPBinds = $LDAPBinds | Select-Object IPAddress,User,BindType -Unique
$UniqueLDAPBinds | Export-CSV -NoTypeInformation $LogFile