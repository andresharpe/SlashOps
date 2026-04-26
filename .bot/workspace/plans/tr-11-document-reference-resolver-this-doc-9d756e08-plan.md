## Overview

Resolve "this doc" deterministically per §7.10 order: explicit path → pipeline input → last result → cwd single-doc → clipboard (if enabled) → most recent download → interactive choice → ask. Ambiguity surfaces as a structured `needs_clarification` observation, not a guess.

## TDD test list

- Explicit path wins.
- Pipeline input wins when no explicit path.
- Last result wins when no pipeline input.
- Single doc in cwd wins next.
- Clipboard read only when enabled.
- Latest downloaded doc as fallback.
- Multiple candidates → `needs_clarification`.

## Implementation steps

1. Author `Private/Agent/Resolve-DocumentReference.ps1` walking the resolution order.
2. Tests cover every TDD bullet using `TestDrive:`.

## PRD references

- §7.10 — resolution order.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Likely document extensions per §7.10 — keep the list authoritative in this file.

