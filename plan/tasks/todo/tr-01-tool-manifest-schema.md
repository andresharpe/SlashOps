---
id: tr-01
title: Tool manifest schema and validator
version: v0.2
group: tool-runtime
subgroup: manifest
sequence: 1
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.6 Tool registry (lines 1019-1055)"
  - "PRD §11.3 Tool registry tests (lines 2626-2636)"
deliverables:
  - src/SlashOps/Private/Tools/Registry/Test-ToolManifest.ps1
  - src/SlashOps/Public/Test-SlashOpsToolManifest.ps1
  - src/SlashOps/ToolManifests/.gitkeep
  - tests/Unit/ToolManifest.Tests.ps1
tags: [v0.2, tools, manifest, schema]
---

## Overview

Define the JSON schema for tool manifests per §7.6 and ship a validator. Manifests live under `src/SlashOps/ToolManifests/*.json`, one per tool, with name, description, category, entrypoint, mutation flags, risk, fast-mode eligibility, dependencies, platform list, and input / output schemas.

## TDD test list

- Valid manifest passes.
- Missing required field (`name`, `entrypoint`, `default_risk`, etc.) fails with field name in error.
- Unknown category fails.
- Invalid `default_risk` (not in enum) fails.
- `requires_auth = $true` requires `category` to be in `[outlook, github, cloud, ...]`.
- Unsupported platform value fails.

## Implementation steps

1. Author `Private/Tools/Registry/Test-ToolManifest.ps1`.
2. Public `Test-SlashOpsToolManifest` thin wrapper.
3. Tests cover every TDD bullet.

## PRD references

- §7.6 — manifest schema.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Public command exported.

## Notes / risks

- The schema is the contract that every later tool task references; any field added later requires a manifest schema bump.
