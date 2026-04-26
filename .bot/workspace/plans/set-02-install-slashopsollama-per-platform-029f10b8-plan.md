## Overview

Install Ollama using platform package managers when available, never silently. On Windows: `winget install Ollama.Ollama`. On macOS: `brew install --cask ollama`. On Linux: display the official `curl | sh` command and require explicit confirmation; never auto-run remote scripts.

## TDD test list

- Already-installed → no-op with diagnostic.
- Missing `winget` on Windows → display official URL, do not auto-download.
- Missing `brew` on macOS → display official URL.
- Linux always requires explicit confirmation before showing the install.sh command and never executes it.
- `SLASHOPS_NONINTERACTIVE = 1` blocks all install paths.

## Implementation steps

1. Author `Public/Install-SlashOpsOllama.ps1` branching on platform.
2. Author `Private/Setup/Install-Ollama.ps1` for shared helpers (e.g., package-manager detection).
3. Tests mock `Get-Command winget` / `brew` and `$IsLinux`.

## PRD references

- §8.5 — platform-specific behaviour.
- §13.3 — remote execution policy: never `curl | sh` automatically.

## Acceptance criteria

- TDD tests pass.
- Cmdlet exported.
- No silent installs.

## Notes / risks

- Copy/paste UX: print the exact command in a copyable card so the user can run it themselves.

