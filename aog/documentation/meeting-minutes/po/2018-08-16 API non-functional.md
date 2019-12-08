# Meeting Minutes

## signup API

### Anforderungen

- API für den Signup
- API um Pläne / Offers anzuzeigen
- API für das "Verwalten" der Subscription (Lifecycle API)
	- canceln
	- payment profile aktualisieren

### Wer ist für welchen Part verantwortlich?

- Variante A (Eingangspunkt für den Signup ist NBS)
	- client kann Offers konfigurieren
	- fragte alles rund um die Offer via API ab (beinhaltet alle Pläne, Preise, Beschreibung, ...) was zu dem Offer konfiguriert wurde
	- Client schickt dann API call zu NBS um Subscription zu starten
	- NBS kümmert sich um die "Verteilung" zu den anderen Systemen (EBS, IDH, ...)

- Variante B (Eingangspunkt für den Signup ist EBS)
	- client bildet das Offers Konstrukt selbst ab (sofern notwendig)
	- client fragt via API alle Pläne ab die er benötigt (beinhaltet ebenso Preise, Beschreibung, ...)
	- client schickt API call zu EBS um subscription zu starten
	- EBS kümmert sich um die "Verteilung" zu den anderen Systemen (IDH, ...)

### next steps

1. AOG analysiert Variante A
	- Wie können Payment Daten eingesammelt werden? (non-PCI)
	- uU berücksichtigen das in der ersten Iteration nur trial-only angeboten wird (PaymentProfile später erfassen)
	- den Client auch die Möglichkeit bieten spezifisch die unterschiedlichen signup flows zu nutzen
	- Erkenntnisse mit POG sharen
	- API zur Abfrage aller Offer Informationen (Preise!? -> was benötigen wir dafür vom Client)
	- Authentifizierung!? (API Token)
2. Iterationen Schneiden
3. Abschätzen welcher Scope für Customize machbar ist

### Dokumentation

- Maria koordiniert mit QOG und Technical-Communication
- Anforderung: keine manuelle Dokumentation -> sollte immer anhand des aktuellen Standes up-to-date sein

## Lifecycle API

- weniger wichtig als signup API... später
- gerne jetzt bereits mal vordenken (Authorisierung)

## non-function requirements

- @POG kommt auf AOG zu und schickt Liste mit aus ihrer Sicht noch offenen / abgestrichenen Items

## Was erwartet uns in Customize?

- @AOG: der etwas größere Blick... (Was ist noch offen, um vernünftig zum general Release aufgestellt zu sein; SLA, Bereitschaft, Infrastruktur, ...)
- @POG: gleiches Thema

## Rollout Prozess

- @POG: sharen was sie sich bereits hierfür Gedanken gemacht haben
- @POG: Ownership um die Definition / Abstimmung vom Gesamtprozess abzustimmen
