## Overview

Merge configuration from six layers, lowest to highest precedence: module defaults → user config → user policy → project config → environment variables → CLI parameters. The merge produces an `effective config` object plus a parallel source-attribution map (which layer set each leaf value), so `Get-SlashOpsEffectiveConfig -Detailed` can show provenance.

## TDD test list

- Module defaults present when no other layer overrides.
- User config overrides defaults for matching keys only.
- User policy overrides user config for safety-related keys.
- Project config overrides user-layer values for keys it contains.
- Environment variables (`SLASHOPS_MODEL`, `SLASHOPS_ENDPOINT`, etc.) override file layers.
- CLI parameters override environment variables.
- Source attribution returns the highest-precedence layer for each leaf value.
- Project config cannot weaken `policy.protectedRoots` unless `policy.allowProjectPolicyRelaxation = true` (per §9.7 + cfg-11).
- Merging is deterministic: same inputs → same outputs.

## Implementation steps

1. Author `Private/Config/Merge-Config.ps1` taking layered hashtables and an explicit precedence array. Recursively deep-merge, with arrays replaced (not concatenated) unless the key path is on a documented "additive" allowlist.
2. Author `Private/Config/Get-EffectiveConfig.ps1` orchestrating: load defaults (cfg-02/03) → load user config (cfg-04) → load user policy (cfg-04) → discover and load project config (cfg-06) → read env vars per §9.2 → apply CLI param hashtable. Produce `(Effective, Sources)` tuple.
3. Tests cover every precedence pair from §9.3 and the source-attribution shape.

## PRD references

- §9.3 lists the six precedence layers in order.
- §9.13 enumerates the TDD requirements.
- §9.7 — project config rules (cannot weaken protected roots by default).
- §9.12 — safety floor enforcement.

## Acceptance criteria

- All TDD tests pass.
- Source attribution covers every leaf in the effective object.
- No filesystem write.
- Deterministic output.

## Notes / risks

- Deep merge of arrays is the trickiest part — prefer "replace" semantics; document any additive exceptions inline.
- `policy.safeWriteRoots` from project config is additive (per §9.7) when relative to project root — apply that exception explicitly.

