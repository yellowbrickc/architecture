# Continious delivery - kick-off 25.01.2018

---

**Our goal: Wir wollen uns von derzeit CI hinzu CD entwickeln.**

---

## Ziel des kick-offs

- alle abholen und mit zu lösenden Problemstellungen vertraut machen
- aktuellen Stand der Erkenntnisse sharen
- Wer kann zu welcher Fragestellung beitragen (Teams, Gilden, ...)?
- Plan für weiteres Vorgehen

## Problemstellung

1. @AOG: Wie sieht unser avisierter Entwicklungsprozess / Workflow / Verantwortlichkeiten (was können/dürfen/sollen Teams / PaaS) aus?
2. @QOG: Welche Quality Gates müssen vor dem Ausliefern durchlaufen werden?
3. abhängig von 1,2: Welche steps sind automatisiert, welche manuell?
4. Unterscheidende Anforderungen (etwa Unterscheidung zw. UI / Backend, oder unterschiedliche Frameworks / Programmiersprachen)!
5. Wie können Migrationspfade integriert werden (=> rolling update, zero-downtime deployment)?
6. @Nico -> Anforderungen für 7. - Welche Unterstützung benötigen wir beim Ausrollen von "green-build" orchestrierten Micro-Services?
7. @PaaS, Nico: Welches Tooling benötigen wir / welches Tooling kann uns bei unseren Anforderungen bestmöglich unterstützen?
8. @Nico -> Anforderungen für 7. - Rollback
9. @PaaS: Rollout von Infrastrukturänderungen?

## Subscription Plattform - CD Übersicht (nur ein draft :-)

![pipeline](sub.rocks-cd/sub.rocks-cd.png)

## Tooling - GoCD

=> [GoCD Website](https://www.gocd.org/)

![pipeline](https://docs.gocd.org/current/resources/images/home-image1.png)

### Get ready (OSX)

- download von Agent und Server und nach `/Applications` kopieren
- zum bootstrappen am besten als aktuell angemeldeter User starten

    
    cd /Applications
    open -a Go\ Server
    open -a Go\ Agent

### Key-Features (see [Why GoCD?](https://www.gocd.org/why-gocd))

- Man kann sehr frei seine notwendigen Pipelines definieren
- Vergleich von Pipeline durchläufen (inkl. Darstellung getätigter Änderungen, ob Code oder Pipeline Settings)
- GUI / Übersichtliche Darstellung von Pipelines (inkl. Abhängigkeiten, Status, Progress)
- Parallele Ausführung (innerhalb einer Pipeline)
- Templating (Projekttypen definieren (Node, Scala, SPA, ...), System e2e, ...)
- fan-in / fan-out (zB bedarf es für den nächsten Step mehrere Abhängikeiten)
- config as Source
- Environment / Pipeline gebundene Skalierbarkeit (zB e2e, security tests, ... dürfen Pipelines für schnelles Feedback nicht verlangsamen)
- [Plugin System](https://www.gocd.org/plugins) (zB LDAP, AWS, Gitlab, JIRA, Notifications (AWS SNS, Slack, Email, Sockets, ...), Package-Manager (NPM), ...) => **profit from the community! :-)**

### Begrifflichkeiten

#### Tasks 

- ein spezifisches shell command 
- z.B. `docker build`, `docker push`, `pushd`, `print`

![tasks](https://docs.gocd.org/current/resources/images/concepts/01_task.png)

#### Jobs

- besteht aus 1-n Tasks, welche in definierter Reihenfolge ablaufen
- sofern ein Task innerhalb eines Jobs failed, failed der Job -> nachfolgende Tasks werden nicht mehr ausgeführt
- sofern etwas failed, kann man clean-ups folgen lassen
- z.B. `build_docker_image`, `tag_docker_image`, `pull_docker_image`, `push_docker_image`

![jobs](https://docs.gocd.org/current/resources/images/concepts/02_job.png)

#### Stages

- besteht aus 1-n Jobs, welche parallel und unabhängig voneinander laufen
- sofern ein Job innerhalb einer Stage failed, failed die Stage -> alle anderen Jobs werden bis zur Beendigung durchlaufen 

![stages](https://docs.gocd.org/current/resources/images/concepts/03_stage.png)

#### Pipelines 

- besteht aus 1-n Stages, welche in definierter Reihenfolge ablaufen
- sofern eine Stage innerhalb einer Pipeline failed, failed die Pipeline -> nachfolgende Stages werden nicht mehr ausgeführt

![pipeline](https://docs.gocd.org/current/resources/images/concepts/05_pipeline_small.png)

#### Materials

- sind im Grunde Trigger, welche eine Pipeline zum Rennen bringen
- idR ist das die Source-Verwaltung (GIT), kann aber auch zB zeitlich gesteuert sein
- eine Pipeline kann mehrere Materials haben
- eine Stage einer Pipeline kann ebenfalls als Material agieren

![abc](https://docs.gocd.org/current/resources/images/concepts/11_pipeline_deps_2.png)
![def](https://docs.gocd.org/current/resources/images/concepts/12_pipeline_deps_3.png)

#### Fan-out

- die Stage einer Pipeline löst mehrere andere Pipelines aus (zB wenn Änderungen an der cleverbridge-ui, alle nutzenden Apps werden neu gebaut und Änderungen automatisch nachgezogen (benötigt natürlich die Tilde in der package.json))

![fan-out](https://docs.gocd.org/current/resources/images/concepts/14_fanout.png)

#### Fan-in

_Fällt mir gerade kein sinnvoller Anwendungsfall ein_

![fan-in](https://docs.gocd.org/current/resources/images/concepts/13_fanin.png)

#### Abweichung von aktuell

- Jobs laufen parallel innerhalb einer Stage, unser aktuelles Konzept sieht eine klare Reihenfolge vor (zB Stage "build" => ... create-image ... => build_, tag_, ..._docker)
    
