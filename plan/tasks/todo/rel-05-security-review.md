---
id: rel-05
title: Security review
version: v1.0
group: release
subgroup: security
sequence: 5
depends_on: [saf-07, exe-03, ma-04]
status: todo
tdd_first: false
prd_refs:
  - "PRD §16 v1.0 security review completed (line 2955)"
  - "PRD §13 Security and privacy (lines 2775-2816)"
deliverables:
  - docs/SECURITY_REVIEW_v1.0.md
tags: [v1.0, security, review]
---

## Overview

Conduct a security review covering the safety pipeline, transcript redaction, policy floor, profile-install behaviour, model-call data flow, and provider auth handling. Document findings and remediations.

## Implementation steps

1. Walk PRD §6.7–§6.13 + §13 against the implementation.
2. Threat-model each tool category (local, document, mail, github, git, cloud).
3. Author `docs/SECURITY_REVIEW_v1.0.md` with findings + remediations.
4. File defects against tasks for any open issues.

## PRD references

- §16 — v1.0 scope.
- §13 — security and privacy.

## Acceptance criteria

- Review document complete.
- All open issues either resolved or accepted with rationale.

## Notes / risks

- Engage an external reviewer if budget allows; document the reviewer's identity and date.
