---
id: tr-09
title: Observation conversion and compression
version: v0.2
group: tool-runtime
subgroup: observations
sequence: 9
depends_on: [tr-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.13 Observation handling (lines 1192-1209)"
  - "PRD §11.3 Observation tests (line 2624)"
deliverables:
  - src/SlashOps/Private/Agent/ConvertTo-Observation.ps1
  - src/SlashOps/Private/Agent/Compress-Observation.ps1
  - tests/Unit/Agent.Observation.Tests.ps1
tags: [v0.2, agent, observations, structure]
---

## Overview

Convert tool outputs into structured observations per §7.13. Large outputs are summarized or truncated with a user-visible note. Raw stdout is not sent back to the model when a structured object is available.

## TDD test list

- Observation includes `step_id`, `tool`, `success`, `risk`, `items`, `summary`, `redactions_applied`.
- Large output is truncated with a marker visible to humans.
- Structured tool output is preferred over raw stdout.
- Redacted secrets recorded in `redactions_applied`.

## Implementation steps

1. Author the converter and compressor.
2. Tests cover every TDD bullet.

## PRD references

- §7.13 — observation schema.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Compression must be lossy in a deterministic way; document the algorithm.
