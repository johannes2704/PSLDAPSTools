Function Get-PSLDAPSInsecureBinds{
	Param (
		[parameter(Mandatory=$false,Position=0)][String]$ComputerName = "$env:COMPUTERNAME.$env:USERDNSDOMAIN",
		[parameter(Mandatory=$false,Position=1)][Int]$Hours = 24
	)

	# Check if Registry Key is set

	# Create an Array to hold our returnedvValues
	$InsecureLDAPBinds = @()

	# Grab the appropriate event entries
	$Events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{Logname='Directory Service';Id=2889; StartTime=(get-date).AddHours("-$Hours")}

	# Loop through each event and output the 
	ForEach ($Event in $Events) { 
		$eventXML = [xml]$Event.ToXml()
		
		# Build Our Values
		$Client = ($eventXML.event.EventData.Data[0])
		$IPAddress = $Client.SubString(0,$Client.LastIndexOf(":")) #Accomodates for IPV6 Addresses
		$User = $eventXML.event.EventData.Data[1]
		Switch ($eventXML.event.EventData.Data[2]){
			0 {$BindType = "Unsigned"}
			1 {$BindType = "Simple"}
		}
		
		# Add Them To a Row in our Array
		$Row = "" | select-object IPAddress,Port,User,BindType
		$Row.IPAddress = $IPAddress
		$Row.User = $User
		$Row.BindType = $BindType
		
		# Add the row to our Array
		$InsecureLDAPBinds += $Row

		# Output
		Write-Output $InsecureLDAPBinds
	}

}

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