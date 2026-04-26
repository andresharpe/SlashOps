---
id: biz-01
title: Outlook provider abstraction (Graph + M365 CLI)
version: v0.3
group: business
subgroup: outlook
sequence: 1
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.9 Outlook/Microsoft 365 handling (lines 1091-1127)"
  - "PRD §17 Q11 (line 2971)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Test-OutlookProvider.ps1
  - src/SlashOps/Private/Tools/Outlook/Resolve-OutlookProvider.ps1
  - tests/Unit/Tools.Outlook.Provider.Tests.ps1
tags: [v0.3, outlook, provider, graph, m365cli]
---

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
