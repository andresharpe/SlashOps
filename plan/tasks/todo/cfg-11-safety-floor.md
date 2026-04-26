---
id: cfg-11
title: Enforce safety policy floor against project / CLI overrides
version: v0.1
group: config
subgroup: safety
sequence: 11
depends_on: [cfg-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.7 Project config rules (lines 2022-2030)"
  - "PRD §9.12 Config and safety interaction (lines 2178-2188)"
deliverables:
  - src/SlashOps/Private/Config/Test-SafetyFloor.ps1
  - tests/Unit/Config.SafetyFloor.Tests.ps1
tags: [config, safety, policy, floor]
---

## Overview

After merging, validate that the effective configuration does not violate the hard safety floor: remote script execution, privilege elevation, encoded commands, broad protected-root deletion, cloud mutation in `/x`, and package install in `/x` cannot be enabled. Project config can only relax `protectedRoots` when user policy sets `allowProjectPolicyRelaxation = true`.

## TDD test list

- Effective config with `policy.blockedBehavior.blockRemoteScriptExecution = false` is rejected.
- Project config attempting to remove `~/.ssh` from `protectedRoots` is rejected when user policy disallows relaxation.
- Project config can add safe write roots inside the project (per §9.7).
- Project config can add stricter regex patterns (per §9.7).
- CLI override cannot disable `blockedBehavior.blockCloudMutationInFastMode`.
- Floor violation surfaces as a structured error, not a silent override.

## Implementation steps

1. Author `Private/Config/Test-SafetyFloor.ps1` taking `(Effective, Sources)` and returning `Passed/Errors/Warnings`.
2. Wire it into `Get-EffectiveConfig` post-merge — failure prevents callers from using the merged config.
3. Tests cover every TDD bullet.

## PRD references

- §9.7 — project config rules.
- §9.12 — explicit safety floor list.

## Acceptance criteria

- All TDD bullets pass.
- Floor violations propagate as structured errors.
- `Get-EffectiveConfig` refuses to return a config that violates the floor.

## Notes / risks

- This task is the last line of defence — keep the rule list tight and append-only.
- Document which rules are floor (immutable) vs configurable in `docs/SAFETY.md` (doc-01).
