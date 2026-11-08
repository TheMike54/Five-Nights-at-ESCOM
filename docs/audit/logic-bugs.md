# Logic bugs

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root. Line numbers count LF characters. `objects/obj_WinTimer/Alarm_0.gml` mixes CR, LF and CRLF line endings, so an editor may show different line numbers for that file.

Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

## Scope and limits

- **Game flow that was traced:**
  - `MenuPrincipal` (the first room in `RoomOrderNodes`) → **New game** → `Periodico` → `N1` (intro) → `Culturales1` (Night 1).
  - **Continue** → `N2` (Night 2).
  - Win → `obj_WinTimer` saves `progreso.ini` and goes to `Win`, which returns to the menu or shows the credits after Night 2.
  - Lose → `GameOver` → `MenuPrincipal`.
- **Checked, with no finding:**
  - **Save and load:** `ini_read_real` defaults to 0 when `progreso.ini` does not exist, and progress is written before the room change to `Win`.
  - **Missing-instance access:** objects that read `obj_Culturales1.x` run only in rooms where `obj_Culturales1` exists and is created first.
  - **Division by zero:** no reachable case.
- **Run in the IDE:** the GameMaker command-line build (Igor, runtime 2026.0.0.23) stopped with `Permission Error : Unable to obtain permission to execute` because the IDE was not signed in. The game was then run from the signed-in IDE (GameMaker LTS 2026, Windows target, **Debug**), and LOGIC-01, LOGIC-02 and LOGIC-03 were reproduced on screen. The recordings are in [evidence/](evidence/).
- **Refuted by running the game:** an earlier finding claimed that the persistent `obj_Coco` (`objects/obj_Coco/obj_Coco.yy:15` `"persistent":true,`), placed in `MenuPrincipal`, adds one more instance on each return to the menu. After three returns to the menu, the debugger's **Instances** list still showed a single `obj_Coco`, so the finding was removed. IDs were not renumbered.

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| LOGIC-01 | The battery uses exact equality and can skip every threshold, including 0 (infinite battery) | High | confirmed, reproduced |
| LOGIC-02 | The main-menu music keeps playing during the whole of Night 2 | High | confirmed, reproduced |
| LOGIC-03 | The credits fade-out sets the gain of the `snd_TY` asset to 0 or below, so the credits are silent the second time | Medium | confirmed, reproduced |
| LOGIC-04 | The clock stays on 5 AM for two intervals, so a night lasts 9 minutes | Medium | confirmed |
| LOGIC-05 | The jumpscare video is opened on every loss and never closed | Low | confirmed |
| LOGIC-07 | The Prismoso movement chance only behaves as a probability when `PMIA = 20` | Low | confirmed |

---

## LOGIC-01 — The battery can skip 0 and never run out

- **Severity:** High (a visible failure: the main resource of the night never runs out).
- **Confidence:** confirmed by reading the code and simulating it, and reproduced in the running game.
- **Location and quotes:**
  - `objects/obj_Culturales1/Create_0.gml:19`: `global.Bateria = 14400;`
  - `objects/obj_BatCamara/Step_2.gml:14` and `objects/obj_BatLaser/Step_2.gml:14`: `global.Bateria = global.Bateria-1;`
  - `objects/obj_BatCheck/Step_2.gml:6`: `switch(l0184DB3D_0)`
  - `objects/obj_BatCheck/Step_2.gml:12`: `case 0:`
  - `objects/obj_BatCheck/Step_2.gml:75`: `case 2880:`
- **What it is:**
  - The camera and the laser each subtract 1 per frame, in two separate End Step events.
  - `obj_BatCheck` reacts only when the value is exactly 0, 2880, 5760, 8640 or 11520. `case 0` is where the camera and the laser are switched off.
  - The two drains can be on together: `objects/obj_CLaserButton/Gesture_0.gml:42` sets `global.BatLaser = 1;`, and raising the camera sets `global.BatCamara = 1;` (`objects/obj_ButtonDown/Gesture_0.gml:43`) without turning the laser off.
  - When both are on, the value moves in steps of 2. If an odd number of single-drain frames came first, the check never sees an even threshold.
  - At that point `global.Bateria` goes below zero and keeps falling, the battery icon stays on one level, and the camera and laser keep working for the rest of the night.
- **How it was found and verified:**
  - Found by a Claude subagent (Opus 5.5), which read the three End Step events and simulated them in Python.
  - Codex (GPT-6.1-sol) recomputed all six possible orders of the three End Step events. In every order, one of the two starting parities skips all thresholds. Example (camera, check, laser after 24 camera-only frames): the check sees 14375, 14373, … −1 and never sees 0.
  - Reproduced in the IDE with the laser and the camera on together. The debugger showed `Bateria` at −72, −708 and −1222 while the camera and the laser kept working, and `BatConteo` stayed at 5 (full icon) for the whole night: the check never matched any threshold.
- **Evidence:** [evidence/logic-01-battery-below-zero.mp4](evidence/logic-01-battery-below-zero.mp4). The middle part is sped up 4×; the boxes mark `Bateria` in the debugger's **Globals** list.
- **Recommended fix (keeps Drag and Drop):**
  1. In `obj_BatCheck` End Step, replace the **Switch** with **If Variable** actions that use *less than or equal*, from the lowest threshold up:
     - `<= 0`: run everything the current `case 0` does.
     - Otherwise `<= 2880`: `BatConteo = 1`.
     - Otherwise `<= 5760`: 2.
     - Otherwise `<= 8640`: 3.
     - Otherwise `<= 11520`: 4.
  2. In the `<= 0` branch, also set `global.Bateria = 0` so the value never stays negative.
- **Alternative (code):** one *Execute Code* action computing `global.BatConteo = clamp(ceil(global.Bateria / 2880), 0, 5);`, followed by the existing shutdown actions when `global.Bateria <= 0`.
- **How to reproduce it today and check the fix:**
  1. Open the project in GameMaker LTS 2026 and run it with **Debug** (F6) on Windows. In the debugger's bottom panel, open the **Variables** tab; the **Globals** list fills in while the game is paused (⏸).
  2. New game → Night 1. Move the pointer to the right edge of the window and tap the **Laser** monitor.
  3. Move the pointer to the left edge until the view stops, then tap the camera button, so that both drains are on.
  4. Leave both on for about two minutes, pausing now and then to read `Bateria` and `BatConteo`:
     - The bug: `Bateria` goes below 0, the camera and the laser keep working, and `BatConteo` never drops.
     - No bug on this attempt: the battery reaches 0 and everything switches off. Which parity skips the thresholds depends on the order of the three End Step events, so restart and wait a different time between the laser and the camera; about half of the attempts are expected to show the bug.
  5. After the fix, the icon passes through every level, reaches empty, and `global.Bateria` ends at 0.

## LOGIC-02 — The main-menu music keeps playing during Night 2

- **Severity:** High (visible and audible to every player who presses Continue).
- **Confidence:** confirmed by tracing every audio stop, and reproduced in the running game: after **Continue**, the menu track is heard over the Night 2 ambience.
- **Location and quotes:**
  - `objects/obj_MM_Empty/Create_0.gml:12`: `audio_play_sound(snd_MM, 0, 1, 1.0, undefined, 1.0);` (looped)
  - `objects/obj_Continuar/Gesture_0.gml:6`: `room_goto(N2);`
  - `objects/obj_Culturales1/Create_0.gml:37`: `audio_play_sound(snd_BKMusic, 0, 1, 0.6, undefined, 1.0);`
  - `objects/objN1_S/Create_0.gml:4`: `audio_stop_all();` (only in room `N1`)
- **What it is:**
  - New game passes through room `N1`, whose `objN1_S` stops all audio.
  - **Continue** goes straight to `N2`, and no object in `N2` stops `snd_MM`.
  - The menu track therefore loops on top of the night ambience until the player wins or loses.
  - `obj_MM_Empty/Create_0.gml:4` also calls `audio_stop_all();`, but before the menu music starts, so it does not help.
- **How it was found and verified:** Claude subagent search for `audio_stop_all`, `audio_stop_sound` and `snd_MM`. Codex followed every stop and every event in `N2`, and found none that stops the menu music.
- **Evidence:** [evidence/logic-02-menu-music-night2.mp4](evidence/logic-02-menu-music-night2.mp4), with sound: the menu, **Continue**, and the first seconds of Night 2.
- **Recommended fix:** in `obj_Culturales1` Create, add a **Stop Audio** action for `snd_MM` before the **Play Audio** of `snd_BKMusic`. `obj_Culturales1` is placed in both nights, so this covers Night 1 and Night 2.
- **How to reproduce it today and check the fix:**
  1. Win Night 1 once, so that **Continue** is enabled, or create `progreso.ini` with `noche_ganada=1` in the `progreso` section. When the game runs from the IDE on Windows, the file goes in `%LOCALAPPDATA%\Five_Nights_at_ESCOM\`.
  2. From the menu, tap **Continue**.
  3. Today: the menu music is heard together with the night ambience. After the fix, only `snd_BKMusic` is heard, and `audio_is_playing(snd_MM)` in the debugger is `false`.

## LOGIC-03 — The credits are silent the second time in one session

- **Severity:** Medium.
- **Confidence:** confirmed by reading the code, and reproduced in the running game.
- **Location and quotes:**
  - `objects/obj_WinManager/Alarm_1.gml:13`: `audio_play_sound(snd_TY, 0, 1, Vol, undefined, 1.0);`
  - `objects/obj_WinManager/Alarm_3.gml:14`: `Vol = Vol-0.1;`
  - `objects/obj_WinManager/Alarm_3.gml:23`: `audio_sound_gain(snd_TY, Vol, 0);`
- **What it is:**
  - `audio_sound_gain` is given the sound asset `snd_TY`, not the voice that `audio_play_sound` returned.
  - The GameMaker LTS manual says that an asset's gain also applies to later plays and multiplies the voice gain.
  - The fade leaves the asset gain at 0 or below, and nothing sets it back: `audio_sound_gain` appears only on this line. In floating point, ten subtractions of 0.1 from 1 leave a tiny positive value, so the loop runs once more and the last call passes about −0.1.
  - `Vol = 1;` in `obj_WinManager/Create_0.gml:14` resets the instance variable, not the asset gain.
- **How it was found and verified:**
  - Found by a Claude subagent. Codex checked the manual and the `Create` reset.
  - Reproduced in the IDE by winning Night 2 twice in one session. In the recording, the first credits play the music; the second credits are digitally silent (−91 dB measured with `ffmpeg volumedetect`) until the player taps out of them.
- **Evidence:** [evidence/logic-03-credits-silent-second-time.mp4](evidence/logic-03-credits-silent-second-time.mp4), with sound and captions. About a minute is cut out between the two wins: the return to the menu, **Continue** and the second change of the hour.
- **Recommended fix:**
  1. In `obj_WinManager` Alarm 1, store the id returned by **Play Audio** in an instance variable such as `snd_ty_voice`, using the action's *target* field.
  2. In Alarm 3, pass `snd_ty_voice` to **Audio Set Volume** instead of `snd_TY`.
- **How to reproduce it today and check the fix:**
  1. Run with **Debug** (F6). Tap **Continue**. To skip the night, pause, set `Hora` to 8 in the **Globals** list of the **Variables** tab, and resume. The clock checks the hour once per minute (`obj_WinTimer`, alarm of 3600 steps), so the win can take up to a minute.
  2. When the credits play, tap them. The fade-out runs and the game returns to the menu.
  3. Without closing the game, tap **Continue** and win Night 2 again the same way.
  4. Today: the second credits are silent. After the fix, they play at normal volume.

## LOGIC-04 — The clock stays on 5 AM for two intervals

- **Severity:** Medium.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_WinTimer/Create_0.gml`: `global.Hora = 0;` and `alarm_set(0, 3600);`
  - `objects/obj_WinTimer/Alarm_0.gml:6`: `if(global.Hora == 8)`
  - `objects/obj_WinTimer/Alarm_0.gml:49`: `global.Hora = global.Hora+1;`
  - `objects/obj_WinTimer/Alarm_0.gml:221`: `case 7:`
  - `objects/obj_WinTimer/Alarm_0.gml:229`: `sprite_index = spr_5AM;`
- **What it is:**
  - Each alarm (3600 steps, 60 s at `"option_game_speed":60,`) first checks `Hora == 8`. If that is false, it increments `Hora` and then switches on cases 0 to 7.
  - Alarms 1–7 show 11 PM to 5 AM. Alarm 8 sets `Hora = 8`, which has no case, so the clock stays on 5 AM. Alarm 9 wins.
  - The result is 9 nominal minutes per night, with 5 AM lasting two minutes. Equal hours are the expected design, but that is inferred, not documented.
  - `case 0` can never run, because the switch is evaluated after the increment.
- **How it was found and verified:** Claude subagent, by reading the code. Codex re-traced it (32,400 steps) and found no other write to `global.Hora`.
- **Recommended fix:** in the first **If Variable** of `obj_WinTimer` Alarm 0, change the value `8` to `7`. Each hour then lasts the same, and the night lasts 8 minutes. The night length is a design choice, so confirm it is the intended one first.
- **How to check it is fixed:** temporarily set the alarm to 60 steps and time it. Each hour lasts the same, and the win comes right after 5 AM.

## LOGIC-05 — The jumpscare video is never closed

- **Severity:** Low.
- **Confidence:** confirmed that the close call is missing. Any memory effect is not proven.
- **Location and quotes:**
  - `objects/obj_PMJS/Create_0.gml:1`: `global.video = video_open("vd_PSJS1.mp4");`
  - `objects/obj_GOManager/Alarm_0.gml:5`: `with(obj_PMJS) instance_destroy();`
- **What it is:**
  - There is no `video_close` anywhere in the project.
  - `obj_PMJS` has only Create and Draw events: no Destroy and no Clean Up.
- **How it was found and verified:**
  - Found by a Claude subagent.
  - Codex confirmed it. It noted that the manual describes a single video slot, so it is not proven that every loss adds another decoder.
- **Recommended fix:** add a **Clean Up** event to `obj_PMJS` that calls `video_close();`.
- **How to check it is fixed:** lose to Prismoso several times in a row with the GameMaker profiler open. Memory returns to the same level each time the menu loads.

## LOGIC-07 — The Prismoso movement chance only works at `PMIA = 20`

- **Severity:** Low (a latent defect: today the value is always 20).
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_PM/Create_0.gml:18`: `global.PMIA = 20;`
  - `objects/obj_PM/Alarm_0.gml:17`: `PMProb = (global.PMIA)*5;`
  - `objects/obj_PM/Alarm_0.gml:26`: `PMComp = floor(random_range(0, (100-PMProb) + 1));`
  - `objects/obj_PM/Alarm_0.gml:34`: `if(PMComp == (100-PMProb)/2)`
- **What it is:**
  - For an integer `PMIA` from 0 to 20:
    - An odd value makes the target a half-integer, so the chance is 0.
    - An even value gives a chance of 1/(101 − 5·PMIA): 1/51 at 10 and 1/101 at 0.
    - At 20 the move always happens.
  - Tuning the difficulty of a future night by changing `PMIA` would therefore stop Prismoso moving, or almost.
- **How it was found and verified:** Claude subagent calculation. Codex recomputed the formula for all values and confirmed that `PMIA` is never assigned another value.
- **Recommended fix:** in `obj_PM` Alarm 0, replace the comparison with "if `irandom(19) < global.PMIA`". This gives a chance of `PMIA`/20, and the value 20 behaves exactly as today.
- **How to check it is fixed:**
  - With `PMIA = 10`, Prismoso moves on about half of the alarms.
  - With 0 it never moves, and with 20 it always moves.
