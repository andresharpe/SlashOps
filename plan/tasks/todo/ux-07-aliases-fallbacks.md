---
id: ux-07
title: Aliases and fallback commands
version: v0.1
group: ux
subgroup: aliases
sequence: 7
depends_on: [ux-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §5.1 fallback commands (lines 286-291)"
  - "PRD §8.8 profile alias block (lines 1532-1542)"
  - "PRD §17 Open question Q6 (line 2966)"
deliverables:
  - src/SlashOps/Private/UX/Set-DefaultAliases.ps1
  - tests/Unit/UX.Aliases.Tests.ps1
tags: [ux, aliases, fallback]
---

## Overview

Define the alias set used by the profile block: `/`, `//`, `/x`, `/!`, `/?`. PowerShell does not always allow non-identifier aliases — provide named fallback functions `slash`, `slashx`, `slashq`, `slashgen` that the profile installs unconditionally so users always have a working entry point.

## TDD test list

- Aliases for the five prefixes register where supported.
- Fallback functions `slash`, `slashx`, `slashq`, `slashgen` always register.
- Fallback functions delegate to the matching `Invoke-SlashOps*` cmdlet.
- Alias registration is idempotent.

## Implementation steps

1. Author `Private/UX/Set-DefaultAliases.ps1` issuing `Set-Alias` and registering fallback functions.
2. Tests assert both aliases and fallbacks resolve.

## PRD references

- §5.1 — fallback names.
- §8.8 — profile block content.
- §17 Q6 — alias install opt-in.

## Acceptance criteria

- TDD tests pass.
- Aliases load idempotently.

## Notes / risks

- `/?` collides with PowerShell's built-in help shortcut on some hosts; document a workaround if `Set-Alias '/?'` fails on a given host.
