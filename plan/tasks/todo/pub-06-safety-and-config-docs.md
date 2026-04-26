---
id: pub-06
title: SAFETY.md and CONFIGURATION.md docs
version: v0.1
group: publish
subgroup: docs
sequence: 6
depends_on: [saf-07, cfg-09]
status: todo
tdd_first: false
prd_refs:
  - "PRD §6 Functional requirements (lines 384-875)"
  - "PRD §9 Configuration (lines 1593-2214)"
  - "PRD §13 Security and privacy (lines 2775-2816)"
deliverables:
  - docs/SAFETY.md
  - docs/CONFIGURATION.md
tags: [publish, docs, safety, configuration]
---

## Overview

Author `docs/SAFETY.md` (the why and how of the safety pipeline: layered checks, classifications, modes, AI review, redaction) and `docs/CONFIGURATION.md` (config and policy schemas, precedence, env overrides, migration, safety floor).

## Implementation steps

1. SAFETY.md sections: principles, classification matrix, static + AST + path + tool checks, AI review, modes, secret redaction, enterprise compatibility, escalation guidance.
2. CONFIGURATION.md sections: file locations, precedence, env vars, schemas, public commands, migration, safety floor, examples.
3. Cross-link both back to the README and to PRD sections.

## PRD references

- §6 — pipeline.
- §9 — configuration.
- §13 — security and privacy.

## Acceptance criteria

- Both files exist and are content-complete.
- Cross-links resolve.

## Notes / risks

- These files are reviewed as part of the v0.1 acceptance gate; keep them accurate.
