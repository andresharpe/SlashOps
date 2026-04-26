---
id: ma-06
title: SecretManagement integration
version: v0.4
group: mature-agent
subgroup: secrets
sequence: 6
depends_on: [cfg-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v0.4 SecretManagement integration (line 2945)"
  - "PRD §12.3 API key handling (line 2768)"
deliverables:
  - src/SlashOps/Private/Config/Get-SecretFromVault.ps1
  - tests/Unit/Config.Secrets.Tests.ps1
tags: [v0.4, secrets, secretmanagement, vault]
---

## Overview

Resolve API keys (PSGallery key, future remote-provider keys) from `Microsoft.PowerShell.SecretManagement` when available, falling back to environment variables. Never log secret values.

## TDD test list

- SecretManagement available + secret present → returns secret.
- SecretManagement missing → falls back to env var.
- Secret never logged (via redaction pipeline).

## Implementation steps

1. Author `Get-SecretFromVault.ps1` with the dual lookup.
2. Update `pub-04` to use this helper.
3. Tests mock SecretManagement.

## PRD references

- §16 — v0.4 scope.
- §12.3 — API key handling.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- SecretManagement requires a vault; document at least one supported vault in `docs/CONFIGURATION.md`.
