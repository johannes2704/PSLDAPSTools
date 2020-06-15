# Microsoft LDAPS Advisory - Powershell Skripte

Microsoft Security Advisor
https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/ADV190023

In der zweiten Jahreshälfte 2020 wird von Microsoft ein Update veröffentlicht, das unsignierte und unverschlüsselte Anfragen 
über LDAP an Domain Controller unterbindet. Bis zu diesem Zeitpunkt müssen alle Domain Controller LDAPS ready gemacht werden
und die Systeme ermittelt werden, die noch unverschlüsselt mit Domain Controllern sprechen.

Dieses Repository enthält alle Skripte um einen Domain Controller LDAPS fähig zu machen.
Desweiteren werden hier Skripte bereitgestellt um die unverschlüsselten LDAP Anfragen automatisiert zu protokollieren.

## New-PSLDAPSCertificate.ps1
    Erstellt ein Self Signed Zertifikat das für 5 Jahre gültig ist. Wird benötigt um den LDAPS Port hochzufahren.
    Dies muss auf jedem Domain Controller ausgeführt werden.

## Create-PSLDAPSTask.ps1
    Mit diesem Skript wird ein Task in der Aufgabenplanung erstellt.
    Dieser führt das CGETPSLDAPSConnections unter C:\LDAP Skript jede Stunde aus

## Disable-PSLDAPSDebugging.ps1
    Schaltet die LDAP Diagnostics ab. 

## Enable-PSLDAPSDebugging.ps1
    Schaltet die LDAP Diagnostics an.

## Get-PSLDAPSConnections.ps1
    Skript für das automatisierte Loggen von LDAP Events
    Dieses sollte nach C:\LDAP\ kopiert werden
    Ausgabe wird nach C:\LDAP\LDAPSysteme.csv geschrieben.

## Get-PSLDAPSInsecureBinds.ps1
    Ermittelt alle Zugriffe auf den Domaincontroller die unverschlüsselt erfolgen

## Get-PSLDAPSOverview.ps1
    Ermittelt eine Übersicht über einen Server. Hierbei wird geprüft ob dieser LDAP spricht 
    und wieviel unverschlüsselte Anfragen in den letzten 24 Stunden erfolgt sind.

## Get-PSLDAPSOverviewDays.ps1
    Ermittelt alle Domain Controller einer Domäne und gibt Statistiken über die LDAP Aufrufe der letzten 7 Tage aus.


## Anleitung

### Debugging einschalten
- Setzt die Registry Keys wie in der Anleitung beschrieben oder führt das Skript Enable-PSLDAPSDebugging.ps1 auf jedem Domain Controller aus.

### Automatischer Task
- Erstellt einen Ordner unter C:\LDAP\
- Kopiert das Skript Get-PSLDAPSConnections.ps1 in den Ordner C:\LDAP\
- Erstellt einen Task mit dem Skript Create-PSLDAPSTask.ps1

### Auswerten
- Unter C:\LDAP\LDAPSysteme.csv findet ihr alle Systeme die unverschlüsselt oder unsigniert mit den Domain Controllern gesprochen haben.
- Die Datei wird 1x pro Stunde durch den Task upgedatet.
- Die Auswertung sollte über mehrere Tage erfolgen.

### Umstellen
- Je nach System muss dies dann entsprechend umgestellt werden. Hinweise finden sich hier oft in der Dokumentation der Hersteller

### Cleanup
- Deaktiviert das Debugging mit Disable-PSLDAPSDebugging.ps1 auf allen Domain Controllern
- Entfernt den Task aus der Aufgabenplanung mit Remove-PSLDAPSTask.ps1
- Entfernt den Ordner C:\LDAP\ und die Skripte vom System.


