## Overview

In-process memory of tool results so re-plans don't re-fetch identical data within the same session. Memory is process-local and ephemeral; never persisted.

## TDD test list

- Identical tool call within session reuses prior result.
- Different args produce a new entry.
- Memory cleared on process exit.
- Configurable max entries.

## Implementation steps

1. Author memory store keyed by `(tool, hash(args))`.
2. Tests cover every TDD bullet.

## PRD references

- §16 — v0.4 scope.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid retaining sensitive content in memory; apply same redaction rules as transcripts.

