## Overview

Enforce byte limits on captured stdout / stderr / run log files. Truncate with a clear marker (`...[truncated to N bytes]...`) so downstream observation conversion (tr-09) can flag it. Limit applies on disk and on the in-memory string returned to the caller.

## TDD test list

- Output above `maxStdoutBytes` truncated to that size.
- Truncation marker appended.
- Output below limit unchanged.
- Limit configurable per-call to support per-tool overrides later.

## Implementation steps

1. Author `Private/Execution/Limit-OutputBytes.ps1` taking `(Text, MaxBytes, Marker = '...[truncated]...')`.
2. Wire into `Invoke-GeneratedCommand` (exe-01) and any future tool-output writer.
3. Tests cover every bullet.

## PRD references

- §9.4 — byte limits.

## Acceptance criteria

- TDD tests pass.
- Marker visible to humans.

## Notes / risks

- Use byte length (`[Text.Encoding]::UTF8.GetByteCount`), not string length, since multi-byte characters near the boundary can split.

