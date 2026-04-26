## Overview

Provide a small provider abstraction so Outlook tools can plug into Microsoft Graph (preferred) or Microsoft 365 CLI (fallback) per §7.9. Detect installed providers, surface auth status, and refuse to operate when no provider is available.

## TDD test list

- Graph available → `Resolve-OutlookProvider` returns Graph.
- Only M365 CLI available → returns M365.
- Neither available → returns `$null` and dependency observation.
- Auth-not-completed surfaces as a structured observation, not an error.

## Implementation steps

1. Author both helpers.
2. Tests mock `Get-Command` and provider auth checks.

## PRD references

- §7.9 — provider preference order.
- §17 Q11 — Graph-first long term.

## Acceptance criteria

- TDD tests pass.
- Provider abstraction documented in `docs/OUTLOOK.md`.

## Notes / risks

- Graph requires app registration; document setup in `docs/OUTLOOK.md`.

