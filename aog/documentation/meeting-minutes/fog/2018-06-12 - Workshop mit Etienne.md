# FOG workshop

## Erfahrungen bei der Metro

### Erfahrungen mit SCS

- löst sich von self-contained systems!?
- dev-Ops team arbeitet ebenfalls in verticals (Cassandra, K8s, CI, ...)
- Plattform für Entwickler wird aus mehreren UI Fragmenten zusammengesteckt
- Vertikalisierung ist mit wachsenden Anforderungen abgeändert worden (anderer Tech-Stack - REACT in bestehendem Go Tech-Stack)
- error budget
	- unkritische Dinge dürfen auch mal down sein
	- minimiert Kosten für eben diese Services
	- soll auch genutzt werden (zB beim rollout, oder auch bei der Weiterentwicklung -> worauf legt man Prioritäten)
	- zB bei "nur" 99% 88h downtime erlaubt

### ... nun "neue" Architektur

- NEIN! Gleiche Architektur, nur besser gelöst -> genau wie bei uns! :-)

### Plattform App

- nur ein Token für die komplette App (IDP as Service)
- Menu als Komponente
- Menupunkte als eine API (Abhängigkeit in Kauf genommen) - noch seeeeehr am Anfang, wird nicht tragen sobald neue / mehr Teams hinzukommen
- page reload, Wechsel der Apps

## Fragen

- Was genau war diese horizontale Kopplung? (SSI)
- Sieht unterschiedlich aus (Abstimmung zwischen Teams - nicht gelöst)

## nice-to knwo / to-read

- REACT -> static pages (typ)

## Spike custom Elements

Fragen:

- Was passiert wenn das upstream custom element nicht da ist?
- Haben wir wirkliche Isolation (vendoring)?
- Sharen wir vendors? => custom-elements möglichst klein halten?

## Spike multi Forms

Fragen:

- Wie erreichen wir, dass verschiedene Forms state (mit-)teilen?
- Wie kann der owner den submit flow kontrollieren?
- Wie validieren wir? Jede Form für sich vs. globale Validierung?


Fragen:
- Kann man das Theme beim Owner definieren und findet es auch im Fragment Anwendung?
- Wie kann man 

**Erkenntnisse**

- owner kann / sollte eine min-height mitgeben (vermeidet uU springen)
- custom element kann Skeleton definieren, bzw. sofort mit Anreichern der DOM und ggf. Spinner darstellen
- Responsiveness muss später gezielter betrachtet werden; Idee: maximal die breite vom owner mitgeben, custom element geht damit um
- das vom owner angewandte Theme sollte auch von den Fragmenten benutzt werden

- custom element sollte selbst Spinner / Ladefortschritt Anzeigen mitbringen (muss natürlich einheitlich sein)
- Rückmeldung an den owner
	- Event das die Initialisierung meldet (aus der erfolgreich geladenen App heraus) - owner setzt auf Eintreffen ein Timeout
	- Owner versieht custom element mit CSS, welches nur angezeigt wird, wenn die DOM noch nicht angereichert wurde (man bekommt aber so nicht mit, wenn zB das App Bundle nicht geladen werden konnte)
	- bei der custom element Definition (connectedCallback) wird ein Event geschmissen, welches signalisiert das Element erfolgreich initialisiert (man bekommt aber so nicht mit, wenn zB das App Bundle nicht geladen werden konnte)

## Fazit

- server-side rendering zunächst out-of-scope

### Thema 1 (composing mittels Custom Elements)

- WebComponents ist das Tool für UI-Composing
- vendors werden ausgelagert (common vendor)
- REACT ist grundsätzlich kein Problem für diesen Ansatz
- REACT lässt sich innerhalb einer Major problemlos vendoren

### Thema 2 (Navigation)

- Navigation braucht einen Owner
- die Art und Weise wie Menüpunktänderungen erfolgen können, kann auf verschiedene Art und Weisen erfolgen; entscheidend ist, dass die Pipeline automatisch diese ausrollt
- es spricht nichts dagegen, dass Navigation als Custom Element eingebunden wird
- Überdenken: muss Navigation REACT sein? Könnte auch viel schlanker...

### Thema 3 (Kommunikation zwischen owner und fragmenten)

- serverseitige Kommunikation nicht betrachtet
- besondere Aufmerksamkeit bei security erforderlich

- keine CustomComponent übergreifende Event Konsumierung
- Schnittstelle von CustomEvents besteht aus Attributen, Triggern, Events
- es wäre erstrebenswert besseres Tooling zu finden, welches das Handling vereinfacht
- Formübergreifende Kommunikation über den owner erfolgt (event-driven)
- Submit-Event propagierung über exposte Handler der einzelnen Komponenten funktionieren (siehe sample) - Offen: Gibt es Möglichkeit das (zB submiten) auf andere Art und Weise zu realisieren
- client-seitige Validierung erfolgt innerhalb der Elemente, owner betrachtet dies als black-box
- gesamtheitliche Fehler von Komponenten werden propagiert, der owner entscheidet wie er damit umgeht
- owner steuer / legt den (submit-)Fluss

## Next steps

- Menü oder Reporting wäre gute samples um Proof umzusetzen
- @CCC: mit Olli besprechen, ob wir die Ownership für das Menü übernehmen und daraus eine custom component bauen
