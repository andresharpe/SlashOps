## Overview

Inspect a PDF: page count, metadata, optional table-of-contents extraction via `pdfinfo` and `pdftotext` from Poppler. Read-only; fast-mode eligible.

## TDD test list

- Returns `pages`, `title`, `author`, `creation_date`.
- Missing `pdfinfo` → `needs_dependency` observation.
- Refuses non-PDF inputs.
- Manifest passes validation.

## Implementation steps

1. Author the tool function invoking `pdfinfo` and parsing output.
2. Author manifest with `required_commands: ['pdfinfo']`.
3. Tests mock external invocation.

## PRD references

- §7.7 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Some PDFs strip metadata; tolerate empty fields.

