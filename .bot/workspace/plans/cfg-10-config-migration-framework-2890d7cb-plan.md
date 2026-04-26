## Overview

Provide a migration entry point that detects older `schema_version` values and applies registered migrations in order. `Initialize-SlashOps` calls this when a known older version is found; unknown future versions are refused without modification, and a `migration_log` entry is written into the migrated config (or history file) recording the bump.

## TDD test list

- Old schema version (e.g. `"0"`) triggers migration to `"1"` after backup.
- Unknown future schema (e.g. `"99"`) is left untouched and returns refusal.
- Migration creates a backup before writing (cfg-05).
- `migration_log` entry recorded with timestamp, from-version, to-version.
- Migration is idempotent — re-running on a `"1"` file is a no-op.

## Implementation steps

1. Author `Private/Config/Invoke-ConfigMigration.ps1` taking `(Path)`, dispatching to a registered migration map keyed by from-version.
2. Each migration is a small private function — register them in a hashtable so future versions can be added without touching the dispatcher.
3. Tests cover every TDD bullet.

## PRD references

- §9.10 — migration support, backup-first, future-version refusal.

## Acceptance criteria

- Tests pass.
- Backup created before write.
- Future schema refused.
- `migration_log` entry recorded.

## Notes / risks

- v0.1 ships only schema `"1"` — the dispatcher exists to make later bumps mechanical.

