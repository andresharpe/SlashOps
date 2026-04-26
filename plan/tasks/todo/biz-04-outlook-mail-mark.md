---
id: biz-04
title: outlook.mail.mark tool
version: v0.3
group: business
subgroup: outlook
sequence: 4
depends_on: [biz-01, saf-08]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
  - "PRD §7.9 email_mutation requires confirmation (lines 1102-1110)"
  - "PRD §11.3 Outlook mark/move test (lines 2657-2658)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Invoke-OutlookMailMark.ps1
  - src/SlashOps/ToolManifests/outlook.mail.mark.json
  - tests/Unit/Tools.Outlook.MailMark.Tests.ps1
tags: [v0.3, outlook, mark, mutation]
---

## Overview

Flag, categorize, or mark-read a selected message. Always requires explicit confirmation. Never runs in `/x` (per safety floor).

## TDD test list

- Disabled by default.
- Enabled + confirmation `EXECUTE` → mutates (mocked).
- Without confirmation → refuses.
- Refuses in `/x` regardless of policy.
- Manifest passes validation with `default_risk: risky-write`, `requires_confirmation: true`, `supports_fast_mode: false`.

## Implementation steps

1. Author the tool function.
2. Author manifest.
3. Tests cover every TDD bullet.

## PRD references

- §7.8 — tool list.
- §7.9 — confirmation rules.
- §11.3 — required test.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Show the selected message before mutation per §7.9.
