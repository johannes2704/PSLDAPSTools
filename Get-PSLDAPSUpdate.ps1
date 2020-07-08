$githubver = "https://raw.githubusercontent.com/johannes2704/PSLDAPSTools/master/Version.txt"
$version = "1.1.0"

function UpdatesAvailable(){

	$updateavailable = $false
	$nextversion = $null
	try	{
		$nextversion = (New-Object System.Net.WebClient).DownloadString($githubver).Trim([Environment]::NewLine)
	}	catch [System.Exception] {
		Write-Host $_ "debug"
	}
	
	Write-Host "CURRENT VERSION: $version"
	Write-Host "AVAILABLE VERSION: $nextversion"
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

function Get-Updates(){
	if (Test-Connection 8.8.8.8 -Count 1 -Quiet)	{
		$updatepath = "$($PWD.Path)\update.ps1"
		if (Test-Path -Path $updatepath)			{
			#Remove-Item $updatepath
		}
		if (UpdatesAvailable) {
				(New-Object System.Net.Webclient).DownloadFile($updatefile, $updatepath)
				Start-Process PowerShell -Arg $updatepath
				exit
			}
		}
	}
	else {
		Write-Message "Unable to check for updates. Internet connection not available." "warning"
	}
}

UpdatesAvailable


