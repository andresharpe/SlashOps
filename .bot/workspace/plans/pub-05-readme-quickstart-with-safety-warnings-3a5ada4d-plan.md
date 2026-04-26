## Overview

Replace the placeholder README from `f-01` with installation, quickstart, prefix table, safety warnings, and three example flows (read-only `/x`, benign-write `/x`, blocked refusal). Cross-link `docs/SAFETY.md`, `docs/CONFIGURATION.md`.

## Implementation steps

1. Write installation block: `Install-Module SlashOps -Scope CurrentUser`.
2. Write quickstart: `Initialize-SlashOps`, then a sample `/x` invocation.
3. Document the prefix table (mirrors §5.1).
4. Add the safety warnings panel: local-only by default, fail-closed, `/x` is bounded.
5. Three example flows.
6. Link to `docs/SAFETY.md`, `docs/CONFIGURATION.md`, `docs/AGENT_RUNTIME.md`.

## PRD references

- §12.1 — README must include installation, quickstart, safety, examples.
- §15.1 #16 — v0.1 acceptance.

## Acceptance criteria

- README sections present.
- Examples runnable.
- Safety warnings are above-the-fold.

## Notes / risks

- Keep README under ~300 lines; deeper material lives in `docs/`.

