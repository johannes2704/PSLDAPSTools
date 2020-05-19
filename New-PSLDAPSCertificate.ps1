Param(
    [parameter(Mandatory=$false,Position=0)][String]$DNSName = "$env:computername.$env:userdnsdomain",
    [parameter(Mandatory=$false,Position=1)][int]$Years = 5
)

New-SelfSignedCertificate -DnsName $DNSName -CertStoreLocation "cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears($Years)