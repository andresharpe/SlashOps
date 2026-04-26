---
id: ctx-04
title: Git repository context
version: v0.1
group: context
subgroup: git
sequence: 4
depends_on: [ctx-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.3 Environment context (lines 501-528)"
  - "PRD §9.4 user config context.includeGitContext (line 1742)"
deliverables:
  - src/SlashOps/Private/Context/Get-GitContext.ps1
  - tests/Unit/Context.Git.Tests.ps1
tags: [context, git, repo]
---

## Overview

When inside a git repository, surface branch, dirty flag, upstream, and a small commit-summary so the planner can phrase prompts like "show changed files in this repo" intelligently. Inclusion is gated on `context.includeGitContext = true` (default true).

## TDD test list

- Outside a repo, returns `$null` (no error).
- Inside a clean repo, returns object with `branch`, `dirty = $false`, `upstream`.
- Inside a dirty repo, returns `dirty = $true`.
- Honours `context.includeGitContext = false` by returning `$null`.
- Function does not run when `git` is not on PATH; returns `$null` with a warning.

## Implementation steps

1. Author `Private/Context/Get-GitContext.ps1` invoking `git -C $PWD rev-parse --is-inside-work-tree`, branch via `git symbolic-ref --short HEAD`, dirty via `git status --porcelain`.
2. Tests mock `git` invocation through a thin wrapper (`Invoke-GitCli`) so platform behaviour is irrelevant.

## PRD references

- §6.3 — git context is part of the prompt context payload.
- §9.4 — `context.includeGitContext` toggles inclusion.

## Acceptance criteria

- TDD tests pass.
- Works without git installed.

## Notes / risks

- Avoid issuing slow git commands; one-line calls only.
