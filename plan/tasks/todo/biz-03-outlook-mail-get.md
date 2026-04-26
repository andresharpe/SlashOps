---
id: biz-03
title: outlook.mail.get tool
version: v0.3
group: business
subgroup: outlook
sequence: 3
depends_on: [biz-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Invoke-OutlookMailGet.ps1
  - src/SlashOps/ToolManifests/outlook.mail.get.json
  - tests/Unit/Tools.Outlook.MailGet.Tests.ps1
tags: [v0.3, outlook, get, read-only]
---

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
