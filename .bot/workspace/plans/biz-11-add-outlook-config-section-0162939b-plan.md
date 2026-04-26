## Overview

Extend default config with `outlook` block: `enabled` (false), `provider` (graph), fast-mode toggles, log toggles for subjects / senders / body, max search results, confirmation toggles for mark / move / send.

## TDD test list

- Default config contains `outlook` block.
- `outlook.enabled` defaults to `false`.
- `outlook.logBody` defaults to `false`.
- `outlook.requireConfirmationForSend` defaults to `true`.

## Implementation steps

1. Update `New-DefaultConfig.ps1`.
2. Tests cover defaults.

## PRD references

- §9.5 — outlook schema.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Migration: existing v0.2 configs need this block added by `cfg-10`.

