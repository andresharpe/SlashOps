---
id: rel-06
title: Stable PSGallery release (1.0.0)
version: v1.0
group: release
subgroup: gallery
sequence: 6
depends_on: [rel-01, rel-02, rel-03, rel-04, rel-05]
status: todo
tdd_first: false
prd_refs:
  - "PRD §16 v1.0 PowerShell Gallery stable release (line 2956)"
deliverables:
  - CHANGELOG.md (update)
  - docs/RELEASE_NOTES_v1.0.md
tags: [v1.0, release, gallery]
---

## Overview

Bump `ModuleVersion` to `1.0.0`, write release notes, run the prepublish chain, and publish to PSGallery.

## Implementation steps

1. Bump version in `SlashOps.psd1`.
2. Update `CHANGELOG.md`.
3. Author `docs/RELEASE_NOTES_v1.0.md`.
4. Run `pub-02` then `pub-04`.

## PRD references

- §16 — v1.0 scope.

## Acceptance criteria

- Module installable from PSGallery as `1.0.0`.
- Tag `v1.0.0` pushed.

## Notes / risks

- This is the irreversible-ish step; ensure all gates passed first.
