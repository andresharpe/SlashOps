---
id: biz-08
title: GitHub tools (PR / issue search, PR comment)
version: v0.3
group: business
subgroup: github
sequence: 8
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
deliverables:
  - src/SlashOps/Private/Tools/GitHub/Invoke-GitHubPrSearch.ps1
  - src/SlashOps/Private/Tools/GitHub/Invoke-GitHubIssueSearch.ps1
  - src/SlashOps/Private/Tools/GitHub/Invoke-GitHubPrComment.ps1
  - src/SlashOps/ToolManifests/github.pr.search.json
  - src/SlashOps/ToolManifests/github.issue.search.json
  - src/SlashOps/ToolManifests/github.pr.comment.json
  - tests/Unit/Tools.GitHub.Tests.ps1
tags: [v0.3, github, pr, issue, comment]
---

## Overview

GitHub tools wrapping `gh` CLI: search PRs, search issues, comment on PR (with confirmation). Comment requires explicit confirmation per `github_mutation` intent.

## TDD test list

- PR search returns ranked PRs.
- Issue search returns ranked issues.
- PR comment requires `EXECUTE` confirmation.
- Missing `gh` → dependency observation.
- All manifests pass validation.

## Implementation steps

1. Author each tool wrapping `gh` invocations.
2. Author each manifest.
3. Tests mock `gh` invocations.

## PRD references

- §7.8 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- `gh` auth: surface `gh auth status` as a precondition observation.
