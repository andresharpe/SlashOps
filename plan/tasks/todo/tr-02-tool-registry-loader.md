---
id: tr-02
title: Tool registry loader and resolver
version: v0.2
group: tool-runtime
subgroup: registry
sequence: 2
depends_on: [tr-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.6 Tool registry (lines 1019-1055)"
  - "PRD §9.5 toolRegistry config (lines 1799-1814)"
  - "PRD §11.3 Tool registry tests (lines 2626-2636)"
deliverables:
  - src/SlashOps/Private/Tools/Registry/Get-ToolRegistry.ps1
  - src/SlashOps/Private/Tools/Registry/Read-ToolManifest.ps1
  - src/SlashOps/Private/Tools/Registry/Resolve-Tool.ps1
  - tests/Unit/ToolRegistry.Tests.ps1
tags: [v0.2, tools, registry, loader]
---

## Overview

Discover manifests under `ToolManifests/`, validate each, filter by `toolRegistry.enabledTools` / `disabledTools`, drop tools whose `supported_platforms` excludes the current OS, drop tools whose `required_commands` are missing from the inventory, and produce an indexed registry the planner and executor consume.

## TDD test list

- Built-in manifests load.
- Invalid manifest is excluded with a warning.
- Disabled tool excluded.
- Wrong platform excluded.
- Missing required command excluded.
- `Resolve-Tool` returns `$null` for unknown name.
- Project config cannot enable user tools by default (per §9.5).

## Implementation steps

1. Author the three private helpers.
2. Tests use `TestDrive:` to seed manifests and a mocked tool inventory.

## PRD references

- §7.6 — registry rules.
- §9.5 — toolRegistry config.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Cache the registry per process; invalidate on policy / config mtime change (per §9.11).
