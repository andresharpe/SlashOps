---
id: ma-01
title: Multi-step plan / observe / re-plan
version: v0.4
group: mature-agent
subgroup: replan
sequence: 1
depends_on: [tr-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.12 Agent loop (lines 1173-1191)"
  - "PRD §16 v0.4 (lines 2937-2945)"
deliverables:
  - src/SlashOps/Private/Agent/Invoke-AgentLoop.ps1 (update)
  - tests/Unit/Agent.MultiStep.Tests.ps1
tags: [v0.4, agent, replan, multi-step]
---

## Overview

Extend the v0.2 agent loop to support multiple plan / observe / re-plan iterations within the existing hard limits. Re-plans reuse prior observations as context.

## TDD test list

- Re-plan uses observation context from previous step.
- Re-plan honours `agent.maxModelCalls`.
- Re-plan respects mutation pause.
- Re-plan refuses to escalate risk class without confirmation.

## Implementation steps

1. Update `Invoke-AgentLoop.ps1` with re-plan branch.
2. Tests cover every TDD bullet.

## PRD references

- §7.12 — loop structure.
- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Re-plan amplifies token use; cap aggressively.
