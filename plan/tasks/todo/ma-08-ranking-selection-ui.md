---
id: ma-08
title: Interactive ranking and selection UI
version: v0.4
group: mature-agent
subgroup: ui
sequence: 8
depends_on: [ui2-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v0.4 richer ranking and result selection UI (line 2940)"
deliverables:
  - src/SlashOps/Private/UI/Read-SlashOpsSelection.ps1
  - tests/Unit/UI.Selection.Tests.ps1
tags: [v0.4, ui, selection, interactive]
---

## Overview

Interactive picker for ranked search results — keyboard arrows, fuzzy filter, selection callback. Falls back to numbered prompt when terminal does not support interactive input.

## TDD test list

- Returns selected item from a list.
- Filter narrows the list.
- Cancel returns `$null`.
- Falls back to numbered prompt in non-interactive terminals.

## Implementation steps

1. Author `Read-SlashOpsSelection.ps1` using FxConsole grid + key reader.
2. Tests stub the key reader.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid platform-specific key handling; rely on `[Console]::ReadKey(intercept=$true)` only when interactive.
