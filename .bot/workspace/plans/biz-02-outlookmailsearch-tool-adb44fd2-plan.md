## Overview

Search mail via the resolved provider. Read-only; fast-mode eligible if `outlook.allowSearchFastMode = true`. Search results show sender, subject, received time, folder, snippet — full body never logged by default.

## TDD test list

- Disabled by default (`outlook.enabled = false`).
- Enabled + Graph → search via Graph (mocked).
- Enabled + M365 CLI → search via CLI (mocked).
- Returns ranked list with sender / subject / received / folder / snippet.
- Body not logged.
- Provider auth failure → workflow stops.

## Implementation steps

1. Author the tool function dispatching to provider.
2. Author manifest.
3. Tests mock both providers.

## PRD references

- §7.8 — tool list.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Manifest valid.

## Notes / risks

- Render results via `ui2-02 Write-SlashOpsSearchResults`.

