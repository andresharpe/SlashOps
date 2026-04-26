---
id: ctx-05
title: ConvertTo-PromptContext composer
version: v0.1
group: context
subgroup: composer
sequence: 5
depends_on: [ctx-01, ctx-02, ctx-03, ctx-04, cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.3 Environment context (lines 501-528)"
  - "PRD §9.4 context section (lines 1733-1745)"
deliverables:
  - src/SlashOps/Public/ConvertTo-SlashOpsPromptContext.ps1
  - tests/Unit/Context.Composer.Tests.ps1
tags: [context, composer, prompt, json]
---

## Overview

Compose the JSON object the planner receives from individual context providers (time, location, tool inventory, git). Honour `context.*` toggles from the effective config and enforce `context.maxContextBytes`. Produce the exact JSON shape from PRD §6.3 plus `mode` and `policy_version` fields.

## TDD test list

- Output includes every field listed in §6.3 when all toggles are on.
- Setting `context.includeAvailableTools = false` omits the tools array.
- Setting `context.includePolicySummary = false` omits the policy summary.
- Output respects `context.maxContextBytes` — over-budget context is trimmed (oldest tool entries first) with a `truncated = true` marker.
- `mode` field reflects the prefix (`/`, `//`, `/x`, `/!`, `/?`).
- Composer is pure: same inputs → same JSON.

## Implementation steps

1. Author `Public/ConvertTo-SlashOpsPromptContext.ps1` taking `(Mode, EffectiveConfig)` and gathering from each `Get-*Context`.
2. Apply truncation strategy when over budget; record what was trimmed.
3. Tests cover every toggle and the truncation path.

## PRD references

- §6.3 — full payload schema.
- §9.4 — `context.*` toggles and `maxContextBytes`.

## Acceptance criteria

- TDD tests pass.
- Over-budget input produces a stable trimmed output.
- Public command exported.

## Notes / risks

- Truncation order matters: tools list first, then git context, then optional fields. Keep mode + datetime + cwd inviolate.
