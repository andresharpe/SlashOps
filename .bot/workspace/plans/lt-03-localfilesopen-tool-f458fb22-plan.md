## Overview

Open a local file or folder in the default app or VS Code (when `code` is on PATH). Per §17 Q14, GUI app open is allowed in `/x` for local paths but the first invocation in a session prompts confirmation.

## TDD test list

- Local path opens via platform default (mocked).
- VS Code chosen when `code` is on PATH and `-Editor 'code'` requested.
- First-time confirmation honoured.
- Refuses non-local URLs.
- Manifest passes validation.

## Implementation steps

1. Author the tool function with platform branches.
2. Author the manifest with `default_risk: benign`.
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.
- §17 Q14 — GUI app policy.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- macOS: `open`. Linux: `xdg-open`. Windows: `Start-Process`.

