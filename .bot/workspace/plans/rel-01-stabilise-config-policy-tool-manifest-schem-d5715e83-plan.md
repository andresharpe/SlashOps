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

