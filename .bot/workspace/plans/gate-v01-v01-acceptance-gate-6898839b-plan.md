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

