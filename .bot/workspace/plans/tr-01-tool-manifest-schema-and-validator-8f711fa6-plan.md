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

