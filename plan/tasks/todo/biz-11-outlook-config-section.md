---
id: biz-11
title: Add outlook config section
version: v0.3
group: business
subgroup: config
sequence: 11
depends_on: [cfg-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.5 outlook config (lines 1827-1839)"
deliverables:
  - src/SlashOps/Private/Config/New-DefaultConfig.ps1 (update)
  - tests/Unit/Config.Outlook.Tests.ps1
tags: [v0.3, config, outlook]
---

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
