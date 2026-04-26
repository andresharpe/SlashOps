## Overview

Render multi-step plans with intent + risk header, dependency status table, and step table. Used for `Invoke-SlashOpsPlan` and tool-using flows.

## TDD test list

- Header shows intent and risk class.
- Dependency table lists `requires_tools` with present / missing flags.
- Step table shows step type (`tool_call` / `command`), tool name or shell, summary.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsToolPlan.ps1` calling FxConsole functions.
2. Tests stub FxConsole.

## PRD references

- §7.16 — tool result UI.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Long step tables truncate with a "+N more" footer.

