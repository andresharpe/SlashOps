---
id: ux-06
title: Invoke-SlashOpsExplain (/?) — explain only
version: v0.1
group: ux
subgroup: invoke
sequence: 6
depends_on: [ux-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §5.1 Prefixes (lines 273-291)"
deliverables:
  - src/SlashOps/Public/Invoke-SlashOpsExplain.ps1
  - tests/Unit/UX.InvokeExplain.Tests.ps1
tags: [ux, invoke, explain, prefix]
---

## Overview

`/?` prefix: generate a plan and ask the model for an explanation of what would happen, then display both. Never executes.

## TDD test list

- `/?` returns plan + explanation.
- Never invokes `Invoke-GeneratedCommand`.
- Explanation content rendered via FxConsole panel.

## Implementation steps

1. Author `Public/Invoke-SlashOpsExplain.ps1` with `Mode = '/?'`.
2. Reuse `Invoke-OllamaChat` with an explanation system prompt.
3. Tests assert both fields are present.

## PRD references

- §5.1 — explain-only behaviour.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- The explanation prompt should be terse — discourage the model from producing prose dumps.
