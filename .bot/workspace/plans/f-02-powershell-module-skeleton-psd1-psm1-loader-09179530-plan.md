## Overview

Create the PowerShell module manifest and root script that the rest of the codebase plugs into. The `.psm1` loader must dot-source every `.ps1` under `Public/` and `Private/**/` deterministically, export only public functions, and never write to disk during `Import-Module` (per PRD §9.2 acceptance "no config write may occur during Import-Module").

## TDD test list

- `Import-Module ./src/SlashOps/SlashOps.psd1` succeeds without error on Windows, macOS, Linux.
- `Test-ModuleManifest ./src/SlashOps/SlashOps.psd1` returns truthy.
- After import, `Get-Module SlashOps` shows `ModuleVersion` `0.1.0`.
- After import, no files exist under `~/.slashops/`.
- The loader dot-sources files in stable alphabetical order (smoke test: add a probe file in `Private/` and assert it is loaded).

## Implementation steps

1. Author `SlashOps.psd1` with: `RootModule = 'SlashOps.psm1'`, `ModuleVersion = '0.1.0'`, generated stable `GUID`, `Author = 'Andre Sharpe'`, `Description` from PRD §8.2, `PowerShellVersion = '7.0'`, `CompatiblePSEditions = @('Core')`. Leave `FunctionsToExport = @()` for now; `pub-01` finalises it.
2. Author `SlashOps.psm1` that:
   - Computes `$here = Split-Path -Parent $PSCommandPath`.
   - Dot-sources `Get-ChildItem -Path (Join-Path $here 'Private') -Recurse -Filter '*.ps1' | Sort-Object FullName`.
   - Then dot-sources `Get-ChildItem -Path (Join-Path $here 'Public') -Filter '*.ps1' | Sort-Object FullName`.
   - Calls `Export-ModuleMember -Function (Get-ChildItem (Join-Path $here 'Public') -Filter '*.ps1').BaseName`.
   - Performs no I/O outside `$here`.
3. Add `.gitkeep` to `Public/` and `Private/` so the empty folders persist under git.
4. Write `tests/Unit/Module.Tests.ps1` covering the test list above.

## PRD references

- §8.2 Module manifest requirements — full keys, tags, project URI placeholders.
- §10.1 Proposed repository structure — paths under `src/SlashOps/`.
- §9.2 acceptance — no config write during import.

## Acceptance criteria

- `Import-Module` is idempotent.
- `Test-ModuleManifest` passes.
- No write under `$HOME` during import.
- Pester unit tests pass on Windows + Linux.
- Loader is order-stable (alphabetical) and recursive over `Private/`.

## Notes / risks

- `AliasesToExport` for `/`, `//`, `/x`, `/!`, `/?` is set in `pub-01` after `ux-07` confirms which aliases are reliably installable.
- GUID must be stable across versions — generate once and never regenerate.

