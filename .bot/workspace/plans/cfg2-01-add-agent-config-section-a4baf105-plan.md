## Overview

Extend the default user config with the `agent` block: `enabled`, `maxSteps`, `maxToolCalls`, `maxModelCalls`, `maxWallClockSeconds`, `allowMultiStepReadOnlyFastMode`, `pauseBeforeMutation`, `failOnUnknownTool`, `failOnLowIntentConfidence`, `minimumIntentConfidence`. Wire defaults through merge (`cfg-07`) and effective-config public command (`cfg-09`).

## TDD test list

- Default config now contains `agent` block.
- All defaults match §9.5.
- Migration from a v0.1 config (no `agent`) adds the block without losing existing values (covered by `cfg-10`).
- `Get-SlashOpsEffectiveConfig` exposes the agent block.

## Implementation steps

1. Update `New-DefaultConfig.ps1` to include the `agent` block.
2. Add validation in `Test-ConfigSchema.ps1` (`cfg-04`).
3. Tests cover defaults and round-trip.

## PRD references

- §9.5 — `agent` schema.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Document defaults in `docs/CONFIGURATION.md`.

