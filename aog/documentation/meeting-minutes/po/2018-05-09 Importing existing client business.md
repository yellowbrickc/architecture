# Importing existing client business

## Teilnehmer:

- Sören, Oli
- CCC
- Contractors

## Vorbedingungen

	- existierendes Business-Modell ist bei uns abbildbar
	- Client mapped seine Kunden auf unsere (bereits vorher)
	- existierende Pläne
	- der Client hat sein existierends Business in Stripe
	- wir importieren nur bezahlte Subscriptions
	- (sofern notwendig) wurde der Customer vorher informiert das seine Daten migiriert werden

## Steps

### 1. Client definiert alle mögliche Plan-Varianten in unserem System

### 2. Client erstellt Export seiner Customer Daten mit mindestens folgenden Daten

	- Vorname
	- Nachname
	- Email
	- Adresse
	- (external customerId)
	- ...

### 3. Client erstellt Export seiner Subscription Daten mit mindestens folgenden Daten

	- (external customerId)
	- paymentProfileId (irgendwie Referenz auf Stripe)
	- aktueller Zustand der Subscription

## Emailing

	- den Customer nicht informieren, außer der Client will das unbedingt
	- alle anderen Emails (Cancel confirmation, Payment succeeded) werden 

## Reporting

> keine historische Daten

	- es gibt keine conversion reports
	- es werden uU Reports verfälscht

## Offene Fragen?

	- Soll es einen Test vorher geben?
	- Wollen wir historische Daten ermöglichen? (Sören: nächste Iteration) => ergbit mehrere Folgeprobleme: Reporting, Wert der Subscription
	- Wollen wir trials unterstützen? (Sören: wichtig auch erstmal bezahlte Subscriptions, aber auch denkbar für weitere Iterationen)
	- Wie können wir es unterstützen, wenn der Client aktuell nicht Stripe nutzt? PCI? 
	- Muss der Customer TaC neu aktzeptieren?
