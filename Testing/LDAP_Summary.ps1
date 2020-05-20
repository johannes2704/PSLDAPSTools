[String]$Folder = ".\TestData\"
[String]$Testfile = ".\TestData\20200518-1210 - AD-01 - InsecureLDAPBinds.csv"
[String]$FileLoggedSystems = "C:\LDAP\LDAPLoggedSystems.csv"


if (Test-Path $FileLoggedSystems -ErrorAction SilentlyContinue){
    $LDAPBinds += Import-CSV $FileLoggedSystems
} else {
    New-Item -ItemType "directory" "C:\LDAP\"
}

$files = Get-ChildItem -Path $Folder -Filter "*.csv"
foreach ($file in $files){
    $LDAPBinds += Import-CSV $file.FullName
}
$LDAPBinds += Import-CSV $Testfile

$UniqueLDAPBinds = $LDAPBinds | Select-Object IPAddress,User,BindType -Unique
$UniqueLDAPBinds | Export-CSV -NoTypeInformation $FileLoggedSystems 