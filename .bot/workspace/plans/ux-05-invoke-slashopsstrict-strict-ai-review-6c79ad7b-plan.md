## Overview

`/!` strict prefix: always runs AI security review; never auto-executes; refuses `blocked` immediately.

## TDD test list

- AI review always invoked.
- AI review failure prevents execution.
- Even `read-only` classifications require explicit confirmation.
- `blocked` always refused.

## Implementation steps

1. Author `Public/Invoke-SlashOpsStrict.ps1` with `Mode = '/!'` and `RequireAiReview = $true`.
2. Tests assert AI review was invoked.

## PRD references

- §5.1 — strict behaviour.
- §6.11 — AI review required for `/!`.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- For users who want defence in depth, `/!` is the recommended default — call this out in `docs/SAFETY.md`.

