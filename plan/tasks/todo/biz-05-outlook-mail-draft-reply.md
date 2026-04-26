---
id: biz-05
title: outlook.mail.draft_reply tool
version: v0.3
group: business
subgroup: outlook
sequence: 5
depends_on: [biz-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.8 Optional v0.3 business/dev tools (lines 1076-1090)"
  - "PRD §7.9 email_draft handling (lines 1108-1110)"
deliverables:
  - src/SlashOps/Private/Tools/Outlook/Invoke-OutlookDraftReply.ps1
  - src/SlashOps/ToolManifests/outlook.mail.draft_reply.json
  - tests/Unit/Tools.Outlook.DraftReply.Tests.ps1
tags: [v0.3, outlook, draft, reply]
---

## Overview

Draft a reply to a selected message. Saves as draft only — never sends. Email send is explicitly out of scope until a future high-risk confirmed flow.

## TDD test list

- Disabled by default.
- Enabled → creates draft (mocked) and returns draft id.
- Never sends regardless of input.
- Manifest passes validation.

## Implementation steps

1. Author the tool function.
2. Author manifest with `default_risk: benign-write`, `supports_fast_mode: false`.
3. Tests cover every TDD bullet.

## PRD references

- §7.8 — tool list.
- §7.9 — draft-only rule.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- The draft body comes from a model summary; ensure privacy section gates whether the source email body was sent to the model.
