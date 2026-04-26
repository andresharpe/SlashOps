## Overview

Stand up the Pester 5+ test harness so every subsequent task can land tests first. The harness must work cross-platform, never write outside `TestDrive:` or system temp, and skip integration tests by default (require `SLASHOPS_RUN_INTEGRATION=1`).

## TDD test list

- `pwsh -File ./build/test.ps1` exits 0 with zero tests defined.
- `Invoke-Pester -Path ./tests/Unit` finds and runs zero tests cleanly.
- Setting `$env:SLASHOPS_RUN_INTEGRATION = '1'` enables `-Tag Integration` runs; otherwise they are excluded.
- Mock helpers from `tests/_helpers/MockHelpers.ps1` are dot-sourceable from any test file.

## Implementation steps

1. Author `tests/PesterConfig.ps1` returning a Pester `Configuration` object with: `Run.Path = ./tests/Unit`, `Output.Verbosity = 'Detailed'`, `Run.PassThru = $true`, `TestResult.Enabled = $true`, `TestResult.OutputPath = ./tests/_results/unit.xml`.
2. Author `build/test.ps1` that imports Pester, applies the config, optionally appends Integration path when `$env:SLASHOPS_RUN_INTEGRATION -eq '1'`, and exits non-zero on failures.
3. Author `tests/_helpers/MockHelpers.ps1` with utility mocks: `Mock-OllamaChat`, `Mock-GetCommand`, `Mock-FileSystemUnderTestDrive`. Each must be a parameterised function callable from `BeforeAll`.
4. Add `.gitkeep` to `tests/Unit/` and `tests/Integration/`.

## PRD references

- §3.5: required Pester features (`Describe`, `Context`, `It`, `BeforeAll`, `Mock`, `Should -Invoke`).
- §11.2: tests must avoid writing outside `TestDrive:` or temp directories.
- §11.4: integration tests gated by `SLASHOPS_RUN_INTEGRATION = '1'`.

## Acceptance criteria

- Harness runs zero tests cleanly on Windows + Linux.
- Integration tests excluded by default.
- Mock helpers are reusable from any unit test file.
- Output XML written to `tests/_results/unit.xml` (gitignored).

## Notes / risks

- Pester v5 syntax differs sharply from v4 — pin the minimum version in the config.
- Avoid `Set-StrictMode -Version Latest` globally; opt-in per test file.

