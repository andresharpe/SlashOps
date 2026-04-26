---
id: tr-07
title: Tool-call argument resolution and step linking
version: v0.2
group: tool-runtime
subgroup: planner
sequence: 7
depends_on: [tr-06]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.4 Planner response contract example (lines 928-989)"
deliverables:
  - src/SlashOps/Private/Agent/Resolve-ToolCall.ps1
  - tests/Unit/Tools.CallResolution.Tests.ps1
tags: [v0.2, planner, resolution, steps]
---

## Overview

Map planner step arguments and inter-step references (`input_from_step`) into concrete invocation parameters. Validate types against the tool's `input_schema`. Refuse plans whose references don't resolve.

## TDD test list

- Plain arg dictionary maps to tool parameters.
- `input_from_step: 1` resolves to the previous step's output.
- Type mismatch (string where int expected) fails.
- Unresolvable reference fails.
- Required input missing fails.

## Implementation steps

1. Author `Private/Agent/Resolve-ToolCall.ps1`.
2. Tests cover every TDD bullet.

## PRD references

- §7.4 — example shows `input_from_step` semantics.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Document the `input_from_step` contract in `docs/AGENT_RUNTIME.md`.
