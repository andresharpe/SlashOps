## Overview

Pretty-print history entries with filters (mode, intent, risk class, date range). Supports `-Tail` for the most recent entries and `-Search` for prompt fragments.

## TDD test list

- `-Tail 5` shows last 5.
- `-Search 'pdf'` filters by prompt fragment.
- `-Mode '/x'` filters by mode.
- `-Risk 'risky-write'` filters by classification.
- Output uses FxConsole tables.

## Implementation steps

1. Author `Public/Show-SlashOpsHistory.ps1`.
2. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Streaming parse — never load entire history into memory.

