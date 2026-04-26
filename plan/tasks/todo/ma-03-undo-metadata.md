---
id: ma-03
title: Undo metadata for benign mutations
version: v0.4
group: mature-agent
subgroup: undo
sequence: 3
depends_on: [exe-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v0.4 undo metadata for benign mutations (line 2942)"
deliverables:
  - src/SlashOps/Private/Execution/New-UndoPlan.ps1
  - src/SlashOps/Public/Invoke-SlashOpsUndo.ps1
  - tests/Unit/Agent.Undo.Tests.ps1
tags: [v0.4, undo, mutation]
---

## Overview

For each benign mutation, record an inverse plan (delete created file, restore moved item, etc.) in the transcript. `Invoke-SlashOpsUndo` reads the latest mutation entry and offers to apply the inverse.

## TDD test list

- Created PDF mutation records `delete <path>` undo.
- Moved file mutation records `move back` undo.
- Undo command requires confirmation.
- Undo refuses if file state has changed since execution.

## Implementation steps

1. Author `New-UndoPlan.ps1` for the supported mutation kinds.
2. Author `Invoke-SlashOpsUndo.ps1` reading transcript and applying inverse with confirmation.
3. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Not every mutation is undoable; document which kinds are supported and refuse the rest.
