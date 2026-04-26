---
id: doc-05
title: docs/OUTLOOK.md (cross-cutting hook to biz-12)
version: v0.3
group: docs
subgroup: outlook
sequence: 5
depends_on: [biz-12]
status: todo
tdd_first: false
prd_refs:
  - "PRD §7.9 Outlook/Microsoft 365 handling (lines 1091-1127)"
deliverables:
  - docs/OUTLOOK.md
tags: [docs, outlook, business]
---

## Overview

This task is the cross-cutting placeholder for the Outlook docs. The actual content lives in `biz-12`; this entry exists so the docs index in `doc-08` and `rel-04` references a stable doc id.

## Implementation steps

1. Move `docs/OUTLOOK.md` into the docs site nav once `biz-12` is `done`.
2. Cross-link from `doc-04 AGENT_RUNTIME.md`.

## Acceptance criteria

- File present (delivered by `biz-12`).
- Cross-links resolved.

## Notes / risks

- Avoid duplicating content here; `biz-12` is canonical.
