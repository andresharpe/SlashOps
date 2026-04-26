## Overview

`/?` prefix: generate a plan and ask the model for an explanation of what would happen, then display both. Never executes.

## TDD test list

- `/?` returns plan + explanation.
- Never invokes `Invoke-GeneratedCommand`.
- Explanation content rendered via FxConsole panel.

## Implementation steps

1. Author `Public/Invoke-SlashOpsExplain.ps1` with `Mode = '/?'`.
2. Reuse `Invoke-OllamaChat` with an explanation system prompt.
3. Tests assert both fields are present.

## PRD references

- §5.1 — explain-only behaviour.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- The explanation prompt should be terse — discourage the model from producing prose dumps.

