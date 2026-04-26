---
id: ma-07
title: Richer transcript viewer
version: v0.4
group: mature-agent
subgroup: viewer
sequence: 7
depends_on: [exe-04]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v0.4 richer transcript viewer (line 2946)"
deliverables:
  - src/SlashOps/Public/Show-SlashOpsHistory.ps1
  - tests/Unit/Execution.HistoryViewer.Tests.ps1
tags: [v0.4, history, viewer]
---

## Overview

Pretty-print history entries with filters (mode, intent, risk class, date range). Supports `-Tail` for the most recent entries and `-Search` for prompt fragments.

## TDD test list

- `-Tail 5` shows last 5.
- `-Search 'pdf'` filters by prompt fragment.
- `-Mode '/x'` filters by mode.
- `-Risk 'risky-write'` filters by classification.
- Output uses FxConsole tables.

## Implementation steps

1. Author `Public/Show-SlashOpsHistory.ps1`.
2. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Streaming parse — never load entire history into memory.
