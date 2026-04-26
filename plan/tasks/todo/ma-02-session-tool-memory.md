---
id: ma-02
title: Session tool-result memory
version: v0.4
group: mature-agent
subgroup: memory
sequence: 2
depends_on: [ma-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §16 v0.4 tool-result memory within a session (line 2941)"
deliverables:
  - src/SlashOps/Private/Agent/Get-SessionMemory.ps1
  - src/SlashOps/Private/Agent/Add-SessionMemory.ps1
  - tests/Unit/Agent.SessionMemory.Tests.ps1
tags: [v0.4, agent, memory, session]
---

## Overview

In-process memory of tool results so re-plans don't re-fetch identical data within the same session. Memory is process-local and ephemeral; never persisted.

## TDD test list

- Identical tool call within session reuses prior result.
- Different args produce a new entry.
- Memory cleared on process exit.
- Configurable max entries.

## Implementation steps

1. Author memory store keyed by `(tool, hash(args))`.
2. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid retaining sensitive content in memory; apply same redaction rules as transcripts.
