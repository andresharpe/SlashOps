---
id: tr-10
title: Plan public commands
version: v0.2
group: tool-runtime
subgroup: public
sequence: 10
depends_on: [tr-08, ui2-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.1 Agent public commands (lines 463-476)"
deliverables:
  - src/SlashOps/Public/New-SlashOpsPlan.ps1
  - src/SlashOps/Public/Invoke-SlashOpsPlan.ps1
  - tests/Unit/Plan.PublicCmds.Tests.ps1
tags: [v0.2, planner, public-api]
---

## Overview

Expose direct planner access for advanced users: `New-SlashOpsPlan` returns a validated plan; `Invoke-SlashOpsPlan` runs an existing plan through the agent loop with full safety pipeline.

## TDD test list

- `New-SlashOpsPlan -Prompt 'X'` returns a validated plan object.
- `Invoke-SlashOpsPlan -Plan $p` runs the agent loop.
- Both honour mode (`-Mode '/x'` etc.).

## Implementation steps

1. Author both public cmdlets thin-wrapping `tr-06`/`tr-08`.
2. Tests cover every TDD bullet.

## PRD references

- §6.1 — public function names.

## Acceptance criteria

- TDD tests pass.
- Cmdlets exported.

## Notes / risks

- These cmdlets unblock testing of the agent loop without going through `Invoke-SlashOps*` orchestration.
