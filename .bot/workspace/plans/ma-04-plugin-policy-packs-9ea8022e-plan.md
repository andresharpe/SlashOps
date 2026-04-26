## Overview

Allow third-party policy packs (signed JSON files) that add stricter rules — extra blocked patterns, additional protected roots, additional confirmation tokens. Packs can never weaken the safety floor.

## TDD test list

- Pack loads from configured path.
- Pack adds blocked patterns.
- Pack cannot weaken safety floor (rejected).
- Pack signature verification (when enabled).
- Multiple packs merge additively.

## Implementation steps

1. Author `Resolve-PolicyPack.ps1` to load and merge packs into effective policy.
2. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Defer signature verification design until v1.0; v0.4 supports unsigned packs with a clear warning.

