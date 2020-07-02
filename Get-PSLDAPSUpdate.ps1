$githubver = "https://raw.githubusercontent.com/johannes2704/PSLDAPSTools/master/Version.txt"
$version = "1.1.1"

function UpdatesAvailable(){

	$updateavailable = $false
	$nextversion = $null
	try	{
		$nextversion = (New-Object System.Net.WebClient).DownloadString($githubver).Trim([Environment]::NewLine)
	}	catch [System.Exception] {
		Write-Host $_ "debug"
	}
	
	Write-Host "CURRENT VERSION: $version"
	Write-Host "NEXT VERSION: $nextversion"
	if ($null -ne $nextversion -and $version -ne $nextversion){
		#An update is most likely available, but make sure
		$updateavailable = $false
		$curr = $version.Split('.')
		$next = $nextversion.Split('.')
		for($i=0; $i -le ($curr.Count -1); $i++)		{
			if ([int]$next[$i] -gt [int]$curr[$i]){
				$updateavailable = $true
				break
			}
		}
	}
	return $updateavailable
}

UpdatesAvailable


