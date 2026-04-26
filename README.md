# SlashOps

Local-first natural language command assistant for cross-platform PowerShell 7+, powered by Ollama and Qwen.

> Status: pre-alpha planning. No code is implemented yet. The PRD and the implementation task plan are complete; module scaffolding starts with task `f-01`.

SlashOps lets you type natural language into `pwsh` using short prefixes such as `/`, `//`, `/x`, `/!`, and `/?`. It classifies the request, asks a local model to produce either a PowerShell command or a registered tool plan, validates the plan through layered safety checks, displays it through FxConsole, and executes only when the selected mode and policy allow it.

## What is here today

- [`PRD.md`](PRD.md) — the full Product Requirements Document, draft v0.3.
- [`plan/`](plan/) — 133 fine-grained task files under `plan/tasks/todo/`, each with frontmatter, a TDD test list, implementation steps, PRD references, and acceptance criteria. Start with [`plan/README.md`](plan/README.md) for conventions.

## Repository layout (planned)

The eventual repository structure is described in PRD §10.1. Once `f-01` and `f-02` land, the tree will look like:

```
SlashOps/
  PRD.md
  README.md
  LICENSE
  CHANGELOG.md
  src/
    SlashOps/
      SlashOps.psd1
      SlashOps.psm1
      Public/
      Private/
      ToolManifests/
      vendor/FxConsole/
  tests/
  build/
  docs/
  examples/
  plan/
```

## Roadmap

| Version | Scope |
|---|---|
| v0.1 | Single-step shell command runtime, full safety pipeline, FxConsole UI, PowerShell Gallery packaging. |
| v0.2 | Tool registry, intent classifier, planner, bounded agent loop, local file and document tools, structured observations. |
| v0.3 | Outlook / Microsoft 365, calendar, GitHub, structured Git tools. |
| v0.4 | Multi-step re-planning, session memory, undo metadata, policy packs, enterprise policy, SecretManagement, richer transcript and selection UI. |
| v1.0 | Stable schemas, cross-platform CI, signed module option, full docs site, security review, stable Gallery release. |

## Principles

- Local first. Default model runtime is Ollama; user prompts and generated commands stay on the local machine unless an explicit remote provider is configured.
- Safe by default. Layered checks (static regex, AST, path policy, tool policy, optional AI security review) classify each command into `read-only`, `benign-write`, `risky-write`, `blocked`, or `unknown` before any execution.
- Test-driven from day one. No production function lands without a failing Pester test first.
- Cross-platform. Windows, macOS, Linux, and WSL under PowerShell 7+.
- Auditable. Every prompt, plan, classification, and execution attempt is recorded as JSONL.

## Contributing

The project is in planning. If you would like to contribute once code starts landing, the task files under `plan/tasks/todo/` are the unit of work. I suggest you pick a task with no unsatisfied dependencies, move it to `plan/tasks/in-progress/`, write the failing tests listed under its TDD test list, then implement.

## License

MIT. See [LICENSE](LICENSE).
