---
id: cfg-01
title: Resolve configuration paths and SLASHOPS_HOME overrides
version: v0.1
group: config
subgroup: paths
sequence: 1
depends_on: [f-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.2 Configuration files and directories (lines 1613-1659)"
  - "PRD §9.13 Config TDD requirements (lines 2189-2214)"
deliverables:
  - src/SlashOps/Private/Config/Get-ConfigPath.ps1
  - src/SlashOps/Public/Get-SlashOpsConfigPath.ps1
  - tests/Unit/Config.Paths.Tests.ps1
tags: [config, paths, env-overrides, cross-platform]
---

## Overview

Provide a single source of truth for resolving SlashOps file locations: home directory, config path, policy path, history path, runs/backups directories, and project-config search root. The resolver respects environment overrides `SLASHOPS_HOME`, `SLASHOPS_CONFIG`, `SLASHOPS_POLICY`, and `SLASHOPS_PROJECT_CONFIG`, and works identically on Windows, macOS, Linux, and WSL under PowerShell 7+.

## TDD test list

- Default path resolution returns `~/.slashops/config.json` and `~/.slashops/policy.json`.
- `SLASHOPS_HOME` override changes all default paths consistently.
- `SLASHOPS_CONFIG` override may point outside `SLASHOPS_HOME`.
- `SLASHOPS_POLICY` override may point outside `SLASHOPS_HOME`.
- `~` expansion uses `$HOME` (not `$env:USERPROFILE`) so behaviour matches across platforms.
- Resolver returns absolute, normalised paths.
- Resolver does not create files or directories — it is read-only.

## Implementation steps

1. Author `Private/Config/Get-ConfigPath.ps1`: a single function returning a `[pscustomobject]` with members `Home`, `Config`, `Policy`, `History`, `RunsDir`, `BackupsDir`, `CacheFile`, `ProjectConfig`. It honours environment overrides, expands `~`, and normalises with `[System.IO.Path]::GetFullPath` after `Resolve-Path -Force` where applicable.
2. Author `Public/Get-SlashOpsConfigPath.ps1` that delegates to the private function and supports `-Detailed` to return the full object versus the default config path string.
3. Add Pester tests for every TDD bullet using `TestDrive:` for any temporary roots.

## PRD references

- §9.2 lists the canonical file paths and environment variables.
- §9.13 enumerates the TDD checklist items this task satisfies (default path resolution, `SLASHOPS_HOME` override, `SLASHOPS_CONFIG` override, `SLASHOPS_POLICY` override).

## Acceptance criteria

- All TDD tests pass on Windows + Linux.
- No filesystem writes.
- `Get-SlashOpsConfigPath` is exported.
- Function works under `Set-StrictMode -Version Latest`.

## Notes / risks

- Avoid `$env:USERPROFILE` — `$HOME` is set in PowerShell 7 on every platform.
- Path comparisons must be case-insensitive on Windows but case-sensitive on Linux/macOS — use `[System.IO.Path]::GetFullPath` for normalisation, not string lower-casing.
