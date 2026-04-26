---
id: saf-07
title: Mode × class execution gate
version: v0.1
group: safety
subgroup: gate
sequence: 7
depends_on: [saf-06]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.12 Execution gating (lines 763-771)"
  - "PRD §11.3 Execution gate tests (lines 2664-2673)"
deliverables:
  - src/SlashOps/Private/Safety/Resolve-ExecutionGate.ps1
  - tests/Unit/Safety.Gate.Tests.ps1
tags: [safety, gate, mode, execution]
---

## Overview

Apply the §6.12 mode × class matrix to determine the gate decision: `auto`, `ask`, `ask-with-warning`, `strict-warning`, `refuse`, or `explain-only`. The gate is the single source of truth for whether to run a command.

## TDD test list

- `/x` + read-only → `auto`.
- `/x` + benign-write + policy-approved → `auto`.
- `/x` + benign-write + policy-disapproved → `ask` (escalate to `/`).
- `/x` + risky-write → `stop` (require `/`).
- `/x` + blocked → `refuse`.
- `//` + any → `explain-only`.
- `/?` + any → `explain-only`.
- `/!` + read-only → `ask`.
- `/!` + blocked → `refuse`.
- `/` + read-only → `ask`.
- `/` + benign-write → `ask`.
- `/` + risky-write → `ask-with-warning`.

## Implementation steps

1. Author `Private/Safety/Resolve-ExecutionGate.ps1` as a pure function over `(Mode, Class, Policy)`.
2. Tests cover the full §6.12 table.

## PRD references

- §6.12 — execution gating matrix.
- §11.3 — required tests.

## Acceptance criteria

- All matrix cells covered by tests.
- Pure function, no side effects.

## Notes / risks

- Keep the matrix as a hashtable so it is trivially auditable.
