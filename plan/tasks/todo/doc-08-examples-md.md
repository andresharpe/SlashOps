---
id: doc-08
title: docs/EXAMPLES.md and examples/*.ps1
version: all
group: docs
subgroup: examples
sequence: 8
depends_on: [ux-02, lt-06, biz-02]
status: todo
tdd_first: false
prd_refs:
  - "PRD §10.1 examples/ tree (lines 2417-2422)"
deliverables:
  - docs/EXAMPLES.md
  - examples/basic.ps1
  - examples/document-conversion.ps1
  - examples/document-summary.ps1
  - examples/local-document-search.ps1
  - examples/outlook-search-mock.ps1
  - examples/git-workflow.ps1
tags: [docs, examples]
---

## Overview

Author the examples directory listed in PRD §10.1 plus a `docs/EXAMPLES.md` index. Each example script is runnable and includes a comment block explaining what it demonstrates.

## Implementation steps

1. Author each `.ps1` example end-to-end.
2. Author the index in `docs/EXAMPLES.md`.

## Acceptance criteria

- All example scripts run on a configured machine.
- Index links them clearly.

## Notes / risks

- The Outlook example must use mocks so it runs without a tenant.
