---
id: saf-08
title: Confirmation UX (y/N + token entry)
version: v0.1
group: safety
subgroup: confirm
sequence: 8
depends_on: [saf-07, ui-04]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.13 Confirmation UX (lines 773-797)"
  - "PRD §9.6 policy.confirmation tokens (lines 1979-1985)"
deliverables:
  - src/SlashOps/Private/Execution/Confirm-Execution.ps1
  - src/SlashOps/Private/Execution/Confirm-Mutation.ps1
  - tests/Unit/Safety.Confirmation.Tests.ps1
tags: [safety, confirm, ux, tokens]
---

## Overview

Render confirmation prompts and validate user input. Standard `y/N`, high-risk `EXECUTE`, package install `INSTALL`, cloud mutation `CLOUD`, model pull `PULL`. Token strings come from `policy.confirmation` so enterprise deployments can localise. Non-interactive mode applies `execution.defaultNonInteractiveAction` (default `refuse`).

## TDD test list

- `y` + standard prompt → `Confirmed = $true`.
- `n` or empty + standard prompt → `Confirmed = $false`.
- `EXECUTE` + risky prompt → confirmed; anything else → not confirmed.
- `INSTALL` token validates package install prompt.
- `CLOUD` token validates cloud mutation prompt.
- `PULL` token validates model-pull prompt.
- `SLASHOPS_NONINTERACTIVE = 1` skips prompt and applies `defaultNonInteractiveAction`.
- Token comparison is exact (case-sensitive).

## Implementation steps

1. Author `Private/Execution/Confirm-Execution.ps1` reading from a thin `Read-UserInput` helper that tests can mock.
2. Author `Private/Execution/Confirm-Mutation.ps1` for high-risk and tokenised flows.
3. Tests mock `Read-UserInput` and `SLASHOPS_NONINTERACTIVE`.

## PRD references

- §6.13 — UX text exactly as documented.
- §9.6 — confirmation token names.
- §9.4 — `execution.defaultNonInteractiveAction`.

## Acceptance criteria

- All TDD tests pass.
- Non-interactive mode honoured.

## Notes / risks

- Do not call `Read-Host` directly; tests need a seam.
