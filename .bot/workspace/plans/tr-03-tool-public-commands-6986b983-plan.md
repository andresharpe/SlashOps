## Overview

Expose registry diagnostics and direct tool invocation via public cmdlets. `Register-SlashOpsTool` is reserved for the built-in registration path in v0.2 (user / project tools are out of scope until v1.0 per §17 Q9).

## TDD test list

- `Get-SlashOpsTool` returns the loaded registry.
- `Get-SlashOpsTool -Name local.files.search` returns one tool.
- `Test-SlashOpsTool` returns dependency / platform check result.
- `Invoke-SlashOpsTool` runs a registered tool with provided args and returns its output.
- `Invoke-SlashOpsTool` refuses unknown / disabled tools.
- `Register-SlashOpsTool` rejects user-supplied manifests when `allowUserTools = false`.

## Implementation steps

1. Author each cmdlet thin-wrapping the registry helpers.
2. Tests cover every TDD bullet.

## PRD references

- §6.1 — public function names.

## Acceptance criteria

- TDD tests pass.
- Cmdlets exported.

## Notes / risks

- Direct `Invoke-SlashOpsTool` is for advanced users; the planner is the main consumer.

