---
id: exe-02
title: Write transcript (JSONL)
version: v0.1
group: execution
subgroup: transcript
sequence: 2
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.14 Execution transcript (lines 799-832)"
deliverables:
  - src/SlashOps/Private/Execution/Write-Transcript.ps1
  - src/SlashOps/Public/Write-SlashOpsTranscript.ps1
  - tests/Unit/Execution.Transcript.Tests.ps1
tags: [execution, transcript, jsonl, history]
---

## Overview

Append a JSONL record per execution attempt to `~/.slashops/history.jsonl`. Record schema follows §6.14 verbatim. Writes are append-only and atomic per line; concurrent writes from multiple processes are tolerated by using `[System.IO.File]::AppendAllText` with a short retry on lock contention.

## TDD test list

- Record matches §6.14 schema (timestamp, slashops_version, mode, cwd, prompt, etc.).
- Append-only: existing entries preserved.
- One JSON object per line, newline-terminated.
- File is created if missing.
- Path honours `logging.historyPath` configuration.

## Implementation steps

1. Author `Private/Execution/Write-Transcript.ps1` taking `(Record)` and serialising via `ConvertTo-Json -Depth 10 -Compress`.
2. Public `Write-SlashOpsTranscript` thin wrapper for diagnostics.
3. Tests use `TestDrive:`.

## PRD references

- §6.14 — full record schema.

## Acceptance criteria

- TDD tests pass.
- JSON parses line-by-line.

## Notes / risks

- Keep line size reasonable — large stdout/stderr stay in `runs/<id>/` files referenced by path, not embedded.
