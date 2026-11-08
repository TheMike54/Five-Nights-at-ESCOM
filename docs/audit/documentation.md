# Documentation

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root.

Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

## What was read

- `README.md`, `AUTHORS.md` and every text file under `docs/`: `LICENCIAS.md`, `privacy/index.html` and the three Markdown files in `docs/evidencias/entrega1/`.
- Agent instruction files. A search for `CLAUDE.md`, `AGENTS.md`, `REVIEW.md`, `CONTRIBUTING.md`, `.cursorrules` and `copilot-instructions` covered the working tree and every branch in the local history (`git log --all --name-only`). It found none of them.

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| DOC-01 | The README describes a student delivery and has no steps to open, run or export the game | Medium | confirmed |
| DOC-02 | `ENTREGA1.md` has a broken link and unfilled fields | Low | confirmed |
| DOC-03 | `PRUEBAS.md` cites commits that do not exist in the history and a macOS test environment | Low | confirmed |
| DOC-04 | There are no instructions for AI coding agents (`AGENTS.md`, `CLAUDE.md`, `REVIEW.md`) | Low | confirmed |
| DOC-05 | `PRUEBAS.md` names `save.ini`, but the game saves to `progreso.ini` | Low | confirmed |
| DOC-06 | A date in `AUTHORS.md` is written without spaces | Low | confirmed |

---

## DOC-01 — The README describes a student delivery, not the game

- **Severity:** Medium (maintenance: anyone new to the repository has to reconstruct how to build it).
- **Confidence:** confirmed.
- **Location and quotes:**
  - `README.md:1`: `# Five-Nights-at-ESCOM-Forked`
  - `README.md:2`: `Repositorio para la ejecución, modificación e implementación de una funcionalidad dentro de un proyecto anteriormente desarrollado para la entrega de una característica nueva mediante un Pull Request completo con evidencias de Quality Assurance.`
  - `README.md:26`: `` Rama: `feature/night-2`. Se agrega la Noche 2 como nueva sala jugable (`N2`), con el ``
- **What it is:**
  - The README opens as the report of one class delivery: course, group and the team's participants. It then describes the Night 2 feature.
  - It does not say what the game is, which GameMaker version and runtime it needs, which `.yyp` to open, or how to run and export the Android build.
  - A "clean clone" guide does exist on the `main` branch of the fork `TheMike54/Five-Nights-at-ESCOM` (commit `43eb4b5`). However, that branch is not an ancestor of the audited commit, and the guide says `El juego no usa JDK, Android SDK ni servicios externos`, which no longer holds for the Android 0.1.1 release.
- **How it was found and verified:**
  - Found by Codex (GPT-6.1-sol) from a full reading and a search for install and run instructions.
  - A Claude subagent (Opus 5.5) confirmed the quotes, found the fork guide with `git show 43eb4b5:README.md`, and checked its ancestry with `git merge-base --is-ancestor`.
  - The brief's claim that "the README describes the team's delivery, not the game" is partly true: it is mostly a delivery report, but it also describes the Night 2 feature.
- **Recommended fix:** restructure the README as the game's front page:
  1. What the game is, and its current version.
  2. Requirements: GameMaker LTS 2026 IDE and runtime versions, plus the JDK, Android SDK and NDK used for the Android export.
  3. Steps to open `Five Nights at ESCOM.yyp`, run it on Windows, and export the Android AAB.
  4. Links to `AUTHORS.md`, the privacy policy and the licences.
  5. Course delivery material moved to `docs/evidencias/`.
- **How to check it is fixed:** someone who has never opened the project follows only the README, from a clean clone, and gets the game running on Windows and on an Android device.

## DOC-02 — `ENTREGA1.md` has a broken link and unfilled fields

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `docs/evidencias/entrega1/ENTREGA1.md:34`: `*Figura 6. Recorrido del usuario. Elaborado por [Nombre] en Mermaid.*`
  - `docs/evidencias/entrega1/ENTREGA1.md:56`: ``| Ficha de idea completa y versionada | [`docs/idea.md`](idea.md) |`` (the rest of the row is an unfilled owner field and an unticked box)
  - `docs/evidencias/entrega1/ENTREGA1.md:61`: `| Historia de usuario y criterio de aceptación | Sección 1.3 de este documento | [Nombre] | ☐ |`
- **What it is:**
  - The link `idea.md` resolves to `docs/evidencias/entrega1/idea.md`, but the file is `IDEA.md`. GitHub paths are case-sensitive, so the link fails.
  - Sections 1.2 and 1.3 are empty, and the figure has no content.
- **How it was found and verified:** Codex, by checking the links against `git ls-files`. A Claude subagent confirmed the lines and the empty sections.
- **Recommended fix:**
  - Change the link to `IDEA.md`.
  - Fill the user journey and the user story, or remove the rows and sections that have no content.
- **How to check it is fixed:** every link in the file opens on GitHub, and no `[Nombre]` remains.

## DOC-03 — `PRUEBAS.md` cites commits that are not in the history

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `docs/evidencias/entrega1/PRUEBAS.md:7`: ``**SHA base:** `7ab6b0399ff609349ae73159be7901c03eb799ae` ``
  - `docs/evidencias/entrega1/PRUEBAS.md:8`: ``**SHA probado:** `66be57f` (incluye sistema de cámaras de N2 y ajuste de dificultad a 10s/8 cámaras)``
  - `docs/evidencias/entrega1/PRUEBAS.md:9`: `**Dispositivo/entorno:** macOS (Apple Silicon), GameMaker IDE v2026.0.0.16, Runtime v2026.0.0.23`
- **What it is:**
  - `git cat-file -t 66be57f` reports that the object does not exist, and so does the base SHA.
  - The feature arrived as the single squash commit `f62f9f0 Feature/night 2 and Intruso added (#4)`, so the branch commits are gone.
  - The tests were run on macOS, not on the Android build that is being released.
- **How it was found and verified:**
  - Found by Codex.
  - A Claude subagent found the squash-merge cause and lowered the severity from Medium to Low: this is missing evidence, not a defect in the game.
- **Recommended fix:**
  - Cite a commit that exists (`f62f9f0`, or the release candidate).
  - Add one test run on an Android device with the release build.
- **How to check it is fixed:** `git show <cited SHA>` works, and the test table names an Android device.

## DOC-04 — No instructions for AI coding agents

- **Severity:** Low (an improvement to maintenance documentation; no defect results from its absence today).
- **Confidence:** confirmed. Absence was checked in the working tree and in all local branches.
- **What it is:**
  - The project has no `AGENTS.md`, `CLAUDE.md` or `REVIEW.md`.
  - The project has a trap that an agent would not guess. In DnD **Execute Code** actions, the code is stored twice: once in the `/// @DnDArgument : "code"` header and once in the body below it. Examples:
    - `objects/obj_WinTimer/Alarm_0.gml:22` holds `ini_open("progreso.ini");` inside the `"code"` argument, and line 25 repeats it in the body.
    - `objects/obj_ButtonUp/Step_0.gml:39` has `/// @DnDArgument : "code" "camera_set_view_pos(global.Camara,0,0)$(13_10)"`, and line 40 has `camera_set_view_pos(global.Camara,0,0)`.

    An agent that edits only one of the two copies leaves them out of sync. Which copy the IDE keeps when it reopens the event was not tested.
- **How it was found and verified:**
  - Found by a Claude subagent (Opus 5.5) during the verification of this topic.
  - Codex confirmed the absence and the duplication in Execute Code actions. It removed a claim that the IDE always regenerates from the header, because that was not demonstrated.
- **Recommended fix:** add an `AGENTS.md` at the repository root. Read by several AI tools, it should cover:
  1. **Project shape:** GameMaker LTS 2026 (IDE 2026.0.0.16, runtime 2026.0.0.23); most events are Drag and Drop.
  2. **Editing rule:** change DnD events in the GameMaker IDE. If a `.gml` file with `@DnDAction` must be edited as text, change the body and the matching `@DnDArgument` lines together, or convert the event to GML in the IDE first.
  3. **Do not edit by hand:** `Five Nights at ESCOM.yyp`, `Five Nights at ESCOM.resource_order` and `options/*/options_*.yy` (version, SDK, package name). Add or remove assets through the IDE.
  4. **Validation:** run `python tools/validate_project.py`, then run the game in the IDE (F5).
  5. **Release:** where the version number lives (`options/android/options_android.yy`, the privacy policy), and that keystores never enter the repository (`.gitignore:7-13`).
  6. **Save data:** `progreso.ini`, section `progreso`, key `noche_ganada`.

  Tools that read `CLAUDE.md` can use a one-line `CLAUDE.md` containing `@AGENTS.md`.
- **How to check it is fixed:** a new agent session, reading only `AGENTS.md`, can name the validation command and the files it must not edit.

## DOC-05 — `PRUEBAS.md` names the wrong save file

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `docs/evidencias/entrega1/PRUEBAS.md:14`: ``Partida nueva, sin ninguna noche superada (`save.ini` inexistente o en 0)``
  - `objects/obj_Continuar/Create_0.gml:2`: `ini_open("progreso.ini");`
  - `objects/obj_WinTimer/Alarm_0.gml:28`: `ini_write_real("progreso", "noche_ganada", global.Noche);`
- **What it is:** a tester who deletes `save.ini` to start a new game does not reset the progress, and gets a false result.
- **How it was found and verified:** found by a Claude subagent with a search for `ini_open` and `save.ini`. Codex confirmed it.
- **Recommended fix:** replace `save.ini` with `progreso.ini` (section `progreso`, key `noche_ganada`).
- **How to check it is fixed:** `grep -n "save.ini" docs/evidencias/entrega1/PRUEBAS.md` prints nothing.

## DOC-06 — A date in `AUTHORS.md` has no spaces

- **Severity:** Low (typo).
- **Confidence:** confirmed.
- **Location and quote:** `AUTHORS.md:15`: `el24deoctubrede2026`
- **How it was found and verified:** found by a Claude subagent. Codex confirmed it.
- **Recommended fix:** write `el 24 de octubre de 2026`.
- **How to check it is fixed:** `grep -n "el24de" AUTHORS.md` prints nothing.
