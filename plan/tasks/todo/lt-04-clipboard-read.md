---
id: lt-04
title: local.clipboard.read tool
version: v0.2
group: local-tools
subgroup: clipboard
sequence: 4
depends_on: [tr-03]
status: todo
tdd_first: true
prd_refs:
  - "PRD §7.7 Required v0.2 local tools (lines 1057-1073)"
  - "PRD §7.17 Tool privacy (lines 1271-1281)"
  - "PRD §17 Q12 (line 2972)"
deliverables:
  - src/SlashOps/Private/Tools/Local/Invoke-ClipboardRead.ps1
  - src/SlashOps/ToolManifests/local.clipboard.read.json
  - tests/Unit/Tools.Local.Clipboard.Tests.ps1
tags: [v0.2, tool, clipboard, privacy]
---

## Overview

Read clipboard text (or path) where supported. Disabled by default per §7.17 / §17 Q12; user must enable explicitly. Read-only; privacy-sensitive: never logs clipboard content.

## TDD test list

- Disabled by default → returns `disabled` observation.
- Enabled → reads clipboard via platform helper (mocked).
- Returns `text` (and `looks_like_path` boolean).
- Never logs clipboard content.
- Manifest passes validation.

## Implementation steps

1. Author the tool function using `Get-Clipboard` on Windows, `pbpaste` on macOS, `xclip` / `wl-paste` on Linux.
2. Author the manifest with `default_risk: read-only`, `requires_confirmation: true` for first use.
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.
- §7.17 — privacy controls.
- §17 Q12 — disabled by default.

## Acceptance criteria

- TDD tests pass.
- No logging of content.

## Notes / risks

- Linux clipboard tooling varies (X11 `xclip` vs Wayland `wl-paste`); detect at runtime.
