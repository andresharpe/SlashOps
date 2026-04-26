---
id: ui-02
title: Banner and preflight panel
version: v0.1
group: ui
subgroup: panels
sequence: 2
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.15 Output rendering with FxConsole (lines 840-875)"
  - "PRD §8.9 Preflight test output (lines 1568-1590)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsBanner.ps1
  - src/SlashOps/Private/UI/Write-SlashOpsPreflight.ps1
  - tests/Unit/UI.Banner.Tests.ps1
tags: [ui, banner, preflight, fxconsole]
---

## Overview

Render the SlashOps banner (`SLASHOPS // local-first pwsh AI`) via `Write-FxBanner`, and the preflight checklist as a status table per §6.15 example.

## TDD test list

- Banner emits the documented title and subtitle.
- Preflight panel renders one row per check with status icon.
- Honours `ui.useFxConsole = false` by emitting plain text.
- Output deterministic for a fixed input set.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsBanner.ps1` and `Write-SlashOpsPreflight.ps1` calling FxConsole functions.
2. Tests stub FxConsole and assert content sent to it.

## PRD references

- §6.15 — banner / preflight output examples.
- §8.9 — preflight result shape.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid embedding emojis in the source — let FxConsole theme dictate the icon set.
