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
    $Eventlog=Get-EventLog -LogName 'Directory Service' -Source "NTDS LDAP" -ErrorAction SilentlyContinue | Where-Object {$_.EventID -eq "2887"} | Select-Object -First 1
    if ($Eventlog) {
        #Extract the values for unencrypted and unsigned messages
        $Eventlog.Message -match '.*TLS erfolgten: (\d+).*'
        $Unencrypted=$matches[1]
        $Eventlog.Message -match '.*Signatur erfolgten: (\d+).*'
        $Unsigned = $matches[1]
    } else {
        $Unencrypted=0
        $Unsigned=0
    }
}

[pscustomobject]@{
    Computer           = $FQDN
    LDAPS              = $LDAPS
    Unencrypted        = $Unencrypted
    Unsigned           = $Unsigned
    debugging          = $Debugging
}