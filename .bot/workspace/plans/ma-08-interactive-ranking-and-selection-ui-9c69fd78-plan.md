## Overview

Interactive picker for ranked search results — keyboard arrows, fuzzy filter, selection callback. Falls back to numbered prompt when terminal does not support interactive input.

## TDD test list

- Returns selected item from a list.
- Filter narrows the list.
- Cancel returns `$null`.
- Falls back to numbered prompt in non-interactive terminals.

## Implementation steps

1. Author `Read-SlashOpsSelection.ps1` using FxConsole grid + key reader.
2. Tests stub the key reader.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid platform-specific key handling; rely on `[Console]::ReadKey(intercept=$true)` only when interactive.

