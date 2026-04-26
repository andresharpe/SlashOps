## Overview

Search calendar items via the resolved provider. Read-only; fast-mode eligible.

## TDD test list

- Disabled by default.
- Enabled → returns events between given dates (mocked).
- Honours timezone context.
- Manifest passes validation.

## Implementation steps

1. Author the tool function.
2. Author manifest.
3. Tests cover every TDD bullet.

## PRD references

- §7.8 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Recurring events: return expanded instances within the requested range, not the master event.

