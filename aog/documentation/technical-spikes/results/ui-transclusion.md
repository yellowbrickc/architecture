##### Fragestellungen:

- Wie aufwändig ist die Einbindung?
- Wie flexibel sind die Lösungen?
- Wie könnten Assets geladen werden?
- Wie performant sind die Lösungen, welche sind schneller?
- Wie lässt sich lokal damit arbeiten?
	- unterschiedliche webpack builds
	- lokal "echte app"
	- in der build puipeline fragment server 
- Wie lässt sich das PCI-Compliant nutzen?
- Sind zum Beispiel 3 React-Apps (per Transclusion) auf einer Seite kompatibel
	-  Javascript wird modularisiert durch AMD/UMD -> keine Konflikte
	-  CSS-Modularisierung muss jedes Fragment selbst übernehmen
		- in Zukunft shadow dom
		- kurzfristig CSSModules    

##### Vorschläge für Techniken:

- Transclusion via JS in Browser
- Edge Side Include (ESI; nginx via SSI?, Varnish)
- Server Side Includes (SSI; nginx etc...)
- Tailor / Mosaic9 (https://www.mosaic9.org)

# Results

#### Client Side include
- Am wenigsten sinnvoll erscheinende Variante, daher nicht gespiked

#### Server Side include
- Ausprobiert via nginx
- "Alte" Sprache und Syntax, die sehr unflexibel und sperrig ist
- Abbrufen von Inhalten nur synchron vor dem Ausliefern der eigentlichen Seite
    - Performance schlecht!
- nginx erlaubt nur das Einbinden von Inhalten und Includes, die im gleichen Server angesiedelt sind und selbst von nginx bereitgestellt werden
    - Daher kein gangbarer Weg, da Systeme und Teams die Inhalte selbst bereitstellen sollen

Fazit: Nicht nutzbar.

Beispiel: [local](http://localhost:6001)

#### Edge Side include
- Ausprobiert mittels Varnish als Proxy/Parser-Lösung und nginx sowie eigenem NodeJS-Webserver als Content-Lieferant
- Dokumentation seitens Varnish schlecht
- Sperrige Sprache
- *Nicht* zum Laufen bekommen!
- Kaum Anwendung in der Welt

Fazit: Nicht nutzbar, bzw. klare Empfehlung dagegen.

Beispiel: [local](http://localhost:10000)

#### Tailor
- Von Zalando erstelltes Open Source-Projekt
- NodeJS
- Sehr schnell, gute TTFB (nicht getestet)
- Recht einfache Einbindung, erste Ergebnisse sehr schnell erhalten
- AMD / UMD, daher UI-Framework-agnostisch
- Gute Flexibilität und Konfigurierbarkeit
    - Fragmente: primary, async, ...
    - Slots innerhalb von Templates zum Positionieren von Content

Fazit: Wahrscheinlich gute Nutzungsmöglichkeit für Transklusion.

Beispiel: [local](http://localhost:4001/index)

## Folgefragen
- Wie können Assets aus verschiedenen Systemen anständig eingebunden werden?
- Wie können für transkludierte Bestandteile Daten an die jeweiligen Systeme geschickt werden?
- Schaffen wir uns nicht eine starke Kopplung an einen möglicherweise notwendigen Asset Store oder an eine komplexe Proxy-Schicht?
- Wird möglicherweise eine umfassende Proxy-Konfiguration in einzelnen Systemen nötig, um das Routing von Server-Anfragen, Assets und in Assets eingebetteten Ressourcen (z.B. innerhalb von CSS) abbilden zu können?
    - Sehr hohe Komplexität an dieser Stelle!


#### Mögliche weitere Spikes/ToDos
- Asset Composing
- Verarbeitung von Daten
    - Wer schickt was wohin?
    - Wie sehen Antworten aus?
    - Wie können diese verarbeitet werden?
    - Entsteht dadurch Kopplung?
    - Implikationen bzgl. Compliance (PCI)
- Weitere Analyse der Möglichkeiten von Tailor
- Transkludierte Hybrid-Apps (die bevorzugt client-seitig redern, aber auch serverseitig können falls kein JS da ist) - Interaktion mit der HTML5-History API über mehrere transkludierte Apps (Beispiel: App1 wechselt die Route, hat das Auswirkungen auf App2?)
    
    
    






## Weitere Fragestellungen

- Statehaltung in Forms
	- Ein Submit-Button für verschiedene Fragmente???

## random thoughts tobi:
- Cliend-Side
	- nicht ausprobiert
- ESI
	- konfiguration komplex - nicht ans laufen bekommen
- SSI
	- kann nur URLs vom eigenem (lokalem) Web-Server laden (dessen Web im gleichem Nginx bspw konfiguriert ist); nicht von anderen Webservern trotz bspw gleicher domain;
- Tailor
	- auf nodejs begrenzt

- Clinch von gleichbenannten, globalen JS Variablen/Funktionen, welche in Child-Apps benutzt werden und von anderen Child-Apps nichts wissen
- Clinch bei gleichen selectoren bei Stylesheets - gleiche css class names, ids, tags, welche in Child-Apps benutzt werden und von anderen Child-Apps nichts wissen
- Asset laden nicht optimal
- starke Kopplung im Proxy - muss wissen wie Urls/Routen aufzulösen sind, um diese an die richtige Child-App weiterzuleiten
- unterschiedliche Build Steps um Child-App selbst entwickeln zu können (mit/ohne Html Gerüst/Struktur wie html head und body bzw. nur html fragment)
- Child Apps durch transclusion u.u. wie im falle bei der Checkout seite dennoch stark über JS miteinander gekoppelt (bspw. form submit abfangen + validierung)
- noch nicht getestet/offene fragestellungen/hinweise:
	- formulare
		- formulareingabe masken
		- gepostete formulareingaben entgegen nehmen
			- wie verhält sich child-app A, wenn diese selbst valide ist und ihren nächsten "review" inhalt anzeigen könnte, child-app B jedoch validierungsfehler enthält
		- jedes SCS müsste eingenes <form> tag für seine masken haben, da es sonst nicht autark ist und somit SCS widerspricht
	- asset
		- zentrales asset projekt
			- ist die kopplung an dieses zentrale asses system nicht schon wieder gleichbedeutend mit starker kopplung, so dass man dessen context (bspw. checkout) nicht doch besser in einer SCS (welche natürlich größer, aber in sich abgeschlossen wäre) baut
				- wiederspricht dem SCS selbst - andere child-apps sind nicht autark sondern an zentrales asset/SCS repo gebunden/von abhängig
	- geht die welt nicht eher immer mehr zu single page applications?
	- macht wenn eine client-seitige transclusion evtl. doch eher sinn?


			