---
id: mdl-02
title: Invoke-OllamaChat (chat completions)
version: v0.1
group: model
subgroup: chat
sequence: 2
depends_on: [mdl-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §3.2 Ollama integration (lines 129-148)"
  - "PRD §6.5 Model request contract (lines 550-583)"
deliverables:
  - src/SlashOps/Private/Model/Invoke-OllamaChat.ps1
  - tests/Unit/Model.Chat.Tests.ps1
tags: [model, ollama, chat, json-mode]
---

## Overview

Issue chat-completion requests against `/v1/chat/completions` with configurable model, system prompt, user messages, temperature, top_p, timeout, and JSON-mode toggle. Surface response content as a single string for parsers.

## TDD test list

- Sends `Authorization: Bearer ollama` header (per §3.2 OpenAI-compatible client).
- Sends `Content-Type: application/json`.
- Body includes `model`, `messages`, `temperature`, `response_format` when JSON mode on.
- Timeout per `model.timeoutSeconds`.
- Retry once on transient failure; otherwise returns structured error.
- Returns `Choices[0].Message.Content` as a string.

## Implementation steps

1. Author `Private/Model/Invoke-OllamaChat.ps1` using `Invoke-RestMethod -TimeoutSec`.
2. Mock the network call in tests.
3. Surface non-2xx responses with a structured error including status + body.

## PRD references

- §3.2 — OpenAI-compatible endpoint, `api_key='ollama'`.
- §6.5 — JSON mode required, no Markdown output.

## Acceptance criteria

- TDD tests pass.
- Retry behaviour proven.

## Notes / risks

- Some Ollama versions ignore `response_format`; do not fail if the field is unsupported — the parse + repair layer (mdl-04) handles output discipline.
