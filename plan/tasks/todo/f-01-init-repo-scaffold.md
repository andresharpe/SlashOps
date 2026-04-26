---
id: f-01
title: Initialize repository scaffold
version: n/a
group: foundation
subgroup: scaffold
sequence: 1
depends_on: []
status: todo
tdd_first: false
prd_refs:
  - "PRD §10.1 Proposed repository structure (lines 2219-2437)"
  - "PRD §12.1 Pre-publish checklist (lines 2727-2742)"
deliverables:
  - README.md (placeholder; final README is pub-05)
  - LICENSE (MIT)
  - CHANGELOG.md
  - .gitignore
  - .editorconfig
  - PRD.md (copy of source PRD)
tags: [foundation, scaffolding, license, repo]
---

## Overview

Set up the empty `SlashOps/` repository with the top-level files every PowerShell Gallery module needs. This task is intentionally minimal — `README.md` here is a placeholder; the real install / quickstart / safety README is delivered by `pub-05`. Licensing follows the FxConsole MIT model so the vendored module remains compatible.

## TDD test list

This task is not test-driven (it creates inert files), but the following sanity checks are part of acceptance:

- `git status` shows the new files staged and no working-tree garbage.
- `Get-Content .\LICENSE` parses as MIT text.
- `.gitignore` excludes `.local-psrepo/`, `*.bak`, `~/.slashops/` test artifacts, `.vscode/` user settings, and `runs/` outputs.

## Implementation steps

1. Create `README.md` with a one-paragraph stub pointing to `PRD.md` and `plan/`.
2. Create `LICENSE` with the MIT license, copyright `(c) 2026 Andre Sharpe`.
3. Create `CHANGELOG.md` with an `## Unreleased` heading.
4. Create `.gitignore` excluding build outputs, local PSRepository folders, `coverage.xml`, and IDE files.
5. Create `.editorconfig` enforcing UTF-8, LF for `*.ps1` / `*.psd1` / `*.psm1` / `*.json` / `*.md`, 4-space indent for PowerShell.
6. Copy `C:\Users\andre\Downloads\Slashops-PRD_v3.md` into the repo as `PRD.md` (linked living copy is `doc-10`).
7. Commit nothing — leave the working tree for the user to inspect.

## PRD references

- §10.1 lists the full target tree; this task only creates the top-level files. Subdirectories `src/`, `tests/`, `build/`, `docs/`, `examples/` are created on demand by later tasks.
- §12.1 item 4–6 require README, LICENSE, and CHANGELOG before publishing.

## Acceptance criteria

- All deliverable files exist at the repo root.
- `Test-Path` returns true for each.
- LICENSE is valid MIT.
- `.gitignore` includes `.local-psrepo/`, `coverage.xml`, `*.bak`, `**/runs/`.
- PRD.md byte size matches the source download.

## Notes / risks

- Do not commit secrets — `.env`, API keys, etc. are not part of this task and `.gitignore` should already block them.
- README content here is deliberately thin so `pub-05` can replace it without merge conflicts.
