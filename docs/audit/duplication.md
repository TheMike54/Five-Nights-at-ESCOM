# Duplication

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root. Line numbers count LF characters, as `grep -n` and `rg -n` do.

This file is written so that a person or an AI coding agent can act on each finding on its own. Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

Most event files in this project are Drag and Drop (DnD) events. In GameMaker, a DnD `.gml` file holds each action twice: a `/// @DnDAction` header with `/// @DnDArgument` lines, followed by the GML that the action produces. Every proposal below is written as steps in the GameMaker IDE so that the DnD workflow is preserved. Where a code-based fix would be simpler, it is listed as an alternative.

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| DUP-01 | 19 camera objects copy the same 358-line tap event and the same Alarm 0 | High | confirmed |
| DUP-03 | 8 `obj_Prismoso*` objects copy the same Step and Create events | Medium | confirmed |
| DUP-04 | Room `N2` is a full copy of `Culturales1` plus one instance | Medium | confirmed |
| DUP-02 | 19 globals `global.Cam01`…`global.Cam19` duplicate `global.CamaraActiva` | Low | confirmed |
| DUP-05 | The "anchor to background" pattern is copied into 4 objects; two battery objects are near copies | Low | confirmed |

---

## DUP-01 — 19 camera objects copy the same tap event and Alarm 0

- **Severity:** High (serious maintenance risk).
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_Cam_01/Gesture_0.gml:5`: `if(global.Cam01 == 0)`
  - `objects/obj_Cam_01/Gesture_0.gml:13`: `global.CamaraActiva = 1;`
  - `objects/obj_Cam_02/Gesture_0.gml:5`: `if(global.Cam02 == 0)`
  - `objects/obj_Cam_02/Gesture_0.gml:13`: `global.CamaraActiva = 2;`
  - `objects/obj_Cam_01/Alarm_0.gml:5`: `layer_sequence_destroy(global.CamChng);` (the same in all 19 `Alarm_0.gml`)
- **What it is:** `obj_Cam_01` to `obj_Cam_19` each have a `Gesture_0.gml` (Tap) of 358 lines. Any two of them differ in 26 to 29 lines. The differences are the camera number, the camera's "on" sprite, the map dot sprite, the location sprite and the DnD hashes. The 19 `Alarm_0.gml` files are identical. In total, 6,802 lines (DnD metadata included) carry one piece of logic. No object in the project has a parent (`parentObjectId` is `null` in all 82 objects).
- **Why it matters:** adding a camera, or changing what a camera switch does (sound, transition, sprites), means editing 19 files by hand. A missed copy shows up as one camera that behaves differently from the others. Each copy differs from the others in only 26–29 lines, which makes such a mistake hard to spot in review.
- **How it was found and verified:**
  - Found by a Claude subagent (Opus 5.5) with Python `difflib.SequenceMatcher` over every pair of files and `wc -l`.
  - Codex (GPT-6.1-sol) re-counted it with clean context. It reproduced 358 lines and 26–29 differing lines, using `SequenceMatcher(autojunk=False)`. It also searched for any shared parent or script, and found none.
  - Codex proposed lowering the severity to Medium, because no copy has drifted yet. The main session kept High: this is the project's largest block of logic, every camera change has to be repeated 19 times, and the same copy-based approach has already been used for a whole room (DUP-04).
  - Not reproduced in the running game: this is a code-structure finding.
- **Recommended fix (keeps Drag and Drop):**
  1. Use the existing empty `obj_CamBase` (see [DEAD-06](dead-code.md#dead-06--obj_cambase-has-no-events-and-two-ignored-instances)) as the parent. In each `obj_Cam_NN`, set **Parent** to `obj_CamBase`.
  2. In each camera, open **Variable Definitions** and add `cam_num`, `spr_on`, `spr_dot` and `spr_place` with that camera's values.
  3. In `obj_CamBase`, create one **Tap** event in DnD. Have it follow the current flow, using the variables in place of the literal numbers and sprites:
     - If `global.CamaraActiva != cam_num`: play the switch sound, start the transition sequence and set the alarm.
     - Turn every camera button off with `with (obj_CamBase)`, then turn this one on.
     - Set `obj_Dots` to `other.spr_dot` and `obj_Lugares` to `other.spr_place`.
     - Set `global.CamaraActiva = cam_num`.
  4. Move the identical Alarm 0 into `obj_CamBase`.
  5. Delete the 19 `Gesture_0` and `Alarm_0` events from the children.
- **Alternative (changes the workflow to code):** a script function `cam_select(_num, _spr_on, _spr_dot, _spr_place)`, called from one *Execute Code* action in each camera.
- **How to check it is fixed:**
  - `objects/obj_Cam_*/Gesture_0.gml` no longer exists. Only `objects/obj_CamBase/Gesture_0.gml` remains.
  - In Night 1 and Night 2, tapping each of the 19 cameras turns on only that button, moves the map dot and shows that camera's image.

## DUP-02 — 19 globals duplicate `global.CamaraActiva`

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_Cam_02/Gesture_0.gml:331`: `global.Cam01 = 0;`
  - `objects/obj_Cam_02/Gesture_0.gml:332`: `global.Cam02 = 1;`
  - `objects/obj_Cam_01/Create_0.gml:5`: `global.Cam01 = 0;`
  - `objects/obj_Coco/Create_0.gml:53`: `global.Cam01 = 0;` (it continues up to `Cam19`)
- **What it is:** each camera keeps its own flag `global.CamNN`. The only place a flag is read is line 5 of that same camera's tap event. Every tap rewrites all 19 flags (lines 331–349), and `global.CamaraActiva` already stores the selected camera.
- **How it was found and verified:**
  - Found by a Claude subagent with a search for reads of `global\.Cam\d\d` outside each camera's own event: 0 reads.
  - Codex confirmed it and added the extra initialisation in `obj_Coco`.
- **Recommended fix:** while doing DUP-01, change the condition to `global.CamaraActiva != cam_num`. Then remove the 19 globals, the 19 camera `Create_0` events and the 19 assignments in `obj_Coco/Create_0.gml`.
- **How to check it is fixed:** a search for `global\.Cam\d\d` in `objects/` returns no matches.

## DUP-03 — 8 `obj_Prismoso*` objects copy the same Step and Create events

- **Severity:** Medium.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_Prismoso9/Step_0.gml:6`: `if(global.PMPos == 9)`
  - `objects/obj_Prismoso9/Step_0.gml:14`: `if(global.CamaraActiva == 9)`
  - `objects/obj_Prismoso10/Step_0.gml:6`: `if(global.PMPos == 10)`
  - `objects/obj_Prismoso10/Step_0.gml:14`: `if(global.CamaraActiva == 10)`
- **What it is:**
  - `obj_Prismoso9`, `10`, `12`, `14`, `15`, `16`, `17` and `18` each have a 49-line `Step_0.gml`. Any two of them differ only in the 4 lines that hold the number.
  - Their `Create_0.gml` files (`image_alpha = 0;`) are identical.
  - `obj_PrismosoO1` (the office version) contains different logic and is not part of this finding.
- **How it was found and verified:**
  - Found by a Claude subagent with `difflib` and `wc -l`.
  - Codex re-counted it independently: 8 objects, 49 lines, 4 differing lines.
  - A note on the brief: it said 7 objects and 47 lines. The measured values are 8 objects and 49 lines.
- **Recommended fix (keeps Drag and Drop):**
  1. Create `obj_PrismosoCam` with the shared Create and Step events. Use a variable `pos_num` in place of the literal number.
  2. Make the 8 objects children of `obj_PrismosoCam`. Set `pos_num` in each child's **Variable Definitions**. Alternatively, keep a single object and set `pos_num` in each room instance's creation code.
  3. Delete the 16 copied events.
- **How to check it is fixed:**
  - Only one `Step_0.gml` contains `global.PMPos == pos_num`.
  - In both nights, Prismoso appears on the right camera in each of the 8 positions.

## DUP-04 — Room `N2` is a full copy of `Culturales1`

- **Severity:** Medium.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `rooms/N2/N2.yy:106`: `"objectId":{"name":"obj_Intruso","path":"objects/obj_Intruso/obj_Intruso.yy",}`
  - `rooms/N2/N2.yy:156`: `"parentRoom":null,`
- **What it is:** with the `_N2` suffixes removed, `N2.yy` matches `Culturales1.yy` except for three things: the `obj_Intruso` instance, its entry in the creation order, and an empty layer `Instances_1`. The three instance creation-code files of `N2` are byte-for-byte equal to those of `Culturales1`.
- **Why it matters:** a fix to the office in Night 1 (a button position, a camera, the battery) does not reach Night 2 unless someone repeats it by hand. The same applies to every future night.
- **How it was found and verified:**
  - Found by a Claude subagent with a normalised `diff --strip-trailing-cr` and a byte comparison of the creation-code files.
  - Codex reproduced the comparison and found no other differences.
- **Recommended fix:**
  1. In the Room Editor, make `N2` a child of `Culturales1` (**Room Inheritance**).
  2. Keep only the `obj_Intruso` instance as N2's own.
  3. Delete the empty `Instances_1` layer and the duplicated creation code.
- **How to check it is fixed:**
  - `rooms/N2/N2.yy` has `"parentRoom":{"name":"Culturales1",...}`.
  - Moving a button in `Culturales1` also moves it in `N2`.

## DUP-05 — The "anchor to background" pattern is copied into 4 objects

- **Severity:** Low.
- **Confidence:** confirmed.
- **Location and quotes:**
  - `objects/obj_CLaser/Step_2.gml:1`, `objects/obj_CLaserButton/Step_2.gml:1`, `objects/obj_CPuerta/Step_2.gml:1` and `objects/obj_PrismosoO1/Step_2.gml:1`: `x = obj_Culturales1.x + anchorX;`
  - `objects/obj_CLaser/Create_0.gml:11` (and the same line in the other three Create events): `anchorX = x - obj_Culturales1.x;`
  - `objects/obj_BatCamara/Step_2.gml:6`: `if(global.BatCamara == 1)`, against the same line in `obj_BatLaser`: `if(global.BatLaser == 1)`
- **What it is:**
  - Four objects repeat the same Create/End Step pair.
  - `obj_BatCamara` and `obj_BatLaser` have 23-line End Step events that differ only in the global they read.
- **How it was found and verified:**
  - Found by a Claude subagent with a search for `obj_Culturales1` in `objects/` and `difflib`.
  - Codex confirmed every quote.
- **Recommended fix:**
  - Create a parent object `obj_AnchoredToBackground` with that Create and End Step, and make it the parent of the four objects. In a child that has its own Create, add the DnD action **Call Parent Event**.
  - Apply the same approach to the two battery objects, with the global to check stored in an instance variable.
- **How to check it is fixed:** a search for `obj_Culturales1.x + anchorX` returns one match. When the view pans, the laser, the button, the door and Prismoso stay attached to the background.
