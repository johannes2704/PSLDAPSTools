Function Get-PSLDAPSDebugging{

    Param(
        [Parameter(ValueFromPipeline=$true)]$HostName = "$env:computername.$env:userdnsdomain"
    )

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

    # Build the object
    [pscustomobject]@{
        Computer           = $ComputerName
        debugging          = $Debugging
    }
}

Get-ADDomainController -Filter * | Get-PSLDAPSDebugging