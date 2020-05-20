Function Get-PSLDAPSOverview{

    Param(
        [Parameter(ValueFromPipeline=$true)]$HostName = "$env:computername.$env:userdnsdomain"
    )

    process{
        $ComputerName = $HostName

        #Check if LDAPS is configured
        try {
            $LDAP = "LDAP://" + $ComputerName + ':' + 636
            $Connection = [ADSI]($LDAP)
            $Connection.Close()
            $LDAPS = $true
        } catch {
            $LDAPS = $false
        }

        # Diagnostics Enabled?
        $Hive = [Microsoft.Win32.RegistryHive]::LocalMachine
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $ComputerName)
        $key = $reg.OpenSubKey('SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics')
        $key = $key.GetValue('16 LDAP Interface Events')
        if ($key -gt 0){
            $Debugging = $true
        } else {
            $Debugging = $false
        }

        # Eventlog Check
        $Eventlog=Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{Logname='Directory Service';Id=2887; StartTime=(get-date).AddHours("-24")} -ErrorAction "SilentlyContinue"
        if ($Eventlog) {
            $eventXML = [xml]$Eventlog.ToXml()
            $Unencrypted=$eventXML.event.EventData.Data[0]
            $Unsigned = $eventXML.event.EventData.Data[1]
        } else {
            $Unencrypted=0
            $Unsigned=0
        }

        # Build the object
        [pscustomobject]@{
            Computer           = $ComputerName
            LDAPS              = $LDAPS
            Unencrypted        = $Unencrypted
            Unsigned           = $Unsigned
            debugging          = $Debugging
        }
    }
}

Get-ADDomainController -Filter * | Get-PSLDAPSOverview