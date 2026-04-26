---
id: ui2-01
title: Tool plan rendering (intent + risk + steps)
version: v0.2
group: ui2
subgroup: plan
sequence: 1
depends_on: [ui-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.16 Tool result UI (lines 1259-1269)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsToolPlan.ps1
  - tests/Unit/UI.ToolPlan.Tests.ps1
tags: [v0.2, ui, plan, fxconsole]
---

## Overview

Render multi-step plans with intent + risk header, dependency status table, and step table. Used for `Invoke-SlashOpsPlan` and tool-using flows.

## TDD test list

- Header shows intent and risk class.
- Dependency table lists `requires_tools` with present / missing flags.
- Step table shows step type (`tool_call` / `command`), tool name or shell, summary.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsToolPlan.ps1` calling FxConsole functions.
2. Tests stub FxConsole.

## PRD references

- §7.16 — tool result UI.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Long step tables truncate with a "+N more" footer.
