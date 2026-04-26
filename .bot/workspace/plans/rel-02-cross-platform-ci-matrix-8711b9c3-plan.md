## Overview

GitHub Actions workflow running unit tests, lint, manifest test on Windows, macOS, and Ubuntu against PowerShell 7.x. Integration tests are gated on `SLASHOPS_RUN_INTEGRATION` and run nightly only.

## Implementation steps

1. Author `.github/workflows/ci.yml` with matrix `os: [windows-latest, macos-latest, ubuntu-latest]`.
2. Use `pwsh -File ./build/prepublish.ps1` as the single entry point.
3. Optional nightly integration job triggered on schedule.

## PRD references

- §16 — v1.0 scope.

## Acceptance criteria

- CI green on all three platforms.

## Notes / risks

- macOS runners are slower; budget for that in test timeouts.

