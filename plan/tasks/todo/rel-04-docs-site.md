---
id: rel-04
title: Full docs site
version: v1.0
group: release
subgroup: docs-site
sequence: 4
depends_on: [doc-01, doc-02, doc-03, doc-04, doc-05, doc-06, doc-07, doc-08]
status: todo
tdd_first: false
prd_refs:
  - "PRD §16 v1.0 full docs site (line 2954)"
deliverables:
  - docs/_config.yml (or equivalent)
  - .github/workflows/docs.yml
tags: [v1.0, docs, site]
---

## Overview

Publish the `docs/` tree as a docs site (GitHub Pages or similar). Auto-build on every push to `main`. Side-bar mirrors the docs tree from PRD §10.1.

## Implementation steps

1. Choose Jekyll / MkDocs / Docusaurus; default to MkDocs Material for simplicity.
2. Author config.
3. Add a docs-build workflow.

## PRD references

- §16 — v1.0 scope.

## Acceptance criteria

- Site builds.
- All docs reachable.

## Notes / risks

- Decide whether the PRD itself ships in the docs site; if yes, redact internal-only sections first.
