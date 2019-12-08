# Austausch / Feedback subscription solution

## Business Vision

### Ausblick subscription solution

=> [Go-To-Market Strategy](./sources/~$Go-To-Market%20Strategy.pptx)

### Forrester

- Reporting
- Globalisierung
- ...

### Business Canvas

=> [Business Model](./sources/Subscription%20Platform%20Business%20Model.pptx)

### Competitors

> Vergleich mit Recurly, Chargebee und  

---

#### Recurly

- keine Globalisierung e2e (E-Mails, Pflegbarkeit Translations generell)
- Emails nicht anpassbar
- Webhooks (Retries, Übersichtlichkeit was wann wie wo)
- sehr eingeschränktes Reporting / Reportingunterstützung

#### Chargify

- Konzept der "Sites"
- => eine Site pro Währung
- => eine Site pro Tax-Category
- ein billingTerm == Produkt
- nur ein single Plan signUp (hosted)
- sehr sehr mageres Reporting

#### chargebee

- UX Reporting
- managen von Plänen sehr unübersichtlich, da zig Pläne (billingTerm, Währung, ...)
 
### Zielgruppe

- eine ganz andere als E-Commerce
- service-provider
- subscription solution == SaaS, self-signup, self-management
- customer centric
- CLV: => retention, growth, cross... 

### Marktfeedback

**Echosec**

- nutzen aktuell Stripe
- haben zuvor Recurly genutzt

Probleme:

- das Reporting von Recurly hat ihnen keine / keine ausreichende Unterstützung geboten
- => !Daten extrahieren, konnten somit nicht sharen
- => sehr unzuverlässlich in der Berechnung selbst
- => kein Payment bezogenes Reporting

Missing:

- unterschiedliche Trail Laufzeiten testen können
- einfache Anpassung / Pflege der Produkte / Pläne - Preise ändern, Coupons, ...

**Printavo**

- nutzen aktuell Stripe

Probleme:

- aktuell geringe Internationalisierung, weitere Schritte in diese Richting mit Stripe quasi ausgeschlossen

Missing:

- A/B Testing bzgl. Preisen
- kein Acquisition cost tracking

**Generell**

- John war auf einigen Subscription orientieren Konferenzen
- sehr positives Feedback und inzwischen zig Kontakte die im Grunde das gleiche / ähnliches berichten:
    - wir nutzen gerade Stripe und kommen nicht weiter
    - eure Idee, ein gesamtheitlichen Service anzubieten, der verschiedene Services (welche eigens für bestimmte Probleme großartig sind) miteinander verbindet ist genau das was wir suchen
    - APIs!!

## Organisationsstruktur

- Erfahrungen der Vergangenheit (Cloud, AOE, myAccount, E-Commerce, ...)
    - Wer kann im API first Ansatz Feedback zu Features geben? Wie wird dieses Feedback ins Team getragen?
    - Bei dem Ansatz "layered" Teams (Backend / Frontend) mussten wir die fachlichen Themen 2 mal durchdringen; dabei haben wir dies unterschiedlich bewertet / priorisiert
    - => starke Kopplung / Abhängigkeiten von nutzbaren Features zwischen n Teams
    - => hoher Abstimmungsbedarf
    - Anforderungen an fachliches Know-How eines Teams sind sehr schnell sehr stark angewachsen
    - es war / ist sehr schwer personell zu skalieren
    - es war / ist schwer neue Leute einzuarbeiten (fachlich)
- => Vertikalisierung
    - DDD !
    - 4 business Teams die jeweils eigene Fachbereiche ownen (Stammdatenpflege, Neukundengeschäft, Bestandskundengeschäft, Reporting, ...) => je nach Anforderungen beliebig erweiterbar und personell skalierbar (neue Teams...)
    - PaaS (Infrastruktur, Platform-services (CD Pipeline, Logging, Metriken, ...))
    - OGs (Architektur, Frontend, Qualität, Product)
- technische Architektur von fachlicher Architektur abgeleitet
    - auf Grund der Erfahrungen => unabhängige Teams in eigenen Fachbereichen
    - Kommunikation über Event-Bus, Daten-Sync, keine "Verdrahtung" über APIs
    - Hauptziel: möglichst unabhängig Features e2e ausliefern können (Makro-Architektur)
    - jedes Team...
        - kann eigenständig und unabhägig ausrollen
        - trägt die Ownership in seinem Bereich
        - kann sich auf seinen fachlichen Bereich fokussieren und findet so die beste Lösung für die jeweiligen Marktanforderungen

## Feedback

### technisch

- sehr viel Technik für wenig Problem (domain event bus, unterschiedliche Datenbanken, unterschiedliche Programmiersprachen)
    - wenig Problem?
    - ja, ist so => Ziel ist es natürlich nicht zu weit auseinander zu laufen und viel voneinander zu profitieren, gehen jedoch den Ansatz: möglichst bestes Tooling für ein bestimmtes Problem
    - möglichst viel Infrastruktur als Service (AWS)
- full reload + redirects
    - ja, ist so 
    - => Vision (composing) 
    - => aus client-user Sicht (gefühlt) eine SPA
    - => aus customer-user Sicht flexible Möglichkeiten der Visualisierung ("one-pager")
- bundle size / Ladezeiten
    - aktuelle improvements darstellen (splitting, imports optimiert, fonts extrahiert)
    - natürlich noch nicht ausreichend (CDN, weitere komprimierung)
    - gerne seine Tips!
- server side rendering
    - **TODO**
        - Was genau ist / macht server-side rendering?
        - Vorteile zu dem Vorgehen von aktuell?
        - ggf. Jan / Sabrina ansprechen
- PWA
    - Was sind in unserem Fall gute Anwendungsbeispiele?
- Layout / Responsiveness
    - keine Prio bisher
    - => Q3,Q4 geht es mit stärkerem Fokus hier voran
    - Desginer wird engagiert, welcher nach UX Überarbeitung aufhübscht
- material-ui / material-design
    - UX Experte engagiert, welcher UX Vorschläge unterbreitet hat => werden zeitnah eingearbeitet
    - breaking changes sind uns bewusst (material-ui), switchen aktuell auf v1
    - bisher haben wir eher material-design gezielt eingesetzt => Welche besseren alternativen gibt es?
- alpha Version
    - derzeit befinden wir uns im alpha stadium
    - Bewusstsein für Softwarequalität natürlich vorhanden, Anspruch an Bug-Freiheit wächst stetig (vor allem im Hinblick MVP Juni, MMP Februar)
    - wir führen mehrere Environments ein => Aufbau einer CD pipeline
    - wir fügen kontinuierlich quality gates hinzu (license, security, System- + Plattform-tests, (Last...))
- APIs
    - bisher kein Fokus, ist im nächsten Milestone recht hoch priorisiert
    - orientieren und an dem Marktfeedback (in unserer Zielgruppendefinition) und Anforderungen der EAP Feedback Clients    
- Customization
    - es gibt bereits erste Möglichkeiten die signup pages im look und feel des Clients zu gestalten
    - je nach Prio wird dies weiter ausgebaut (offen zB Emails, ...) - konkurriert mit APIs
    - aktuell unterstützen wir 2 signup-flows, weitere folgen
    - Was vermisst / erwartet man bzgl. signup / customization?

----

- Integrationsmöglichkeiten (keine schlafenden Hunde wecken :-))
    - hosted pages
    - webhooks
    - Adapter bieten, mit welchen sich Client mit seinen User-Datenbanken andocken kann

### funktional

- Filtern / Sortieren
    - Prio / Zeit
- Pagination
    - Prio / Zeit
- Sprache
    - client-facing: ja, englisch aktuell gesetzt -> irgendwann vielleicht schon
    - customer-facing: wir unterstützen bereits mehrere Sprachen, welche end2end durchgezogen werden (anders als bei den competitors)
- unklarer Sinn des Produktes / usp? (nur eine Bridge Stripe <==> ChartMogul)
    - ergibt sich hoffentlich aus der Produkt-Vision
    - Feedback John (weg von Recurly weil..., hinzu Stripe und jetzt unsere Vision -> findet sehr großen Anspruch)
- Payment Provider Integrationen
    - mehrere geplant, jedoch zuvor e2e Customer lifecycle
- APIs
    - siehe oben
- Customer Care
    - je nach Marktfeedback in Aussicht (ist nicht unbedacht, jedoch aktuell nicht priorisiert)
- Competitors
    - Welche Anbieter hast du bereits eingesetzt / genutzt?
    - Welche Konzepte fandest du bei x besser als du gerade bei uns siehst?
    - Was wäre denn deine Prio? => Was sollte man aus deiner Sicht als nächstes (technisch und fachlich) am stärksten pushen?
