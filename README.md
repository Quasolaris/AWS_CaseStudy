# PCLS Case Study HS22
### Team
- Marcel Soltermann
- Ismail Cadaroski
- Sebastian Grau 
- Ilija Kljajic

### Beschreibung
Als Ausgangslage für den Use Case wird ein KMU angenommen, welches eine statische Webseite hos-tet und den Besuchenden der Webseite ermöglicht via Formular eine Lambda Funktion zu triggern. Hierfür sollte die Lösung tiefe Kosten generieren, eine hohe Skalierbarkeit bieten und Hochverfügbar sein.

### Services
- S3 Bucket mit statischer Webseite
- Lambda Funktion
- API Gateway für Lambda Trigger
- Cloudfront als CDN
- Cloudwatch für Monitoring
- LoadBalancer für mögliche EC2 Erweiterung

## Dokumentation
- 

### Dateien
- [main.tf](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/main.tf)
- [variable.tf](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/variable.tf)
- [README für Terraform](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/README.md)
- [Lambda Function Python Code](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Lambda/func.py)
- [index.html](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/webpage/index.html)
- [error.html](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/webpage/error.html)

## SetUp
Für eine Anleitung zum Deployment und welche Informationen in der [variable.tf](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/variable.tf) Datei angepasst werden müssen, siehe das [README](https://github.com/Quasolaris/AWS_CaseStudy/blob/main/Terraform/README.md) im Terraform Ordner.


## Funktionalität des Deployments testen
Wärend des Terrafom Build Prozesses kann es zu Fehler betreffend der Zertifikate kommen. Diese können weitgehend ignoriert werden, da die Lerner Labs von AWS nicht alle Berechtigungen für Zertifikate haben. Folgend sind Schritte um zu überprüfen ob alle Services funktionieren und interagieren:

1. S3 Bucket

Ist der Bucket vorhanden, index.html und error.html Dateien abgespeichert und AWSLogs Ordner aufgesetzt?
<img title="S3" alt="S3 picture" src="/Images/s3.png">

2. Webseite

Wird man via diesem [link](http://s3-static-webpage-casestudy-fhnw-som.s3.amazonaws.com/index.html) auf HTTP und dann automatisch zu HTTPS weitergeleitet?
<img title="Website" alt="Website picture" src="/Images/website.png">

3. Lambda Trigger

Erhält man durch drücken auf "Activate Lambda" eine Response via dem API-Gateway (Manchmal zweimal Drücken nötig)?
<img title="Trigger" alt="Trigger picture" src="/Images/trigger.png">

