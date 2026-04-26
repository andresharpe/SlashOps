---
id: lt-03
title: local.files.open tool
version: v0.2
group: local-tools
subgroup: files
sequence: 3
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
  - "PRD §17 Q14 (line 2974)"
deliverables:
  - src/SlashOps/Private/Tools/Local/Invoke-LocalFileOpen.ps1
  - src/SlashOps/ToolManifests/local.files.open.json
  - tests/Unit/Tools.Local.Open.Tests.ps1
tags: [v0.2, tool, files, open]
---

## Overview

Open a local file or folder in the default app or VS Code (when `code` is on PATH). Per §17 Q14, GUI app open is allowed in `/x` for local paths but the first invocation in a session prompts confirmation.

## TDD test list

- Local path opens via platform default (mocked).
- VS Code chosen when `code` is on PATH and `-Editor 'code'` requested.
- First-time confirmation honoured.
- Refuses non-local URLs.
- Manifest passes validation.

## Implementation steps

1. Author the tool function with platform branches.
2. Author the manifest with `default_risk: benign`.
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.
- §17 Q14 — GUI app policy.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- macOS: `open`. Linux: `xdg-open`. Windows: `Start-Process`.
