---
id: ui2-02
title: Search results table
version: v0.2
group: ui2
subgroup: search
sequence: 2
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.16 Tool result UI (lines 1259-1269)"
  - "PRD §7.11 Local document search (lines 1153-1171)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsSearchResults.ps1
  - tests/Unit/UI.SearchResults.Tests.ps1
tags: [v0.2, ui, search, fxconsole]
---

## Overview

Render ranked search results — used by file search, document search, mail search. Columns are tool-specific (file: name / size / modified / path; mail: sender / subject / received / folder / snippet) but the helper accepts a column spec so each tool can configure its own.

## TDD test list

- Renders rows with the supplied column spec.
- Renders rank column when ranking metadata present.
- Truncates long snippets to a configurable width.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsSearchResults.ps1` calling `Write-FxTable`.
2. Tests stub FxConsole.

## PRD references

- §7.16 — search results UI.
- §7.11 — local document search ranking.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid rendering full snippets; truncate to keep terminals readable.
