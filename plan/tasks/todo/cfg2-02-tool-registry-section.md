---
id: cfg2-02
title: Add toolRegistry config section
version: v0.2
group: config2
subgroup: tool-registry
sequence: 2
depends_on: [cfg-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.5 Tool runtime configuration (lines 1799-1814)"
deliverables:
  - src/SlashOps/Private/Config/New-DefaultConfig.ps1 (update)
  - tests/Unit/Config.ToolRegistry.Tests.ps1
tags: [v0.2, config, tool-registry]
---

## Overview

Extend the default user config with the `toolRegistry` block: `enabled`, `registryPath`, `allowUserTools`, `allowProjectTools`, `enabledTools`, `disabledTools`. Defaults disable user / project tools per §17 Q9 / Q10.

## TDD test list

- Default config contains `toolRegistry`.
- `enabledTools` matches PRD §9.5 default list.
- `allowUserTools` and `allowProjectTools` default to `false`.
- Project config cannot enable user tools (per safety floor cfg-11).

## Implementation steps

1. Update `New-DefaultConfig.ps1`.
2. Add validation.
3. Tests cover every TDD bullet.

## PRD references

- §9.5 — `toolRegistry` schema.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Adding new built-in tools requires updating `enabledTools` here.
