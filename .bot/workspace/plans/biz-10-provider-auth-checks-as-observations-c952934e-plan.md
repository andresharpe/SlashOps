## Overview

Auth checks for Outlook / Graph / GitHub providers must surface as structured observations, never auto-trigger interactive auth. The agent loop pauses and instructs the user to authenticate manually (per §7.12).

## TDD test list

- Auth failure produces `auth_required` observation.
- Workflow stops on auth-required observation.
- Auth success produces no observation noise.
- Function never invokes interactive `Connect-*` cmdlets.

## Implementation steps

1. Author `Test-OutlookAuth.ps1` invoking the provider's "whoami" / `gh auth status` equivalent.
2. Tests mock the provider call.

## PRD references

- §7.9 — email flow auth.
- §11.3 — required test.
- §15.3 — acceptance criterion.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Document that automated auth (silent token grants) is out of scope for SlashOps; it remains a user concern.

