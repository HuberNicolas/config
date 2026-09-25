---
name: publish-repo
description: Bring an old student, course or thesis repository into shape so it can be shared publicly on GitHub - make it run again with its original versions (no modernising unless asked), clean it up, check secrets and data licenses, write README with badges, docs, TODO.md and a license. Also covers publishing texts: thesis LaTeX sources (e.g. Overleaf exports), course summaries and notes, as separate repos with a PDF build. Use when the user wants to publish, clean up or "in Schuss bringen" one of their old repos, theses or course materials.
argument-hint: "[Kontext: Projekt, Hochschule, Jahr, Besonderheiten]"
---

# Studenten-Repo in Schuss bringen und veröffentlichen

Der Nutzer macht seine früheren Studien- und Abschlussarbeiten nach und nach öffentlich zugänglich. Die Repos gibt es
meist schon (lokal und oft auf GitHub, vielleicht privat). Es geht **nicht ums Modernisieren**, sondern darum, die
Arbeit von damals in Schuss zu bringen: Sie soll laufen, verständlich dokumentiert und sauber sein. Dass der Stack
veraltet ist, ist in Ordnung und darf in der README ehrlich stehen (z. B. „Built in 2021 with Vue 2; the dependencies
are pinned to that time.“).

Arbeite das aktuelle Repository Schritt für Schritt mit dem Nutzer durch, nach den Regeln und Phasen unten.

**Kontext vom Nutzer:** $ARGUMENTS

Fehlt Kontext (Projektart, Hochschule, Jahr, Autor, Betreuer), leite ihn aus dem Repo ab (Git-History, Dokumente,
Arbeit als PDF) und frag nur nach, was sich nicht ableiten lässt.

## Grundregeln (gelten immer)

1. **Nichts löschen, was nicht wiederherstellbar ist.** Originaldaten, Datenbanken, Dumps, `data/`-Ordner, Branches und
   untracked Dateien fasst du nicht an, bevor ich zugestimmt habe. Veraltetes, das weg soll, schiebst du zuerst auf
   einen Archiv-Branch oder in einen Ordner ausserhalb des Repos, den ich nenne.
2. **Keine echten Daten in Tests.** Tests und Probeläufe machst du in einer isolierten Umgebung (eigenes Docker-Netzwerk,
   eigene Container und Ports, Kopie des Repos im Scratchpad), nie gegen meine laufenden Datenbanken.
3. **Laufen lassen vor Modernisieren.** Ziel ist, dass das Projekt mit den ursprünglichen Versionen wieder startet und
   funktioniert. Pakete, Frameworks und Sprachversionen upgradest du **nicht** auf den neuesten Stand, ausser ich
   verlange es ausdrücklich. Lockfiles bleiben massgeblich (`npm ci`, `poetry install`, …). Wenn ein Upgrade nötig ist,
   damit es überhaupt läuft, fragst du vorher und erklärst warum.
4. **Nur behaupten, was geprüft ist.** Jede Aussage in der Doku (Befehle, Pfade, Ports, Optionen, Env-Variablen,
   Statuscodes) prüfst du gegen den Code oder durch Ausführen. Was du nicht ausführen konntest, sagst du mir.
5. **Commits:** klein und thematisch, Betreff im Imperativ auf Englisch („Fix …“, „Add …“), bei Bedarf mit einem Body,
   der das Warum erklärt. **Kein `Co-Authored-By`-Trailer, Claude nirgends erwähnen**, `.claude/` nicht in die
   `.gitignore` aufnehmen. **Nie pushen, ausser ich sage es.** Neue Repos erstellst du nur auf meine Anweisung;
   meistens gibt es das Repo schon.
6. **Autor-Adresse:** Meine Hochschul-E-Mail (z. B. `nicolas.huber2@uzh.ch`) ist nicht mehr gültig. Neue Commits laufen
   unter `nicolas.huber.dev@gmail.com`. Prüfe vor dem ersten Commit `git config user.email` (auch lokale
   Repo-Konfiguration). Commits, die noch nie gepusht wurden, darfst du vor dem ersten Push auf diese Adresse
   umschreiben; bereits gepushte nur mit meinem Go (Force-Push), am besten zusammen mit einer ohnehin nötigen
   History-Bereinigung.
7. **Kosten und Aussenwirkung:** Alles, was Geld kostet (LLM-APIs, Cloud) oder nach aussen wirkt (Repo erstellen,
   pushen, History umschreiben, force-push), nur nach meiner ausdrücklichen Zustimmung.
8. **Sprache:** Mit mir sprichst du Deutsch. Alles im Repo (README, Doku, Kommentare, Commits) schreibst du auf
   Englisch: klar, kurz, aktive Sätze, keine Marketing-Floskeln.
9. **TODO.md pflegen:** Offene Punkte kommen in `TODO.md` (siehe unten). Nach jeder Phase aktualisierst du sie.

## Phase 1: Verstehen und Bestandsaufnahme (noch nichts ändern)

- **Doppelte Kopien zuerst klären:** Liegen mehrere Klone oder Kopien desselben Projekts vor (z. B. `repo` und
  `repo_old`), vergleiche Remote, Commits, uncommittete Änderungen und Dateien (`git log`, `git status`, `diff -rq`
  ohne `.git`/`node_modules`/DB-Daten). Bestimme den massgeblichen Stand und prüfe, ob in den anderen Kopien etwas
  liegt, das dort fehlt. Die anderen Kopien fasst du nicht an.
- Lies den Code: Struktur, Stack, wie es gestartet wird (Docker Compose, Skripte, Env-Dateien), wie die Daten
  entstehen.
- Finde Altlasten: doppelte oder verwaiste Ordner, tote Services, kaputte Imports, Dateien, auf die nichts verweist.
- **Sensible Inhalte:** Secrets (API-Keys, Passwörter, Tokens, `.env`-Dateien) im Arbeitsverzeichnis **und in der
  gesamten Git-History**, fremde oder institutionelle Daten (z. B. Publikationen, Personendaten, Notebook-Ausgaben mit
  echten Daten), echte E-Mail-Adressen. Zeig mir Fundstellen nur maskiert. Alte E-Mail-Adressen von mir (z. B. die
  Uni-Adresse in `pyproject.toml`, `package.json` oder Commit-Metadaten) sind kein Geheimnis, werden aber vor dem
  Veröffentlichen ersetzt (siehe [Commit-Autor und E-Mail](#commit-autor-und-e-mail)).
  Meine eigene Studierenden-ID bzw. Matrikelnummer, mein Name auf Abgaben und Kursnummern sind kein Problem und
  dürfen stehen bleiben. Die Datensätze eines Kurses prüfst du trotzdem wie alle anderen Daten (Herkunft, Weitergabe).
- **Daten prüfen** (auch wenn sie harmlos wirken, z. B. ein Kaggle-Datensatz): siehe
  [Datenprüfung](#datenprüfung) unten.
- Gib mir eine kurze Übersicht auf Deutsch: Was ist das Projekt, was läuft vermutlich nicht, was ist heikel, und
  einen Vorschlag für die Reihenfolge. Frag mich dann nach den Entscheidungen, die nur ich treffen kann.

### Datenprüfung

Suche alle Daten im Repo und in der History: Dateien wie CSV, JSON, Parquet, Excel, SQL-Dumps, Bilder, Archive,
Modelle, aber auch Daten in Notebook-Ausgaben, Plots (z. B. Plotly-HTML mit Hover-Texten), Fixtures und Tests. Für
jede Quelle erstellst du eine Zeile in einer Tabelle:

| Datei / Ort | Herkunft | Lizenz / Nutzungsbedingungen | Weitergabe erlaubt? | Personendaten? | Grösse | Vorschlag |
|---|---|---|---|---|---|---|

Prüfe dabei:

1. **Herkunft:** Woher stammen die Daten (Kaggle, ESA/Gaia-Archiv, Hochschule, Firma, selbst erhoben, generiert)?
   Suche nach Hinweisen im Code (Download-URLs, Notebook-Zellen, Kommentare, READMEs). Wenn unklar, frag mich.
2. **Lizenz und Bedingungen:** Welche Lizenz hat die Quelle (z. B. die auf der Kaggle-Seite angegebene Lizenz, CC BY,
   CC BY-NC, ODbL, „nur für Wettbewerbszwecke“, Nutzungsbedingungen eines Archivs)? Viele Quellen verlangen eine
   **Quellenangabe oder Zitation** (z. B. die ESA für Gaia-Daten). Gib an, wenn du die Lizenz nicht sicher bestimmen
   kannst, statt zu raten.
3. **Weitergabe:** Darf der Datensatz im Repo mitveröffentlicht werden, oder nur die Analyse? Wenn Weitergabe nicht
   erlaubt oder unklar ist: Daten aus dem Repo nehmen und stattdessen ein Download-Skript oder eine Anleitung mit
   Link zur Originalquelle anbieten.
4. **Personendaten und Vertrauliches:** Namen, E-Mails, IDs, Standorte, Freitexte über Personen, interne Daten
   einer Hochschule oder Firma. Solche Daten nie veröffentlichen; Alternative vorschlagen (Anonymisierung, Dummy-Daten,
   Generator). Ausgenommen sind meine eigenen Angaben (Name, Studierenden-ID auf meinen Abgaben).
5. **Grösse:** Dateien über 50 MB (GitHub warnt) bzw. 100 MB (GitHub lehnt ab). Vorschlag: Download-Skript, Git LFS
   oder ein Datenrepositorium (z. B. Zenodo).
6. **Abgeleitete Daten:** Auch Ergebnisse, Modelle oder Plots können Rohdaten enthalten (z. B. Titel in Plot-Tooltips,
   Beispiele in Notebook-Ausgaben). Diese gleich behandeln wie die Rohdaten.

Die Quellenangaben kommen danach in die README (Abschnitt **Data** und **Acknowledgements**), mit Link, Lizenz und der
geforderten Zitation.

## Phase 2: Zum Laufen bringen

- Bring das Projekt mit minimalen Änderungen wieder zum Laufen und prüfe es wirklich: Container bauen, API-Endpunkte
  aufrufen, Frontend im Browser öffnen, alle Seiten durchklicken, Konsole auf Fehler prüfen.
- Behebe Fehler, die du dabei findest, und nenne jeden in der Zusammenfassung.
- Geht etwas nicht mehr mit vertretbarem Aufwand (abgeschaltete externe Dienste oder APIs, nicht mehr erhältliche
  Modelle), baust du es nicht neu, sondern dokumentierst es unter **Known issues** und schlägst mir Optionen vor.
- Überflüssiges entfernen (nach Rückfrage): tote Services, ungenutzte Datenbanken, Starter-Reste, doppelte Ordner.
- Wenn Daten nicht veröffentlicht werden dürfen: Schlag einen Weg vor, wie das Projekt ohne sie läuft, z. B. einen
  Generator für einen Dummy-Datensatz (ggf. als eigenes Repo), der nur die externe Quelle ersetzt, damit die
  bestehende Pipeline unverändert nutzbar bleibt. Teste den ganzen Ablauf von Ende zu Ende in der isolierten
  Umgebung.

## Phase 3: Aufräumen und Absichern

- Secrets aus Code und Beispielen entfernen; Beispiel-Env-Dateien (`*.env.example`) mit Platzhaltern anlegen.
- Keine Passwörter oder Tokens in Logs; sinnvolle HTTP-Statuscodes (401 statt 500 bei ungültigem Token o. Ä.).
- Skripte, die beim Import sofort Daten verändern, hinter `main()` und `if __name__ == "__main__":` verschieben.
- API-Sammlungen (Postman o. Ä.) aus `openapi.json` neu erzeugen, ohne Passwörter/Tokens, mit Anleitung zum
  Neu-Erzeugen.
- Build-Warnungen beheben, soweit ohne Upgrades möglich.

### Linter und Python-Umgebung

- **Python: [Ruff](https://docs.astral.sh/ruff/)** als einziger Linter und Formatter (ersetzt Black, isort,
  Flake8). Konfiguration einfach halten, in `ruff.toml` bzw. `[tool.ruff]`:

  ```toml
  target-version = "py3XX"   # die Python-Version des Projekts
  line-length = 120
  extend-exclude = ["notebooks", "data"]

  [lint]
  select = ["E4", "E7", "E9", "F", "I"]   # Fehler, Pyflakes, Import-Sortierung; keine Stil-Modernisierung (kein UP)
  ```

  Vorgehen: `uvx ruff check --fix .`, dann `uvx ruff format .`. Begründete Ausnahmen statt Umbau: z. B. `E402`
  (Skripte setzen Pfade vor Imports), `E711`/`E712` (SQLAlchemy braucht `== None`), `F821` für String-Vorwärtsreferenzen
  in Models/Schemas, `F841` (unbenutzte Variablen) vorerst ignorieren. Unbenutzte Imports nur entfernen, wenn kein
  Seiteneffekt daran hängt (z. B. Registrierung von SQLAlchemy-Models). Jeden echten Fehler, den Ruff findet, einzeln
  beheben und mir nennen.
  Danach prüfen, dass alles noch läuft (Kompilieren, API-Start, Skripte in der isolierten Umgebung), idealerweise
  Ausgaben vorher/nachher vergleichen. Formatierung und Fixes in einem eigenen Commit, damit das Review lesbar bleibt.
- **Frontend:** vorhandenen Linter/Formatter (ESLint, Prettier) benutzen; keinen neuen einführen.
- **[uv](https://docs.astral.sh/uv/)** ist das Standardwerkzeug für Python:
  - Tools ohne Installation ausführen: `uvx ruff …`.
  - Fehlende alte Python-Versionen installieren: `uv python install 3.X.Y`.
  - Repos **ohne** Paketverwaltung (nur `requirements.txt` oder gar nichts) und neue Repos bekommen ein
    `pyproject.toml` mit `uv.lock` (`uv init`/`uv add`, Ruff als `dev`-Gruppe); Versionen aus `requirements.txt`
    übernehmen, nicht anheben.
  - Bestehende Poetry-, Pipenv- oder Conda-Setups **nicht** auf uv umbauen, ausser ich will es; dort nur `uvx` und
    `uv python` nutzen. Werkzeuge (Poetry, uv, Ruff, nbconvert-Exporter …) dürfen aktuell sein; nur die
    **Bibliotheken** des Projekts bleiben auf dem Stand von damals.
  - Fehlt ein Lockfile oder löst es nicht mehr auf, die Versionen von damals mit einem Stichtag reproduzieren:
    `[tool.uv] exclude-newer = "YYYY-MM-DDT00:00:00Z"` (Datum der Abgabe bzw. des letzten Lock-Updates aus der
    Git-History). Bei einem vorhandenen alten Lockfile prüfen, dass `uv.lock` dieselben Versionen ergibt.
  - Pakete, die der Code benutzt, die aber nie deklariert waren (z. B. `xgboost`, `tabulate`, `setuptools` für
    `pkg_resources`), in der Version von damals nachtragen und im Commit begründen.
- README: Ruff-Badge (`![Ruff](https://img.shields.io/badge/Ruff-D7FF64?logo=ruff&logoColor=black)`) und die
  Befehle im Development-Abschnitt.

## Phase 4: Dokumentation

Die README ist die zentrale Anlaufstelle; Details kommen nach `docs/`, eine Seite pro Thema, mit einem Index
`docs/README.md`.

**README-Aufbau** (Abschnitte weglassen, die nicht passen):

1. Zentrierter Kopf: Titel, ein Satz, was das Projekt tut, Badges, Schnell-Links:

   ```html
   <div align="center">

   # Projektname

   **Ein Satz, was es tut**

   ![Python](https://img.shields.io/badge/Python-3.10-3776AB?logo=python&logoColor=white)
   ![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)
   ![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
   ![License](https://img.shields.io/badge/License-MIT-yellow)

   [Quick start](#quick-start) · [API](#api) · [Documentation](#documentation)

   </div>
   ```

2. Kurzbeschreibung und **Features** (Liste, gern mit einem Emoji pro Punkt)
3. Hinweis-Boxen (`> [!NOTE]`, `> [!WARNING]`, `> [!TIP]`), z. B. wenn Daten nicht Teil des Repos sind, und ein
   ehrlicher Hinweis zum Stand: wann und wofür es entstanden ist, dass die Abhängigkeiten aus dieser Zeit stammen und
   das Projekt nicht weiterentwickelt wird
4. **Contents** (Inhaltsverzeichnis)
5. **Tech stack** als Tabelle nach Bereichen (Frontend, Backend, Datenbanken, ML, Infrastruktur), jede Technologie als
   shields.io-Badge mit Logo: `![Name](https://img.shields.io/badge/<Text>-<Farbe>?logo=<simple-icons-slug>&logoColor=white)`.
   Logo-Slugs und Markenfarben stammen von [simple-icons](https://simpleicons.org/).
6. **Architecture** als Mermaid-Diagramm (`flowchart`) plus eine kurze Tabelle, was wo liegt
7. **Repository structure** als Tabelle mit Links auf die Ordner
8. **Quick start**: Voraussetzungen, dann nummerierte Schritte. **Jeder Befehl in einem eigenen ```` ```bash ````-Block**,
   ohne `$` und ohne Ausgabe im Block.
9. **Services and ports**, **Configuration** (Env-Variablen mit Default und Bedeutung), **API**, **Data**
10. **Development** (Tabelle „Aufgabe → Befehl/Guide“), **Documentation** (Tabelle aller Guides), **Known issues**
11. **Acknowledgements**, **License**, **Author** (inkl. Kontext: Arbeit, Hochschule, Jahr)

**`docs/`**: nur, was es im Projekt gibt, z. B. `architecture.md`, `dataset.md`, `api/README.md`, `databases.md`
(Backup/Restore), `migrations.md`, `docker.md`, `development.md` (Umgebung, Linting, echte Namenskonventionen des
Codes, „Where to change what“), `deployment.md` (ohne interne Hostnamen), `troubleshooting.md`. Allgemeine
Tutorials, die nicht zum Code passen, ersetzt du durch Beschreibungen dieses Codes. Unterordner wie `frontend/`
bekommen eine eigene README statt des Framework-Starters.

**Prüfen, bevor du fertig meldest:** alle relativen Links und Anker, Mermaid-Diagramme (rendern), Befehle ausgeführt
oder als nicht getestet gekennzeichnet.

**TODO.md** – Aufbau:

```markdown
# TODO

Open tasks before the repository is made public. See also [Known issues](README.md#known-issues).

## 1. <Thema>

- [x] Erledigt, mit einem Halbsatz, was genau
- [ ] Offen, mit Grund oder Voraussetzung
  - [ ] Unterpunkt

## N. Before publishing

- [ ] Choose and add a license
- [ ] Add the project context (thesis/course, institution, supervisors) to the README
- [ ] Credit third parties (data sources, models, research group)
- [ ] Check for secrets in the files and the git history, right before publishing
```

## Phase 5: Lizenz

- Frag mich, welche Lizenz ich will. Vorschlag: **MIT** für den Code, falls ich nichts anderes sage.
- Lege `LICENSE` mit dem vollständigen, unveränderten Lizenztext an (Jahr und mein Name im Copyright), ein
  License-Badge und einen Abschnitt **License** in der README.
- Lizenziere nur, was mir gehört. Weise darauf hin, wenn Teile fremd sind (Daten der Hochschule, Datensätze von
  Kaggle oder aus Archiven, fremde Modelle, Icons, Schriften, kopierter Code) und im README einen eigenen Hinweis
  brauchen: Sie behalten ihre eigene Lizenz, die MIT-Lizenz gilt für sie nicht. Für eigene Daten oder Doku, die
  separat lizenziert werden soll, schlag z. B. CC BY 4.0 vor.
- Prüfe, ob Abhängigkeiten eine Copyleft-Lizenz (GPL, AGPL) haben, die mit der gewählten Lizenz kollidiert, und sag es
  mir.

## Phase 6: Veröffentlichen (nur auf meine Anweisung)

Das Repo existiert meist schon auf GitHub. Veröffentlichen heisst dann: die Commits pushen und das Repo auf
„Public“ stellen. Das Umstellen der Sichtbarkeit mache ich selbst in den GitHub-Einstellungen; du sagst mir, wann es
so weit ist.

- Letzter Secret-Check über Dateien **und** History, und die Datenprüfung aus Phase 1 noch einmal über den aktuellen
  Stand.
- Falls sensible Daten in der History sind: Plan mit `git filter-repo` vorschlagen, **erst nach einem Backup** und nur
  mit meinem ausdrücklichen Go (umgeschriebene History und force-push sind nicht rückgängig zu machen).
- Commit-Autor und E-Mail vereinheitlichen, siehe unten.
- Repo-Beschreibung und Topics für GitHub vorschlagen.

### Commit-Autor und E-Mail

Meine aktuelle Adresse ist **`nicolas.huber.dev@gmail.com`**. Alle Repos, die ich veröffentliche, verwenden nur noch
diese Adresse, in den Commits und in den Dateien. Das Umschreiben dafür ist generell freigegeben; pushen mache ich.

1. Im Repo setzen, damit neue Commits sie schon tragen:
   `git config user.name "Nicolas Huber"` und `git config user.email nicolas.huber.dev@gmail.com`.
2. Alte Adressen in den Dateien des aktuellen Stands ersetzen oder entfernen (z. B. `authors` in `pyproject.toml`).
3. Ganz am Schluss, wenn alle Commits gemacht sind: Remote-Branches, die es lokal noch nicht gibt, als lokale Branches
   anlegen (`git fetch origin --tags`, dann `git branch <name> origin/<name>`), sonst werden sie nicht umgeschrieben.
   Backup als Bundle direkt ins Archiv:
   `git bundle create /Users/nicolas/Code/Personal/_archive/<repo>-before-filter-repo.bundle --all` (Schema
   `<repo>-before-<schritt>.bundle`, mit `git bundle verify` aus einem Repo heraus prüfen). Datum/Uhrzeit aller Commits
   vorher festhalten (`git log --all --format='%ad %cd' --date=iso-strict`), um nachher zu belegen, dass sie gleich
   geblieben sind. Dann mit [git filter-repo](https://github.com/newren/git-filter-repo) (`uvx --from git-filter-repo
   git-filter-repo …`) in **einem** Lauf:
   - `--mailmap <datei>` mit Zeilen wie `Nicolas Huber <nicolas.huber.dev@gmail.com> <alte@adresse>` für Autor und
     Committer,
   - `--replace-text <datei>` mit Zeilen wie `alte@adresse==>nicolas.huber.dev@gmail.com`, damit die alte Adresse auch
     aus früheren Dateiversionen verschwindet,
   - bei Bedarf `--invert-paths --path …`, um grosse, inzwischen gelöschte generierte Dateien aus der History zu
     entfernen.
4. filter-repo entfernt `origin`: wieder anlegen (`git remote add origin <url>`). Prüfen, dass der Tree von `HEAD`
   unverändert ist, die Commit-Daten identisch sind (Liste von vorher vergleichen), alle Branches und Tags noch da
   sind und keine alte Adresse mehr vorkommt (`git log --all --format='%ae %ce'` und `git log --all -p | grep`).
   `GitHub <noreply@github.com>` als Committer von Web-Edits ist in Ordnung und bleibt.
5. Remote auf SSH umstellen, falls es noch HTTPS ist (GitHub nimmt bei HTTPS keine Passwörter an; mein SSH-Schlüssel
   ist eingerichtet): `git remote set-url origin git@github.com:HuberNicolas/<repo>.git`, prüfen mit
   `ssh -T git@github.com`.
6. Mir die Push-Befehle nennen: alle umgeschriebenen Branches (`git push --force origin <branch> …`) und die Tags
   (`git push --force origin --tags`), und das Bundle im Archiv mit Pfad erwähnen. Hinweisen, dass GitHub-Releases
   danach auf die neuen Tag-Commits zeigen (gleicher Inhalt, neuer Hash).

Keine `.mailmap` im Repo und kein separates Repo mit alten Adressen: GitHub wertet beides nicht aus, und es würde nur
weitere Adressen veröffentlichen. Die Adresse muss in meinem GitHub-Account verifiziert sein, damit die Commits meinem
Profil zugeordnet werden.

## Texte veröffentlichen: Abschlussarbeiten, Zusammenfassungen, Kursmaterial

Gilt, wenn es nicht um Code geht, sondern um Text: den LaTeX-Quelltext einer Abschlussarbeit (meist ein
Overleaf-Export), Zusammenfassungen oder eigene Unterlagen aus Kursen. Die Grundregeln oben gelten weiter
(nichts löschen, nie pushen ohne mein Wort, Repo-Inhalte auf Englisch, mit mir Deutsch).

### Repo und Name

- **Ein Repo pro Arbeit bzw. pro Kurs**, getrennt vom Code. Code- und Text-Repo verlinken sich gegenseitig in der
  README.
- **Abschlussarbeit:** Name des Code-Repos plus Suffix im selben Stil: `MTDStrategySelectionAgent-Thesis`,
  `sdg-tag-heroes-thesis`. Den Namen des Code-Repos nicht ändern, auch wenn er nicht ideal ist.
- **Gibt es das Text-Repo schon** (z. B. `msc-thesis`), wird es auf GitHub **umbenannt** (Settings → Repository
  name; mache ich selbst), nie neu angelegt. Beim Umbenennen bleiben History, Tags, Issues und Stars erhalten, und die
  alte URL leitet weiter. Danach lokal `git remote set-url origin …`.
- **Die History einer Abschlussarbeit ist mir extrem wichtig.** Nur additive Commits; kein Rewrite, kein Force-Push.
  Commits mit meiner GitHub-noreply-Adresse (`…@users.noreply.github.com`) sind meinem Profil zugeordnet und
  verraten nichts: nicht umschreiben. Ein Rewrite nur bei fremden oder privaten Adressen, und nur nach ausdrücklicher
  Rückfrage. Die Uni-Adresse auf dem Titelblatt der abgegebenen Fassung bleibt; sie steht so auch im PDF.
- **Kurse:** Namen vorschlagen und mich bestätigen lassen, z. B. `<kurs>-summary` oder `<kurs>-notes` (kurz,
  kleingeschrieben, Englisch), mit Kursname, Hochschule und Semester in der README.
- Repos auf GitHub lege ich an oder du nach meiner Anweisung; Sichtbarkeit stelle ich selbst um.

### Rechte und Inhalte prüfen (Phase 1 für Texte)

- **Abschlussarbeit:** Fragen, ob sie schon veröffentlicht wurde (z. B. durch die Betreuer) und ob es einen
  Sperrvermerk oder ein NDA gab. Ist daraus ein Paper entstanden, dessen Verlagsbedingungen erwähnen.
- **Fremde Inhalte:** Abbildungen, Tabellen oder längere Zitate aus fremden Quellen auflisten. Sie brauchen eine
  Quellenangabe und fallen nicht unter meine Lizenz; unveränderte Übernahmen markieren.
- **Kursmaterial:** Nur eigene Arbeit veröffentlichen. **Keine** Folien, Skripte, Prüfungsfragen oder offiziellen
  Musterlösungen der Dozierenden; aus Folien kopierte Abbildungen entfernen oder ersetzen. Bei Lösungen zu
  bewerteten Übungen fragen, bevor sie rein kommen (Plagiatsgefahr für spätere Jahrgänge).
- **Persönliches:** Matrikelnummer, Unterschrift (z. B. gescannte Selbstständigkeitserklärung), private Adressen und
  Telefonnummern finden und mit mir klären. Unterschriften-Scans nie veröffentlichen.
- **Kommentare im Quelltext:** `%`-Kommentare, `\todo{}`-Notizen und auskommentierte Passagen durchsehen (Notizen an
  Betreuer, private Bemerkungen) und mir auffällige zeigen, bevor sie öffentlich werden.
- **Grösse:** Bilder und PDFs über 50 MB melden. Bilder nicht ohne Rückfrage verkleinern oder umwandeln.

### Aufbau

```text
README.md
LICENSE                # CC BY 4.0, vollständiger Legal Code
CITATION.cff           # nur bei Abschlussarbeiten
main.tex               # bzw. der Name aus dem Overleaf-Export
chapters/  figures/  bibliography.bib
.gitignore             # LaTeX-Hilfsdateien (*.aux, *.log, *.out, *.toc, *.bbl, *.blg, *.fdb_latexmk, *.fls, *.synctex.gz, …)
.github/workflows/build.yml
```

- Die Struktur des Overleaf-Exports möglichst beibehalten; nur umbauen, wenn ich es will.
- **Kein PDF im Repo**, sondern bauen lassen. Ausnahme: die **abgegebene Fassung** als Release-Asset, wenn sie vom
  Build abweicht (z. B. andere Schriften, Titelblatt der Hochschule).
- Den Compiler von Overleaf übernehmen (pdfLaTeX, XeLaTeX oder LuaLaTeX; steht im Menü von Overleaf oder in einer
  `latexmkrc`) und im Build genauso setzen.

### Build und Release

- **Lokal prüfen**, bevor der Workflow kommt: mit `latexmk`, falls installiert, sonst isoliert in Docker (z. B. Image
  `texlive/texlive`), nie durch Installationen am System ohne Rückfrage. Das Image ist mehrere GB gross: vorher
  `docker system df` prüfen. Ist der Docker-Speicher voll, **nichts prunen** (Images und Volumes anderer Projekte),
  sondern mich fragen oder den Build dem CI-Workflow überlassen und das sagen. Warnungen zu fehlenden Referenzen,
  Zitaten oder Schriften beheben oder in der TODO.md notieren.
- **GitHub Action** `.github/workflows/build.yml`: bei jedem Push das PDF mit
  [`xu-cheng/latex-action`](https://github.com/xu-cheng/latex-action) bauen und als Workflow-Artefakt hochladen; bei
  einem Tag `v*` das PDF zusätzlich an ein GitHub-Release hängen
  ([`softprops/action-gh-release`](https://github.com/softprops/action-gh-release)). Action-Versionen auf aktuelle
  Major-Tags setzen und prüfen, dass es sie gibt.
- **Release** `v1.0` = abgegebene Fassung; bei bestehender History den Tag auf den Commit der Abgabe setzen (Datum der
  Abgabe, Commit-Message prüfen), nicht auf `HEAD`. Spätere Korrekturen als `v1.1` usw. mit kurzer Beschreibung im Release.
- **Zenodo (optional, bei Abschlussarbeiten vorschlagen):** Die GitHub-Integration auf zenodo.org aktiviere ich
  selbst, **bevor** das Release angelegt wird; danach DOI-Badge und DOI in README und `CITATION.cff` eintragen.

### README für Texte

1. Zentrierter Kopf: Titel der Arbeit, eine Zeile Kontext (z. B. „Bachelor thesis, University of Zurich, 2022“),
   Badges (LaTeX, Lizenz CC BY 4.0, Build-Status des Workflows, ggf. DOI), Links: **PDF** (neuestes Release), **Code**
   (Code-Repo), **Citation**
2. Abstract (aus der Arbeit übernommen)
3. Kontext: Abschluss, Hochschule, Institut/Gruppe, Jahr, Betreuer und Professor; bei Kursen Kursname, Semester,
   Dozierende und der Hinweis, dass es inoffizielle, eigene Unterlagen ohne Gewähr sind
4. Struktur (Tabelle: Kapitel bzw. Ordner → Inhalt)
5. Bauen: Voraussetzungen und Befehle, jeder in einem eigenen ```` ```bash ````-Block
6. Citation: BibTeX-Block (`@thesis` bzw. `@mastersthesis`/`@bachelorsthesis` nach Verwendung in der Arbeit) und
   Verweis auf `CITATION.cff`
7. License: CC BY 4.0 für Text und eigene Abbildungen; fremde Abbildungen behalten ihre Lizenz; der Code liegt im
   Code-Repo unter dessen Lizenz

Im **Code-Repo** einen Link zum Text-Repo ergänzen (Kopf-Links und Abschnitt Author/Acknowledgements).

### History und E-Mail

Ein Overleaf-Export hat meist keine Git-History: dann ein neues Repo mit `git init`, Identität wie in
[Commit-Autor und E-Mail](#commit-autor-und-e-mail) setzen, ein erster Commit mit dem Stand der Abgabe („Add thesis
source as submitted“), danach die Aufräum-Commits. Hat der Export eine History (Overleaf-Git), gilt Phase 6 wie für
Code.

## Zusammenfassungen an mich

Nach jeder Phase auf Deutsch, kurz: was erledigt ist, was du dabei gefunden und behoben hast, was nicht getestet ist
und warum, und welche Entscheidungen jetzt bei mir liegen. Commit-Hashes nur als Liste am Ende.
