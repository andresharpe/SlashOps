---
id: saf-05
title: AI security review (second model call)
version: v0.1
group: safety
subgroup: review
sequence: 5
depends_on: [mdl-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.11 AI security review (lines 738-761)"
deliverables:
  - src/SlashOps/Public/Invoke-SlashOpsSecurityReview.ps1
  - tests/Unit/Safety.AiReview.Tests.ps1
tags: [safety, ai, review, second-pass]
---

## Overview

Optional AI security review via a second Ollama call (default same model). Required for `/!` strict mode, `/` for risky-write/unknown classifications, `/x` benign-write unless policy disables it for speed, and any command touching cloud, git mutation, packages, sync, or remote URLs. AI review can raise risk but cannot lower a static block.

## TDD test list

- Returns object matching §6.11 schema (`risk`, `summary`, `reasons`, `safer_alternative`).
- Static-blocked command remains blocked even if AI review says `risk = low`.
- AI review `risk = high` raises a static-benign result.
- AI review failure prevents `/x` execution for write operations (§6.11 last bullet).
- Cache hit by command hash + policy version + review model (§9.11).

## Implementation steps

1. Author `Public/Invoke-SlashOpsSecurityReview.ps1` issuing a chat call with the review-system prompt and the candidate command.
2. Apply the cannot-lower rule downstream of static block (saf-06 enforces).
3. Tests mock `Invoke-OllamaChat` and assert raise/cannot-lower behaviour.

## PRD references

- §6.11 — full schema and rules.
- §9.11 — cache key.

## Acceptance criteria

- TDD tests pass.
- Function exported.

## Notes / risks

- Document the review system prompt in `docs/SAFETY.md` (doc-01) so the heuristic is auditable.
