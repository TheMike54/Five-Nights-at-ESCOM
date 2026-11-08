# Release and privacy

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root.

Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

## What was read and searched

- **Files read in full:** `options/android/options_android.yy`, the other nine `options/*/options_*.yy`, `docs/privacy/index.html`, `objects/obj_MM_Empty/Draw_64.gml` (the in-game privacy panel), `.gitignore`, `README.md` and `AUTHORS.md`.
- **Signing material, in the tree:** `rg --files --hidden --no-ignore` for `*.jks`, `*.keystore`, `*.p12`, `*.pfx`, `*.pem` and `*.key`. None found.
- **Signing material, in the history:** `git log --all --name-only` filtered by the same extensions. None found. This checks file names, not the content of files with other names.
- **Secrets:** a case-insensitive search in all text files for `password`, `secret`, `token`, `api key`, `credential`, `keystore`, absolute personal paths, private-key headers, and GitHub, AWS and Google key formats. The only matches were ignore rules and URLs. Binary files were not scanned for embedded secrets.
- **Save data:** a search of `objects/` for `ini_open`, `file_text_open`, `file_bin_open` and `buffer_save`. The only stored data is `progreso.ini` (`objects/obj_WinTimer/Alarm_0.gml:28`: `ini_write_real("progreso", "noche_ganada", global.Noche);`).

## Checked, with no finding

| Area | Value and location |
|---|---|
| Permissions | Bluetooth, Internet, network state, phone state, microphone and external storage are all `false` (`options/android/options_android.yy:58-63`). This matches the privacy policy. |
| SDK levels | Minimum `"24"`, target `"36"`, compile `"36"` (lines 50, 75 and 11). This audit does not state the exact minimum that Google Play requires at review time. |
| Architectures | `"option_android_arch_arm64":true`. ARMv7 and x86_64 are `false` (lines 6-8). |
| Backups | `"option_android_attribute_allow_backup":false` (line 9). |
| Orientation | Landscape only (lines 51-54), consistent with the 1280×720 GUI. |
| Icons | All 18 launcher and adaptive icon PNG files are present, at the expected sizes (36-192 px legacy, 81-432 px adaptive). |
| Signing | No keystore in the tree or in the history by file name. `.gitignore:7-13` excludes `*.jks`, `*.keystore`, `*.p12`, `*.pfx`, `keystore.properties` and `local.properties`. |
| Privacy policy against the code | The game stores one local number (`progreso.ini`) and uses no network. The policy says it collects and shares no personal data and that internal files stay on the device. |

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| REL-02 | `docs/LICENCIAS.md`, linked from the README, is empty, and asset provenance is kept outside the repository | Medium | confirmed |
| REL-01 | The privacy policy says version 0.1.0; the Android build is 0.1.1 | Low | confirmed |
| REL-03 | The package declares Android TV (Leanback) support, but there is no remote or gamepad input | Low | confirmed (settings) / likely (effect) |

---

## REL-02 — The licences document is empty

- **Severity:** Medium. The game is being prepared for Google Play, and the provenance of each asset cannot be reviewed from the repository.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `README.md:20`: ``* [`Documento explicativo de las licencias`](/docs/LICENCIAS.md)``
  - `AUTHORS.md:11`: `La procedencia y las condiciones de música, sonidos, fotografías, gráficos y video se están documentando antes de la distribución.`
  - `AUTHORS.md:13`: `La relación de archivos fuente se conserva en el expediente local de publicación para revisar las autorizaciones concretas sin sustituir licencias de terceros.`
- **What it is:**
  - `docs/LICENCIAS.md` is 0 bytes. It was created empty by `f62f9f0`.
  - A 25-line `docs/licencias.md` (commit `cc53555`) exists on the `main` branch of the fork `TheMike54/Five-Nights-at-ESCOM`, which is not part of the audited line. Its content was not reviewed in this audit.
  - The build also packages an unused effects pack whose origin is not documented ([DEAD-01](dead-code.md#dead-01--a-third-party-effects-pack-is-never-used)).
- **Why it matters:** this audit does not claim that any permission is missing. The point is that nobody can check, from the repository, the licence of what the APK distributes.
- **How it was found and verified:**
  - Found by Codex (GPT-6.1-sol): `Get-Item` gave `Length = 0`.
  - A Claude subagent (Opus 5.5) confirmed it and traced the history with `git log --all --stat`.
- **Recommended fix:**
  1. Remove the unused assets first (DEAD-01), so the inventory covers only what ships.
  2. Fill `docs/LICENCIAS.md` with one row per asset or asset group: source, licence or permission, required attribution, and a reference to the evidence. Leave out confidential data.
  3. The fork's `docs/licencias.md` can serve as a starting point.
- **How to check it is fixed:** every sprite, sound, font and video folder in the build is covered by a row in `docs/LICENCIAS.md`.

## REL-01 — The privacy policy shows a different version from the build

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `options/android/options_android.yy:82`: `"option_android_version":"0.1.1",`
  - `docs/privacy/index.html:4`: `<p>Última actualización: 23 de octubre de 2026. Versión del juego: 0.1.0.</p>`
  - `objects/obj_MM_Empty/Draw_64.gml:27`: `policy = "Versión 0.1.0 · 23 de octubre de 2026\n\n"`
  - `objects/obj_MM_Empty/Draw_0.gml:17` draws the version with `GM_version`.
  - `options/windows/options_windows.yy:34`: `"option_windows_version":"0.1.0.0",`
- **What it is:**
  - `GM_version` takes the version of the target being built. On Android the main menu is expected to show `v0.1.1`, while the privacy panel says `Versión 0.1.0`. This was not observed on a device.
  - On Windows the version was not raised: running the game from the IDE, the main menu shows `v0.1.0.0`.
  - The public page says 0.1.0 as well.
  - According to the GitHub API on 2026-11-07, GitHub Pages serves `/docs` from the branch `prepare/google-play-closed-test` (last commit `5808e2c`). The policy is therefore at `https://gabrielhuav.github.io/Five-Nights-at-ESCOM/privacy/`, and it does not follow the release branch.
  - `git diff upstream/prepare/google-play-closed-test 0adaaaa -- docs/privacy` shows no difference today.
- **How it was found and verified:** found by Codex with a repository-wide search for version strings. A Claude subagent confirmed every quote.
- **Recommended fix:**
  1. In the in-game panel, build the heading from `GM_version` instead of a fixed number, and keep the policy date separate. Raise the Windows version in **Game Options → Windows** to match.
  2. Update the version line in `docs/privacy/index.html`, on the branch that Pages serves (or point Pages at the release branch).
  3. Add both files to the release checklist in `AGENTS.md` ([DOC-04](documentation.md#doc-04--no-instructions-for-ai-coding-agents)).
- **How to check it is fixed:** the Android and Windows settings, the menu, the in-game panel and the public page all show the same version.

## REL-03 — Android TV support is declared without remote or gamepad input

- **Severity:** Low.
- **Confidence:** confirmed for the settings. What happens on a TV was not tested, and the generated manifest was not inspected.
- **Location and quotes:**
  - `options/android/options_android.yy:18`: `"option_android_gamepad_support":false,`
  - `options/android/options_android.yy:79`: `"option_android_tv_isgame":true,`
  - `options/android/options_android.yy:80`: `"option_android_tv_supports_leanback":true,`
- **What it is:**
  - There are no keyboard, gamepad or joystick checks, `vk_` constants or keyboard events in `objects/`.
  - Input is through 55 `Gesture_*` events and pointer position, for example `objects/obj_MM_Empty/Gesture_64.gml:1` with `device_mouse_x_to_gui(0)`.
  - If the game reached a TV, the menu could not be used with a remote. Play Console also requires TV distribution to be enabled; that was not checked.
- **How it was found and verified:**
  - Found by a Claude subagent while verifying this topic.
  - Codex confirmed the three lines and the absence of remote or gamepad input. It rephrased "touch only" as "no keyboard or gamepad controls implemented".
- **Recommended fix:** in **Game Options → Android**, turn off **Supports Leanback** and **Is Game** under the TV settings, then bump the version.
- **How to check it is fixed:** in the generated AAB's manifest, the `LEANBACK_LAUNCHER` category no longer appears.
