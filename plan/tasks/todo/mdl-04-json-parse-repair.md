---
id: mdl-04
title: Strict JSON parsing with one repair attempt
version: v0.1
group: model
subgroup: parsing
sequence: 4
depends_on: [mdl-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.5 Model request contract — hard requirements (lines 575-583)"
  - "PRD §11.3 Model JSON tests (lines 2554-2562)"
deliverables:
  - src/SlashOps/Private/Model/Repair-ModelJson.ps1
  - tests/Unit/Model.Json.Tests.ps1
tags: [model, json, parse, repair]
---

## Overview

Parse model output as strict JSON. If parsing fails, perform exactly one repair attempt — invoke the model again with the malformed output and a "fix to valid JSON only" instruction. If the second attempt also fails, return a structured failure and refuse to execute.

## TDD test list

- Valid JSON parses without invoking the model.
- Markdown-fenced JSON is unwrapped or rejected (one repair attempt).
- Invalid JSON triggers exactly one repair attempt.
- Two failures → fail-closed result (`Passed = $false`).
- Missing required schema fields (`command` for v0.1) → fail-closed.
- Non-PowerShell shell content rejected.

## Implementation steps

1. Author `Private/Model/Repair-ModelJson.ps1` taking `(RawOutput, RepairFn)` where `RepairFn` is an injectable lambda that invokes `Invoke-OllamaChat` so tests can mock it.
2. Tests provide canned malformed strings and assert the repair path is hit at most once.

## PRD references

- §6.5 — JSON parse + one repair + fail-closed.
- §11.3 — Model JSON tests.

## Acceptance criteria

- All TDD tests pass.
- Repair attempts strictly limited to one.

## Notes / risks

- Be defensive about model output containing leading/trailing whitespace or BOM — strip before parsing, but do not strip aggressively (whitespace inside strings is valid JSON).
