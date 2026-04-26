---
id: biz-07
title: calendar.draft_event tool
version: v0.3
group: business
subgroup: calendar
sequence: 7
depends_on: [biz-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Invoke-CalendarDraftEvent.ps1
  - src/SlashOps/ToolManifests/calendar.draft_event.json
  - tests/Unit/Tools.Calendar.DraftEvent.Tests.ps1
tags: [v0.3, calendar, draft, event]
---

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
