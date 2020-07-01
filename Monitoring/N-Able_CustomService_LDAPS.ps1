$FQDN = "$env:computername.$env:userdnsdomain"

#Check if LDAPS is configured
try {
    $LDAP = "LDAP://" + $FQDN + ':' + 636
    $Connection = [ADSI]($LDAP)
    $Connection.Close()
    $LDAPS = $true
} catch {
    $LDAPS = $false
}

# Global Variables
[int]$Unencrypted = 0
[int]$Unsigned = 0
[int]$Unsecured = 0

#Check if debugging is enabled
if (Test-Path HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics -ErrorAction SilentlyContinue) {
    if ((Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics").GetValue('16 LDAP Interface Events') -gt 0){
        $Debugging = $true
    } else {
        $Debugging = $false
    }
} else {
    $Debugging = $false
}

#Check the eventlog
if ([System.Diagnostics.EventLog]::Exists('Directory Service')){
    $Eventlog=Get-WinEvent -FilterHashtable @{Logname='Directory Service';Id=2887; StartTime=(get-date).AddHours("-24")} -ErrorAction "SilentlyContinue"
    if ($Eventlog) {
        $eventXML = [xml]$Eventlog.ToXml()
        $Unencrypted=$eventXML.event.EventData.Data[0]
        $Unsigned = $eventXML.event.EventData.Data[1]
    } else {
        $Unencrypted=0
        $Unsigned=0
    }
    # May Update (New Event)
    $Eventlog=Get-WinEvent -FilterHashtable @{Logname='Directory Service';Id=3040; StartTime=(get-date).AddHours("-24")} -ErrorAction "SilentlyContinue"
    if ($Eventlog) {
        $eventXML = [xml]$Eventlog.ToXml()
        $UnsignedLDAPS=$eventXML.event.EventData.Data
    } else {
        $UnsignedLDAPS=0
    }
}

[pscustomobject]@{
    Computer           = $FQDN
    LDAPS              = $LDAPS
    Unencrypted        = $Unencrypted
    Unsigned           = $Unsigned
    UnsignedLDAPS      = $UnsignedLDAPS
    debugging          = $Debugging
}