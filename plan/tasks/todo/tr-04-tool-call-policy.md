---
id: tr-04
title: Tool-call and agent-plan policy
version: v0.2
group: tool-runtime
subgroup: policy
sequence: 4
depends_on: [tr-02, saf-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.14 Safety matrix for tools (lines 1212-1234)"
  - "PRD §11.3 Tool policy tests (lines 2590-2596)"
deliverables:
  - src/SlashOps/Private/Safety/Test-ToolCallPolicy.ps1
  - src/SlashOps/Private/Safety/Test-AgentPlanPolicy.ps1
  - tests/Unit/Tools.PolicyCheck.Tests.ps1
tags: [v0.2, tools, policy, safety]
---

## Overview

Validate planner-emitted tool calls and full plans against policy. Rules: tool must be registered, tool must be enabled, mutation tools require confirmation, fast-mode eligibility comes from the manifest (`supports_fast_mode`), email-send is forbidden, cloud / package mutations are forbidden in `/x`.

## TDD test list

- Plan calling unregistered tool fails.
- Plan calling disabled tool fails.
- Plan with email-send step fails.
- Plan with email-mark step requires confirmation.
- `/x` plan with cloud-mutation step fails.
- `/x` plan with package-install step fails.
- Read-only plan in `/x` passes.

## Implementation steps

1. Author both private helpers.
2. Tests cover §7.14 matrix exhaustively.

## PRD references

- §7.14 — safety matrix.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Mutation pause (tr-08) and confirmation UX (saf-08) are downstream from this; this task only decides allowed / not-allowed.
