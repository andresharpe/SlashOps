## Overview

Tie the model layer together for v0.1 single-step shell flow: build context (ctx-05) → assemble system prompt (mdl-03) → call Ollama (mdl-02) → parse with repair (mdl-04) → emit a `CommandPlan` matching the §6.5 schema. The result is what the safety pipeline (saf-*) consumes.

## TDD test list

- Happy path returns a populated `CommandPlan` object.
- Mocked Ollama returning malformed JSON triggers repair, then succeeds.
- Mocked Ollama returning unrecoverable JSON returns a fail-closed result.
- Mode is recorded in the plan.
- Plan includes `summary`, `command`, `risk_guess`, `requires_tools`, `expected_outputs`, `undo_hint` per §6.5.

## Implementation steps

1. Author `Public/New-SlashOpsCommandPlan.ps1` orchestrating the steps above and returning a structured object.
2. Tests mock `Invoke-OllamaChat` exhaustively.

## PRD references

- §6.5 — schema.
- §6.1 — public function name.

## Acceptance criteria

- TDD tests pass.
- Function exported.
- Returns structured fail-closed on parse failure.

## Notes / risks

- Keep this function shell-only for v0.1; tool-using plans land in `tr-06`.

