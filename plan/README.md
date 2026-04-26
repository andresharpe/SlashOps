# SlashOps implementation plan

This folder is the executable plan for delivering SlashOps as described in `PRD.md` (PRD v0.3 dated 2026-04-26). Each task in `tasks/todo/` is a self-contained chunk of work with its own TDD test list, implementation steps, and acceptance criteria.

## Layout

```
plan/
  README.md                    # this file
  tasks/
    todo/                      # tasks not yet started
    in-progress/               # tasks currently being worked on
    done/                      # accepted tasks
```

The folder a task lives in is its status. The `status:` field in frontmatter is the canonical record and must be updated when a task is moved.

## Task filename pattern

```
{group}-{sequence}-{slug}.md
```

Group prefixes:

| Prefix | Area | Version |
|---|---|---|
| `f-` | Foundation / repo scaffolding | n/a |
| `cfg-` | Configuration subsystem | v0.1 |
| `ctx-` | Context collection | v0.1 |
| `mdl-` | Model / Ollama integration | v0.1 |
| `saf-` | Safety subsystem | v0.1 |
| `exe-` | Execution + transcript | v0.1 |
| `set-` | Setup / install | v0.1 |
| `ux-` | Public UX commands | v0.1 |
| `ui-` | FxConsole rendering | v0.1 |
| `pub-` | Packaging / publishing | v0.1 |
| `gate-` | Acceptance gate | per version |
| `tr-` | Tool runtime / planner / agent loop | v0.2 |
| `lt-` | Local tools | v0.2 |
| `cfg2-` | Config additions | v0.2 |
| `ui2-` | UI additions | v0.2 |
| `biz-` | Business / dev connectors | v0.3 |
| `ma-` | Mature agent workflows | v0.4 |
| `rel-` | Release prep | v1.0 |
| `doc-` | Cross-cutting docs | all |

## Frontmatter schema

```yaml
---
id: cfg-07
title: Merge layered configuration into effective config
version: v0.1
group: config
subgroup: merge
sequence: 7
depends_on: [cfg-04, cfg-06]
status: todo
tdd_first: true
prd_refs:
  - "PRD §9.3 Configuration precedence (lines 1660-1690)"
deliverables:
  - src/SlashOps/Private/Config/Merge-Config.ps1
  - tests/Unit/Config.Tests.ps1
tags: [config, precedence, merge]
---
```

Field semantics:

- **id** — stable cross-reference; used by `depends_on`.
- **version** — milestone the task belongs to (`v0.1`, `v0.2`, `v0.3`, `v0.4`, `v1.0`, or `n/a` for foundation).
- **group / subgroup** — functional area.
- **sequence** — recommended order inside the group; lower runs first when dependencies are equal.
- **depends_on** — task ids that must be done first.
- **status** — `todo` / `in-progress` / `done`. Must match the folder.
- **tdd_first** — when true, failing Pester tests must land before any production code (per PRD §11.1).
- **prd_refs** — section + approximate line range; an executor should re-read those before starting.

## Querying the plan

List all v0.1 tasks:

```powershell
Get-ChildItem -Path .\plan\tasks\todo\*.md |
  Select-String -Pattern '^version: v0\.1' |
  Select-Object -ExpandProperty Path -Unique
```

List tasks blocked on `cfg-07`:

```powershell
Get-ChildItem -Path .\plan\tasks\todo\*.md |
  Select-String -Pattern 'cfg-07' |
  Select-Object -ExpandProperty Path -Unique
```

## How to execute a task

1. Move the file from `todo/` → `in-progress/` and update `status:` in frontmatter.
2. Re-read the PRD sections listed in `prd_refs:` — they are the source of truth.
3. Write the failing Pester tests listed under `## TDD test list` first.
4. Implement the deliverables listed in frontmatter.
5. Verify the `## Acceptance criteria` checklist passes.
6. Move the file to `done/` and update `status:`.

## Versions and gates

Each version closes with a `gate-vXX-acceptance` task that lists every preceding task as a dependency. The gate is a checklist task (no code) verifying the PRD §15 acceptance criteria for that milestone.

## See also

- `PRD.md` (when copied into the repo by `doc-10-prd-living-copy`)
- `C:\Users\andre\Downloads\Slashops-PRD_v3.md` (the original source)
