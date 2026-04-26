## Overview

Search text content within text files (TXT, MD, HTML, JSON, YAML, CSV) using `Select-String` or `rg` when available. Refuses binary files. Read-only; fast-mode eligible.

## TDD test list

- Returns matches with file, line number, snippet.
- Skips binary files.
- Uses `rg` when available, falls back to `Select-String`.
- Manifest passes validation.

## Implementation steps

1. Author the tool function.
2. Author the manifest with `required_commands: []` (rg is optional, fall back to Select-String).
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- For PDFs and DOCX use `doc.text.extract` first (lt-05); this tool sticks to plain text.

