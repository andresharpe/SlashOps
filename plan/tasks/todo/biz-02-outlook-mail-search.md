---
id: biz-02
title: outlook.mail.search tool
version: v0.3
group: business
subgroup: outlook
sequence: 2
depends_on: [biz-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
  - "PRD §11.3 Outlook tools mocked tests (lines 2654-2662)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Invoke-OutlookMailSearch.ps1
  - src/SlashOps/ToolManifests/outlook.mail.search.json
  - tests/Unit/Tools.Outlook.MailSearch.Tests.ps1
tags: [v0.3, outlook, search, read-only]
---

## Overview

Search mail via the resolved provider. Read-only; fast-mode eligible if `outlook.allowSearchFastMode = true`. Search results show sender, subject, received time, folder, snippet — full body never logged by default.

## TDD test list

- Disabled by default (`outlook.enabled = false`).
- Enabled + Graph → search via Graph (mocked).
- Enabled + M365 CLI → search via CLI (mocked).
- Returns ranked list with sender / subject / received / folder / snippet.
- Body not logged.
- Provider auth failure → workflow stops.

## Implementation steps

1. Author the tool function dispatching to provider.
2. Author manifest.
3. Tests mock both providers.

## PRD references

- §7.8 — tool list.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- Render results via `ui2-02 Write-SlashOpsSearchResults`.
