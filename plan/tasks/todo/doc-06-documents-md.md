---
id: doc-06
title: docs/DOCUMENTS.md
version: v0.2
group: docs
subgroup: documents
sequence: 6
depends_on: [lt-06]
status: todo
tdd_first: false
prd_refs:
  - "PRD §7.10-§7.11 (lines 1129-1171)"
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
deliverables:
  - docs/DOCUMENTS.md
tags: [docs, documents, local-tools]
---

## Overview

Reference for document workflows: resolution order, local document search, summarization with chunking + citations, conversion via Pandoc, PDF inspection via Poppler.

## Implementation steps

1. Sections: resolution, search, extraction, summarization, conversion, PDF inspection, privacy.
2. Worked examples for each.

## Acceptance criteria

- File present, content-complete.

## Notes / risks

- Privacy section must call out that document text is sent to local Ollama; never to a remote provider unless explicit policy is set.
