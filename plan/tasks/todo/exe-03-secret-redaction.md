---
id: exe-03
title: Secret redaction in transcript and logs
version: v0.1
group: execution
subgroup: redaction
sequence: 3
depends_on: [exe-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §13.2 Secret redaction (lines 2782-2793)"
  - "PRD §6.14 logging.redactSecrets (lines 1758-1766)"
deliverables:
  - src/SlashOps/Private/Execution/Hide-SecretsInText.ps1
  - tests/Unit/Execution.Redaction.Tests.ps1
tags: [execution, redaction, secrets, privacy]
---

## Overview

Apply redaction patterns from §13.2 to any text written to history or run logs: API keys, tokens, passwords, bearer tokens, AWS keys, GitHub tokens, Azure tokens, private key blocks, connection strings. Redaction happens before write, never after.

## TDD test list

- AWS access key (`AKIA[0-9A-Z]{16}`) redacted to `<REDACTED:aws-key>`.
- GitHub token (`gh[pous]_[A-Za-z0-9]{36,}`) redacted.
- Bearer tokens in `Authorization: Bearer ...` redacted.
- `-----BEGIN PRIVATE KEY-----` block redacted.
- Connection strings with `Password=` redacted.
- Plain text without secrets passes through unchanged.

## Implementation steps

1. Author `Private/Execution/Hide-SecretsInText.ps1` applying compiled regex patterns.
2. Wire into `Write-Transcript` (exe-02) and run-log writers (exe-01) before disk write.
3. Tests cover every TDD bullet.

## PRD references

- §13.2 — required pattern categories.
- §9.4 — `logging.redactSecrets` toggle.

## Acceptance criteria

- TDD tests pass.
- Patterns compile.

## Notes / risks

- Regex-based redaction is best-effort; document this in `docs/SAFETY.md` so users do not assume it is complete.
