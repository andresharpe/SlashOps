---
id: biz-09
title: Git tools (status / diff / branch_switch)
version: v0.3
group: business
subgroup: git
sequence: 9
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
deliverables:
  - src/SlashOps/Private/Tools/Git/Invoke-GitStatus.ps1
  - src/SlashOps/Private/Tools/Git/Invoke-GitDiff.ps1
  - src/SlashOps/Private/Tools/Git/Invoke-GitBranchSwitch.ps1
  - src/SlashOps/ToolManifests/git.status.json
  - src/SlashOps/ToolManifests/git.diff.json
  - src/SlashOps/ToolManifests/git.branch_switch.json
  - tests/Unit/Tools.Git.Tests.ps1
tags: [v0.3, git, status, diff, branch]
---

## Overview

Structured git tools beyond shell commands. `git.status` and `git.diff` are read-only and fast-mode eligible. `git.branch_switch` warns when the working tree is dirty and asks for confirmation.

## TDD test list

- `git.status` returns structured object (branch, dirty files, ahead, behind).
- `git.diff` returns per-file diff summary.
- `git.branch_switch` refuses dirty worktree without `-Force`.
- All manifests pass validation.

## Implementation steps

1. Author each tool wrapping `git` invocations.
2. Author each manifest.
3. Tests mock `git`.

## PRD references

- §7.8 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- `git.branch_switch` is `risky-write` per safety matrix; gate accordingly.
