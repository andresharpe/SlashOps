## Overview

Support an admin-managed enterprise policy file (e.g. `/etc/slashops/policy.json` on Linux, `%ProgramData%\SlashOps\policy.json` on Windows). Enterprise policy merges into the effective policy with the highest precedence among file layers (above user policy), per §17 Q8.

## TDD test list

- Enterprise policy file loaded when present.
- Enterprise policy overrides user policy where configured.
- Enterprise policy cannot be weakened by user / project.
- Missing enterprise file is silently skipped.

## Implementation steps

1. Author `Resolve-EnterprisePolicy.ps1`.
2. Update precedence layer in `cfg-07` (effective config merge).
3. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.
- §17 Q8 — precedence question.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Enterprise file path differs by platform; document both in `docs/CONFIGURATION.md`.

