---
id: ux-05
title: Invoke-SlashOpsStrict (/!) — strict + AI review
version: v0.1
group: ux
subgroup: invoke
sequence: 5
depends_on: [ux-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §5.1 Prefixes (lines 273-291)"
  - "PRD §6.11 AI security review required for /! (lines 738-761)"
deliverables:
  - src/SlashOps/Public/Invoke-SlashOpsStrict.ps1
  - tests/Unit/UX.InvokeStrict.Tests.ps1
tags: [ux, invoke, strict, ai-review, prefix]
---

## Overview

`/!` strict prefix: always runs AI security review; never auto-executes; refuses `blocked` immediately.

## TDD test list

- AI review always invoked.
- AI review failure prevents execution.
- Even `read-only` classifications require explicit confirmation.
- `blocked` always refused.

## Implementation steps

1. Author `Public/Invoke-SlashOpsStrict.ps1` with `Mode = '/!'` and `RequireAiReview = $true`.
2. Tests assert AI review was invoked.

## PRD references

- §5.1 — strict behaviour.
- §6.11 — AI review required for `/!`.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- For users who want defence in depth, `/!` is the recommended default — call this out in `docs/SAFETY.md`.
