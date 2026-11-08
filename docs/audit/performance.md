# Android performance and package size

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root. Line numbers count LF characters.

Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

## Limits of this report

- No APK or AAB was built, and the game was not profiled on a phone. A build from the command line (Igor, runtime 2026.0.0.23) stopped with `Permission Error : Unable to obtain permission to execute`: the GameMaker installation on the audit machine was not signed in.
- The measurements below are therefore configuration values, file sizes and video metadata (`ffprobe`). Any effect on APK size, memory or frame rate is labelled `likely` until someone measures it.

## Checked, with no finding

- **Step and Draw events:** no Step or Draw event runs a per-frame search (`instance_find`, `collision_*` or loops). The camera `with` blocks run only on a tap.
- **Surfaces:** there are no `surface_create` calls.
- **Division by zero:** no reachable case.

## Measured sizes on disk

| Folder | Size |
|---|---|
| `sprites/` | 69 MB (PNG frames and layers) |
| `datafiles/` | 27.4 MB (one video) |
| `sounds/` | 12.2 MB |

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| PERF-01 | All 211 sounds are uncompressed and none is streamed, including three music tracks of 53–133 s | Medium | confirmed (settings) / likely (memory) |
| PERF-02 | The build keeps unused assets (`option_remove_unused_assets` is `false`) | Medium | confirmed (setting) / likely (size) |
| PERF-03 | The main background (2125 px wide) does not fit the 2048×2048 texture page | Medium | confirmed (does not fit) / likely (visible loss) |
| PERF-04 | The jumpscare video is 27.4 MB for 10.5 s (20.7 Mbit/s at 59.94 fps) | Medium | confirmed (measured) / likely (APK saving, stutter) |

---

## PERF-01 — All sounds are uncompressed and not streamed

- **Severity:** Medium.
- **Confidence:** confirmed for the settings. Memory use is an estimate (likely).
- **Location and quotes:**
  - `sounds/snd_BKMusic/snd_BKMusic.yy:10`, `sounds/snd_MM/snd_MM.yy:10` and `sounds/snd_TY/snd_TY.yy:10`: `"compression":0,`
  - The durations of those three tracks are 133.3 s, 71.5 s and 52.8 s.
- **What it is:**
  - All 211 sounds use compression 0 (uncompressed, not streamed), 16-bit and 44.1 kHz.
  - All of them are in `audiogroup_default`, which GameMaker loads at game start (`"preload":false` in a sound's `.yy` does not change that for non-streamed sounds in the default group).
  - The 15 sounds the game uses add up to 309.4 s of audio. As 16-bit mono PCM that is about 27.3 MB (estimate). Their source files take 6.0 MB.
- **Why it matters:** the uncompressed audio makes the APK larger and uses more memory from the first frame. On low-end phones, more memory in use makes it more likely that Android closes the game in the background (likely).
- **How it was found and verified:**
  - Found by a Claude subagent (Opus 5.5) by reading all 211 `sounds/*/*.yy` files and adding up their durations.
  - Codex (GPT-6.1-sol) re-counted it and checked the loading behaviour of `audiogroup_default` in the GameMaker LTS manual.
- **Recommended fix:**
  1. In the Sound Editor, set `snd_BKMusic`, `snd_MM` and `snd_TY` to **Compressed – Streamed**.
  2. Set the effects longer than about 2 s to **Compressed – Not Streamed**: `snd_Laser`, `snd_Footsteps`, `snd_GameOver`, `snd_6AM`, `snd_Night`, `snd_CamUp`, `snd_Electricidad` and `snd_IntrusoJS`.
  3. Leave short clicks uncompressed.
- **How to check it is fixed:**
  - Build the APK before and after the change and compare the sizes.
  - Compare memory in the main menu with the GameMaker profiler.
  - Play both nights and listen for missing or clipped sounds.

## PERF-02 — The build keeps unused assets

- **Severity:** Medium.
- **Confidence:** confirmed for the setting. The size reduction is likely.
- **Location and quote:** `options/main/options_main.yy:19`: `"option_remove_unused_assets":false,`
- **What it is:**
  - 196 sounds and 670 sprites have no reference anywhere in the project ([DEAD-01](dead-code.md#dead-01--a-third-party-effects-pack-is-never-used) to [DEAD-04](dead-code.md#dead-04--14-objects-are-never-placed-or-created)).
  - With this option off, the build packages them anyway.
  - This finding overlaps with the DEAD findings, so the two savings should not be added together. It is listed separately because one checkbox fixes it, while deleting the assets takes longer.
- **How it was found and verified:**
  - Found by a Claude subagent.
  - Codex repeated the reference search, including `.dnd` files, and got the same 196 and 670.
  - The game never loads an asset by a name built at run time: 0 `asset_get_index` calls and 0 quoted asset names. That makes the option safe to turn on.
- **Recommended fix:** in **Game Options → Main**, enable **Remove unused assets**.
- **How to check it is fixed:**
  - Build the APK before and after and compare the sizes.
  - Play both nights, a loss and a win, and check that nothing is missing.

## PERF-03 — The main background does not fit the texture page

- **Severity:** Medium.
- **Confidence:** confirmed that it does not fit. The visible loss of sharpness is likely.
- **Location and quotes:**
  - `options/android/options_android.yy:76`: `"option_android_texture_page":"2048x2048",`
  - `sprites/spr_Culturales1/spr_Culturales1.yy:89`: `"width":2125,`
  - `sprites/spr_Culturales1/spr_Culturales1.yy:7`: `"bbox_right":2124,`
- **What it is:**
  - Sixteen sprites are wider than 2048 px. In 15 of them the visible area is 63 to 445 px wide, so automatic cropping makes them fit.
  - The office background, `spr_Culturales1`, is opaque across its whole 2125 × 1080 area, so cropping does not help.
  - The GameMaker LTS manual says that a sprite too large for the texture page is scaled down by half, repeatedly if needed.
  - The other platforms also use 2048 × 2048, so the effect, if it shows, is the same on desktop.
- **Why it matters:** this background is on screen for the whole night. If it is halved, it would look noticeably blurrier than the rest of the art (likely, not observed).
- **How it was found and verified:**
  - Found by a Claude subagent from the sprite `.yy` files.
  - Codex measured the alpha bounds of the PNG files with Pillow.
  - Codex also corrected the expected effect: the first report said the background would be shrunk by about 3.6%, but the manual describes halving.
- **Recommended fix:** in **Game Options → Android → Graphics**, set the texture page to **4096×4096** (the minimum SDK is 24, Android 7.0).
- **Alternative:** split `spr_Culturales1` into two sprites narrower than 2048 px.
- **How to check it is fixed:**
  - The compile log no longer warns that `spr_Culturales1` was scaled.
  - A phone screenshot of the right edge of the office looks as sharp as the source PNG.

## PERF-04 — The jumpscare video is oversized

- **Severity:** Medium.
- **Confidence:** confirmed for the measurements. The APK saving and any stutter on low-end phones are likely.
- **Location and quotes:**
  - `Five Nights at ESCOM.yyp:129`: `"%Name":"vd_PSJS1.mp4"`
  - `objects/obj_PMJS/Create_0.gml:1`: `global.video = video_open("vd_PSJS1.mp4");`
- **What it is:** `ffprobe` reports for `datafiles/vd_PSJS1.mp4`:
  - 27,414,155 bytes, the largest file in the repository;
  - 10.52 s of H.264 video at 1280 × 720 and 59.94 fps;
  - a video bit rate of 20,700,607 bit/s;
  - AAC stereo audio at 48 kHz.
- **How it was found and verified:** Claude subagent with `ffprobe`. Codex reproduced every value.
- **Recommended fix:** re-encode the video with the same name, for example `ffmpeg -i vd_PSJS1.mp4 -c:v libx264 -preset slow -b:v 3M -r 30 -c:a aac -b:a 128k vd_PSJS1_new.mp4`. Check the result, then replace the file in `datafiles/`.
- **How to check it is fixed:**
  - `ffprobe` shows the new bit rate.
  - On a phone, losing to Prismoso plays the whole jumpscare smoothly, with the audio in sync.
