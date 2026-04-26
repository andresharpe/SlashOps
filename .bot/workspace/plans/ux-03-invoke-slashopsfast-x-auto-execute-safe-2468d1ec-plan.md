## Overview

Fast mode entry point. Auto-executes when classification is `read-only` or policy-approved `benign-write`. Refuses `blocked`. Stops `risky-write` and `unknown`, instructing the user to retry with `/`.

## TDD test list

- `/x` + `read-only` → auto-execute.
- `/x` + `benign-write` (policy-approved) → auto-execute.
- `/x` + `benign-write` (policy-disapproved) → stops with guidance.
- `/x` + `risky-write` → stops with guidance.
- `/x` + `blocked` → refuses.
- `/x` + `unknown` → stops.
- Transcript records the gate decision and reason.

## Implementation steps

1. Author `Public/Invoke-SlashOpsFast.ps1` reusing the orchestrator from `ux-02` with `Mode = '/x'`.
2. Tests mock the gate decision.

## PRD references

- §5.1 / §5.2 / §5.3 — fast-mode behaviour and examples.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Cloud mutation and package install must remain blocked in `/x` per §9.12 floor.

