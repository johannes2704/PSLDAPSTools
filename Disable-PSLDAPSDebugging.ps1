if (Test-Path HKLM:SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics) {
    New-ItemProperty -Path HKLM:SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics -Name "16 LDAP Interface Events" -PropertyType DWord -Value 0 -Force
} else {
    Write-Warning "Please execute this script on a domain controller!"
}

