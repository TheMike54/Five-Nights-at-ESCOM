# Code audit — Five Nights at ESCOM

## Summary

1. No Critical issue was found: no finding shows a crash, a freeze, lost progress or a Google Play rejection. The code was read and measured, and three logic bugs were then reproduced in the running game and recorded (see Method).
2. The three High findings are two bugs that players will notice and one maintenance risk:
   - the battery can skip 0 and never run out (LOGIC-01);
   - the menu music keeps playing all through Night 2 (LOGIC-02);
   - the camera logic is copied 19 times (DUP-01).

   Both bugs were reproduced on screen, and each is fixed by changing one or two Drag and Drop actions.
3. The APK is likely larger than it needs to be: the build settings keep 830 unused assets (DEAD-01, PERF-02), all audio is uncompressed (PERF-01), and the jumpscare video is 27 MB for 10 seconds (PERF-04).
4. The repository documents a class delivery rather than the game. It has no build guide (DOC-01), no licence inventory (REL-02) and no instructions for AI agents (DOC-04), and its CI does not protect the branch that is being released (CI-01, CI-03).
5. 37 findings survived verification by a second model: 3 High, 12 Medium and 22 Low. Three of them were also reproduced in the game. Each one has its file, its line and a literal quote in the topic reports linked below.

## Audited commit

| | |
|---|---|
| Repository | `gabrielhuav/Five-Nights-at-ESCOM` |
| Branch | `prepare/android-night2-update` |
| Commit | `0adaaaab73c1bdc666d347904d1fdbdf3878a52c`, "release: prepare Android 0.1.1 with installed SDK tools" (2026-11-07) |
| Engine | GameMaker LTS 2026 (runtime 2026.0.0.23), Android build 0.1.1 |
| Audit date | 2026-11-07 |

Everything in this audit refers to that commit. Line numbers count LF characters, as `grep -n` does.

## How the game is built

- **Rooms.** The game starts in `MenuPrincipal`, which offers New game and Continue.
  - New game goes to `Periodico` (the newspaper), then to the intro room `N1`, then to `Culturales1` (Night 1).
  - Continue is enabled after Night 1 has been won, and goes straight to `N2` (Night 2).
  - Winning goes to `Win`, which leads to the credits after Night 2. Losing goes to `GameOver`. Both return to the menu.
  - `N2` is a copy of `Culturales1` with one more enemy. Three more rooms exist but are never visited (`N134`, `N1345`, `Guardia`).
- **Office and cameras.** The player sits in the office (`obj_Culturales1`), which pans with the touch position. Raising the monitor shows 19 camera buttons (`obj_Cam_01`…`obj_Cam_19`).
  - Each button sets `global.CamaraActiva`, shows its location sprite and moves a dot on the map.
  - The camera and the door laser both drain a shared battery (`global.Bateria = 14400`, one unit per frame each), and `obj_BatCheck` turns everything off at 0.
  - A clock (`obj_WinTimer`) advances one hour per minute. At 6 AM the night is won.
- **Enemies.**
  - **Prismoso** (`obj_PM`) moves between camera positions (`global.PMPos`). Eight copies of `obj_Prismoso*` show it on the matching camera.
    - When it reaches the office (`obj_PrismosoO1`), an active laser pushes it back to position 18.
    - Otherwise it plays the jumpscare video `vd_PSJS1.mp4` and the game is over.
  - **Intruso** (`obj_Intruso`, Night 2 only) moves among cameras 1–8: its Create event sets `camara_max = 8;` and `alarm[0] = room_speed * 10;`.
- **Saving.** The only stored data is the highest night won, in `progreso.ini` (section `progreso`, key `noche_ganada`). It is written just before the room change to `Win`, and read by the Continue button. A missing file reads as 0.
- **Code style.** Almost all logic is Drag and Drop: there are 988 `@DnDAction` blocks in `objects/`, and only 22 `.gml` files with content have no DnD. No object has a parent and there are no scripts, so shared behaviour is copied between objects rather than inherited.

## Priority table

Effort: S = under an hour in the IDE; M = a few hours; L = a day or more.

| ID | Finding | Severity | What the player or maintainer notices | Effort | Recommended fix |
|---|---|---|---|---|---|
| [LOGIC-01](logic-bugs.md#logic-01--the-battery-can-skip-0-and-never-run-out) | Battery compared with exact equality; can skip 0 | High | With camera and laser on together, the battery can go negative and never run out (reproduced) | S | Replace the Switch with "less than or equal" checks |
| [LOGIC-02](logic-bugs.md#logic-02--the-main-menu-music-keeps-playing-during-night-2) | Menu music keeps playing in Night 2 | High | Every Continue: menu music over the night ambience (reproduced) | S | Stop `snd_MM` in `obj_Culturales1` Create |
| [DUP-01](duplication.md#dup-01--19-camera-objects-copy-the-same-tap-event-and-alarm-0) | 19 cameras copy a 358-line tap event | High | Every camera change must be repeated 19 times | M | Make `obj_CamBase` the parent, with one shared Tap event |
| [DUP-03](duplication.md#dup-03--8-obj_prismoso-objects-copy-the-same-step-and-create-events) | 8 Prismoso objects copy Step and Create | Medium | Every Prismoso change must be repeated 8 times | S | One parent object with `pos_num` |
| [DUP-04](duplication.md#dup-04--room-n2-is-a-full-copy-of-culturales1) | Room `N2` copies `Culturales1` | Medium | Office fixes in one night do not reach the other | S | Room Inheritance: `N2` as child of `Culturales1` |
| [DEAD-01](dead-code.md#dead-01--a-third-party-effects-pack-is-never-used) | Unused effects pack: 635 sprites, 195 sounds | Medium | 19.7 MB of assets with no use; cluttered Asset Browser | S | Delete the five pack folders in the IDE |
| [LOGIC-03](logic-bugs.md#logic-03--the-credits-are-silent-the-second-time-in-one-session) | Credits fade sets the asset gain, not the voice gain | Medium | Second credits in a session are silent (reproduced) | S | Fade the voice id returned by Play Audio |
| [LOGIC-04](logic-bugs.md#logic-04--the-clock-stays-on-5-am-for-two-intervals) | Clock stays on 5 AM twice | Medium | 5 AM lasts 2 minutes; nights last 9 minutes | S | Change the win check from 8 to 7 |
| [PERF-01](performance.md#perf-01--all-sounds-are-uncompressed-and-not-streamed) | All 211 sounds uncompressed, none streamed | Medium | Larger APK, more memory from the first frame | S | Music: compressed and streamed; long effects: compressed |
| [PERF-02](performance.md#perf-02--the-build-keeps-unused-assets) | Build keeps unused assets | Medium | Larger download for no gain | S | Enable **Remove unused assets** |
| [PERF-03](performance.md#perf-03--the-main-background-does-not-fit-the-texture-page) | Office background (2125 px) larger than the texture page | Medium | Background may be halved and blurry (likely) | S | Texture page 4096×4096 |
| [PERF-04](performance.md#perf-04--the-jumpscare-video-is-oversized) | Jumpscare video 27.4 MB for 10.5 s | Medium | About a third of the asset weight | S | Re-encode at 30 fps and about 3 Mbit/s |
| [DOC-01](documentation.md#doc-01--the-readme-describes-a-student-delivery-not-the-game) | README is a delivery report; no build guide | Medium | A new maintainer cannot build from the README | S | Rewrite as the game's front page with requirements and steps |
| [CI-01](ci-and-git.md#ci-01--the-qa-check-only-tests-that-pruebasmd-is-not-empty) | QA step only checks that `PRUEBAS.md` is not empty | Medium | A green check says nothing about QA | S | Validate required fields and results |
| [REL-02](release-and-privacy.md#rel-02--the-licences-document-is-empty) | `docs/LICENCIAS.md` is empty | Medium | Asset licences cannot be reviewed before Play | M | Inventory every shipped asset with its source and licence |
| [DUP-02](duplication.md#dup-02--19-globals-duplicate-globalcamaraactiva) | 19 globals duplicate `global.CamaraActiva` | Low | 19 flags to keep in sync by hand | S | Compare with `CamaraActiva` (part of DUP-01) |
| [DUP-05](duplication.md#dup-05--the-anchor-to-background-pattern-is-copied-into-4-objects) | "Anchor to background" copied into 4 objects | Low | Small repeated edits | S | One parent object |
| [DEAD-02](dead-code.md#dead-02--33-project-sprites-have-no-reference) | 33 project sprites have no reference | Low | 0.6 MB of unused art | S | Delete, or move to a "future nights" folder |
| [DEAD-03](dead-code.md#dead-03--sequence-sqn_pmjs1-its-sprites-and-snd_pmjs-are-unreachable) | Old jumpscare sequence and sound unreachable | Low | 1.6 MB of unused assets | S | Delete five assets |
| [DEAD-04](dead-code.md#dead-04--14-objects-are-never-placed-or-created) | 14 objects never placed or created | Low | Empty or debug objects in the tree | S | Delete them and their 4 sprites |
| [DEAD-05](dead-code.md#dead-05--rooms-guardia-n134-and-n1345-are-never-visited) | 3 rooms never visited | Low | Extra rooms in the room order | S | Delete them |
| [DEAD-06](dead-code.md#dead-06--obj_cambase-has-no-events-and-two-ignored-instances) | `obj_CamBase` empty, 2 ignored instances | Low | Crossed-out instances in the editor | S | Use it as the camera parent (DUP-01) |
| [DEAD-07](dead-code.md#dead-07--obj_opciones-and-obj_extras-are-empty-and-ignored-in-the-main-menu) | Options and Extras empty and ignored in the menu (addressed by a separate pull request) | Low | No Options or Extras in the menu | S | Options: separate PR; Extras: build or delete |
| [DEAD-08](dead-code.md#dead-08--two-events-are-registered-without-a-gml-file) | 2 events registered without a `.gml` file | Low | IDE may recreate files on open (not tested) | S | Delete or fill the events; check in CI |
| [DEAD-09](dead-code.md#dead-09--empty-event-files-and-empty-else-branches) | Empty event files and `else` blocks | Low | Noise in the event list | S | Delete them |
| [DEAD-10](dead-code.md#dead-10--variables-that-are-written-but-never-read) | Variables written but never read | Low | Readers look for a use that does not exist | S | Remove the assignments, keep the calls |
| [LOGIC-05](logic-bugs.md#logic-05--the-jumpscare-video-is-never-closed) | Jumpscare video never closed | Low | Nothing visible proven | S | Clean Up event with `video_close()` |
| [LOGIC-07](logic-bugs.md#logic-07--the-prismoso-movement-chance-only-works-at-pmia--20) | Prismoso movement chance only works at `PMIA = 20` | Low | Tuning difficulty would stop Prismoso moving | S | `irandom(19) < global.PMIA` |
| [DOC-02](documentation.md#doc-02--entrega1md-has-a-broken-link-and-unfilled-fields) | `ENTREGA1.md`: broken link and unfilled fields | Low | Link fails on GitHub | S | Fix the link; fill or remove the sections |
| [DOC-03](documentation.md#doc-03--pruebasmd-cites-commits-that-are-not-in-the-history) | `PRUEBAS.md` cites commits that do not exist | Low | Tests cannot be traced to code | S | Cite an existing SHA; test on Android |
| [DOC-04](documentation.md#doc-04--no-instructions-for-ai-coding-agents) | No `AGENTS.md`, `CLAUDE.md` or `REVIEW.md` | Low | AI agents miss the DnD and `.yyp` rules | S | Add `AGENTS.md` (outline included) |
| [DOC-05](documentation.md#doc-05--pruebasmd-names-the-wrong-save-file) | `PRUEBAS.md` names `save.ini` | Low | A tester resets the wrong file | S | Use `progreso.ini` |
| [DOC-06](documentation.md#doc-06--a-date-in-authorsmd-has-no-spaces) | Date without spaces in `AUTHORS.md` | Low | Typo on GitHub | S | Fix the spacing |
| [CI-02](ci-and-git.md#ci-02--the-validator-only-checks-that-files-exist) | Validator checks existence only; no `permissions:` | Low | A malformed `.yy` passes CI | S | Parse each `.yy`; check events; set `permissions` |
| [CI-03](ci-and-git.md#ci-03--no-completed-ci-run-is-recorded-for-the-release-line) | No completed CI run recorded for the release line | Low | The 0.1.1 code has no workflow result | S | Open a PR from the release branch into `main` |
| [REL-01](release-and-privacy.md#rel-01--the-privacy-policy-shows-a-different-version-from-the-build) | Privacy policy says 0.1.0; build is 0.1.1 | Low | Policy panel says 0.1.0; Android build is 0.1.1; the Windows menu shows v0.1.0.0 | S | Use `GM_version` in the panel; update the page |
| [REL-03](release-and-privacy.md#rel-03--android-tv-support-is-declared-without-remote-or-gamepad-input) | Android TV declared without remote input | Low | Unusable menu on a TV (not tested) | S | Turn off Leanback and Is Game |

## Quick wins

These are the serious, cheap fixes. Each takes minutes in the IDE and does not change how the game is built.

1. **LOGIC-02:** add one **Stop Audio** (`snd_MM`) action to `obj_Culturales1` Create.
2. **LOGIC-01:** in `obj_BatCheck`, change the **Switch** to "less than or equal" checks and clamp the battery at 0.
3. **PERF-02:** tick **Remove unused assets** in Game Options → Main.
4. **PERF-01:** set `snd_BKMusic`, `snd_MM` and `snd_TY` to **Compressed – Streamed**.
5. **PERF-04:** re-encode `vd_PSJS1.mp4` with the `ffmpeg` command in the report.
6. **LOGIC-04:** change the win check from 8 to 7, after confirming that 8 equal hours is the intended design.
7. **REL-01:** show `GM_version` in the privacy panel and update the version on the public page.

## High findings

**LOGIC-01 — The battery can skip 0.**

- `obj_BatCamara` and `obj_BatLaser` each subtract 1 per frame, while `obj_BatCheck` acts only on the exact values 0, 2880, 5760, 8640 and 11520 (`objects/obj_BatCheck/Step_2.gml:12` `case 0:`).
- With both on, the battery falls by 2 per frame. Depending on its parity at that moment and on the order of the three End Step events, every threshold is skipped: the icon freezes and the camera and laser work all night.
- Codex recomputed all six event orders and confirmed it. In the running game the debugger showed the battery at −1222 with the camera still on ([video](evidence/logic-01-battery-below-zero.mp4)).
- The fix keeps Drag and Drop: **If Variable** with *less than or equal*.

**LOGIC-02 — The menu music plays during Night 2.**

- `obj_MM_Empty` loops `snd_MM`. New game reaches Night 1 through room `N1`, whose `objN1_S` calls `audio_stop_all()`.
- **Continue** goes straight to `N2` (`objects/obj_Continuar/Gesture_0.gml:6` `room_goto(N2);`), and nothing there stops the menu track.
- Every player who continues hears both tracks until the night ends, as the recording shows ([video](evidence/logic-02-menu-music-night2.mp4)). One **Stop Audio** action in `obj_Culturales1` Create fixes both nights.

**DUP-01 — The camera logic is copied 19 times.**

- Each `obj_Cam_NN/Gesture_0.gml` has 358 lines and differs from the others in 26–29 lines. The 19 `Alarm_0.gml` files are identical: 6,802 lines for one behaviour.
- Any change to camera switching has to be repeated 19 times, and a missed copy is hard to see.
- Recommended, in Drag and Drop: make the existing empty `obj_CamBase` the parent, with one Tap event that reads per-camera variables (`cam_num`, `spr_on`, `spr_dot`, `spr_place`).
- Alternative (changes the workflow to code): one script function called from an *Execute Code* action in each camera.

## Severity and confidence

| Severity | Meaning for an Android game |
|---|---|
| Critical | Crashes, freezes, loses progress, or gets the build rejected by Google Play |
| High | A failure the player can see or hear, or a serious maintenance risk |
| Medium | A real cost (size, memory, effort, traceability) without a visible failure |
| Low | Minor issues; style and naming are never higher than Low |

- **confirmed:** verified by reading the code, counting, measuring or simulating, and checked again by a second model.
- **likely:** the code path is confirmed, but the visible effect needs the running game or a built APK.
- Speculative findings were not included.

## Method

The audit used two models from different providers, each checking the other's work:

- **Search, by topic:** a Claude Opus 5.5 subagent searched for duplication and dead code, and another searched for logic and performance. Codex (GPT-6.1-sol) searched documentation, CI and release.
- **Verification, with clean context:** each finding was then attacked by the other model. Codex verified the Claude findings, and a Claude subagent verified the Codex findings. Codex then verified, in two short extra rounds, the new findings that came up during verification.
- **Results:**
  - Two findings were refuted and left out: a texture-loading stall, and a mismatch in camera 19's sprites whose intent could not be determined.
  - A third, a persistent `obj_Coco` duplicating on each return to the menu, was refuted by running the game and removed; IDs were not renumbered.
  - One more was dropped as out of scope, because it described the branches of a local clone rather than the repository.
  - Several severities and counts were corrected.
  - Every quote was re-read against the file by the main session before it was written here.
- **Running the game:** a command-line build (Igor) stopped at the licence check because the GameMaker installation was not signed in. The logic bugs were then tested by hand in the signed-in IDE (GameMaker LTS 2026, Windows target, **Debug**), using the debugger to read the battery and to move the clock forward. LOGIC-01, LOGIC-02 and LOGIC-03 were reproduced and recorded in [evidence/](evidence/); the `obj_Coco` finding was not.
- **Not run:** nothing was run on an Android device, and no APK was built. Findings whose effect needs a device or a built APK stay `likely`, and each one includes the steps to check it.
- **Repository state:** all searches ran on a clean checkout of `0adaaaa`, and nothing in the game was modified.

## Topic reports

Each topic report lists, for every finding, its location and literal quote, how it was found and verified, the confidence, the recommended fix step by step, and how to check that it is fixed. They are written so that an AI coding agent can act on a single finding.

- [duplication.md](duplication.md): DUP-01 to DUP-05
- [dead-code.md](dead-code.md): DEAD-01 to DEAD-10
- [performance.md](performance.md): PERF-01 to PERF-04
- [logic-bugs.md](logic-bugs.md): LOGIC-01 to LOGIC-05 and LOGIC-07
- [evidence/](evidence/): recordings of LOGIC-01, LOGIC-02 and LOGIC-03
- [documentation.md](documentation.md): DOC-01 to DOC-06
- [ci-and-git.md](ci-and-git.md): CI-01 to CI-03
- [release-and-privacy.md](release-and-privacy.md): REL-01 to REL-03
