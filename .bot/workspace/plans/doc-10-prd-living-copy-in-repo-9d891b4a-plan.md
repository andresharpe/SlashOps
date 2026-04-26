## Overview

The PRD copy created by `f-01` is the canonical living version. This task tracks updates: when the source PRD in `~/Downloads` changes, refresh `PRD.md` and record the changeset in the commit message and `CHANGELOG.md`.

## Implementation steps

1. After every source-PRD revision, copy the new file over `PRD.md`.
2. Record the version + date in `CHANGELOG.md`.
3. File task-level updates against any tasks whose `prd_refs` no longer match.

## Acceptance criteria

- `PRD.md` byte size matches the source on each refresh.

## Notes / risks

- A changed PRD section may invalidate existing `prd_refs` line ranges; budget time to update them.

