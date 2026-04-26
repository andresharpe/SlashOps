---
id: ma-04
title: Plugin policy packs
version: v0.4
group: mature-agent
subgroup: policy
sequence: 4
depends_on: [cfg-11]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v0.4 plugin policy packs (line 2943)"
deliverables:
  - src/SlashOps/Private/Config/Resolve-PolicyPack.ps1
  - tests/Unit/Config.PolicyPack.Tests.ps1
tags: [v0.4, policy, packs, plugin]
---

## Overview

Allow third-party policy packs (signed JSON files) that add stricter rules — extra blocked patterns, additional protected roots, additional confirmation tokens. Packs can never weaken the safety floor.

## TDD test list

- Pack loads from configured path.
- Pack adds blocked patterns.
- Pack cannot weaken safety floor (rejected).
- Pack signature verification (when enabled).
- Multiple packs merge additively.

## Implementation steps

1. Author `Resolve-PolicyPack.ps1` to load and merge packs into effective policy.
2. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Defer signature verification design until v1.0; v0.4 supports unsigned packs with a clear warning.
