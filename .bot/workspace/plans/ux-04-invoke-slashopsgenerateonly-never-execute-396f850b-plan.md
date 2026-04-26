## Overview

`//` prefix: generate a command plan and display it; never execute regardless of classification.

## TDD test list

- `//` always returns the generated plan and never invokes `Invoke-GeneratedCommand`.
- Plan rendered via FxConsole.
- Transcript records `executed = false`.

## Implementation steps

1. Author `Public/Invoke-SlashOpsGenerateOnly.ps1` with `Mode = '//'`.
2. Tests assert no execution occurred.

## PRD references

- §5.1 — generate-only behaviour.
- §6.12 — gate matrix `//` row.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- This is the safest mode and useful for code review or learning. Document accordingly.

