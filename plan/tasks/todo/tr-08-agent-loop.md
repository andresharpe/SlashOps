---
id: tr-08
title: Bounded agent loop
version: v0.2
group: tool-runtime
subgroup: loop
sequence: 8
depends_on: [tr-06, tr-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.12 Agent loop (lines 1173-1191)"
  - "PRD §9.5 agent section (lines 1786-1798)"
  - "PRD §11.3 Agent loop tests (lines 2620-2624)"
deliverables:
  - src/SlashOps/Private/Agent/Invoke-AgentLoop.ps1
  - tests/Unit/Agent.Loop.Tests.ps1
tags: [v0.2, agent, loop, bounded]
---

## Overview

Drive the plan → execute → observe → re-plan cycle with hard limits: `maxSteps`, `maxToolCalls`, `maxModelCalls`, `maxWallClockSeconds`. Pause for confirmation before any mutation step. Stop on unknown risk or auth-required observation.

## TDD test list

- Loop honours `maxSteps`.
- Loop honours `maxToolCalls`.
- Loop honours `maxModelCalls`.
- Loop honours `maxWallClockSeconds`.
- Loop pauses before mutation.
- Loop stops on `unknown` risk.
- Loop stops on auth-required observation.
- Re-plan calls model only when allowed by `agent.allowMultiStepReadOnlyFastMode`.

## Implementation steps

1. Author `Private/Agent/Invoke-AgentLoop.ps1` consuming a validated plan and the registry.
2. Tests mock tool invocations and observation conversion.

## PRD references

- §7.12 — hard limits.
- §9.5 — config knobs.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- The wall clock check must use a `Stopwatch` started at loop entry.
