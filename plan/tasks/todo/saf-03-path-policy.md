---
id: saf-03
title: Path policy normalisation and check
version: v0.1
group: safety
subgroup: paths
sequence: 3
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.10 Path policy (lines 699-735)"
  - "PRD §11.3 Path policy tests (lines 2582-2588)"
deliverables:
  - src/SlashOps/Private/Safety/Test-PathPolicy.ps1
  - src/SlashOps/Public/Test-SlashOpsPathPolicy.ps1
  - src/SlashOps/Public/Get-SlashOpsSafeWriteRoot.ps1
  - src/SlashOps/Public/Add-SlashOpsSafeWriteRoot.ps1
  - src/SlashOps/Public/Remove-SlashOpsSafeWriteRoot.ps1
  - tests/Unit/Safety.PathPolicy.Tests.ps1
tags: [safety, paths, policy]
---

## Overview

Normalise paths (`~`, `$HOME`, relative, env-var expansion) and check them against policy `safeWriteRoots` and `protectedRoots`. Reject writes outside safe roots in `/x`, reject writes to protected roots in any mode unless explicit. Provide public commands so users can manage safe roots.

## TDD test list

- `~/work/file.txt` normalises to `$HOME/work/file.txt`.
- `./sub/file` resolves relative to `$PWD`.
- Path under `safeWriteRoots` returns `Allowed = $true`.
- Path under `protectedRoots` returns `Allowed = $false`.
- `/etc/foo` blocked on Linux.
- `C:\Windows\foo` blocked on Windows.
- Broad wildcard write returns `RequiresConfirmation = $true`.
- Overwrite of existing file returns `RequiresConfirmation = $true` unless explicit.
- `Add-` and `Remove-SlashOpsSafeWriteRoot` mutate user policy via cfg-08.

## Implementation steps

1. Author `Private/Safety/Test-PathPolicy.ps1` returning structured result.
2. Add `Get/Add/Remove-SlashOpsSafeWriteRoot` public commands, all driven by user policy file.
3. Tests cover normalisation and policy decisions.

## PRD references

- §6.10 — full path policy.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Public commands exported.
- Cross-platform path handling.

## Notes / risks

- Symlink resolution: `Resolve-Path` follows symlinks; document that policy decisions are made on the canonical path.
