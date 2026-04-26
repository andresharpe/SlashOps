---
id: lt-08
title: doc.pdf.inspect tool (Poppler)
version: v0.2
group: local-tools
subgroup: documents
sequence: 8
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
deliverables:
  - src/SlashOps/Private/Tools/Documents/Invoke-PdfInspect.ps1
  - src/SlashOps/ToolManifests/doc.pdf.inspect.json
  - tests/Unit/Tools.Doc.PdfInspect.Tests.ps1
tags: [v0.2, tool, pdf, poppler]
---

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
