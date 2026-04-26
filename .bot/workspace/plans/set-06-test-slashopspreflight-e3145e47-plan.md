## Overview

Run the §8.9 preflight checklist: PowerShell version, manifest, FxConsole, config / policy readability, effective merge, history path, Ollama executable, Ollama server, default model, JSON-capable model, AST parser, alias install (if requested), tool inventory. Output is structured (`Passed`, `Checks`, `MissingRequired`, `MissingOptional`, `Remediation`) per §8.9.

## TDD test list

- All checks passing → `Passed = $true`.
- Missing Ollama → `Passed = $false` with remediation pointing to `Install-SlashOpsOllama`.
- Missing model → remediation pointing to `Install-SlashOpsModel`.
- Missing optional tool (e.g. pandoc) → entry in `MissingOptional`, not `MissingRequired`.
- Output is JSON-serialisable.

## Implementation steps

1. Author `Public/Test-SlashOpsPreflight.ps1` chaining individual checks.
2. Tests mock each check.

## PRD references

- §8.9 — full check list.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Render the result via `Write-SlashOpsPreflight` (ui-02), not `Write-Host`.

