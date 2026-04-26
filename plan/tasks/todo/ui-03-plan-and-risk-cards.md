---
id: ui-03
title: Generated plan and risk summary cards
version: v0.1
group: ui
subgroup: panels
sequence: 3
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.15 Output rendering (lines 840-875)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsPlan.ps1
  - src/SlashOps/Private/UI/Write-SlashOpsRisk.ps1
  - tests/Unit/UI.Plan.Tests.ps1
tags: [ui, plan, risk, fxconsole]
---

## Overview

Render the generated command in a card, and the risk classification + reason in a parallel card. Dependency status table optional via `ui.showDependencyTable`.

## TDD test list

- Plan card includes the command text verbatim.
- Risk card includes class label and reason.
- Dependency table appears when configured to show.
- Cards honour `ui.theme`.

## Implementation steps

1. Author both helpers calling `Write-FxCard`.
2. Tests stub FxConsole.

## PRD references

- §6.15 — generated command card, risk summary card, dependency status table.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Long commands wrap awkwardly; document the recommended max width and rely on FxConsole to handle the wrap.
