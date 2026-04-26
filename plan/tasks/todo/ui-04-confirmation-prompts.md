---
id: ui-04
title: Confirmation prompts (themed)
version: v0.1
group: ui
subgroup: prompts
sequence: 4
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.13 Confirmation UX (lines 773-797)"
  - "PRD §6.15 Confirmation prompts (line 849)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsConfirm.ps1
  - tests/Unit/UI.Confirm.Tests.ps1
tags: [ui, confirmation, fxconsole]
---

## Overview

Render confirmation prompts as themed panels. The actual user input loop lives in `saf-08`; this helper only renders the prompt text and warning context.

## TDD test list

- Standard prompt shows the y/N hint.
- High-risk prompt shows the EXECUTE token requirement.
- Package install prompt shows INSTALL token.
- Cloud prompt shows CLOUD token.
- Pull prompt shows PULL token.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsConfirm.ps1` taking `(Kind, Reason)` and dispatching to FxConsole panel calls.
2. Tests stub FxConsole and assert prompt content.

## PRD references

- §6.13 — exact prompt text.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Render-only; do not call `Read-Host` here. That happens in `saf-08`.
