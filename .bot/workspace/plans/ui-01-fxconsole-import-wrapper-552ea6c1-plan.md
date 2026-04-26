## Overview

Provide a single private helper that imports the vendored FxConsole module, sets the configured theme (`ui.theme`, default `amber`), and is safe to call repeatedly. Other UI helpers call this lazily so non-UI code paths never load FxConsole.

## TDD test list

- First call imports the vendored module and sets theme.
- Subsequent calls are no-ops.
- Honours `ui.useFxConsole = false` by silently degrading to `Write-Host` fallback.
- Theme name comes from effective config.

## Implementation steps

1. Author `Private/UI/Import-FxConsole.ps1` using `Import-Module` against the vendored path.
2. Author `Private/UI/Use-FxConsole.ps1` returning a boolean indicating whether FxConsole is active.
3. Tests use `TestDrive:` with a stub `FxConsole` module to assert idempotency.

## PRD references

- §3.1 — vendored FxConsole.
- §6.15 — UI requirements.

## Acceptance criteria

- TDD tests pass.
- Idempotent.
- Fallback works when disabled.

## Notes / risks

- Tests must stub FxConsole, not load the real module — keep them fast.

