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

