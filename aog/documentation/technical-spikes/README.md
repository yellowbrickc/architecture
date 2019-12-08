# Technical Spikes

## Organisation

#### Rahmen:
- Ähnlich wie Exploration Day - einzelne Entwickler finden sich zu Teams zusammen, um ein Thema zu bearbeiten
- Teams werden *nicht* explizit innerhalb der Teams bearbeitet, sondern teamübergreifend
- Ergebnisse müssen dokumentiert und reproduzierbar sein
- Kein Augenmerk auf Schönheit des Codes, Testabdeckung usw., sondern auf Erkenntnisse. Nicht im Vorfeld mit der Frage beschäftigen, ob man das Endergebnis weiterverwenden kann oder nicht!

#### Zweiter Zeitplan:
- Montag - Freitag: Spikes
- Freitag Nachmittag: Review

#### Spike-Übersicht für Montag 2:
1. [Domain Event Bus 1 - Kafka](#domain-event-bus)
2. [Domain Event Bus 2 - Kinesis](#domain-event-bus)
3. [Asset Composing](#asset-composing)
4. [Documentation](#documentation)
5. [UI Customizations](#ui-customizations)
6. [Translations](#translations)

---

#### Alter Zeitplan:
- Montag: Umzug, Teamfindung, Orga usw.
- Dienstag - Freitag Morgen: Spiking
- Freitag Morgen: Vorstellung Spike-Ergebnisse
- Nach Freitags-Review: Entscheidung, ob mit einem Thema weiter gemacht werden sollte, ob ein neues Thema angegangen wird, oder wie es generell weitergeht (next steps)

#### Spike-Übersicht für ersten Montag:
1. [UI transclusion (alle Unterthemen)](#ui-composing-transclusion)
2. [Authentication 1 - KeyCloak](#authentication-authorization)
3. [Living Styleguide](#living-styleguide)
4. [PDF Invoicing](#pdf-invoicing)
5. [Standard Storage in K8s](#standard-storage-in-k8s)

##### Weitere:
1. [Test Broker](#test-broker-contract-driven-testing)
2. [Customer Tracking](#customer-tracking)
3. [Client Tracking](#client-tracking)
4. [Feature Toggling](#feature-toggling)
5. [Mailing](#mailing)
6. [Authentication 2 - Stormpath](#authentication-authorization)
7. [Authentication 3 - MITREid](#authentication-authorization)
8. Orchestration
9. DB Landscape Overview

---

## Domain Event Bus

Ziel: Verschiedene Systeme zum publishen & konsumieren von Domain Events evaluieren und untereinander abgleichen.

##### Annahme:
- Bus ist nicht für dauerhafte Persistenz zuständig
- Persistenz von Events sofern nötig findet außerhalb des Busses innerhalb der Systeme statt
- Producer legen Events auf die Queues / Topics, Consumer nutzen diese zum Anstoßen weiterer Verarbeitung im eigenen System

##### Fragestellungen:

- Wie einfach lässt sich der Bus anbinden, insbesondere mit node.js?
- Wie komplex ist der Consumer
- Wie hoch sind die Kosten für den Bus (Kinesis)
- Gibt es Dinge, die gegen die Verwendung des Busses sprechen?
- Wie lange können Consumer offline sein bevor Events verloren gehen?
- Wie hoch ist die Latenz?
- Was gibt es für Garantien bezüglich Nachrichtenübertragung, Verfügbarkeit (Kinesis)?
- Was für Statistiken / Metriken / Alerts gibt es?
- Wie kann man lokal damit arbeiten?

##### Vorschläge für Bus:

- [Kafka](http://kafka.apache.org/)
- [Amazon Kinesis](https://aws.amazon.com/de/kinesis)
- ...
- 

### [Ergebnisse Kinesis Spike](https://git.cgn.cleverbridge.com/spike-kinesis/spike-kinesis-compose)

## Asset Composing

##### Definition Assets:
- CSS
- JS
- Images
- ...

##### Annahme:
- Tailor wird als Transclusion-Service genutzt
- Jedes System erstellt die Assets selbst (Auslieferung ausgeklammert an diesem Punkt)

##### Hinweis:
Am besten mit dem "Living Styleguide"-Spiketeam syncen!

##### Fragestellungen:
- Wie kann ein System Assets von einem anderen System ansprechen und beim Transkludieren effektiv anwenden?
- Wie vermeidet man Konflikte zwischen Assets aus verschiedenen Systemen?
- Wie kann man Assets bundlen?
- Wo sollten Assets am besten liegen (z.b. innerhalb eines Systems oder in einem gemeinsamen Asset Store)?
- Wie lässt sich vermeiden, dass jedes System einen reichhaltigen Proxy konfigurieren muss um die Asset-URIs entsprechend auflösen zu können?
- Wie lässt sich vermeiden, dass sich alle Systeme fest an ein zentrales Asset-System / -Team koppeln?

#### Vorschläge zur Analyse
- Auflösung von URLs mittels nginx
- Evaluieren von [Skipper](https://github.com/zalando/skipper)
- ...

## Documentation

Ziel: Herausfinden, welche Bestandteile der Plattform in welcher Art und Weise für wen dokumentiert werden sollen.

##### Fragestellungen:
- Welche Teile der Plattform müssen dokumentiert werden, z. B. Checkout Pages, APIs, Message Broker, UI für Clients?
- Welche Informationstypen gibt es, z. B. API-Referenz, User Guide, kontextsensitive Hilfe in UI?
- Wer sind die Zielgruppen, z. B. intern, extern?
- Wer dokumentiert was?
- Welches Tooling setzen wir ein?
- Wie sollen Code-Beispiele in der Entwicklerdokumentation aussehen?
- Wo wird die Dokumentation gehostet?
- Welches Source Control System nutzen wir?
- Wie publizieren wir Dokumentation?
- Wie verknüpfen wir die Developer Documentation mit der Business User Documentation?

##### Vorschläge für Techniken / Tools:
1. [Docs as Code] (http://hackwrite.com/posts/docs-as-code/) Approach 
2. [Swagger](http://swagger.io/) & [Swagger UI](http://swagger.io/swagger-ui/) for API Explorer
3. Markdown & Static Site Generator (for example [GitBook](https://www.gitbook.com/), [Jekyll](https://jekyllrb.com/) or [Sphinx](http://www.sphinx-doc.org/en/stable/)) for Developer Documentation
4. [MadCap Flare](http://www.madcapsoftware.com/products/flare/) für Business User Documentation
5. [MadCap Central](http://www.madcapsoftware.com/products/central/) & GitHub für Hosting

## UI Customizations
Ziel: Einen Weg finden, wie ein Team wie CLS die UI-Darstellung eines Systems für einen einzelnen Client anpassen kann.

##### Annahme: 
- ReactJS als UI-Framework

##### Fragestellungen:
- Wie können Assets eingebunden werden, ohne dass dafür eine App neu gebuildet werden muss?
- Wie kann verhindert werden, dass für jeden Client eine eigene App gestartet werden muss?

## Translations
Ziel: Einen Weg finden, um die Subscription Platform multi-language-fähig zu gestalten.

##### Fragestellungen:
- Welche Tools und Frameworks gibt es bereits?
- Wie können Texte/Translations in die jeweiligen UIs eingebunden werden?
- Wie können Texte/Translations verwaltet & gepflegt werden, innerhalb des Systems und/oder systemübergreifend?
- Wie können Sprachwechsel in der übergeordneten UI auf alle transkludierten Teilbereiche angewendet werden?
- Wie können client-spezifische Texte abgelegt und angewendet werden?

##### Annahme:
- Ein zentrales, systemübergreifendes Repository beinhaltet "generelle" Texte und Translations
- Jedes System pflegt zudem ein eigenes Repository mit system-spezifischen Texten und Translations
- Localization ist Owner der Daten innerhalb aller Repositories
- Bei Änderungen an Texten wird eine neue Version des Repositories deployed

---

## UI composing & transclusion

Ziel: Verschiedene Arten der Einbettung von UI-Content (HTML, CSS, JS) zu evaluieren und zu überprüfen, wie und ob sich diese in unseren Systemen anwenden lassen.

[Blogpost zum Thema](https://www.innoq.com/de/blog/transclusion/)

##### Fragestellungen:

- Wie aufwändig ist die Einbindung?
- Wie flexibel sind die Lösungen?
- Wie könnten Assets geladen werden?
- Wie performant sind die Lösungen, welche sind schneller?
- Wie lässt sich lokal damit arbeiten?
- Wie lässt sich das PCI-Compliant nutzen?
- Sind zum Beispiel 3 React-Apps (per Transclusion) auf einer Seite kompatibel

##### Vorschläge für Techniken:

- Transclusion via JS in Browser
- Edge Side Include (ESI; nginx via SSI?, Varnish)
- Server Side Includes (SSI; nginx etc...)
- Tailor / Mosaic9 (https://www.mosaic9.org)

## Authentication & Authorization

Ziel: Möglichkeiten evaluieren, um Userverwaltung und -logins systemübergreifend durch einen Third Party-Service bereitzustellen.

##### Fragestellungen:
- Was sind die Szenarien und Anforderungen für:
    - Customer Auth
    - Client Auth
    - M2M Auth
- Wie aufwendig ist die Implementierung eines derartigen Services?
- Ist es sinnvoll, den Service auch für Machine to Machine-Kommunikation zu nutzen?
- Wie wird der identifizierte User im System weiter autorisiert / wie können alle Systeme mit dem authentifizierten User umgehen
- Geschwindigkeit
- Skalierbarkeit
- Für cloud-hosted Solutions:
    - Uptime / SLAs 
    - Kann der Dienst auch selbst gehostet werden?

##### Vorschläge für Techniken / Tools:

- [Stormpath](https://stormpath.com/)
- [MITREid Connect](https://github.com/mitreid-connect/)
- [KeyCloak](http://www.keycloak.org/) (-> CAP / AOE konsultieren)
- ... 

## Living Styleguide

Ziel: Einen Weg finden, der sicherstellt, dass transkludierte UI-Inhalte zueinander kompatibel sind und gleichen Designanforderungen (HTML-Struktur, CSS-Klassen ...) unterliegen.

##### Fragestellungen:
- Ist ein Living Styleguide eine Lösung der Problematik?
- Wie werden Inhalte im Styleguide gepflegt und neue Versionen publiziert?
- Könnte ein Team wie CLS damit arbeiten?

##### Vorschläge für Techniken / Tools:
- [Fabricator](https://fbrctr.github.io/)
- [SourceJS](https://sourcejs.com/)
- ...

## Test Broker (Contract Driven Testing)

Ziel: Möglichkeiten erörtern, um mittels Tests sicherzustellen, dass abgestimmte Schemata (Contracts) zwischen Systemen eingehalten werden.

##### Fragestellungen:
- Welche Contract Testing Tools gibt es?
    - Für REST APIs?
    - Für Message Queues?
    - Für UI-Integration?
- Welches Setup / welche Infrastruktur wäre jeweils von Nöten?
- Wie lässt sich dies in einer Continuous Delivery-Pipeline einsetzen?

##### Vorschläge für Techniken / Tools
- [Pact](https://github.com/realestate-com-au/pact)
- ...

## PDF Invoicing
Ziel: Analyse von Third Party-Lösungen auf deren Funktionalität sowie Erörtern einer Eigenlösung.

##### Fragestellungen:
- Welche Third Party-Lösungen gibt es?
- Wie arbeiten die Third Party-Lösungen?
- Wie aufwendig ist es, den Anbieter zu implementieren?
- Wie aufwändig wäre eine Eigenentwicklung?

##### Vorschläge für Techniken / Tools
- [Fastbill](https://www.fastbill.com)
- [Billiving](https://www.billiving.com)
- ...

##TODO

## Mailing
Ziel: Herauszufinden, mit welchen Aufwänden eine eigene Template-Lösung umzusetzen wäre.

##### Annahmen:
- Platzhalter in statischen Texten sollen mit Werten ersetzt werden
- Mail muss gesendet werden
- Mailversand muss verifiziert werden (bounced?)
- Texte sind mehrsprachig
- Mehrere Templates nötig (Confirmation, Renewal, Cancelled ...)
- ggf. Customizations (Logos)

##### Fragestellungen:
- Gibt es bestehendes und nutzbares Tooling?
- Kann erfasst werden, ob eine Email erfolgreich versendet wurde und wenn ja, wie?
- Wie hoch ist der voraussichtliche Aufwand einer Eigenentwicklung und dahingehender Wartung im Vergleich zu einer Third Party Lösung?

## Standard-Storage in K8s
Ziel: Einen Weg finden, um einzelnen Systemen und Teams standardisiert persistierten Speicherplatz im K8s-Cluster zur Verfügung stellen kann.

##### Fragestellungen
- Wie bindet man beliebigen Storage in K8s ein?
- Wie wird sichergestellt, dass Systeme nicht auf gegenseitigen Storage zugreifen?
- Wie kann der Storage in einzelnen Services (Message Busses, Datenbanken, Caching etc) genutzt und eingebunden werden?
- Kann man in verschiedene Arten von Storage (HDD vs SSD) unterscheiden? Ist dies nötig?

## Weitere Ideen

- Orchestrierung von Systemen und Systemservices
- DB Landscape Overview: Verschiedene Arten von Datenbanken + Vor- und Nachteilen

## Customer Tracking
Ziel: Einen Weg finden, wie Clients verschiedene Customer-Trackings in der Customer-Facing-UI einbinden können.

##### Hinweis:
Mit Kalle kurzschließen, der aktuell eine ReactJS-Tracking-Lösung für Core evaluiert und implementiert.

##### Fragestellungen:
- Welche Anforderungen bestehen an Trackings und die Einbindung von Trackings (technisch, business, compliance, legal, ...)?
- Lässt sich dies mit einem Transclusion-Ansatz lösen?
- Muss dies systemübergreifend gelöst werden oder kann dies jedes System selbst implementieren?
- Wie ließe sich in einer modularen UI event-basiertes Tracking umsetzen?

## Client Tracking
Ziel: Einen Weg finden, wie wir das Nutzungsverhalten unserer Clients sowieso die Nutzung der von uns gebauten Features nachvollziehen können.

##### Hinweis:
Ggf. gibt es hier eine Schnittmenge mit dem Thema "Customer Tracking".

##### Fragestellungen:
- Wie kann aus einem zusammengesetzten UI heraus das Nutzungsverhalten des Clients nachvollzogen werden (event-basiert)?
- Welche Möglichkeiten und Tools gibt es?


## Feature Toggling
Ziel: Einen Weg finden, um technische Entwicklungen auf Service-, System- oder gar Domainebene einzeln zu de-/aktivieren.

##### Fragestellungen:
- Gibt es Use Cases, in denen man Features Domain-weit umschalten können muss?
- Welche Techniken & Tools gibt es hierzu?