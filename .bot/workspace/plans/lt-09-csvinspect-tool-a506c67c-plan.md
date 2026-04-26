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

