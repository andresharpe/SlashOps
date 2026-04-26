---
id: ux-03
title: Invoke-SlashOpsFast (/x) — auto-execute safe
version: v0.1
group: ux
subgroup: invoke
sequence: 3
depends_on: [ux-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §5.1 Prefixes (lines 273-291)"
  - "PRD §5.2 safe fast execution (lines 293-320)"
  - "PRD §5.3 benign-write fast execution (lines 322-361)"
  - "PRD §11.3 Execution gate /x tests (lines 2667-2673)"
deliverables:
  - src/SlashOps/Public/Invoke-SlashOpsFast.ps1
  - tests/Unit/UX.InvokeFast.Tests.ps1
tags: [ux, invoke, fast-mode, prefix]
---

## Overview

Fast mode entry point. Auto-executes when classification is `read-only` or policy-approved `benign-write`. Refuses `blocked`. Stops `risky-write` and `unknown`, instructing the user to retry with `/`.

## TDD test list

- `/x` + `read-only` → auto-execute.
- `/x` + `benign-write` (policy-approved) → auto-execute.
- `/x` + `benign-write` (policy-disapproved) → stops with guidance.
- `/x` + `risky-write` → stops with guidance.
- `/x` + `blocked` → refuses.
- `/x` + `unknown` → stops.
- Transcript records the gate decision and reason.

## Implementation steps

1. Author `Public/Invoke-SlashOpsFast.ps1` reusing the orchestrator from `ux-02` with `Mode = '/x'`.
2. Tests mock the gate decision.

## PRD references

- §5.1 / §5.2 / §5.3 — fast-mode behaviour and examples.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Cloud mutation and package install must remain blocked in `/x` per §9.12 floor.
