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

