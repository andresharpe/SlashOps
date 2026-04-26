## Overview

Produce a calendar event payload (title, time, attendees, body) without creating the event. Creation requires confirmation in a separate `calendar.create_event` tool (out of scope for v0.3 first cut).

## TDD test list

- Returns structured payload with required fields.
- Never creates the event.
- Time fields use ISO 8601.
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

- Defer attendee resolution (email lookup) to a follow-up task.

