## Overview

Render the generated command in a card, and the risk classification + reason in a parallel card. Dependency status table optional via `ui.showDependencyTable`.

## TDD test list

- Plan card includes the command text verbatim.
- Risk card includes class label and reason.
- Dependency table appears when configured to show.
- Cards honour `ui.theme`.

## Implementation steps

1. Author both helpers calling `Write-FxCard`.
2. Tests stub FxConsole.

## PRD references

- §6.15 — generated command card, risk summary card, dependency status table.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Long commands wrap awkwardly; document the recommended max width and rely on FxConsole to handle the wrap.

