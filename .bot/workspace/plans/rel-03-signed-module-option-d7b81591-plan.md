## Overview

Add an optional code-signing step to the publish pipeline. Document how to use it. Signing is opt-in; unsigned releases continue for community contributors.

## Implementation steps

1. Author `build/sign.ps1` using `Set-AuthenticodeSignature` on Windows; document macOS / Linux signing path (or note unsupported).
2. Author `docs/SIGNING.md` explaining cert acquisition and use.
3. Update `pub-04` to call signing when configured.

## PRD references

- §16 — v1.0 scope.

## Acceptance criteria

- Signing step runs end-to-end with a test cert.

## Notes / risks

- Cert renewal is operational; set a calendar reminder before expiry.

