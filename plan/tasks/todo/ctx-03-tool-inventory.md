---
id: ctx-03
title: Tool inventory with caching
version: v0.1
group: context
subgroup: tools
sequence: 3
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.4 Tool inventory (lines 530-548)"
  - "PRD §10.3 Performance requirements / caching (lines 2466-2484)"
deliverables:
  - src/SlashOps/Private/Context/Get-ToolInventory.ps1
  - src/SlashOps/Public/Get-SlashOpsToolInventory.ps1
  - tests/Unit/Context.ToolInventory.Tests.ps1
tags: [context, tools, inventory, cache]
---

## Overview

Detect external CLI tools using `Get-Command`. Cache results for `tools.inventoryCacheMinutes` (default 10). Distinguish required tools (those a registered tool depends on) from optional ones. Missing required tools produce `needs_dependency` plans rather than improvised commands (per §6.4).

## TDD test list

- Inventory finds tools that exist in PATH (via mocked `Get-Command`).
- Inventory marks missing tools as `present = $false`.
- Inventory caches for the configured TTL.
- Cache invalidates when configuration mtime changes (per §10.3 caching rules).
- Required vs optional flag respected in output.
- Resolved source path included where `Get-Command` provides it.

## Implementation steps

1. Author `Private/Context/Get-ToolInventory.ps1` taking the preferred-tool list from effective config.
2. Cache file: in-memory plus `~/.slashops/cache.json` per config. Key by tool name + platform.
3. Public `Get-SlashOpsToolInventory` exposes the inventory for diagnostics.

## PRD references

- §6.4 — default tool list and inventory rules.
- §10.3 — caching durations.

## Acceptance criteria

- TDD tests pass.
- Cache TTL respected.
- Public command exported.

## Notes / risks

- Mock `Get-Command` deterministically; do not rely on the host PATH in tests.
