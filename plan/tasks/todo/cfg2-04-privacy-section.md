---
id: cfg2-04
title: Add privacy config section
version: v0.2
group: config2
subgroup: privacy
sequence: 4
depends_on: [cfg-08, exe-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.5 privacy config (lines 1840-1849)"
  - "PRD §7.17 Tool privacy (lines 1271-1281)"
deliverables:
  - src/SlashOps/Private/Config/New-DefaultConfig.ps1 (update)
  - tests/Unit/Config.Privacy.Tests.ps1
tags: [v0.2, config, privacy]
---

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
