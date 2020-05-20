Get-PSLDAPSInsecureBinds -ComputerName AD12.netz16.local

<#
[parameter(Mandatory=$false,Position=0)][String]$FileName,
[parameter(Mandatory=$false,Position=1)][bool]$ExportToFile = $false

$InsecureLDAPBinds = Get-PSLDAPSInsecureBinds


if ($ExportToFile){
	if ($FileName -eq "") {
		$CurrentDate = Get-Date -Format "yyyyMMdd-HHmm" 
		$FileName = "$CurrentDate - InsecureLDAPBinds.csv" 
	}
	# Dump it all out to a CSV.
	Write-Host $InsecureLDAPBinds.Count "records saved to .\InsecureLDAPBinds.csv for Domain Controller" $ComputerName
	$InsecureLDAPBinds | Export-CSV -NoTypeInformation .\$FileName
} else {
	Write-Output $InsecureLDAPBinds
}
#>