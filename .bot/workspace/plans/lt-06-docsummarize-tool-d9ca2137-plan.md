## Overview

Summarize a local document by chunking via `documents.chunkSizeChars` (default 12000) with `chunkOverlapChars` overlap, summarising each chunk via Ollama, then synthesising the chunk summaries into a final summary with citations / excerpts when `summarizeWithCitations = true`.

## TDD test list

- Small document produces a single-pass summary.
- Large document chunks per config.
- Final summary references chunks (citations).
- Never logs full document text by default (privacy section).
- Refuses documents above `documents.maxDocumentBytes`.
- Manifest passes validation.

## Implementation steps

1. Author chunker `Split-DocumentText.ps1`.
2. Author summariser orchestrator.
3. Author manifest.
4. Public `Invoke-SlashOpsDocumentSummary` thin wrapper.

## PRD references

- §7.7 — tool list.
- §7.10 — document resolution.
- §9.5 — chunking config.

## Acceptance criteria

- TDD tests pass.
- Citations present when configured.

## Notes / risks

- Local-only model; never send to a remote provider unless `privacy.allowRemoteProviderForSensitiveContent = true` (default false).

