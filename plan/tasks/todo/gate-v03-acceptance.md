---
id: gate-v03
title: v0.3 acceptance gate
version: v0.3
group: gate
subgroup: acceptance
sequence: 999
depends_on: [gate-v02, biz-01, biz-02, biz-03, biz-04, biz-05, biz-06, biz-07, biz-08, biz-09, biz-10, biz-11, biz-12]
status: todo
tdd_first: false
prd_refs:
  - "PRD §15.3 v0.3 Outlook/business connector acceptance (lines 2879-2892)"
deliverables:
  - docs/RELEASE_NOTES_v0.3.md
tags: [gate, acceptance, v0.3]
---

## Overview

Checklist gate that closes the v0.3 milestone. Verify all 10 acceptance criteria from PRD §15.3.

## Acceptance criteria (PRD §15.3)

1. Outlook tooling is disabled by default.
2. User can explicitly configure an Outlook / Microsoft 365 provider.
3. Email search is read-only and may run in `/x` if policy allows.
4. Email mark / move / categorize requires explicit confirmation.
5. Email send is blocked or future-only.
6. Email search result UI shows ranked candidates.
7. Email body is not logged by default.
8. Mocked Pester tests cover all Outlook workflows.
9. Provider auth failures stop workflow safely.
10. Documentation explains Graph / Microsoft 365 CLI setup and privacy model.

## Implementation steps

1. Walk every criterion.
2. File defects.
3. Write `docs/RELEASE_NOTES_v0.3.md`.
4. Tag `v0.3.0`.

## Notes / risks

- Privacy is the critical concern; double-check redaction pipelines for email content.
