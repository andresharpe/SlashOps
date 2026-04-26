## Overview

Fetch a selected message's metadata and (optionally) body. Body access requires explicit user opt-in per `outlook.logBody` and `privacy.sendEmailBodyToModel`.

## TDD test list

- Returns metadata for an existing message.
- Body returned only when policy allows.
- Body not logged by default.
- Manifest passes validation.

## Implementation steps

1. Author the tool function.
2. Author manifest.
3. Tests cover every TDD bullet.

## PRD references

- §7.8 — tool list.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Body retrieval is the highest-risk read; audit-log every access.

