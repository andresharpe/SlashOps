## Overview

Extend default config with `privacy` block: `logContent`, `logDocumentText`, `logEmailBody`, `sendDocumentTextToModel`, `sendEmailBodyToModel`, `allowRemoteProviderForSensitiveContent`, `redactBeforeModel`. Defaults bias toward minimal logging and local-only model calls.

## TDD test list

- Defaults match §9.5.
- `logEmailBody` defaults to `false`.
- `sendEmailBodyToModel` defaults to `false`.
- `allowRemoteProviderForSensitiveContent` defaults to `false`.
- Wire `redactBeforeModel` into the system-prompt assembler (mdl-03) and tool-output sender.

## Implementation steps

1. Update `New-DefaultConfig.ps1`.
2. Tests cover defaults.
3. Hook into mdl-03 / observation sender.

## PRD references

- §9.5 — privacy schema.
- §7.17 — privacy rules.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Document the rule that this section can only be relaxed via user policy, never project policy.

