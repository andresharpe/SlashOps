---
id: ui-06
title: Transcript and run-log location panel
version: v0.1
group: ui
subgroup: panels
sequence: 6
depends_on: [ui-01]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.15 transcript location panel (line 853)"
deliverables:
  - src/SlashOps/Private/UI/Write-SlashOpsTranscriptPanel.ps1
  - tests/Unit/UI.Transcript.Tests.ps1
tags: [ui, transcript, panel, fxconsole]
---

## Overview

After every executed command, render a small panel showing the transcript path, run id, and per-run log directory so users can investigate quickly.

## TDD test list

- Panel renders transcript path verbatim.
- Panel renders run id and run log directory.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsTranscriptPanel.ps1` calling `Write-FxPanel`.
2. Tests stub FxConsole.

## PRD references

- §6.15 — transcript location panel.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Make paths clickable in supported terminals via OSC-8 hyperlinks if FxConsole already supports it; otherwise plain text.
