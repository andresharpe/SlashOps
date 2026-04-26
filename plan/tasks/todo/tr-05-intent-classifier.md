---
id: tr-05
title: Intent classifier with confidence
version: v0.2
group: tool-runtime
subgroup: intent
sequence: 5
depends_on: [mdl-04]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.5 Intent taxonomy (lines 991-1017)"
  - "PRD §9.5 agent.minimumIntentConfidence (line 1797)"
  - "PRD §11.3 Intent classifier tests (lines 2598-2607)"
deliverables:
  - src/SlashOps/Public/Resolve-SlashOpsIntent.ps1
  - src/SlashOps/Private/Agent/Resolve-Intent.ps1
  - tests/Unit/Intent.Classifier.Tests.ps1
tags: [v0.2, intent, classifier, agent]
---

## Overview

Use the model to classify each prompt into one of the §7.5 intents with a confidence score. Below `agent.minimumIntentConfidence`, downgrade execution mode to confirmation-required. `unknown` intent fails closed.

## TDD test list

- Direct command prompts classify as `shell_command`.
- Document summary prompts classify as `document_summary`.
- Quote / download prompts classify as `document_text_search`.
- Outlook search prompts classify as `email_search`.
- Outlook mark / move prompts classify as `email_mutation`.
- Confidence score returned in 0..1 range.
- Confidence below threshold downgrades mode.
- `unknown` intent never executes.

## Implementation steps

1. Author the classifier as a model call returning structured JSON `{intent, confidence, reasons}`.
2. Tests mock `Invoke-OllamaChat`.

## PRD references

- §7.5 — intent list.
- §9.5 — confidence threshold.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- The classifier prompt is critical; document it in `docs/AGENT_RUNTIME.md`.
