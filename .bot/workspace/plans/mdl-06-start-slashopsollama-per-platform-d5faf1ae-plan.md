## Overview

Start the Ollama service if it is installed but not running. On Windows, prefer launching the desktop app or `Start-Service`. On macOS, `open -a Ollama`. On Linux, `systemctl start ollama` if systemd is available, else display manual instructions. Never auto-install — the caller must run `Install-SlashOpsOllama` first.

## TDD test list

- When Ollama is already reachable, returns `AlreadyRunning = $true` without launching anything.
- When not reachable but installed, attempts platform-appropriate start (mocked).
- When not installed, returns guidance to call `Install-SlashOpsOllama` and does not attempt start.
- Honours `SLASHOPS_NONINTERACTIVE = 1` by failing without prompting.

## Implementation steps

1. Author `Public/Start-SlashOpsOllama.ps1` branching on `$IsWindows`/`$IsMacOS`/`$IsLinux`.
2. Mock platform branches in tests via thin private helpers.

## PRD references

- §8.5 — platform-specific install + start behaviour.
- §6.1 — public function name.

## Acceptance criteria

- TDD tests pass.
- No auto-install.
- Cmdlet exported.

## Notes / risks

- Linux without systemd needs explicit manual instructions; do not assume `service` either.

