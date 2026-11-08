# Dead code and unused assets

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root. Line numbers count LF characters.

Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

## How "unused" was established

An asset or object is reported as unused only when its name, matched as a whole word, appears nowhere outside its own folder. The search covered:

- every `.gml` file in `objects/` and `rooms/` (160 event files and 6 instance creation-code files);
- every `.yy` file in `rooms/`, `sequences/`, `objects/` (`spriteId`, `parentObjectId`, `spriteMaskId`) and `sprites/`;
- the `.dnd` backup files.

Being registered in `Five Nights at ESCOM.yyp` or `Five Nights at ESCOM.resource_order` was not counted as a use. The search also looked for names that are built at run time:

- `asset_get_index` is used 0 times;
- quoted asset names (`"spr_`, `"snd_`, `"obj_`) appear 0 times;
- the only string concatenation in the project is the privacy text in `objects/obj_MM_Empty/Draw_64.gml:22`, which builds no asset name.

Reachability was then followed from the first room, `MenuPrincipal`, through room instances that are not ignored, creation code, `room_goto` targets and instance creation.

These folders do not exist in the project: `scripts/`, `tilesets/`, `paths/`, `shaders/`, `timelines/`, `notes/`, `extensions/` and `animcurves/`.

Who did what:

- A Claude subagent (Opus 5.5) did the search, with its own Python scripts.
- Codex (GPT-6.1-sol) repeated it independently with clean context and added the `.dnd` files.

Disk sizes are sizes in the repository, not sizes inside the APK. Measuring the APK requires a build, and none was made for this audit.

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| DEAD-01 | A third-party effects pack (635 sprites, 195 sounds, 19.7 MB on disk) is never used | Medium | confirmed |
| DEAD-02 | 33 project sprites (maps, map UI, camera UI, a button) have no reference | Low | confirmed |
| DEAD-03 | Sequence `sqn_PMJS1`, its 3 sprites and `snd_PMJS` are unreachable | Low | confirmed |
| DEAD-04 | 14 objects are never placed or created, plus 4 sprites only they use | Low | confirmed |
| DEAD-05 | Rooms `Guardia`, `N134` and `N1345` are never visited | Low | confirmed |
| DEAD-06 | `obj_CamBase` has no events and two ignored instances | Low | confirmed |
| DEAD-07 | `obj_Opciones` and `obj_Extras` are empty and ignored in the main menu | Low | confirmed |
| DEAD-08 | Two events are registered in `.yy` files but have no `.gml` file | Low | confirmed |
| DEAD-09 | Three empty event files and an empty `else` in every camera | Low | confirmed |
| DEAD-10 | Variables that are written but never read, and an unreachable `break` | Low | confirmed |

---

## DEAD-01 — A third-party effects pack is never used

- **Severity:** Medium.
- **Confidence:** confirmed (no references). The APK saving is likely; it was not measured.
- **Location and quotes:**
  - `options/main/options_main.yy:19`: `"option_remove_unused_assets":false,`
  - `Five Nights at ESCOM.yyp:390`: `{"id":{"name":"wav_snd_knight_death","path":"sounds/wav_snd_knight_death/wav_snd_knight_death.yy",},},`
  - `Five Nights at ESCOM.yyp:1252`: `{"id":{"name":"spr_water_droplet","path":"sprites/spr_water_droplet/spr_water_droplet.yy",},},`
- **What it is:**
  - The IDE folders `Sprites/Animated VFX` and `Sprites/Single Sprites` hold 635 sprites (13,671,780 bytes).
  - The IDE folders `Sounds/WAV`, `Sounds/OGG` and `Sounds/MP3` hold 195 sounds (6,004,345 bytes): the same 65 effects, once in each format.
  - None of these 830 assets is referenced. Together they are 70% of the project's 1,180 resources.
  - They were added in the first commit, `b4b4ecc` (2025-06-10). The folder names suggest a sample pack, but that origin is not proven.
- **Why it matters:**
  - With `option_remove_unused_assets` set to `false`, GameMaker packages these assets, so the download and the install are larger with no effect on the game.
  - They also clutter the Asset Browser when searching.
- **How it was found and verified:**
  - Found by a Claude subagent: whole-word search plus folder grouping, and `git log --diff-filter=A` for the date it was added.
  - Codex re-counted the same 635 + 195 assets and 19,676,125 bytes, and found no references in `.dnd` files either.
- **Recommended fix:**
  1. In the Asset Browser, delete the folders `Sprites/Animated VFX`, `Sprites/Single Sprites`, `Sounds/WAV`, `Sounds/OGG` and `Sounds/MP3`. Deleting from the IDE also updates the `.yyp` and the `.resource_order`.
  2. Run `python tools/validate_project.py` and run the game once.
- **How to check it is fixed:**
  - The `.yyp` no longer lists `wav_`, `ogg_` or `mp3_` sounds.
  - `sprites/` and `sounds/` are about 19.7 MB smaller.
  - The exported APK or AAB is smaller than the one built from `0adaaaa`.

## DEAD-02 — 33 project sprites have no reference

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quote:** `Five Nights at ESCOM.yyp:1212`: `{"id":{"name":"spr_TMap_1","path":"sprites/spr_TMap_1/spr_TMap_1.yy",},},`
- **What it is:** 33 sprites, 637,785 bytes:
  - 18 map variants (`spr_BMap`, `spr_CMap_1`, `spr_CMap_2`, `spr_GMap*`, `spr_PMap*`, `spr_TMap_1`…`spr_TMap_6`, `spr_TMap_C/G/P`);
  - 11 map UI variants (`spr_CUI_1`, `spr_CUI_2`, `spr_GUI*`, `spr_PUI*`, `spr_TUI*`);
  - `spr_Bat7`, `spr_Rec_1`, `spr_Rec_2` and `spr_ButtonLeft`.

  The base sprites of these families are used: `objects/obj_CharacterMap/obj_CharacterMap.yy:31` has `"name":"spr_CMap",`, `obj_CharacterUI.yy:31` has `"name":"spr_CUI",` and `obj_Rec.yy:31` has `"name":"spr_Rec",`.
- **How it was found and verified:** Claude subagent search. Codex confirmed the 33 assets and their byte count, and checked that the used base sprites do not cover the variants.
- **Recommended fix:**
  - If these sprites are art for future nights, move them to an IDE folder named for that purpose.
  - If they are not, delete them from the IDE.
- **How to check it is fixed:** the search reports none of these names as unreferenced.

## DEAD-03 — Sequence `sqn_PMJS1`, its sprites and `snd_PMJS` are unreachable

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `Five Nights at ESCOM.yyp:240`: `{"id":{"name":"sqn_PMJS1","path":"sequences/sqn_PMJS1/sqn_PMJS1.yy",},},`
  - `Five Nights at ESCOM.yyp:387`: `{"id":{"name":"snd_PMJS","path":"sounds/snd_PMJS/snd_PMJS.yy",},},`
  - `objects/obj_PMJS/Create_0.gml:1`: `global.video = video_open("vd_PSJS1.mp4");`
- **What it is:**
  - Nothing plays `sqn_PMJS1` or `snd_PMJS`.
  - `spr_Disparo`, `spr_PMJS` and `spr_RS` are referenced only from that sequence, for example `sequences/sqn_PMJS1/sqn_PMJS1.yy:44`.
  - The current jumpscare plays the included video `vd_PSJS1.mp4`.
  - Together these assets take 1,592,434 bytes.
- **How it was found and verified:** Claude subagent reachability graph. Codex confirmed the references and the byte count.
- **Recommended fix:** delete `sqn_PMJS1`, `spr_Disparo`, `spr_PMJS`, `spr_RS` and `snd_PMJS` from the IDE.
- **How to check it is fixed:** losing to Prismoso still plays the video, and the five names are gone from the `.yyp`.

## DEAD-04 — 14 objects are never placed or created

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `Five Nights at ESCOM.yyp:139`: `{"id":{"name":"MM1","path":"objects/MM1/MM1.yy",},},`
  - `objects/objN2/objN2.yy:4`: `"eventList":[],`
  - `objects/obj_deb1/Alarm_0.gml:6`: `room_goto(N1);`
  - `objects/obj_Music/Create_0.gml:4`: `variable = room;`
- **What it is:**
  - These objects have no room instance, no `instance_create*`, no `with` and no parent reference: `MM1`, `MMT`, `objN2` to `objN8`, `obj_ButtonUp`, `obj_Derecha`, `obj_Music`, `obj_PrismosoGO` and `obj_deb1`.
  - `objN2`…`objN8` and `obj_PrismosoGO` have no events and no sprite.
  - Four sprites are used only by these objects: `MM_BG`, `MM_BG_Base`, `MM_Text1` and `spr_ButtonRight` (560,522 bytes).
- **How it was found and verified:**
  - Found by a Claude subagent. Its first count said 3 dependent sprites.
  - Codex confirmed the 14 objects and corrected the count to 4 sprites, citing `objects/obj_Derecha/obj_Derecha.yy:34` `"name":"spr_ButtonRight",`.
- **Recommended fix:**
  - Delete the 14 objects and the 4 sprites from the IDE.
  - If `objN2`…`objN8` are reserved for future nights, say so in the README.
- **How to check it is fixed:** a full run (menu, newspaper, Night 1, win or game over, Continue, Night 2) behaves as before.

## DEAD-05 — Rooms `Guardia`, `N134` and `N1345` are never visited

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `Five Nights at ESCOM.yyp:1325`: `{"roomId":{"name":"N134","path":"rooms/N134/N134.yy",},},`
  - `Five Nights at ESCOM.yyp:1326`: `{"roomId":{"name":"N1345","path":"rooms/N1345/N1345.yy",},},`
  - `Five Nights at ESCOM.yyp:1329`: `{"roomId":{"name":"Guardia","path":"rooms/Guardia/Guardia.yy",},},`
- **What it is:**
  - There are 10 `room_goto` calls, which go to `Culturales1`, `Win`, `MenuPrincipal`, `N1`, `N2`, `GameOver` and `Periodico`.
  - There are no `room_goto_next`, `room_goto_previous` or `room_restart` calls.
  - `Guardia` has no instances. `N134` and `N1345` each hold one `objN1_E`.
- **How it was found and verified:** Claude subagent search. Codex repeated the navigation search and found no path to these rooms.
- **Recommended fix:** delete the three rooms from the IDE. They also leave the room order.
- **How to check it is fixed:** `RoomOrderNodes` lists 7 rooms and the game still starts in `MenuPrincipal`.

## DEAD-06 — `obj_CamBase` has no events and two ignored instances

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_CamBase/obj_CamBase.yy:4`: `"eventList":[],`
  - `rooms/Culturales1/Culturales1.yy:113`: an instance named `inst_557DD803` with `"ignore":true`.
  - `rooms/N2/N2.yy:117`: an instance named `inst_557DD803_N2` with `"ignore":true`.
- **What it is:**
  - The object folder contains only the `.yy` file, and no object uses it as a parent.
  - Its sprite, `spr_ButtonsBase`, is referenced only by `obj_CamBase.yy`.
- **How it was found and verified:** Claude subagent. Codex confirmed it and corrected the name of the N2 instance.
- **Recommended fix:** make `obj_CamBase` the parent of the cameras, as described in [DUP-01](duplication.md#dup-01--19-camera-objects-copy-the-same-tap-event-and-alarm-0). Then remove the two ignored instances.
- **How to check it is fixed:** searching for `"ignore":true` in `rooms/Culturales1` and `rooms/N2` returns no matches.

## DEAD-07 — `obj_Opciones` and `obj_Extras` are empty and ignored in the main menu

- **Severity:** Low.
- **Confidence:** confirmed.
- **Note:** addressed by a separate pull request (Options screen). This finding describes commit `0adaaaa` only.
- **Location and quotes:**
  - `rooms/MenuPrincipal/MenuPrincipal.yy:26`: `"%Name":"inst_15A707C"` … `"ignore":true` … `"objectId":{"name":"obj_Opciones","path":"objects/obj_Opciones/obj_Opciones.yy",}`
  - `rooms/MenuPrincipal/MenuPrincipal.yy:27`: `"%Name":"inst_1A5228E8"` … `"ignore":true` … `"objectId":{"name":"obj_Extras",...}`
  - `objects/obj_Opciones/obj_Opciones.yy:4` and `objects/obj_Extras/obj_Extras.yy:4`: `"eventList":[],`
- **What it is:**
  - The menu shows neither Options nor Extras.
  - `spr_Opciones` and `spr_Extras1` are used only by these two objects.
  - `spr_Extras2` and `spr_Extras3` have no reference.
- **How it was found and verified:** Claude subagent. Codex confirmed both instances and both empty event lists.
- **Recommended fix:**
  - Options: handled by the separate pull request.
  - Extras: decide whether to build it, or delete it together with `spr_Extras1`…`spr_Extras3`.
- **How to check it is fixed:** searching for `"ignore":true` in `rooms/MenuPrincipal` returns no matches.

## DEAD-08 — Two events are registered without a `.gml` file

- **Severity:** Low.
- **Confidence:** confirmed for the missing files. What the IDE does with them was not checked.
- **Location and quotes:**
  - `objects/obj_Bat/obj_Bat.yy:5`: `"eventNum":0,"eventType":0,"isDnD":true` (Create). There is no `objects/obj_Bat/Create_0.gml`.
  - `objects/obj_ButtonUp/obj_ButtonUp.yy:8`: `"eventNum":0,"eventType":2,"isDnD":true` (Alarm 0). There is no `objects/obj_ButtonUp/Alarm_0.gml`.
- **What it is:**
  - `git log --all` shows that neither file ever existed.
  - `obj_Bat` has instances in both nights.
  - `tools/validate_project.py` checks only the resources listed in the `.yyp`, so CI does not notice the gap (see [CI-02](ci-and-git.md#ci-02--the-validator-only-checks-that-files-exist)).
- **How it was found and verified:**
  - Found by a Claude subagent, comparing each `eventList` with the files on disk.
  - Codex confirmed it and lowered the severity from Medium to Low, because no effect in the IDE is proven.
- **Recommended fix:**
  1. In the IDE, delete the empty Create event of `obj_Bat`, or give it its intended actions, and save.
  2. `obj_ButtonUp` goes away with DEAD-04.
- **How to check it is fixed:** every event listed in an object's `.yy` has its `.gml` file, and the check added in CI-02 passes.

## DEAD-09 — Empty event files and empty `else` branches

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - The files `objects/obj_PM/Alarm_3.gml`, `objects/obj_UI/Create_0.gml` and `objects/obj_WinManager/Gesture_0.gml` are 0 bytes.
  - `objects/obj_PM/obj_PM.yy:9`: `"eventNum":3,"eventType":2`
  - `objects/obj_Cam_01/Gesture_0.gml:355`: `else`, followed by `{`, an empty line and `}`. The same block appears in all 19 cameras.
- **What it is:** nothing sets Alarm 3 of `obj_PM`, so that empty event can never run.
- **How it was found and verified:** Claude subagent. Codex confirmed the three empty files and the `else` blocks.
- **Recommended fix:** delete the three events and the empty DnD **Else** action. In the cameras, the `else` disappears with DUP-01.
- **How to check it is fixed:** no `.gml` file under `objects/` is 0 bytes.

## DEAD-10 — Variables that are written but never read

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_Coco/Create_0.gml:85`: `global.ManMov = 0;`
  - `objects/obj_Coco/Create_0.gml:86`: `global.ManIA = 0;`
  - `objects/obj_ButtonUp/Create_0.gml:17`: `global.cami = 0;`
  - `objects/obj_PMJS/Create_0.gml:1`: `global.video = video_open("vd_PSJS1.mp4");`
  - `objects/obj_GOManager/Create_0.gml:4`: `InstGO = 0;`
  - `objects/obj_GOManager/Create_0.gml:18` and `:19`: two `break;` lines in a row; the second can never run.
- **How it was found and verified:** Claude subagent search for global and instance writes with no read. Codex confirmed that none of them is read.
- **Recommended fix:**
  - Remove the assignments `global.ManMov`, `global.ManIA`, `global.cami` and `InstGO`.
  - Keep the calls themselves: `video_open(...)` and `instance_create_layer(...)` have effects that the game uses.
  - Remove the second `break;`.
- **How to check it is fixed:** a search for each variable name in `objects/` finds no assignment without a read.
