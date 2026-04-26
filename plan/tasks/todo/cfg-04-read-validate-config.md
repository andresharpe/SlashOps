---
id: cfg-04
title: Read and validate config + policy JSON
version: v0.1
group: config
subgroup: io
sequence: 4
depends_on: [cfg-02, cfg-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.4 User config schema (lines 1691-1776)"
  - "PRD §9.6 Policy config schema (lines 1869-1987)"
  - "PRD §9.8 Test-SlashOpsConfig (lines 2097-2108)"
  - "PRD §9.10 Config migration (lines 2141-2157)"
deliverables:
  - src/SlashOps/Private/Config/Read-Config.ps1
  - src/SlashOps/Private/Config/Test-ConfigSchema.ps1
  - src/SlashOps/Private/Config/Test-PolicySchema.ps1
  - tests/Unit/Config.ReadValidate.Tests.ps1
tags: [config, validation, schema, io]
---

## Overview

Read user config and policy from disk and validate them against the v1 schema. Validation must catch invalid JSON, missing required fields, malformed endpoint URI, non-positive durations, regex compilation failures, and unknown future schema versions. Failure must be structured (not just exceptions) so callers can present remediation.

## TDD test list

- Valid config round-trip parses without error.
- Invalid JSON returns `Passed = $false` with parse-error message.
- Invalid schema version (not `"1"` and not future-known) returns `Passed = $false`.
- Future schema version (e.g. `"99"`) returns `Passed = $false` with refusal note (per §9.10).
- Missing required field returns `Passed = $false` listing the field path.
- Endpoint not matching URI format returns `Passed = $false`.
- Negative timeouts/cache durations are rejected.
- Policy regex patterns that fail to compile are rejected.

## Implementation steps

1. Author `Private/Config/Read-Config.ps1` returning a parsed object or throwing a structured `[pscustomobject]@{ Passed; Errors; Warnings; Path }` per §9.8.
2. Author `Private/Config/Test-ConfigSchema.ps1` and `Test-PolicySchema.ps1` returning the same structured shape.
3. Use `ConvertFrom-Json -AsHashtable` for stable shape; convert back to `pscustomobject` only at API boundaries.
4. Tests cover every TDD bullet using `TestDrive:` and seeded JSON files.

## PRD references

- §9.4 — required user config fields.
- §9.6 — required policy fields.
- §9.8 `Test-SlashOpsConfig` semantics.
- §9.10 — refusal of unknown future schemas without modification.

## Acceptance criteria

- All TDD tests pass.
- Validators return structured results, not bare booleans.
- No mutation of the input file.

## Notes / risks

- Use `[uri]::IsWellFormedUriString` for endpoint check; tolerate trailing slashes.
- Avoid `Test-Json` since older PS 7 versions vary; do explicit shape checks instead.
