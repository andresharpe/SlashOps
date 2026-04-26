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

