---
id: pub-01
title: Finalise module manifest
version: v0.1
group: publish
subgroup: manifest
sequence: 1
depends_on: [cfg-08, exe-04, set-05, ux-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §8.2 Module manifest requirements (lines 1309-1337)"
  - "PRD §12.1 Pre-publish checklist (lines 2727-2742)"
deliverables:
  - src/SlashOps/SlashOps.psd1 (update)
  - tests/Unit/Manifest.Tests.ps1
tags: [publish, manifest, gallery]
---

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
