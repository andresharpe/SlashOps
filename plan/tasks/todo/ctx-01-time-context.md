---
id: ctx-01
title: Time and timezone context
version: v0.1
group: context
subgroup: time
sequence: 1
depends_on: [f-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.3 Environment context (lines 501-528)"
  - "PRD §6.6 Model system prompt — relative-time rules (lines 603-610)"
deliverables:
  - src/SlashOps/Private/Context/Get-TimeContext.ps1
  - tests/Unit/Context.Time.Tests.ps1
tags: [context, time, timezone, dates]
---

## Overview

Produce time fields that the planner uses to resolve relative phrases such as "today", "yesterday", "this morning", "last week", "recently". Output includes ISO local datetime with offset, IANA timezone, and pre-computed boundary timestamps for each phrase so the planner does not invent its own date math.

## TDD test list

- Output includes `current_datetime` (ISO 8601 with offset).
- Output includes `timezone` (IANA, e.g. `Europe/Zurich`).
- Output includes `today_start` / `today_end` covering local calendar day.
- Output includes `yesterday_start` / `yesterday_end`.
- Output includes `this_morning_start` / `this_morning_end` (00:00–12:00 local).
- Output includes `last_week_start` (7 days back, midnight local).
- All datetimes serialise as strings, not `DateTime` objects, so JSON is stable.
- Output is deterministic for a fixed clock injection.

## Implementation steps

1. Author `Private/Context/Get-TimeContext.ps1` taking optional `[datetime]$Now = (Get-Date)` to enable test-time injection.
2. Use `[TimeZoneInfo]::Local.Id` for the IANA-or-Windows zone id, prefer `Get-TimeZone` on Windows.
3. Tests use a fixed injected `$Now` to assert exact boundary timestamps.

## PRD references

- §6.3 includes `current_datetime` and `timezone` in the context payload.
- §6.6 lists relative-time resolution rules the model relies on.

## Acceptance criteria

- All TDD bullets pass on Windows + Linux.
- Output is JSON-serialisable.

## Notes / risks

- Windows reports timezone IDs differently than Linux (Windows: `W. Europe Standard Time`; Linux: `Europe/Zurich`). Document both and pass through whatever `Get-TimeZone` returns.
