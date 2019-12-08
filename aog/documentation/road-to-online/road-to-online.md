# Road to Online

## Development

**Bereitstellung: 07. März 2018**

- Vollständige Umstellung des Development-Environments zu AWS
- Teams müssen Configmaps, Secrets etcpp bereitstellen
- Restliche Jobs von mole.cgn.cleverbridge.com müssen zu AWS migriert werden

## Alpha

**Bereitstellung: März 2018**

**Annahmen / Fakten müssen klar intern und extern und ggf. innerhalb der Software kommuniziert werden**

- Stellt den aktuellen Stand der Software und Infrastruktur dar
- Dient dazu, Prospects die Platform zu zeigen und bestmöglich zu "echten" Clients zu konvertieren
- Feedback der Prospects soll eingeholt werden
- Spielwiese
- Kein garantierte Uptime
- Keine Bereitschaft / SLA
- Keine Lasttests
- Keine garantierte Performance
- Daten sind persistent, aber keine Backups
- Dient als kontinuierliche Annäherung an das Production-Environment (Software, Infrastruktur, Auditing, Security...)
- KEIN echter Geldfluss

## Production

**Bereitstellung: ~Juni 2018**

- Echtes Production-Environment
- Echter Geldfluss
- Auditing
- Security
- Monitoring
- Uptime
- Backups
- Failover
- Keine Migration von Alpha-Environment-Inhalten - fängt bei 0 an

[Liste der non-functional requirements](./requirements.md)