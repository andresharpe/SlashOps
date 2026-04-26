## Overview

Flag, categorize, or mark-read a selected message. Always requires explicit confirmation. Never runs in `/x` (per safety floor).

## TDD test list

- Disabled by default.
- Enabled + confirmation `EXECUTE` → mutates (mocked).
- Without confirmation → refuses.
- Refuses in `/x` regardless of policy.
- Manifest passes validation with `default_risk: risky-write`, `requires_confirmation: true`, `supports_fast_mode: false`.

## Implementation steps

1. Author the tool function.
2. Author manifest.
3. Tests cover every TDD bullet.

## PRD references

- §7.8 — tool list.
- §7.9 — confirmation rules.
- §11.3 — required test.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Show the selected message before mutation per §7.9.

