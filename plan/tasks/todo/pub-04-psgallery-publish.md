---
id: pub-04
title: PSGallery publish wrapper
version: v0.1
group: publish
subgroup: scripts
sequence: 4
depends_on: [pub-03]
status: todo
tdd_first: false
prd_refs:
  - "PRD §12.3 Gallery publish (lines 2755-2772)"
deliverables:
  - build/publish.ps1 (final)
  - tests/Integration/PublishGallery.Tests.ps1
tags: [publish, psgallery, release]
---

## Overview

Final `build/publish.ps1` that publishes to PSGallery using `$env:PSGALLERY_API_KEY`. Refuses to publish a dirty tree unless `-Force`. Supports `-WhatIf`. Displays version + repository before invoking `Publish-Module`.

## TDD test list

- `-WhatIf` prints planned actions and does not call `Publish-Module`.
- Dirty tree without `-Force` aborts.
- Missing `PSGALLERY_API_KEY` aborts with remediation.
- Version + repository displayed before publish.

## Implementation steps

1. Replace the skeleton from `f-06` with the full implementation.
2. Integration test mocks `Publish-Module` to verify the surrounding logic.

## PRD references

- §12.3 — Gallery publish requirements.

## Acceptance criteria

- All TDD bullets pass.

## Notes / risks

- Never log the API key. Use `[SecureString]` or read directly from env at the call site.
