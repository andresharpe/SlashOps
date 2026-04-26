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

