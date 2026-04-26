---
id: pub-03
title: Local PSRepository smoke test
version: v0.1
group: publish
subgroup: scripts
sequence: 3
depends_on: [pub-02]
status: todo
tdd_first: false
prd_refs:
  - "PRD §12.2 Local publish test (lines 2742-2754)"
deliverables:
  - build/publish-local.ps1
  - tests/Integration/PublishLocal.Tests.ps1
tags: [publish, smoke, local]
---

## Overview

Use a local PSRepository under `.local-psrepo/` to validate `Publish-Module` produces an installable artefact. After publish, install it into a temp scope and import to confirm cmdlets resolve.

## TDD test list

- `.local-psrepo/` is created if missing.
- `Publish-Module` succeeds.
- `Find-Module SlashOps -Repository SlashOpsLocal` returns the published version.
- `Install-Module ... -Scope CurrentUser -Force` succeeds.
- `Import-Module SlashOps` after install resolves all public cmdlets.

## Implementation steps

1. Author `build/publish-local.ps1` per §12.2.
2. Integration test runs the full cycle.

## PRD references

- §12.2 — exact command sequence.

## Acceptance criteria

- Cycle completes end-to-end.
- Imported module exposes the expected cmdlets.

## Notes / risks

- Clean up `.local-psrepo/` between runs to avoid version-pinning surprises.
