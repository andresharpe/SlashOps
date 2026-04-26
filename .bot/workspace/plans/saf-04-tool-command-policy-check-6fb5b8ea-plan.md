## Overview

Compare each command extracted by the AST parser (saf-02) against `policy.fastAllowedCommands` and `policy.neverFastExecute`. Determine fast-mode eligibility. Cloud / package-install commands are treated specially: blocked in `/x` per §9.12 floor.

## TDD test list

- `Get-ChildItem` is in `fastAllowedCommands` → fast OK.
- `Remove-Item` is in `neverFastExecute` → fast not OK.
- `winget install` is package install → blocked in `/x`.
- `kubectl apply` is in `neverFastExecute` and risky regex → blocked in `/x`.
- Missing required CLI tool returns `MissingDependencies` non-empty.

## Implementation steps

1. Author `Public/Test-SlashOpsToolPolicy.ps1` taking `(AstResult, Policy, ToolInventory)`.
2. Tests cover every TDD bullet.

## PRD references

- §9.6 — `fastAllowedCommands`, `neverFastExecute`.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Function exported.

## Notes / risks

- The neverFastExecute list overlaps with risky regex; the rule is "any list match → not fast-mode eligible" — order does not matter.

