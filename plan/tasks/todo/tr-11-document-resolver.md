---
id: tr-11
title: Document reference resolver ("this doc")
version: v0.2
group: tool-runtime
subgroup: documents
sequence: 11
depends_on: [tr-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.10 Document resolution (lines 1129-1151)"
  - "PRD §11.3 Document resolver tests (lines 2645-2647)"
deliverables:
  - src/SlashOps/Private/Agent/Resolve-DocumentReference.ps1
  - tests/Unit/Agent.DocumentResolver.Tests.ps1
tags: [v0.2, documents, resolver, agent]
---

## Overview

Resolve "this doc" deterministically per §7.10 order: explicit path → pipeline input → last result → cwd single-doc → clipboard (if enabled) → most recent download → interactive choice → ask. Ambiguity surfaces as a structured `needs_clarification` observation, not a guess.

## TDD test list

- Explicit path wins.
- Pipeline input wins when no explicit path.
- Last result wins when no pipeline input.
- Single doc in cwd wins next.
- Clipboard read only when enabled.
- Latest downloaded doc as fallback.
- Multiple candidates → `needs_clarification`.

## Implementation steps

1. Author `Private/Agent/Resolve-DocumentReference.ps1` walking the resolution order.
2. Tests cover every TDD bullet using `TestDrive:`.

## PRD references

- §7.10 — resolution order.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Likely document extensions per §7.10 — keep the list authoritative in this file.
