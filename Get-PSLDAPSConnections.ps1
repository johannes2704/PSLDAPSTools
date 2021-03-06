Param(
    [String]$LogFile = "C:\LDAP\LDAPSysteme.csv",
    $OutputConsole = $true
)

Function Get-PSLDAPSInsecureBinds{
	Param (
		[parameter(Mandatory=$false,Position=0)][String]$ComputerName = "$env:COMPUTERNAME.$env:USERDNSDOMAIN",
		[parameter(Mandatory=$false,Position=1)][Int]$Hours = 24
	)

	# Check if LDAP Diagnostics is enabled
	$Hive = [Microsoft.Win32.RegistryHive]::LocalMachine
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $ComputerName)
	$key = $reg.OpenSubKey('SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics')
	$key = $key.GetValue('16 LDAP Interface Events')
	if ($key -gt 0){

		# Create an Array to hold our returnedvValues
		$InsecureLDAPBinds = @()

		# Grab the appropriate event entries
		$Events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{Logname='Directory Service';Id=2889; StartTime=(get-date).AddHours("-$Hours")} -ErrorAction SilentlyContinue

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
}

$LDAPBinds = @()

# Check if there is an existing Log File and Import it
if (Test-Path $LogFile -ErrorAction "SilentlyContinue"){
    Write-Debug "Existing Logfile found. Import."
    $LDAPBinds += Import-CSV $LogFile
}

Write-Debug "Searching for Domain Controllers"
$DomainControllers = Get-ADDomainController -Filter *
Foreach ($DC in $DomainControllers){
    Write-Debug "Checking Domain Controller $DC"
    $LDAPBinds += Get-PSLDAPSInsecureBinds -ComputerName $DC
}

# Export to File
Write-Debug "Export System to logfile $logfile"
$UniqueLDAPBinds = $LDAPBinds | Select-Object IPAddress,User,BindType -Unique
$UniqueLDAPBinds | Export-CSV -NoTypeInformation $LogFile

if ($OutputConsole){
    Write-Output $UniqueLDAPBinds
}