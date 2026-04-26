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

