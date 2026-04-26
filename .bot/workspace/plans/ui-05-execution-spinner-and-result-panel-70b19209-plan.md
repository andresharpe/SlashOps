## Overview

Wrap long-running execution in `Invoke-FxJob`-driven spinners; render the final success / error panel with timing and exit code. Stdout / stderr summaries shown only when `ui.showContextSummary = true`.

## TDD test list

- Spinner starts before invocation and stops after.
- Success panel shows duration and exit code.
- Error panel shows exit code and stderr summary.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author the helpers wrapping `Invoke-FxJob` and `Write-FxStatus`.
2. Tests stub FxConsole.

## PRD references

- §6.15 — execution spinner / progress / result.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Spinner must terminate on exception — wrap in `try { ... } finally { ... }` to clean up the FxJob handle.

