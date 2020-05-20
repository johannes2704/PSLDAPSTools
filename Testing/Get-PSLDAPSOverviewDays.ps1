Function Get-PSLDAPSOverviewDays{

    Param(
        [Parameter(ValueFromPipeline=$true)]$HostName = "$env:computername.$env:userdnsdomain",
        $Days = 7
    )

    process{
        $ComputerName = $HostName
        # Eventlog Check
        $Events=Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{Logname='Directory Service';Id=2887; StartTime=(get-date).AddDays(-$Days)} -ErrorAction "SilentlyContinue"
        ForEach ($Event in $Events) { 
            $eventXML = [xml]$Event.ToXml()
            $Unencrypted=$eventXML.event.EventData.Data[0]
            $Unsigned = $eventXML.event.EventData.Data[1]
            $Day = Get-Date $event.TimeCreated -Format "dd.MM.yyyy"
        
            # Build the object
            [pscustomobject]@{
                ComputerName       = $ComputerName
                Day                = $Day
                Unencrypted        = $Unencrypted
                Unsigned           = $Unsigned
            }
        }
    }
}

Get-ADDomainController -Filter * | Get-PSLDAPSOverviewDays | Sort-Object ComputerName