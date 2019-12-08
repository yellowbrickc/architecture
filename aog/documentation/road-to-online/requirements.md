# Scope

Diese Dokument beschreibt nicht-funktionale Requirements welche vor einem Onlinegang implementiert und getestet werden müssen.

Onlinegang bedeutet insbesondere dass

1. auf die Subscription Platform direkt vom öffentlichen Internet aus zugegriffen werden kann, und dass
2. nicht-cleverbridge Mitarbeiter ("Clients") Zugangsdaten zu dem admin-Bereich bekommen, und dass
3. die Clients Test-Signups mit echten Personendaten und echten Kreditkarten durchführen.
4. echte Customer mit echten Personendaten/Kreditkarten echte Signups durchführen.

# Requirements
  
## Embargoed Countries

Anforderung: Der Zugriff auf die gesamte Platfom darf nicht aus einem Embargoed Country erfolgen

ToDos:

- Blockieren des Client Logins (**CCC in Abhängigkeit vom ersten Wurf der Blackies**)
- Blockieren von Customer Seiten (**alle die Customer Seiten ownen**)
	- ThankYouPage
	- Receipt
	- ContractCancel
	- UpdatePaymentProfile
- Validierung ob mit Ingress-Umstellung IP-Addresse korrekt erkannt wird (**Black**)
      
## Absicherung aller Informationen

Anforderung: Nur Nutzer mit gültigen Zugangsdaten können auf die Plattform zugreifen

ToDos:

- Invalide User dürfen nicht authorisiert werden (**CCC**)
- Absicherung der Customer-Seiten und Zugriffen (z.B. cancel subscription, change payment) (**Contractors**)

## Autorisierung auf Customer-Ebene

Anforderung: Ein Customer darf ausschließlich auf seine eigenen Daten zugreifen
  
## Logging

Anforderung: Es dürfen keine sensiblen/personenbezogene Daten geloggt werden

ToDos:

- Anynomisierung aller Log-Nachrichten (**Loggen von Kafka Validation Errors ohne Payload**)

## Browser-Kompatibilität

Anforderung: genaue Definition noch unklar (was erwarten wir bis zum EAP/MVP)

ToDos:

- @FOG: Requirements für MMP ermitteln + timeline (https://git.sub.rocks/fog/cleverbridge-ui/wikis/Browser-compatibility)

## Tracking

Anforderung: Clients müssen sich des Trackings bewusst sein

ToDos:
- Check ob Tracking in den TaC aufgeführt wird (wartet auf TaC von Legal)

## Audit

Anforderung: Noch unklar, Audit-Vorbereitungs-Termin wird von Vincent koordiniert

## Security Analyse

Anforderung: Das System soll regelmäßig auf Sicherheitslücken kontrolliert werden

ToDos:

- Winnie führt einen "manuellen" Sicherheitstest durch (**@Krisztina**)
  
## SDN-Screening / Terrorlisten

Anforderung: Der Zugriff auf die Platform darf nicht von einer Person erfolgen welche das SDN-Screening nicht besteht

ToDos:

- alle Seiten, welche personalisierte Daten erfassen (customer- und client-facing), gemäßg SDN Absichern -> Business-Feature -> @POs

## Konsistente Löschung Personenbezogener Daten

Anforderung: Bei Bedarf müssen sämtliche personenbezogenen Daten aus dem System gelöscht werden

ToDos:

- Feature für das Löschen/Anonymisieren von Customerdaten 
- Feature für das Löschen/Anonymisierung von Clientdaten

-> Business-Feature -> @POs

Offen:

- Muss man auch Backups rückwirkend löschen?
- @Istvan: In cleverbridge erarbeitetes Dokument zur Löschung personenbezogener Daten sharen.