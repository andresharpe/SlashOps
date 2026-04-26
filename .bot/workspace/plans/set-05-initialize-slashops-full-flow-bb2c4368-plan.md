## Overview

The user-facing first-run command. Runs the §8.4 17-step flow: banner, version checks, Ollama detection / install, model detection / pull, optional CLI inventory, profile install (opt-in), config + policy creation, preflight, success panel. Idempotent — safe to re-run after partial setup.

## TDD test list

- Fresh machine: full flow with all confirmations granted writes config + policy and runs preflight.
- Re-run on a configured machine: idempotent — no duplicate writes, no duplicate profile blocks.
- `-AcceptDefaults` runs without prompting.
- `SLASHOPS_NONINTERACTIVE = 1` without `-AcceptDefaults` exits with remediation.
- Each step's success / failure is reflected in a final structured result.

## Implementation steps

1. Author `Public/Initialize-SlashOps.ps1` orchestrating all steps.
2. Tests mock every sub-step.

## PRD references

- §8.4 — full step list.
- §9.9 — first-run prompts.

## Acceptance criteria

- TDD tests pass.
- Idempotent.
- Cmdlet exported.

## Notes / risks

- Preserve existing config on re-run; only write defaults when missing. Backup any existing config before overwrite even on partial migrations.

