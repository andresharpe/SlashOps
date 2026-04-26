## Overview

Combine static, AST, path, tool, and (optionally) AI review findings into exactly one of `read-only`, `benign-write`, `risky-write`, `blocked`, `unknown`. AI review can only escalate; it cannot lower a static block. Multi-command scripts take the highest risk of any contained command (saf-02).

## TDD test list

- Pure read-only command returns `read-only`.
- Bounded `pandoc` write inside safe root returns `benign-write`.
- `Remove-Item` returns `risky-write`.
- `Invoke-Expression` returns `blocked`.
- AI review escalates `benign-write` to `risky-write` or `blocked`.
- AI review cannot lower `blocked` to `risky-write`.
- AST parse error returns `unknown`.

## Implementation steps

1. Author `Private/Safety/Resolve-RiskClassification.ps1` with deterministic precedence: blocked > risky-write > benign-write > read-only; unknown short-circuits.
2. Public `Get-SlashOpsRiskClassification` thin wrapper accepting a `CommandPlan`.
3. Tests cover every TDD bullet.

## PRD references

- §6.7 — five classes.
- §6.11 — AI review escalation rules.

## Acceptance criteria

- TDD tests pass.
- Function exported.
- Cannot-lower invariant proven.

## Notes / risks

- Keep the precedence rule trivially enumerable; document it in `docs/SAFETY.md`.

