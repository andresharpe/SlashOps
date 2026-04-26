---
id: set-03
title: Install-SlashOpsModel (pull with PULL token)
version: v0.1
group: setup
subgroup: model
sequence: 3
depends_on: [mdl-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §8.6 Model installation behavior (lines 1478-1496)"
deliverables:
  - src/SlashOps/Public/Install-SlashOpsModel.ps1
  - src/SlashOps/Public/Get-SlashOpsModel.ps1
  - src/SlashOps/Private/Setup/Install-Model.ps1
  - tests/Unit/Setup.Model.Tests.ps1
tags: [setup, model, ollama, pull]
---

## Overview

Pull a model via `ollama pull <name>` after explicit `PULL` token confirmation per §8.6 (covers the ~19 GB download warning for `qwen3-coder:30b`). Verify the model appears post-pull and run a small test prompt to confirm the model returns valid JSON.

## TDD test list

- Already-present model → no-op.
- Missing model + confirmation `PULL` → pulls (mocked).
- Missing model + wrong token → refuses.
- Post-pull verification calls model list (mocked).
- Test prompt verification asserts JSON-mode response.
- `SLASHOPS_NONINTERACTIVE = 1` requires `-AcceptDefaults`.

## Implementation steps

1. Author `Public/Install-SlashOpsModel.ps1` and `Get-SlashOpsModel.ps1`.
2. Tests mock `ollama` CLI and `Invoke-OllamaChat`.

## PRD references

- §8.6 — pull flow.

## Acceptance criteria

- TDD tests pass.
- Cmdlets exported.

## Notes / risks

- Document that the size in the prompt is approximate; pull the actual size from `ollama show` post-confirmation if cheap.
