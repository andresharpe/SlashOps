## Overview

Provide a backup helper for config and policy mutations. Every `Set-`, `Edit-`, `Reset-`, or `Invoke-ConfigMigration` call must pass through this helper to write a timestamped copy under `~/.slashops/backups/` before touching the live file. On post-write validation failure, the caller restores from the backup.

## TDD test list

- Backup creates `~/.slashops/backups/{filename}.{timestamp}.{schemaVersion}.json` with original content.
- Timestamp uses `yyyy-MM-ddTHHmmss` in local time, matching PRD §9.10 example.
- Helper is idempotent for the same file within the same second (suffix bumped).
- Helper returns the backup path so callers can restore.
- Restore-from-backup helper recreates the original file atomically.

## Implementation steps

1. Author `Private/Config/ConvertTo-ConfigBackup.ps1` taking `(Path)` and returning the backup path.
2. Add a `Restore-ConfigBackup` companion (private) that copies a backup back into place.
3. Pester tests cover every TDD bullet using `TestDrive:`.

## PRD references

- §9.8 `Set-SlashOpsConfig` requires backup before write and restore on invalid result.
- §9.10 example backup path: `~/.slashops/backups/config.2026-04-26T143012.v1.json`.

## Acceptance criteria

- Backup files created with correct naming.
- Restore copies content back faithfully.
- Tests pass.

## Notes / risks

- Use `Copy-Item` rather than reading + writing to avoid encoding drift.
- Backups directory must be created lazily — first call creates it.

