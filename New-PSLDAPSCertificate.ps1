<# 
.SYNOPSIS
    Erstellt ein Self Signed Zertifikat auf einem Domaincontroller. Mit diesem Zertifikat wird LDAPS eingeschaltet.
    Das Zertifikat wird automatisch in die vertrauenswürdigen Stammzertifizierungstellen des Domänencontrollers kopiert.
    Das Zertifikat besitzt standardmäßig eine Gültigkeit von 5 Jahren ab dem Ausstellungsdatum.

.NOTES 
   DATE         : 2020-06-02
   AUTHOR       : Johannes Rehle
   DESCRIPTION  : Initiale Skripterstellung
   VERSION      : 1.0
#> 

Param(
    [parameter(Mandatory=$false,Position=0)][String]$DNSName = "$env:computername.$env:userdnsdomain",
    [parameter(Mandatory=$false,Position=1)][int]$Years = 5
)

# Erstellen des Zertifikates
$Certificate = New-SelfSignedCertificate -DnsName $DNSName -CertStoreLocation "cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears($Years) -ErrorAction Stop

# Hinzufuegen des Zertifikates in die Vertrauenwuerdigen Stammzertifizierungsstellen
$filepath="$env:TEMP\owncer.cer"
Export-Certificate -Cert $Certificate.pspath -FilePath $filepath | Out-Null
Import-Certificate -FilePath $filepath -CertStoreLocation "Cert:\LocalMachine\Root\" | Out-Null
Remove-Item -Path $filepath -Force

Write-Host "Zertifikat wurde erfolgreich erstellt."