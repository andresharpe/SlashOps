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

