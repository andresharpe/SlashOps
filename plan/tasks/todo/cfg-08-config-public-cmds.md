---
id: cfg-08
title: Public config and policy commands
version: v0.1
group: config
subgroup: public
sequence: 8
depends_on: [cfg-05, cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.8 Config commands (lines 2031-2108)"
deliverables:
  - src/SlashOps/Public/Get-SlashOpsConfig.ps1
  - src/SlashOps/Public/Set-SlashOpsConfig.ps1
  - src/SlashOps/Public/Edit-SlashOpsConfig.ps1
  - src/SlashOps/Public/Reset-SlashOpsConfig.ps1
  - src/SlashOps/Public/Test-SlashOpsConfig.ps1
  - src/SlashOps/Public/Get-SlashOpsPolicy.ps1
  - src/SlashOps/Public/Set-SlashOpsPolicy.ps1
  - src/SlashOps/Public/Edit-SlashOpsPolicy.ps1
  - src/SlashOps/Public/Test-SlashOpsPolicy.ps1
  - src/SlashOps/Private/Config/Set-ConfigValue.ps1
  - tests/Unit/Config.PublicCmds.Tests.ps1
tags: [config, public-api, cmdlets]
---

## Overview

Expose the public config / policy commands per PRD §9.8. Setters accept dot-paths (e.g. `model.generationModel`), validate the setting exists unless `-AllowNew`, back up before write (cfg-05), validate the result (cfg-04), and restore on failure. Editors open the file in the user's editor (`$env:EDITOR`/`$env:VISUAL`/`code`/platform default), validate after exit, and offer restore.

## TDD test list

- `Get-SlashOpsConfig` returns the user config object.
- `Get-SlashOpsConfig -Raw` returns the raw JSON text.
- `Set-SlashOpsConfig model.generationModel qwen3-coder:30b` round-trips the value.
- `Set-SlashOpsConfig model.generationModel ''` fails validation.
- `Set-SlashOpsConfig some.unknown.path 'x'` fails without `-AllowNew`.
- `Set-SlashOpsConfig` backs up before writing.
- `Set-SlashOpsConfig` restores from backup if post-write validation fails.
- `Edit-SlashOpsConfig` opens an editor (mock) and validates after.
- `Reset-SlashOpsConfig` requires confirmation, backs up old config, writes defaults, preserves history.
- `Test-SlashOpsConfig` returns structured `Passed/Errors/Warnings/Path`.
- Same suite passes for `*-SlashOpsPolicy`.

## Implementation steps

1. Author each public cmdlet thin-wrapping a private helper. Reuse `Set-ConfigValue.ps1` for dot-path mutation.
2. `Edit-*` chooses editor by precedence: `$env:EDITOR` → `$env:VISUAL` → `code` if on PATH → `notepad` (Windows) → `nano` (Linux/macOS).
3. Confirmation prompts for `Reset-*` honour `-Confirm` / `-Force` ShouldProcess semantics.
4. Tests use `TestDrive:` and `Mock` for editor invocation.

## PRD references

- §9.8 — full cmdlet list and behaviour requirements.
- §9.5 — naming convention: dot-separated camelCase paths.

## Acceptance criteria

- Every cmdlet listed in deliverables is exported.
- All TDD tests pass.
- ShouldProcess semantics work for `Set-`, `Reset-`.
- Backup + restore proven by tests.

## Notes / risks

- Dot-path setter must handle nested objects and arrays — write tests for both.
- Editor invocation must be mockable; do not call `Start-Process` directly inside the cmdlet — use a private helper that tests can override.
