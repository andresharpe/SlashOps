---
id: mdl-01
title: Ollama health check
version: v0.1
group: model
subgroup: health
sequence: 1
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §3.2 Ollama integration (lines 129-148)"
  - "PRD §10.3 Caching requirements (lines 2478-2484)"
deliverables:
  - src/SlashOps/Private/Model/Test-Ollama.ps1
  - src/SlashOps/Public/Test-SlashOpsOllama.ps1
  - tests/Unit/Model.Health.Tests.ps1
tags: [model, ollama, health, cache]
---

## Overview

Check Ollama reachability via `GET /v1/models`. Cache the result for `cache.ollamaHealthSeconds` (default 300) so preflight and command pipelines can call it freely. Surface a structured result so callers can drive remediation.

## TDD test list

- 200 OK from `/v1/models` returns `Reachable = $true` with model list.
- Connection refused returns `Reachable = $false` with reason.
- Timeout returns `Reachable = $false` with timeout reason.
- Cached result is reused within TTL.
- Cache bypass via `-NoCache`.

## Implementation steps

1. Author `Private/Model/Test-Ollama.ps1` issuing `Invoke-RestMethod` against the configured `modelsEndpoint`.
2. Cache layer keyed by endpoint + model.
3. Public `Test-SlashOpsOllama` thin wrapper.

## PRD references

- §3.2 — endpoints + OpenAI-compatible API.
- §10.3 — Ollama health cache 5 minutes default.

## Acceptance criteria

- TDD tests pass.
- Cache TTL respected.
- Cmdlet exported.

## Notes / risks

- Mock `Invoke-RestMethod` in tests; do not hit a real Ollama server.
