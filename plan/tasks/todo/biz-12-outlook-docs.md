---
id: biz-12
title: Outlook setup and privacy docs
version: v0.3
group: business
subgroup: docs
sequence: 12
depends_on: [biz-11]
status: todo
tdd_first: false
prd_refs:
  - "PRD §15.3 acceptance criterion 10 (line 2892)"
  - "PRD §10.1 docs/OUTLOOK.md (line 2433)"
deliverables:
  - docs/OUTLOOK.md
tags: [v0.3, docs, outlook]
---

## Overview

Document the Outlook provider abstraction, Graph app-registration flow, M365 CLI fallback, the privacy model (what is logged, what is sent to the model), and worked examples for search / mark / draft.

## Implementation steps

1. Sections: provider preference, Graph setup (app registration / scopes), M365 CLI install / login, privacy defaults, fast-mode policy, examples.
2. Cross-link from `README.md` and `docs/CONFIGURATION.md`.

## PRD references

- §15.3 — acceptance criterion 10 requires docs.
- §10.1 — docs path.

## Acceptance criteria

- File exists and is content-complete.
- Cross-links resolve.

## Notes / risks

- Graph scopes are easy to over-grant; recommend the minimum scopes for read-only and explicit added scopes for mutations.
