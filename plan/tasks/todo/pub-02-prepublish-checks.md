---
id: pub-02
title: Pre-publish checks script
version: v0.1
group: publish
subgroup: scripts
sequence: 2
depends_on: [pub-01, gate-v01]
status: todo
tdd_first: false
prd_refs:
  - "PRD §12.1 Pre-publish checklist (lines 2727-2742)"
deliverables:
  - build/prepublish.ps1
  - tests/Integration/Prepublish.Tests.ps1
tags: [publish, ci, checks]
---

## Overview

Single-command wrapper running Pester (unit), PSScriptAnalyzer, and `Test-ModuleManifest`. CI and humans both call this before any publish step.

## TDD test list

- Script returns 0 on a clean tree.
- Script returns non-zero when Pester fails.
- Script returns non-zero when PSScriptAnalyzer reports errors.
- Script returns non-zero when manifest is invalid.

## Implementation steps

1. Author `build/prepublish.ps1` chaining `build/test.ps1`, `build/lint.ps1`, `Test-ModuleManifest`.
2. Integration test runs the chain end-to-end on a known-good tree.

## PRD references

- §12.1 — pre-publish requirements.

## Acceptance criteria

- Script runs end-to-end.
- Failure modes proven.

## Notes / risks

- Keep this stage fast — under 60 seconds on a warm machine.
