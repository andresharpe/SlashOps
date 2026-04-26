## Overview

Walk upward from the current directory to find `./.slashops.json`. Stop at the filesystem root or when found. Respect `SLASHOPS_NO_PROJECT_CONFIG=1` (skip discovery entirely). Project paths in the config (e.g. safe write roots) resolve relative to the project config file location.

## TDD test list

- Discovery returns `$null` when no `.slashops.json` exists in any ancestor.
- Discovery returns the closest ancestor's path when one exists.
- `SLASHOPS_NO_PROJECT_CONFIG=1` short-circuits and returns `$null`.
- `SLASHOPS_PROJECT_CONFIG` env var, when set, takes precedence over walk-up.
- Walk-up stops at the filesystem root without infinite loop.
- Discovery is read-only.

## Implementation steps

1. Author `Private/Config/Resolve-ProjectConfig.ps1` taking `[string]$StartDirectory = $PWD` and returning the resolved path or `$null`.
2. Pester tests use `TestDrive:` to create nested directory trees with and without `.slashops.json`.

## PRD references

- §9.7 — project config schema and discovery semantics.
- §9.13 — TDD: project config discovery + disabling via env.

## Acceptance criteria

- Walk-up bounded, no infinite loop.
- `SLASHOPS_NO_PROJECT_CONFIG=1` honoured.
- Tests pass.

## Notes / risks

- Walk-up must use `Split-Path -Parent` until `$parent -eq $current`.
- Document that project config does not get loaded when called from a global script with no `$PWD` context (caller must supply explicit start dir).

