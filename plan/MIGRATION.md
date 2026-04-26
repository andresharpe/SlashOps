# dotbot task migration

The 133 markdown task files under `plan/tasks/todo/` have been mirrored into the dotbot task store at `.bot/workspace/tasks/todo/`. This document explains the mapping and how to re-run the migration.

## Why two stores?

- `plan/tasks/todo/*.md` is the **source of truth** for humans and code review. Every task is a self-contained markdown file with frontmatter and six body sections (Overview, TDD test list, Implementation steps, PRD references, Acceptance criteria, Notes / risks).
- `.bot/workspace/tasks/todo/*.json` is the **runtime store** that dotbot's MCP server, dashboard, and per-task worktree workflow consume. Task names look like `[<slug>] <title>` so dotbot's fuzzy dependency resolver can map our slugs (`cfg-04`, `f-01`, etc.) to its UUID-based ids.
- `.bot/workspace/plans/*.md` carries the full original markdown body for each task, attached via `plan_path`. Nothing prose-side is lost.

## Field mapping

| Markdown source | Dotbot field |
|---|---|
| `id` (e.g. `cfg-07`) | embedded in `name` as `[cfg-07] <title>`, also stored as custom `slug` |
| `title` | `name` (after `[<slug>]` prefix) |
| body `## Overview` paragraph | `description` |
| `version` | custom `version` |
| `group` | dotbot `category` (mapped) plus custom `group` |
| `subgroup` | custom `subgroup` |
| `sequence` | custom `sequence`; folds into `priority` |
| `depends_on` | `dependencies` (slugs as strings) |
| `status: todo` | `status: todo` |
| `tdd_first` | custom `tdd_first` and drives `applicable_agents` |
| `prd_refs` (frontmatter + body) | custom `prd_refs`, deduplicated |
| `deliverables` | custom `deliverables` |
| `tags` | custom `tags` |
| body `## TDD test list` | `steps[]` prefixed `TDD: …` |
| body `## Implementation steps` | `steps[]` (after the TDD entries) |
| body `## Acceptance criteria` | `acceptance_criteria[]` |
| body `## Notes / risks` | custom `notes[]` |
| whole markdown body | linked plan via `plan_path` |

### Category mapping

| Group | Category |
|---|---|
| `f-`, `pub-`, `rel-`, `set-`, `cfg-`, `cfg2-`, `doc-` | `infrastructure` |
| `ctx-`, `mdl-`, `saf-`, `exe-`, `gate-` | `core` |
| `ux-`, `ui-`, `ui2-` | `ui-ux` |
| `tr-`, `lt-`, `biz-`, `ma-` | `feature` |

### Priority formula (lower = higher priority)

```
priority = version_base + sequence
```

| Version | Base |
|---|---|
| `n/a` (foundation) | 0 |
| `v0.1` | 10 |
| `v0.2` | 30 |
| `v0.3` | 50 |
| `v0.4` | 70 |
| `v1.0` | 85 |

`doc-*` tasks add an extra +80 offset so they sort last in their version. `gate-v01` lands at 99 / 100, `gate-v02` at 49, `gate-v03` at 69.

### Effort defaults

| Shape | Effort |
|---|---|
| `gate-*`, `doc-*` | `XS` |
| `set-05`, `tr-06`, `tr-08`, `lt-06`, `biz-01`, `ma-01`, `ma-04`, `ma-05` | `M` |
| `rel-04`, `rel-05` | `L` |
| Default | `S` |

### `applicable_agents`

| When | Agents |
|---|---|
| `gate-*` | `.claude/agents/reviewer.md` |
| `doc-*` | `.claude/agents/planner.md` |
| `pub-*`, `rel-*` | `.claude/agents/reviewer.md` |
| `tdd_first: true` | `.claude/agents/tester.md`, `.claude/agents/implementer.md` |
| Default | `.claude/agents/implementer.md` |

## Re-running the migration

```powershell
# Smoke test: parse and map only, do not write
pwsh ./build/migrate-tasks-to-dotbot.ps1 -DryRun

# Smoke test: actually create the first 3 tasks
pwsh ./build/migrate-tasks-to-dotbot.ps1 -Limit 3

# Full migration
pwsh ./build/migrate-tasks-to-dotbot.ps1

# Skip the per-task plan_create pass
pwsh ./build/migrate-tasks-to-dotbot.ps1 -SkipPlans
```

The script is **idempotent**: any task whose custom `slug` already exists in the dotbot store is skipped. To re-create from scratch, delete the existing dotbot artefacts first:

```powershell
Remove-Item .bot/workspace/tasks/todo/*.json
Remove-Item .bot/workspace/plans/*.md
pwsh ./build/migrate-tasks-to-dotbot.ps1
```

## Notes on the implementation

- The script invokes dotbot's underlying tool functions directly (`Invoke-TaskCreateBulk`, `Invoke-PlanCreate`) by dot-sourcing `.bot/systems/mcp/tools/*/script.ps1`. It does not go through the MCP stdio transport.
- A "Phase 4b" repair pass walks every newly-created JSON file and normalises array-typed fields. PowerShell's `ConvertTo-Json` on hashtables unwraps single-element arrays to scalars and emits empty arrays as `null`; the repair pass re-reads via `ConvertFrom-Json` (which yields `PSCustomObject`) and re-emits the file with array shapes preserved.
- Topological sort uses Kahn's algorithm against the parsed `depends_on` graph. Sort order within a "ready" set is non-deterministic but valid — dotbot only requires that every dependency appears before its dependents in the bulk batch.

## When the markdown source changes

Update the markdown task files under `plan/tasks/todo/` and re-run the migration. The idempotency check skips already-created slugs, so you may need to delete the affected JSON file first to force recreation. Future work: add a `--force` flag to the script that updates existing tasks in place.
