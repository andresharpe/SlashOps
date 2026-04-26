## Overview

Produce the default `policy.json` — safe write roots, protected roots, `neverFastExecute` list, `fastAllowedCommands` list, blocked / risky regex patterns, blocked-behavior toggles, and confirmation tokens — exactly as in PRD §9.6.

## TDD test list

- Default policy contains all sections required by §9.6.
- `schema_version` is `"1"`.
- `policy.protectedRoots` includes both `~` and `~/.ssh` plus the cross-platform list.
- All `blockedRegexPatterns` compile as valid .NET regex.
- All `riskyRegexPatterns` compile as valid .NET regex.
- `policy.allowProjectPolicyRelaxation` defaults to `false`.
- `policy.confirmation` tokens default to `EXECUTE`, `INSTALL`, `CLOUD`, `PULL`.

## Implementation steps

1. Author `Private/Config/New-DefaultPolicy.ps1` returning an `[ordered]` hashtable matching §9.6.
2. Pester tests verify presence of each list, regex compilation, and default token values.

## PRD references

- §9.6 — full schema.
- §9.12 — these defaults form the safety floor that user/project config cannot weaken.

## Acceptance criteria

- Default policy round-trips to JSON identically to §9.6.
- All regex patterns compile.
- Tests pass.

## Notes / risks

- Regex strings embed double escaping in JSON (`\\b`); ensure tests pull the parsed string and feed it directly to `[regex]::new`.
- Do not modify regex patterns — they are part of the safety contract documented in PRD.

