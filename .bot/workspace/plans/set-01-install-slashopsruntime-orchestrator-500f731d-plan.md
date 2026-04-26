## Overview

Top-level orchestrator that ensures Ollama is installed and reachable, the default model is present, optional CLIs are surveyed, and config / policy files exist. It is a thin coordinator over `Install-SlashOpsOllama`, `Install-SlashOpsModel`, and config defaults — never auto-runs destructive steps.

## TDD test list

- Skips Ollama install when reachable.
- Calls `Install-SlashOpsOllama` (mocked) when missing.
- Calls `Install-SlashOpsModel` (mocked) when default model missing.
- Refuses to proceed with `SLASHOPS_NONINTERACTIVE = 1` and missing `-AcceptDefaults`.
- Returns a structured result with per-step status.

## Implementation steps

1. Author `Public/Install-SlashOpsRuntime.ps1` calling sub-installers in order, surfacing errors.
2. Tests mock each sub-installer.

## PRD references

- §6.1 — public function name.
- §8 — overall setup flow context.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Keep this thin; the heavy lifting lives in `set-02`/`set-03`/`set-05`.

