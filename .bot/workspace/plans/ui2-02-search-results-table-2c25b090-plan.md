## Overview

Render ranked search results — used by file search, document search, mail search. Columns are tool-specific (file: name / size / modified / path; mail: sender / subject / received / folder / snippet) but the helper accepts a column spec so each tool can configure its own.

## TDD test list

- Renders rows with the supplied column spec.
- Renders rank column when ranking metadata present.
- Truncates long snippets to a configurable width.
- Honours `ui.useFxConsole = false` fallback.

## Implementation steps

1. Author `Private/UI/Write-SlashOpsSearchResults.ps1` calling `Write-FxTable`.
2. Tests stub FxConsole.

## PRD references

- §7.16 — search results UI.
- §7.11 — local document search ranking.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Avoid rendering full snippets; truncate to keep terminals readable.

