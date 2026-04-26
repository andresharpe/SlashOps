## Overview

Apply blocked/risky/benign regex patterns from policy to the generated command string. Return findings as a structured list of `{Pattern, Class, Match}`. The classifier later combines these with AST + path + tool checks (saf-06).

## TDD test list

- `Invoke-Expression` matches blocked.
- `iex` matches blocked.
- `curl ... | sh/bash/pwsh/powershell/iex` matches blocked.
- `-EncodedCommand` matches blocked.
- `Format-Volume` matches blocked.
- `Start-Process -Verb RunAs` matches blocked.
- `Remove-Item` matches risky.
- `Move-Item ... *` matches risky.
- `Copy-Item ... -Force` matches risky.
- `git push --force` matches risky.
- `Get-ChildItem` does not match any blocked/risky patterns.
- `pandoc input -o output` does not match.

## Implementation steps

1. Author `Private/Safety/Test-StaticSafety.ps1` taking `(CommandText, Policy)` and returning findings list.
2. Compile each policy regex once per call.
3. Tests cover every PRD §6.8 pattern.

## PRD references

- §6.8 — full pattern list.
- §9.6 — regex policy structure.
- §11.3 — required tests.

## Acceptance criteria

- All TDD bullets pass.
- Function returns findings as objects, not strings.

## Notes / risks

- Regex is the cheapest first defence; AST (saf-02) catches obfuscation. Both must agree before benign-write classification.

