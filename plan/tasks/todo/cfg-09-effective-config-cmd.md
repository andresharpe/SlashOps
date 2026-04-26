---
id: cfg-09
title: Get-SlashOpsEffectiveConfig with source attribution
version: v0.1
group: config
subgroup: public
sequence: 9
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.8 Get-SlashOpsEffectiveConfig (lines 2057-2062)"
  - "PRD §9.13 effective config source attribution (line 2213)"
deliverables:
  - src/SlashOps/Public/Get-SlashOpsEffectiveConfig.ps1
  - tests/Unit/Config.Effective.Tests.ps1
tags: [config, effective, source-attribution]
---

## Overview

Public command that returns the merged effective configuration. With `-Detailed`, the output includes per-leaf source attribution so the user can see which layer (default / user / policy / project / env / CLI) determined each value, plus whether project config was discovered.

## TDD test list

- Plain call returns the effective config object.
- `-Detailed` returns object with `Effective` and `Sources` members.
- `Sources` covers every leaf path in `Effective`.
- `-Detailed` reports `ProjectConfigPath` when found, `$null` when not.
- Output is deterministic for a given input set.

## Implementation steps

1. Author `Public/Get-SlashOpsEffectiveConfig.ps1` thin-wrapping `Private/Config/Get-EffectiveConfig.ps1`.
2. Pester tests using seeded layers in `TestDrive:`.

## PRD references

- §9.8 — `Get-SlashOpsEffectiveConfig` requirements (`-Detailed` source attribution, project-config-found indicator).
- §9.13 — TDD: source attribution.

## Acceptance criteria

- Plain and detailed forms work.
- Source attribution covers every leaf.
- Tests pass.

## Notes / risks

- Source attribution adds non-trivial size; ensure it is emitted only with `-Detailed`.
