# Meeting Minutes AOG, PO, Compliance & Security 8.12.2017

In **Fettschrift** geschriebene Dinge wurden anhand der Non-Functional-Requirements-Liste von AOG/PO im Laufe des Meetings ergänzt. Dies sind nicht die vollständigen Non-Function-Requirements!

- relevante Zeitpunkte:
    - SaaStr – Feb ‘18
    - Close Early Access Program – June ‘18 (--> MMP)
    
- Security
    - SaaStr + MMP: 
      - Authorisierung zur Abfrage von backend Resourcen
      	- **Sobald die Platform "public" erreichbar ist dürfen keinerlei fremde Daten mehr abgerufen oder fremde Aktionen aufgerufen werden können, egal ob aus Sicht des Clients oder Customers (public APIs, Cancellations etcpp...)**
			- **Mechanismus für TY-Pages ist ok, da nicht erratbar**
			- **Möglicherweise müssen Seiten wie Cancellations und dergleichen hinter einem Customer-Login versteckt werden**
		- **HTTPS-only in öffentlicher Kommunikation, inkl. Webhooks**
			- **interne Kommunikation kann erstmal bei HTTP bleiben, Empfehlung ist aber HTTPS**
		- **Passwort-Stärke sollte nochmals überprüft werden**
		- **URL-Redirect-Mechanismus im Signup nochmal von Winni überprüfen lassen @Pete**
		- **Cloudflare-Anbindung evtl. nochmal betrachten**
    - nicht relevant für MMP:
        - statische Code Analyse
        - "Winni" Security Tools
        	- **Halbautomatisierter / manueller Check in (un)regelmäßige Abständen, nicht in CI-Pipeline integriert**
- Compliance
    - MMP: 
        - Zertifizierungen nicht relevant (PCI, ...) (@PO's: wollen wir zur MMP Phase mit solchen Zertifizierungen werben?)
        - export compliance relevant
            - **SDN-Screening ("Terrorlisten") muss separat geklärt werden @POs & Vincent**
    - SaaStr:
        - **Embargoed countries ein Muss, mittels IP-Detection ausreichend**
- Privacy
    - SaaStr, MMP: für beide gleichermaßen relevant
    - Data minimization: wird bereits beachtet
    - Pseudonymization or anonymization: können wir aktuell nicht einschätzen
        - **Bei Webhooks ist der Client im Service Provider-Modell in der Pflicht**
    - Encryption: SSL (client to server), Cookies (verschlüsselt ja/nein)
        - **s.o. bei Sicherheit**
    - Logging: keine sensiblen Daten loggen
    - Opt-in / opt-out: keine Relevanz (tracking!?)
        - **Bei eigenen Trackings müsste TaC angepasst werden und ggf. pro Client deaktiviert werden können**
    - different environments: wird bereits beachtet
    - **Daten löschen**
        - **SaaStr: Aus-x-en ok, am Ende wird eh weggeschmissen**
        - **MMP: Daten löschen muss möglich sein**
        - **Was müssen wir an Daten behalten?**
- Audit & control
    - Standard-Zertifizierungen:
        - grundsätzlich keine Zertifizierungen relevant, es sei denn wir benötigen diese für Marketing oder aber es gibt auch im service provider Modell rechtlich bindende Regularien 
    - Audit:
        - Aktuell schwer eine Aussage für den MMP zu treffen, da nicht konkret genug.
        - Was sind master-data? 
        - Bzw. müssen alle Datenänderungen nach Audit Vorgaben nachgehalten werden?
        - Wie lange?
        - **Separate Klärung @AOG**
        - **Vincent schickt separat Übersicht an Audit-Fragen an uns zum Einschätzen**