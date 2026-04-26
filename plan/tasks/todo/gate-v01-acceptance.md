---
id: gate-v01
title: v0.1 acceptance gate
version: v0.1
group: gate
subgroup: acceptance
sequence: 999
depends_on: [f-01, f-02, f-03, f-04, f-05, f-06, cfg-01, cfg-02, cfg-03, cfg-04, cfg-05, cfg-06, cfg-07, cfg-08, cfg-09, cfg-10, cfg-11, ctx-01, ctx-02, ctx-03, ctx-04, ctx-05, mdl-01, mdl-02, mdl-03, mdl-04, mdl-05, mdl-06, saf-01, saf-02, saf-03, saf-04, saf-05, saf-06, saf-07, saf-08, exe-01, exe-02, exe-03, exe-04, exe-05, set-01, set-02, set-03, set-04, set-05, set-06, ux-01, ux-02, ux-03, ux-04, ux-05, ux-06, ux-07, ui-01, ui-02, ui-03, ui-04, ui-05, ui-06, pub-01, pub-05, pub-06]
status: todo
tdd_first: false
prd_refs:
  - "PRD §15.1 v0.1 preview acceptance (lines 2842-2862)"
deliverables:
  - docs/RELEASE_NOTES_v0.1.md
tags: [gate, acceptance, v0.1]
---

## Overview

Checklist gate that closes the v0.1 milestone. No code; verify all 16 acceptance criteria from PRD §15.1 against the implementation.

## Acceptance criteria (PRD §15.1)

1. Module installs locally with `Import-Module` on Windows, macOS, Linux.
2. Module manifest passes `Test-ModuleManifest`.
3. Unit tests cover all public functions.
4. Pester tests pass on at least two platforms before public publish.
5. `Initialize-SlashOps` creates config and runs preflight.
6. `Test-SlashOpsPreflight` accurately reports Ollama / model / tool status.
7. `/` can generate a command and ask before execution.
8. `//` generates only.
9. `/x` auto-executes read-only commands.
10. `/x` auto-executes bounded benign-write command when policy permits.
11. `/x` refuses destructive command.
12. Safety scan blocks remote script execution.
13. History is written to JSONL.
14. FxConsole renders setup / preflight / plan / risk / result output.
15. Gallery packaging scripts exist.
16. README includes clear safety warnings and examples.

## Implementation steps

1. Walk every criterion against the running tree.
2. File defects against specific tasks for any criterion that fails.
3. When all criteria pass, write `docs/RELEASE_NOTES_v0.1.md` summarising delivered scope.
4. Tag the repo `v0.1.0`.

## Notes / risks

- This task gates `pub-02..04` for the actual publish.
