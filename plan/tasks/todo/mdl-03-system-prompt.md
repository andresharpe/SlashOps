---
id: mdl-03
title: Generation system prompt assembly
version: v0.1
group: model
subgroup: prompts
sequence: 3
depends_on: [ctx-05]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.6 Model system prompt (lines 585-610)"
  - "PRD §7.15 Tool prompting rules (lines 1235-1257)"
deliverables:
  - src/SlashOps/Private/Model/New-SystemPrompt.ps1
  - tests/Unit/Model.SystemPrompt.Tests.ps1
tags: [model, prompts, system, generation]
---

## Overview

Assemble the system prompt fed to Ollama. v0.1 uses the §6.6 baseline (PowerShell 7 only, no aliases, no Markdown, bounded operations, relative-time rules). v0.2+ extends the prompt with tool-registry awareness via §7.15.

## TDD test list

- Output starts with the §6.6 baseline rules verbatim.
- Output appends the prompt context JSON.
- Output forbids Markdown fences and prose outside JSON.
- Output includes alias-free instruction.
- Length stays under a configured ceiling (`context.maxContextBytes`).

## Implementation steps

1. Author `Private/Model/New-SystemPrompt.ps1` taking `(Context, Mode, Toolset = @())`. v0.1 ignores `Toolset`; v0.2 reuses this same function with the tool registry summary appended.
2. Tests assert the baseline string is present and the context JSON is embedded.

## PRD references

- §6.6 — baseline rules.
- §7.15 — tool-aware prompt extensions for v0.2.

## Acceptance criteria

- TDD tests pass.
- Output deterministic for fixed inputs.

## Notes / risks

- Keep the baseline rules in a `data` block so they are easy to diff and review.
