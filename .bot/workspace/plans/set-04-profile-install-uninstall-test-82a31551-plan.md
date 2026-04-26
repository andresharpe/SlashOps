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

