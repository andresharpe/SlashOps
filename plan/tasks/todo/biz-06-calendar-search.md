---
id: biz-06
title: calendar.search tool
version: v0.3
group: business
subgroup: calendar
sequence: 6
depends_on: [biz-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Invoke-CalendarSearch.ps1
  - src/SlashOps/ToolManifests/calendar.search.json
  - tests/Unit/Tools.Calendar.Search.Tests.ps1
tags: [v0.3, calendar, search, read-only]
---

## Overview

Search calendar items via the resolved provider. Read-only; fast-mode eligible.

## TDD test list

- Disabled by default.
- Enabled → returns events between given dates (mocked).
- Honours timezone context.
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

- Recurring events: return expanded instances within the requested range, not the master event.
