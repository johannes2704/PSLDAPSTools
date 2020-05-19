#[String]$Folder = "C:\Test"
[String]$Testfile = 'C:\Test\20200513-2000 - AD-01 - InsecureLDAPBinds.csv'

Import-CSV $Testfile | Get-Unique



<#
$Files = Get-ChildItem $Folder -Filter '*.csv'
$CSV = {}
Foreach ($file in $files) {
    $String = Import-Csv $file | Select-Object -Unique
    $CSV = $CSV + $String
}

$CSV
#>