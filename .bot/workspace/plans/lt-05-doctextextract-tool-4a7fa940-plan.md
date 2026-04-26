## Overview

Extract text from TXT, MD, HTML, RTF, PDF (via Poppler `pdftotext`), DOCX (via Pandoc). Each format is a separate code path with graceful degradation when the optional CLI is missing — return a `needs_dependency` observation rather than improvise.

## TDD test list

- TXT and MD pass-through verbatim.
- HTML stripped to plain text.
- RTF converted via available helper.
- PDF requires `pdftotext`; missing tool → dependency observation.
- DOCX requires `pandoc`; missing tool → dependency observation.
- Output respects `documents.maxExtractedTextBytes`.
- Manifest passes validation.

## Implementation steps

1. Author `Private/Tools/Documents/Invoke-DocumentTextExtract.ps1` with format dispatch.
2. Author the manifest.
3. Tests mock external tool invocation.

## PRD references

- §7.7 — tool list.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Document the format-to-tool map in `docs/DOCUMENTS.md`.

