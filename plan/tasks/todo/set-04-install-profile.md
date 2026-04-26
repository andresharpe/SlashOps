---
id: set-04
title: Profile install / uninstall / test
version: v0.1
group: setup
subgroup: profile
sequence: 4
depends_on: [ux-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §8.8 Profile setup (lines 1518-1546)"
  - "PRD §11.3 Setup tests (lines 2685-2691)"
deliverables:
  - src/SlashOps/Public/Install-SlashOpsProfile.ps1
  - src/SlashOps/Public/Uninstall-SlashOpsProfile.ps1
  - src/SlashOps/Public/Test-SlashOpsProfile.ps1
  - src/SlashOps/Private/Setup/Install-Profile.ps1
  - tests/Unit/Setup.Profile.Tests.ps1
tags: [setup, profile, aliases]
---

## Overview

Manage the marker-delimited block in `$PROFILE.CurrentUserCurrentHost` that imports SlashOps and sets aliases. Idempotent install (no duplicates); clean uninstall (removes block, leaves rest of profile untouched); test reports presence + version.

## TDD test list

- Install adds the marker block to a clean profile.
- Install on a profile that already has the block is a no-op.
- Uninstall removes the block cleanly, leaving surrounding lines intact.
- Test returns `Present = $true` after install.
- Profile creation prompts confirmation when missing.

## Implementation steps

1. Author each public cmdlet thin-wrapping `Private/Setup/Install-Profile.ps1`.
2. Tests use `TestDrive:` to simulate `$PROFILE`.

## PRD references

- §8.8 — exact marker block content.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Markers idempotent.

## Notes / risks

- Use `# >>> SlashOps >>>` and `# <<< SlashOps <<<` exactly as documented; tooling parses these markers.
