---
id: cfg-02
title: Default user config (config.json) generator
version: v0.1
group: config
subgroup: defaults
sequence: 2
depends_on: [cfg-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.4 User config schema (lines 1691-1776)"
  - "PRD §9.9 First-run config creation (lines 2110-2139)"
deliverables:
  - src/SlashOps/Private/Config/New-DefaultConfig.ps1
  - src/SlashOps/Private/Config/Write-Config.ps1
  - tests/Unit/Config.Defaults.Tests.ps1
tags: [config, defaults, schema, json]
---

## Overview

Produce the default user `config.json` exactly as documented in PRD §9.4 — `model`, `execution`, `ui`, `context`, `tools`, `logging`, `cache` sections, plus `schema_version: "1"`. Writes are gated: nothing happens at `Import-Module`; only `Initialize-SlashOps` and the public `Set-`/`Reset-` commands trigger persistence.

## TDD test list

- Generated default object has every key listed in §9.4.
- `schema_version` is `"1"`.
- `model.generationModel` defaults to `qwen3-coder:30b`.
- `execution.allowFastExecution` defaults to `true`.
- `ui.theme` defaults to `amber`.
- Writer creates the parent directory if missing.
- Writer is no-op when called during `Import-Module` (it must only be invoked from setters).
- Writer round-trips: object → JSON file → object equals the original.

## Implementation steps

1. Author `Private/Config/New-DefaultConfig.ps1` returning the §9.4 hashtable. Use `[ordered]` so JSON output is deterministic.
2. Author `Private/Config/Write-Config.ps1` taking `(Path, Object)` and writing pretty JSON with stable key ordering and 2-space indentation. Use `ConvertTo-Json -Depth 10`.
3. Pester tests cover every TDD bullet using `TestDrive:`.

## PRD references

- §9.4 defines the full schema. Keep camelCase exactly as shown.
- §9.9 step 3 — "Create `config.json` from defaults if missing".
- §9.5 naming convention: JSON persisted config uses camelCase.

## Acceptance criteria

- Default object matches PRD §9.4 byte-for-byte after round-trip.
- Tests pass.
- No write at import.

## Notes / risks

- `tools.preferredTools` is a long list — keep it inline so the file remains diff-friendly.
- `cache.path` uses `~` literal in JSON; resolution happens at read time, not write time.
