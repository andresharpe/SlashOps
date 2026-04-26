## Overview

Add PSScriptAnalyzer settings tuned for SlashOps. Treat all default rules as enabled, with explicit excludes documented inline (e.g. `PSAvoidUsingWriteHost` is acceptable in UI rendering paths if FxConsole requires it). Provide a build script wrapper so CI and pre-publish checks call the same entry point.

## TDD test list

- `pwsh -File ./build/lint.ps1` runs PSScriptAnalyzer with the settings file and exits 0 on a clean tree.
- Introducing a deliberate `Write-Host` violation in a non-UI file fails lint.
- `PSScriptAnalyzerSettings.psd1` parses as a valid PowerShell data file.

## Implementation steps

1. Author `PSScriptAnalyzerSettings.psd1` with `IncludeDefaultRules = $true`, `Severity = @('Error','Warning')`, `ExcludeRules = @()` initially. Document any additions inline with rationale.
2. Author `build/lint.ps1` that imports PSScriptAnalyzer, runs `Invoke-ScriptAnalyzer -Path ./src/SlashOps -Recurse -Settings ./PSScriptAnalyzerSettings.psd1`, prints findings, and exits non-zero on error severity.
3. Wire up `build/lint.ps1` to be callable standalone or from `pub-02-prepublish-checks`.

## PRD references

- §3.4 — PSScriptAnalyzer is required for Gallery best practice.
- §11.5 — `Invoke-ScriptAnalyzer -Path ./src/SlashOps -Recurse` is the canonical command.
- §12.1 — pre-publish step 2 requires no PSScriptAnalyzer errors.

## Acceptance criteria

- Settings file is valid.
- Lint script exits 0 on a clean tree.
- Lint script exits non-zero on a deliberate violation.

## Notes / risks

- Do not silence rules globally; prefer file-scoped suppression with `[Diagnostics.CodeAnalysis.SuppressMessageAttribute()]` and a comment explaining why.

