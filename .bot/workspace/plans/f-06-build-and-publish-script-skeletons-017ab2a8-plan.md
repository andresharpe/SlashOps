## Overview

Create skeletons for `build/build.ps1` and `build/publish.ps1`. The skeletons orchestrate test → lint → manifest test, but do not yet publish; final publish logic lives in `pub-03` and `pub-04`. Establishing the entry points now lets CI (`rel-02`) and the gate tasks call them without further plumbing.

## TDD test list

- `pwsh -File ./build/build.ps1` runs `test.ps1`, `lint.ps1`, then `Test-ModuleManifest` and exits 0 on success.
- `pwsh -File ./build/build.ps1 -SkipTests` skips tests but still lints + tests manifest.
- `pwsh -File ./build/publish.ps1 -WhatIf` prints planned actions and exits 0 without publishing.

## Implementation steps

1. Author `build/build.ps1` with parameters `-SkipTests` and `-SkipLint`. Sequence: tests → lint → `Test-ModuleManifest ./src/SlashOps/SlashOps.psd1`.
2. Author `build/publish.ps1` with parameters `-Repository` (default `PSGallery`), `-WhatIf`, `-Force`. Skeleton must guard against publishing with a dirty git tree unless `-Force`.
3. Both scripts must accept `-Verbose` and surface clear failure messages.

## PRD references

- §11.5 — canonical commands the scripts wrap.
- §12.2 — local PSRepository smoke test (full implementation in `pub-03`).
- §12.3 — Gallery publish requirements: API key from env, `-WhatIf` support, version display.

## Acceptance criteria

- Both scripts run end-to-end on a clean tree.
- `-WhatIf` on publish does not invoke `Publish-Module`.
- Dirty-tree guard works.
- Scripts emit a final pass/fail line for CI consumption.

## Notes / risks

- API key handling stays out of these skeletons; `pub-04` adds the SecretManagement-or-env hook.

