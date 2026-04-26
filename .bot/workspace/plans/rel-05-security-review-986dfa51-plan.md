## Overview

Conduct a security review covering the safety pipeline, transcript redaction, policy floor, profile-install behaviour, model-call data flow, and provider auth handling. Document findings and remediations.

## Implementation steps

1. Walk PRD §6.7–§6.13 + §13 against the implementation.
2. Threat-model each tool category (local, document, mail, github, git, cloud).
3. Author `docs/SECURITY_REVIEW_v1.0.md` with findings + remediations.
4. File defects against tasks for any open issues.

## PRD references

- §16 — v1.0 scope.
- §13 — security and privacy.

## Acceptance criteria

- Review document complete.
- All open issues either resolved or accepted with rationale.

## Notes / risks

- Engage an external reviewer if budget allows; document the reviewer's identity and date.

