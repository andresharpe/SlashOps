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

