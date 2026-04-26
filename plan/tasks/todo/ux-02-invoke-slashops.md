---
id: ux-02
title: Invoke-SlashOps (/) — generate, scan, ask
version: v0.1
group: ux
subgroup: invoke
sequence: 2
depends_on: [mdl-05, saf-07, exe-01, ui-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §5.1 Prefixes (lines 273-291)"
  - "PRD §6.1 Core UX (lines 392-398)"
deliverables:
  - src/SlashOps/Public/Invoke-SlashOps.ps1
  - tests/Unit/UX.InvokeSlashOps.Tests.ps1
tags: [ux, invoke, normal-mode, prefix]
---

## Overview

The default `/` prefix entry point. Generates a command plan, runs the safety pipeline, displays the plan and risk via FxConsole, asks for confirmation per the gate decision, then executes (or refuses).

## TDD test list

- Mode `'/'` flows through context → plan → safety → gate.
- `read-only` class produces `ask` gate; on `y` confirmation, executes.
- `risky-write` class produces `ask-with-warning`; on `EXECUTE` token, executes.
- `blocked` class refuses execution.
- Transcript written for every attempt regardless of outcome.

## Implementation steps

1. Author `Public/Invoke-SlashOps.ps1` orchestrating the pipeline.
2. Tests mock context, model, safety, gate, exec, transcript.

## PRD references

- §5.1 — prefix table.
- §6.1 — public function name.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.

## Notes / risks

- Keep this function thin — orchestration only. All logic lives in the modules it calls.
