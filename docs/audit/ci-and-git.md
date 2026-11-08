# CI and git workflow

Audited commit: `0adaaaab73c1bdc666d347904d1fdbdf3878a52c` (2026-11-07). Paths are relative to the repository root.

Severity and confidence follow the scale in [README.md](README.md#severity-and-confidence).

## What was read

- `.github/workflows/pr-quality-gate.yml`, the only workflow in the audited tree.
- `tools/validate_project.py`. It was read in full first, to confirm that it writes nothing, and then run: `python tools/validate_project.py` exits 0 with `OK: los 1180 recursos declarados en Five Nights at ESCOM.yyp existen en disco.`
- `.gitignore` and `.gitattributes`.
- The local history, with `git log --oneline --graph` over `upstream/main`, `upstream/prepare/android-night2-update` and `upstream/prepare/google-play-closed-test`.
- Read-only GitHub API queries made on 2026-11-07 with `gh`: pull requests, workflow runs, workflows and the Pages source.

The workflow states its own scope, and this audit accepts that scope. It says that the game cannot be compiled on a free runner without a GameMaker licence:

> `# No es posible compilar ni correr el juego completo en GitHub Actions sin una`
> `# licencia de GameMaker y su runtime (Igor), que no esta disponible en un`
> `# runner gratuito.`

The missing build step is therefore not reported as a finding.

| ID | Finding | Severity | Confidence |
|---|---|---|---|
| CI-01 | The QA step only checks that `PRUEBAS.md` is not empty | Medium | confirmed |
| CI-02 | The validator only checks that files exist, and the workflow sets no token permissions | Low | confirmed |
| CI-03 | No completed CI run is recorded for the release line | Low | confirmed (git) / likely (run history) |

---

## CI-01 — The QA check only tests that `PRUEBAS.md` is not empty

- **Severity:** Medium (maintenance: a green check gives no information about QA).
- **Confidence:** confirmed.
- **Location and quotes:**
  - `.github/workflows/pr-quality-gate.yml:34`: `if [ ! -s "docs/evidencias/entrega1/PRUEBAS.md" ]; then`
  - `.github/workflows/pr-quality-gate.yml:38`: `echo "docs/evidencias/entrega1/PRUEBAS.md tiene contenido. OK."`
  - `docs/evidencias/entrega1/PRUEBAS.md:14`: one of the test cases whose result is still `[PENDIENTE]` (lines 14-17 and 69).
- **What it is:**
  - Today the file is 7,274 bytes, so the step passes on any pull request, whether or not the tests were updated or run.
  - Several test cases still have no result.
  - The brief's claim that "CI only checks that `PRUEBAS.md` is not empty" is not accurate. The workflow also runs `tools/validate_project.py` (lines 29-30), and only the QA step is a non-empty check.
- **How it was found and verified:**
  - Found by Codex (GPT-6.1-sol), which read the workflow and reproduced the check locally.
  - A Claude subagent (Opus 5.5) confirmed the lines and the cases with no result.
- **Recommended fix:**
  1. Give each test case in `PRUEBAS.md` a fixed result column (`PASS`, `FAIL` or `N/A`) and a build identifier line.
  2. In the workflow, replace the non-empty check with a short script. It fails when any required case still says `[PENDIENTE]`, or when the build identifier does not match the commit under review.
  3. Optionally, require `PRUEBAS.md` to change in pull requests that touch `objects/` or `rooms/`.
- **How to check it is fixed:** on a test branch, a `PRUEBAS.md` with a `[PENDIENTE]` result makes the check fail, and a complete one makes it pass.

## CI-02 — The validator only checks that files exist

- **Severity:** Low.
- **Confidence:** confirmed. Today's tree passes all the extra checks, so the gap has no current effect.
- **Location and quotes:**
  - `tools/validate_project.py:34`: `data = load_yyp(yyp_path)`
  - `tools/validate_project.py:39`: `if not os.path.isfile(rel_path):`
  - `.github/workflows/pr-quality-gate.yml:3-5`: `on:`, `pull_request:`, `branches: [ main ]`
  - `.github/workflows/pr-quality-gate.yml:22`: `uses: actions/checkout@v4`
  - `.github/workflows/pr-quality-gate.yml:25`: `uses: actions/setup-python@v5`
- **What it is:**
  - The validator never opens the `.yy` files it lists, so a malformed `.yy` passes.
  - It does not notice `.yy` files that exist on disk but are not in the `.yyp`.
  - It does not notice events listed in an object's `eventList` that have no `.gml` file. Two such events exist today ([DEAD-08](dead-code.md#dead-08--two-events-are-registered-without-a-gml-file)).
  - The workflow has no `permissions:` key. The effective token permissions depend on repository settings, which were not checked.
  - The actions are pinned by major version, not by commit SHA.
- **How it was found and verified:**
  - Found by a Claude subagent. Its own read-only script confirmed that today there are 0 malformed `.yy` files and 0 undeclared ones.
  - Codex confirmed the validator's limits. It noted that a missing `permissions:` key does not prove excessive permissions.
- **Recommended fix:**
  1. In `validate_project.py`, parse every declared `.yy` with the same `load_yyp` function.
  2. Also list `.yy` files on disk that are not declared.
  3. For each object, check that every `eventList` entry has its `.gml` file.
  4. Add `permissions: contents: read` at the top level of the workflow.
- **How to check it is fixed:** on a test branch, break a comma in one `.yy` file, or delete one event `.gml`. CI fails with a message that names the file.

## CI-03 — No completed CI run is recorded for the release line

- **Severity:** Low. The workflow covers only checks that do not need the engine, and manual QA is the documented main gate.
- **Confidence:** confirmed for the git structure. The run history comes from the GitHub API and is likely: deleted runs cannot be ruled out.
- **Location and quotes:**
  - `.github/workflows/pr-quality-gate.yml:3-5`: `on:` / `pull_request:` / `branches: [ main ]`
  - The audited commit `0adaaaa` is on `prepare/android-night2-update`. `git merge-base --is-ancestor 0adaaaa upstream/main` exits 1, so it is not on `main` (`f62f9f0`).
  - `git log --diff-filter=A -- .github/workflows/pr-quality-gate.yml` shows that the workflow arrived with `f62f9f0 Feature/night 2 and Intruso added (#4)`.
- **What it is:**
  - The release line has no pull request into `main`. It holds nine commits from 2026-10-23 to 2026-11-07, including the merge `05511c1`.
  - The workflow runs only on pull requests into `main`, so it is not triggered by commits pushed directly to that branch.
  - On 2026-11-07 the API listed two `pull_request` runs in the repository's history. Both are for PR #2 (`feature/luis-changes`), and both have the conclusion `action_required`, which means they are waiting for a maintainer to approve them.
  - No completed run is listed for PR #4 or for the release branch.
- **How it was found and verified:**
  - Found by the main session (Claude) with `git log --graph` and `gh api .../actions/runs`.
  - Codex confirmed the ancestry and the single trigger, and found no other workflow on those branches. Its environment had no network access, so it could not repeat the API queries.
  - Codex lowered the severity to Low, and reworded "never passed CI" to "no completed run is recorded".
- **Recommended fix:**
  1. Open a pull request from `prepare/android-night2-update` into `main` before the release, so the existing gate runs on the release code.
  2. Approve the two fork runs that are waiting for approval, or set the repository's fork-approval policy so that they do not wait.
  3. If release branches will keep receiving direct pushes, add `push: branches: [ 'prepare/**' ]` to the workflow triggers.
- **How to check it is fixed:** the **Actions** tab shows a completed "PR Quality Gate" run for the release commit.
