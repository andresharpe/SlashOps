---
id: ui-05
title: Execution spinner and result panel
version: v0.1
group: ui
subgroup: panels
sequence: 5
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.15 Output rendering (lines 840-875)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsResult.ps1
  - src/SlashOps/Private/UI/Use-SlashOpsSpinner.ps1
  - tests/Unit/UI.Result.Tests.ps1
tags: [ui, spinner, result, fxconsole]
---

## Overview

Wrap long-running execution in `Invoke-FxJob`-driven spinners; render the final success / error panel with timing and exit code. Stdout / stderr summaries shown only when `ui.showContextSummary = true`.

## TDD test list

- Spinner starts before invocation and stops after.
- Success panel shows duration and exit code.
- Error panel shows exit code and stderr summary.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author the helpers wrapping `Invoke-FxJob` and `Write-FxStatus`.
2. Tests stub FxConsole.

## PRD references

- §6.15 — execution spinner / progress / result.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Spinner must terminate on exception — wrap in `try { ... } finally { ... }` to clean up the FxJob handle.
