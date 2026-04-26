---
id: lt-07
title: doc.markdown.convert tool (Pandoc)
version: v0.2
group: local-tools
subgroup: documents
sequence: 7
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
  - "PRD §11.3 Markdown conversion test (line 2651)"
deliverables:
  - src/SlashOps/Private/Tools/Documents/Invoke-MarkdownConvert.ps1
  - src/SlashOps/ToolManifests/doc.markdown.convert.json
  - tests/Unit/Tools.Doc.MarkdownConvert.Tests.ps1
tags: [v0.2, tool, documents, pandoc]
---

## Overview

Convert Markdown to PDF / DOCX / HTML via Pandoc. When Pandoc is missing, return a structured `needs_dependency` observation pointing at the platform install command. Output path must be inside a safe write root (saf-03).

## TDD test list

- Pandoc available + valid input → produces output file (mocked invocation).
- Pandoc missing → `needs_dependency` observation with platform install hint.
- Output path outside safe write root → refused.
- Existing output file → confirmation required unless overwrite explicit.
- Manifest passes validation.

## Implementation steps

1. Author the tool function invoking `pandoc <in> -o <out>`.
2. Author manifest with `required_commands: ['pandoc']`, `default_risk: benign-write`, `supports_fast_mode: true`.
3. Tests mock pandoc invocation.

## PRD references

- §7.7 — tool list.
- §11.3 — required test.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Pandoc PDF output requires a TeX install on some platforms; surface this as a sub-dependency hint when PDF format requested.
