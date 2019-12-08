# Client integration

Ausgangslage:

- Pläne werden bei uns angelegt und gepflegt!

Fragen:

- Wer ist der owner des Users?
- Wie erfolgt der Austausch über User-Informationen?
- Wann erfolgt der "Grenzübertritt" (client system -> subscription platform)

**client owned den user**

Scenario 1: User registriert sich auf der Website des Clients, legt dort ein Kundenkonto an und nutzt die hosted pages

Scenario 2: User registriert sich auf der Website des Clients, legt dort ein Kundenkonto an und nutzt die API

Scenario 3: User registriert sich für eine trial auf der Website des Clients und legt dort ein Kundenkonto an

**social media owned den user**

## API vs. hosted pages

- Erfassung von Payment Daten (wie im API Ansatz?) => muss der Client hier auf eine hosted page leiten (falls ja, wie sieht die aus? :-))? 
- Kann es einen hybriden zwischen API und hosted page geben?
- Unsicherheit und Risiko bei API Ansatz deutlich größer (Authorisierung, Dokumentation, Split von Zuständigkeiten auf verschiedene Systeme, NBS entfällt hierbei komplett?)
- Aufwand für Client bei API Ansatz deutlich höher (signup, upgrade, downgrade, review pages, ...) und wohl auch bei uns (Support des Clients)
- bei API Fokus: wie schaffen wir es hierbei proaktiv ein Produkt zu entwickeln (Vergleich Cloud: API ohne die Prüfung der Nutzbarkeit)
- bei API Ansatz kein Tracking möglich -> Analyse des Customer zum Optimieren der Conversion liegt komplett beim Client
- bei API Ansatz kein A/B Testing Support möglich (MVT)
- bei API Globalization nur eingeschränkt (keine Übersetzungen)
