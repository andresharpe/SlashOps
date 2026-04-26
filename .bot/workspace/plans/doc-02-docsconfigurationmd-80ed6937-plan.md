## Overview

Reference for the entire configuration subsystem: file locations, precedence, env vars, schemas, public commands, migration, safety floor, examples.

## Implementation steps

1. Sections: principles, files / paths, precedence, schemas, public commands, migration, safety floor, examples.
2. Provide three concrete examples: per-user defaults, project override, enterprise lock-down.

## Acceptance criteria

- File present, content-complete.

## Notes / risks

- Keep schema tables aligned with `New-DefaultConfig.ps1` — drift is a common bug source.

