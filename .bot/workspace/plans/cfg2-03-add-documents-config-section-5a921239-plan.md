## Overview

Extend default config with `documents` block: `downloadsDirectory`, `defaultSummaryStyle`, byte / chunk limits, `preferPandoc`, `preferPoppler`, `summarizeWithCitations`.

## TDD test list

- Default config contains `documents`.
- Defaults match §9.5.
- Validation rejects negative byte / chunk values.

## Implementation steps

1. Update `New-DefaultConfig.ps1`.
2. Tests cover defaults and validation.

## PRD references

- §9.5 — documents schema.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- `chunkSizeChars` and `chunkOverlapChars` are tuned for a 256K context window — leave defaults conservative.

