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

