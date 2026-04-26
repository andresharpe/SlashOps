## Overview

Search local files by root, extension list, modified-on-or-after, name fragment. Read-only; fast-mode eligible. Used by document search workflows and direct shell-like prompts.

## TDD test list

- Resolves `~/Downloads` correctly.
- Filters by today using timezone context (per §7.11).
- Ranks by recency and keyword match.
- Returns structured rows with `Name`, `LastWriteTime`, `Length`, `FullName`.
- Refuses to search outside safe roots (delegates to path policy).
- Manifest passes `Test-SlashOpsToolManifest`.

## Implementation steps

1. Author `Private/Tools/Local/Invoke-LocalFilesSearch.ps1`.
2. Author the manifest with `default_risk: read-only`, `supports_fast_mode: true`.
3. Tests cover every TDD bullet.

## PRD references

- §7.7 — tool list.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- Use `Get-ChildItem -File -Recurse:$false` by default; recurse only on explicit input.

