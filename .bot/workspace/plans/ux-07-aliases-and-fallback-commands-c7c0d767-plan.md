## Overview

Define the alias set used by the profile block: `/`, `//`, `/x`, `/!`, `/?`. PowerShell does not always allow non-identifier aliases — provide named fallback functions `slash`, `slashx`, `slashq`, `slashgen` that the profile installs unconditionally so users always have a working entry point.

## TDD test list

- Aliases for the five prefixes register where supported.
- Fallback functions `slash`, `slashx`, `slashq`, `slashgen` always register.
- Fallback functions delegate to the matching `Invoke-SlashOps*` cmdlet.
- Alias registration is idempotent.

## Implementation steps

1. Author `Private/UX/Set-DefaultAliases.ps1` issuing `Set-Alias` and registering fallback functions.
2. Tests assert both aliases and fallbacks resolve.

## PRD references

- §5.1 — fallback names.
- §8.8 — profile block content.
- §17 Q6 — alias install opt-in.

## Acceptance criteria

- TDD tests pass.
- Aliases load idempotently.

## Notes / risks

- `/?` collides with PowerShell's built-in help shortcut on some hosts; document a workaround if `Set-Alias '/?'` fails on a given host.

