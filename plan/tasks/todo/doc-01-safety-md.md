---
id: doc-01
title: docs/SAFETY.md
version: all
group: docs
subgroup: safety
sequence: 1
depends_on: [saf-07]
status: todo
tdd_first: false
prd_refs:
  - "PRD §6.7-§6.13 (lines 612-797)"
  - "PRD §13 Security and privacy (lines 2775-2816)"
deliverables:
  - docs/SAFETY.md
tags: [docs, safety]
---

## Overview

Document the safety subsystem end-to-end: principles, classification, static + AST + path + tool checks, AI review, modes, secret redaction, escalation. Pair with `pub-06`.

## Implementation steps

1. Sections: principles, classification matrix, layered checks, AI review, modes, redaction, enterprise compatibility, escalation.
2. Cross-link to `docs/CONFIGURATION.md` and PRD sections.

## Acceptance criteria

- File present, content-complete, cross-links resolve.

## Notes / risks

- Keep examples concrete; abstract advice is unhelpful.
