## Overview

Capture all remaining arguments after the prefix as the prompt text. Preserve quoted strings, normalise whitespace, handle empty input by displaying help in interactive mode and exiting non-zero in non-interactive mode.

## TDD test list

- `/x find files` captures `find files`.
- `/ "find files with spaces"` preserves the quoted string verbatim.
- Empty prompt in interactive mode shows help.
- Empty prompt in non-interactive mode exits non-zero.
- Prompt capture works under PowerShell 7+ on Windows / macOS / Linux / WSL.

## Implementation steps

1. Author `Private/UX/Get-PromptText.ps1` accepting `[string[]]$Tokens` from `ValueFromRemainingArguments`.
2. Public `Invoke-SlashOps*` cmdlets reuse this helper.
3. Tests cover every TDD bullet.

## PRD references

- §6.2 — capture pattern + acceptance criteria.

## Acceptance criteria

- TDD tests pass.
- Quoted strings preserved.

## Notes / risks

- PowerShell parameter parsing is finicky; use `[Parameter(ValueFromRemainingArguments = $true)] [string[]]$Prompt` exactly as documented.

