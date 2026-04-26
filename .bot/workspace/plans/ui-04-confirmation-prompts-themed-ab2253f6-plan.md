## Overview

Render confirmation prompts as themed panels. The actual user input loop lives in `saf-08`; this helper only renders the prompt text and warning context.

## TDD test list

- Standard prompt shows the y/N hint.
- High-risk prompt shows the EXECUTE token requirement.
- Package install prompt shows INSTALL token.
- Cloud prompt shows CLOUD token.
- Pull prompt shows PULL token.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsConfirm.ps1` taking `(Kind, Reason)` and dispatching to FxConsole panel calls.
2. Tests stub FxConsole and assert prompt content.

## PRD references

- §6.13 — exact prompt text.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Render-only; do not call `Read-Host` here. That happens in `saf-08`.

