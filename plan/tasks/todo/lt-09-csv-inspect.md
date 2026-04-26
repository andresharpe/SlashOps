---
id: lt-09
title: csv.inspect tool
version: v0.2
group: local-tools
subgroup: data
sequence: 9
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
deliverables:
  - src/SlashOps/Private/Tools/Data/Invoke-CsvInspect.ps1
  - src/SlashOps/ToolManifests/csv.inspect.json
  - tests/Unit/Tools.Data.CsvInspect.Tests.ps1
tags: [v0.2, tool, csv, data]
---

## Overview

Inspect CSV / TSV shape: detected delimiter, header, row count, sample rows, column types inferred from a small sample. Read-only; fast-mode eligible.

## TDD test list

- Detects comma vs tab delimiter.
- Returns header.
- Returns row count.
- Returns first N sample rows.
- Infers column types (int / float / date / string) from sample.
- Manifest passes validation.

## Implementation steps

1. Author `Private/Tools/Data/Invoke-CsvInspect.ps1` using `Import-Csv` after delimiter detection.
2. Author manifest.
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid loading whole large CSVs — read first N lines for inspection.
