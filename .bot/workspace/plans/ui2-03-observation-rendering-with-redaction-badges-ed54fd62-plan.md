## Overview

Render structured observations: summary card, item count, redaction-applied badges so the user can see which fields were redacted before logging or model upload.

## TDD test list

- Summary text rendered.
- Redaction badges appear when `redactions_applied` non-empty.
- Truncation marker rendered when observation is compressed.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsObservation.ps1` calling FxConsole panels.
2. Tests stub FxConsole.

## PRD references

- §7.13 — observation schema.
- §7.16 — tool UI.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Redaction badges should be visually obvious — encode them with a distinct icon / colour.

