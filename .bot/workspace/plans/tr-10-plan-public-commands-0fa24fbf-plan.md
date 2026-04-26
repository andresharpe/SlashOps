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

