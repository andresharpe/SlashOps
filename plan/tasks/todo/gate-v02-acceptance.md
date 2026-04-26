---
id: gate-v02
title: v0.2 acceptance gate
version: v0.2
group: gate
subgroup: acceptance
sequence: 999
depends_on: [gate-v01, tr-01, tr-02, tr-03, tr-04, tr-05, tr-06, tr-07, tr-08, tr-09, tr-10, tr-11, lt-01, lt-02, lt-03, lt-04, lt-05, lt-06, lt-07, lt-08, lt-09, lt-10, cfg2-01, cfg2-02, cfg2-03, cfg2-04, ui2-01, ui2-02, ui2-03]
status: todo
tdd_first: false
prd_refs:
  - "PRD §15.2 v0.2 local tool runtime acceptance (lines 2864-2877)"
deliverables:
  - docs/RELEASE_NOTES_v0.2.md
tags: [gate, acceptance, v0.2]
---

## Overview

Checklist gate that closes the v0.2 milestone. Verify all 11 acceptance criteria from PRD §15.2 against the running implementation.

## Acceptance criteria (PRD §15.2)

1. Intent classifier distinguishes `shell_command`, `file_search`, `document_text_search`, `document_summary`, `document_conversion`.
2. Planner can return multi-step registered tool plans.
3. Tool registry loads built-in manifests and refuses unknown tools.
4. `/x find the quote that I downloaded today` runs as read-only local file/document search.
5. `/ summarize this doc` resolves explicit paths, pipeline input, last result, latest downloaded document.
6. Document summarization chunks large files and produces a final summary.
7. Markdown conversion uses Pandoc only when available and generates dependency guidance when missing.
8. Tool outputs are represented as structured observations.
9. Agent loop respects max steps, max tool calls, mutation pause rules.
10. Config includes `agent`, `toolRegistry`, `documents`, `privacy` sections.
11. Pester tests cover tool registry, document resolution, local tools, observations, agent loop.

## Implementation steps

1. Walk every criterion against the running tree.
2. File defects.
3. Write `docs/RELEASE_NOTES_v0.2.md`.
4. Tag `v0.2.0`.

## Notes / risks

- v0.2 is the largest milestone surface-area-wise; budget for iteration.
