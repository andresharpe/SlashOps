## Overview

Update `SlashOps.psd1` with the final list of `FunctionsToExport`, `AliasesToExport`, tags, project URI, license URI, and release notes. Validate via `Test-ModuleManifest` and assert that every cmdlet exported actually exists.

## TDD test list

- `Test-ModuleManifest` returns truthy.
- `FunctionsToExport` lists every public function file in `Public/`.
- `AliasesToExport` includes `/`, `//`, `/x`, `/!`, `/?`.
- Tags include the documented set.
- LicenseUri and ProjectUri set.

## Implementation steps

1. Update the manifest from `f-02` with the final exports.
2. Pester test asserts the cmdlet list matches `Get-ChildItem Public/*.ps1`.

## PRD references

- §8.2 — manifest schema.
- §12.1 — pre-publish requirements.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- Remember to update `ModuleVersion` on every release per SemVer.

