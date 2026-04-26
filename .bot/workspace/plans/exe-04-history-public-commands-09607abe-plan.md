## Overview

Read, clear, and export the JSONL transcript. `Get-SlashOpsHistory` returns objects with optional `-Last`, `-Mode`, `-Since` filters. `Clear-SlashOpsHistory` requires `-Confirm`. `Export-SlashOpsHistory` writes a copy to a path the user supplies.

## TDD test list

- `Get-SlashOpsHistory` returns parsed objects.
- `-Last 5` returns the last five records.
- `-Mode '/x'` filters by mode.
- `-Since (Get-Date).AddDays(-1)` filters by timestamp.
- `Clear-SlashOpsHistory -Confirm` requires confirmation.
- `Export-SlashOpsHistory -Path` writes a deduplicated copy.

## Implementation steps

1. Author each cmdlet thin-wrapping JSONL parse helpers.
2. Tests use a seeded JSONL file in `TestDrive:`.

## PRD references

- §6.1 — public function names.
- §6.14 — record schema.

## Acceptance criteria

- TDD tests pass.
- Cmdlets exported.

## Notes / risks

- Streaming parse — do not slurp the entire file when only `-Last` is requested.

