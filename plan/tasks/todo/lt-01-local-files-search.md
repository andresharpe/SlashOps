---
id: lt-01
title: local.files.search tool
version: v0.2
group: local-tools
subgroup: files
sequence: 1
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
  - "PRD §11.3 Local/document tools tests (lines 2638-2651)"
deliverables:
  - src/SlashOps/Private/Tools/Local/Invoke-LocalFilesSearch.ps1
  - src/SlashOps/ToolManifests/local.files.search.json
  - tests/Unit/Tools.Local.FilesSearch.Tests.ps1
tags: [v0.2, tool, files, search]
---

## Overview

Search local files by root, extension list, modified-on-or-after, name fragment. Read-only; fast-mode eligible. Used by document search workflows and direct shell-like prompts.

## TDD test list

- Resolves `~/Downloads` correctly.
- Filters by today using timezone context (per §7.11).
- Ranks by recency and keyword match.
- Returns structured rows with `Name`, `LastWriteTime`, `Length`, `FullName`.
- Refuses to search outside safe roots (delegates to path policy).
- Manifest passes `Test-SlashOpsToolManifest`.

## Implementation steps

1. Author `Private/Tools/Local/Invoke-LocalFilesSearch.ps1`.
2. Author the manifest with `default_risk: read-only`, `supports_fast_mode: true`.
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- Use `Get-ChildItem -File -Recurse:$false` by default; recurse only on explicit input.
