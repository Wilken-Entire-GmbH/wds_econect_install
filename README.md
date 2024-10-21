# Windows Installation des P5DMS WCS3 To Rest Adapters

## P5DMS WCS3 To Rest Adapter
Der P5DMS WCS3 To Rest Adapter übersetzt WCS SOAP Aufrufe in REST Aufrufe des zugrunde liegenden DMS. Die Übersetztung nach REST ist hierbei nicht fix programmiert, sondern über eine Konfigurationsdatei parametiert. Im Prinzip lassen sich damit beliebige DMS anbinden, unter der Voraussetzung, dass ein REST Service verfügbar und alle, für die WCS3, notwendigen dokumentenbezogenen Operationen unterstützt werden. 

Für D3 und das P5DMS sind Konfigurationen erstellt. Diverse andere DMS können, auf Anfrage, von der Entwicklung konfiguriert werden. 

## Installationsvoraussetzungen 
  * Zugriff auf das Internet (Herunterladen der Installation)
  * Lokale Administrationsrechte für die Registrierung des Windows Service 
  * Halbwegs modernes Windows Betriebssystem (> XP auf Client, >= Windows Server 2008 R2)

## Download wds_wcs_rest_installer

Die Installer zips sind unter https://github.com/Wilken-Entire-GmbH/wcs_rest_install/releases hinterlegt. 

Das *wcs_rest_installer.zip* ist für das jeweilige Release unter Assets hinterlegt. Download erfolgt direkt durch Anklicken des Links.

Ist das Release bekannt kann der Link direkt im Browser eingegeben werden und der Download erfolgt sofort. 

Beispiel: https://github.com/Wilken-Entire-GmbH/wcs_rest_install/releases/download/v1.3.102/wds_wcsrest_install.zip

## Entpacken der Installation
Zip-Datei in beliebigem Installationsverzeichnis (lokale Platte) entpacken.

Beispiel: c:\wilken\wcsrest 

Bitte Pfade ohne Leerzeichen und Sonderzeichen wählen. 

## Inhalt der Installation 
Nach dem Entpacken sind folgende Verzeichnisse ab Installationsverzeichnis verfügbar: 

Verzeichnis | Beschreibung 
-|-
app\p5dms | Beinhaltet das Binary wds_contentservice_rest.exe
config\p5dms | Beinhaltet die Konfiguration des/der Rest Services
control | Bat Skripte zur Registrierung/Deregistrierung, Starten/Stoppen des/der Rest Service(s)
runtime\p5dms\<tenantid> | Ablageort für Logfiles. Die Ids (tenantid) sind definiert als *prod* und *test*

## Globale Konfiguration
Einmalig muss die IP oder der Rechnername hinterlegt werden. Diese Information wird in der WSDL für den Servicenamen verwendet.

IP oder Rechnername in der Datei config\p5dms\envInitialize.yaml unter SOAP_HOSTNAME eintragen.

Als Defaultwert ist 127.0.0.1 hinterlegt. Dies ermöglicht ausschließlich lokale Zugriffe. 

```yaml
SOAP_HOSTNAME: 127.0.0.1 
```
## Windows Service Verwaltungsfunktionen
Für die Windows Service Installation sind lokale Adminrechte erforderlich. Die Bat-Skripte für Installation/Deinstallation, Starten/Stoppen befinden sich unter \control. 

Die folgenden Beispiele verwenden den WCS3Rest Service test.

### Service installieren 
```bash
wds_install test
```

Der Service ist nun registriert und wird unter Dienste angezeigt.

### Service starten 
```bash 
wds_start test
```
Der Service wird gestartet.

WSDL: http://<SOAP_HOSTNAME>:6951/soap/ContentService?wsdl

Swagger-ui: http://<SOAP_HOSTNAME>:6951

Port 6951 kann für den Service entsprechend angepasst werden. Siehe weiter unten "WCS3 Rest Service konfigurieren"

### Service stoppen
```bash 
wds_stop test
```

Der Service wird angehalten. 

### Service deinstallieren
```bash 
wds_remove test
``` 

Der Service wird vom Rechner entfernt und wird unter Dienste nicht mehr angezeigt. Sind alle Dienste entfernt, kann die komplette Installation von der Platte gelöscht werden.

## WCS3 Rest service konfigurieren
Der Service wird bereits vorkonfiguriert ausgeliefert. Diese Konfiguation kann nach den individuellen Bedürfnissen angepasst werden. 

Die Konfigurationen der Services befindet sich unter \config\p5dms\tenants\<tenantid>.env 

Hier der ausgelieferte Inhalt von test: 

```yaml
# P5/2 DMS WCS3 Rest Service Tenant Configuration

# tenant 
TENANT_CAPTION: Test - WCS3 To REST Adapter

# http port of service
WDSREST_HTTP_PORT: 6951

# extend logging of soap calls
WDSREST_SOAP_LOG: true 
WDSRERST_SOAPCONFIG_LOG: true
```

Die Parameter haben folgende Bedeutung:

Parameter | Beschreibung 
-|-
WDSREST_HTTP_PORT | Legt den Port fest über den auf den Service zugegriffen wird.
TENANT_CAPTION | Legt den Titel der Swagger UI im Browser fest. 
WDSREST_BASEURL | BaseURL der REST API des externen DMS.
WDSREST_AUTH_BEARER | Bearer Authentifizierung key (z.B. D3 REST).
WDSREST_D3_REPOSITORYID | Nur D3: ID des zu verwendenden D3 Repositories.
WDSREST_SOAP_LOG | Erweitertes SOAP Logging Contentservice an/aus.
WDSREST_SOAPCONFIG_LOG | Erweitertes SOAP Logging ContentConfiguration Service an/aus.












