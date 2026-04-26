---
id: rel-01
title: Stabilise config / policy / tool-manifest schemas
version: v1.0
group: release
subgroup: schemas
sequence: 1
depends_on: [cfg-10]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v1.0 stable schemas (lines 2949-2952)"
deliverables:
  - docs/SCHEMAS.md
  - tests/Unit/Schemas.Stability.Tests.ps1
tags: [v1.0, schema, stability]
---

## Overview

Freeze the v1 schemas for config, policy, and tool manifest. Add tests asserting the public surface (top-level keys, required fields) does not regress. Document the SemVer policy for future schema bumps.

## TDD test list

- Snapshot test of default config keys.
- Snapshot test of default policy keys.
- Snapshot test of tool manifest required fields.
- Migration path from `"1"` to a future `"2"` documented.

## Implementation steps

1. Add snapshot tests.
2. Author `docs/SCHEMAS.md` describing the schemas and migration policy.

## PRD references

- §16 — v1.0 scope.

## Acceptance criteria

- TDD tests pass.
- Schema doc complete.

## Notes / risks

- Schema bumps are breaking changes — bump `SchemaMajorVersion` and add a migration in `cfg-10`.
