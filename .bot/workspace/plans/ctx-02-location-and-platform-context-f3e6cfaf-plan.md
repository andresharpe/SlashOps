## Overview

Provide working directory, home directory, downloads directory, OS family, and PowerShell version. `Resolve-DownloadsPath` handles platform differences: Windows uses the registry-known `Downloads` shell folder, macOS uses `~/Downloads`, Linux uses XDG `XDG_DOWNLOAD_DIR` if set, otherwise `~/Downloads`.

## TDD test list

- `current_directory` matches `$PWD`.
- `home_directory` matches `$HOME`.
- `downloads_directory` resolves on Windows / macOS / Linux.
- `os` reports a simple family string (`Windows`, `macOS`, `Linux`).
- `platform` matches `$IsWindows` / `$IsMacOS` / `$IsLinux`.
- `powershell_version` matches `$PSVersionTable.PSVersion`.
- `Resolve-DownloadsPath` is mockable for tests.

## Implementation steps

1. Author `Private/Context/Get-LocationContext.ps1` returning the documented fields.
2. Author `Private/Context/Resolve-DownloadsPath.ps1` with platform branches and XDG fallback.
3. Tests use `Mock` to override per-platform branches.

## PRD references

- §6.3 — required fields including `current_directory`, `home_directory`, `downloads_directory`, `os`, `platform`, `powershell_version`.

## Acceptance criteria

- All TDD bullets pass.
- Function works without elevated privileges.

## Notes / risks

- On Windows, prefer `[Environment]::GetFolderPath` only as fallback — the registry-known folder is the authoritative location and respects user redirection. Use `[Environment]::GetFolderPath('UserProfile') + '\Downloads'` only when nothing better is available.

