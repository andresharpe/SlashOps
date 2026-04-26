---
id: cfg2-03
title: Add documents config section
version: v0.2
group: config2
subgroup: documents
sequence: 3
depends_on: [cfg-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.5 documents config (lines 1816-1826)"
deliverables:
  - src/SlashOps/Private/Config/New-DefaultConfig.ps1 (update)
  - tests/Unit/Config.Documents.Tests.ps1
tags: [v0.2, config, documents]
---

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
