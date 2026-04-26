---
id: ui2-03
title: Observation rendering with redaction badges
version: v0.2
group: ui2
subgroup: observation
sequence: 3
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.13 Observation handling (lines 1192-1209)"
  - "PRD §7.16 Tool result UI (lines 1259-1269)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsObservation.ps1
  - tests/Unit/UI.Observation.Tests.ps1
tags: [v0.2, ui, observation, fxconsole]
---

## Overview

Render structured observations: summary card, item count, redaction-applied badges so the user can see which fields were redacted before logging or model upload.

## TDD test list

- Summary text rendered.
- Redaction badges appear when `redactions_applied` non-empty.
- Truncation marker rendered when observation is compressed.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsObservation.ps1` calling FxConsole panels.
2. Tests stub FxConsole.

## PRD references

- §7.13 — observation schema.
- §7.16 — tool UI.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Redaction badges should be visually obvious — encode them with a distinct icon / colour.
