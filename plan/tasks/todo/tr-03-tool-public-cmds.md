---
id: tr-03
title: Tool public commands
version: v0.2
group: tool-runtime
subgroup: public
sequence: 3
depends_on: [tr-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.1 Agent and registered tools (lines 463-476)"
  - "PRD §7.6 Tool registry (lines 1019-1055)"
deliverables:
  - src/SlashOps/Public/Get-SlashOpsTool.ps1
  - src/SlashOps/Public/Test-SlashOpsTool.ps1
  - src/SlashOps/Public/Invoke-SlashOpsTool.ps1
  - src/SlashOps/Public/Register-SlashOpsTool.ps1
  - tests/Unit/Tools.PublicCmds.Tests.ps1
tags: [v0.2, tools, public-api]
---

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
