---
id: f-04
title: Vendor FxConsole into the module
version: n/a
group: foundation
subgroup: vendoring
sequence: 4
depends_on: [f-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §3.1 FxConsole integration (lines 91-127)"
  - "PRD §8.3 Dependency strategy / Bundled module dependency (lines 1349-1369)"
  - "PRD §17 Open questions Q1 (line 2961)"
deliverables:
  - src/SlashOps/vendor/FxConsole/FxConsole.psd1
  - src/SlashOps/vendor/FxConsole/FxConsole.psm1
  - src/SlashOps/vendor/FxConsole/Public/*
  - src/SlashOps/vendor/FxConsole/Private/*
  - src/SlashOps/vendor/FxConsole/theme-config.json
  - src/SlashOps/vendor/FxConsole/LICENSE
  - src/SlashOps/vendor/FxConsole/SOURCE_VERSION.txt
  - tests/Unit/Vendor.FxConsole.Tests.ps1
tags: [foundation, vendor, fxconsole, ui]
---

## Overview

Vendor the FxConsole module under `src/SlashOps/vendor/FxConsole/` so Gallery users get a working UI without manually cloning. Preserve the MIT license verbatim, record the upstream commit SHA in `SOURCE_VERSION.txt`, and add a Pester test that imports the vendored module to catch regressions.

## TDD test list

- `Import-Module ./src/SlashOps/vendor/FxConsole/FxConsole.psd1` succeeds.
- All public exports listed in PRD §3.1 (`Set-FxTheme`, `Get-FxTheme`, `Format-Fx`, `Write-Fx`, `Write-FxStatus`, `Write-FxStep`, `Write-FxShimmer`, `Invoke-FxJob`, `Write-FxBanner`, `Write-FxCard`, `Write-FxPanel`, `Write-FxTable`, `Write-FxGrid`, `Write-FxProgress`, `Invoke-FxProgress`, `Invoke-FxScript`) resolve as functions.
- LICENSE file checksum matches upstream MIT.
- `SOURCE_VERSION.txt` contains a non-empty commit SHA.

## Implementation steps

1. Clone or download FxConsole from `https://github.com/andresharpe/FxConsole` at a known commit. Copy `src/FxConsole/` contents into `src/SlashOps/vendor/FxConsole/`.
2. Copy `LICENSE` from upstream verbatim.
3. Write `SOURCE_VERSION.txt` containing the commit SHA and date pulled.
4. Add `tests/Unit/Vendor.FxConsole.Tests.ps1` covering the test list.
5. Add a `.gitignore` exclusion for any FxConsole user-state files (e.g. `*.user.json`).

## PRD references

- §3.1 lists the FxConsole public surface SlashOps consumes.
- §8.3 mandates vendoring (with license preservation) until FxConsole is published as its own Gallery module.
- §17 Q1: revisit vendor-vs-dependency decision before v1.0.

## Acceptance criteria

- Vendored module imports cleanly cross-platform.
- All PRD §3.1 functions are exported.
- LICENSE preserved.
- Source version recorded.
- Pester test passes.

## Notes / risks

- Do not modify FxConsole source; treat the vendor folder as read-only mirror.
- If upstream changes its public surface, `ui-*` tasks need to adapt — re-vendor and re-run the export-list test before touching UI tasks.
