## Overview

GitHub tools wrapping `gh` CLI: search PRs, search issues, comment on PR (with confirmation). Comment requires explicit confirmation per `github_mutation` intent.

## TDD test list

- PR search returns ranked PRs.
- Issue search returns ranked issues.
- PR comment requires `EXECUTE` confirmation.
- Missing `gh` → dependency observation.
- All manifests pass validation.

## Implementation steps

1. Author each tool wrapping `gh` invocations.
2. Author each manifest.
3. Tests mock `gh` invocations.

## PRD references

- §7.8 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- `gh` auth: surface `gh auth status` as a precondition observation.

