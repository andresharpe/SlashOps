---
generated_at: "2026-04-26T09:29:50.7824486Z"
generator: "dotbot-kickstart"
model: "opus"
phase: "phase-1-product-document"
process_id: "proc-d65aa9"
---

# Product: SlashOps

## Executive Summary

SlashOps is a local-first natural language command assistant for cross-platform PowerShell 7+. Users type plain English after a short prefix (`/`, `//`, `/x`, `/!`, `/?`) and SlashOps asks a local Ollama model to produce either a PowerShell command or a structured tool plan, validates that plan through layered safety checks, and executes only when the selected mode and policy allow it. The product exists to give developers, power users, and operators a private, auditable terminal assistant that does not send prompts or generated commands to cloud services by default.

## Problem Statement

PowerShell is powerful but the syntax is hard to recall, especially across Windows, macOS, Linux, and WSL. Users either keep cheat sheets, switch context to a search engine or a chatbot, or accept slower work. Cloud-hosted assistants solve the recall problem but introduce three new ones:

- Prompts and generated commands leave the local machine, which is unacceptable for sensitive repositories, regulated work, and offline environments.
- Generated commands run against the user's filesystem and credentials with no consistent safety check before execution.
- There is no shared transcript of what was asked, what was generated, what was classified as risky, and what actually ran.

If this is left unsolved, users continue to choose between speed (ask a cloud assistant and paste the answer) and control (write everything by hand). Neither is satisfying for the kinds of multi-step tasks SlashOps targets, such as converting recent downloads, searching local documents, or running guarded git workflows.

## Goals and Success Criteria

### Primary goals

1. Make natural language a first-class entry mode in `pwsh` without replacing PowerShell itself. The user keeps the shell, the history, and the scripting language; SlashOps adds a planner and a safety gate.
2. Keep the runtime fully local by default. Ollama and Qwen handle reasoning. Prompts, generated commands, and document content stay on the local machine.
3. Classify every generated action into `read-only`, `benign-write`, `risky-write`, `blocked`, or `unknown` before execution, using layered checks: static regex, PowerShell AST, path policy, tool policy, and optional AI security review.
4. Match execution to mode. `/x` auto-runs only read-only or policy-approved benign-write actions. `/` asks before running. `//` and `/?` never execute. `/!` adds an AI security review step and never auto-executes.
5. Ship as a PowerShell Gallery module that installs and initializes cleanly on Windows, macOS, Linux, and WSL with PowerShell 7+.
6. Be test-driven with Pester from the first commit. No production function lands without a failing Pester test first.

### Measurable outcomes

- One public PowerShell Gallery release for v0.1 with a working install, initialize, preflight, and `/x` happy path on all four supported platforms.
- All safety classifications covered by Pester tests, including blocked patterns, AST checks, path policy, and tool policy.
- Two documented model profiles tested against the same prompt suite: Qwen3-Coder 30B as default, Qwen2.5-Coder 7B as the small profile for laptops with eight to sixteen gigabytes of RAM.
- A JSONL transcript of every prompt, plan, classification, and execution attempt, on by default and fully disablable per user.
- An auditable policy stack with strict narrow-only merging across enterprise, user, and project layers.

### Non-goals

1. SlashOps is not a general autonomous agent. It does not chain arbitrary multi-step work without approval. The bounded agent loop in v0.2 is experimental, opt-in, and limited to read-only local tools.
2. SlashOps does not replace PowerShell command discovery, help, or manual scripting.
3. SlashOps does not execute privileged or admin commands automatically.
4. SlashOps does not ship cloud-hosted LLM integrations in v0.1. A provider abstraction exists from day one, but only the local Ollama provider is wired up. Remote providers are a later-version capability behind explicit opt-in.
5. SlashOps does not depend on Windows PowerShell 5.1 and does not require Windows-only features in the core product.
6. SlashOps does not load user-defined or third-party tools before v1.0. Until then, the tool registry contains only built-in, project-signed tools.
7. SlashOps does not include Outlook or Microsoft 365 mail support in v0.x. Those capabilities are deferred to v1.x.

## Target Users

### Business power user

Comfortable with documents and basic PowerShell but not advanced scripting. Wants to convert files, find recent downloads, prepare folders, compress deliverables, extract text from PDFs, and search files without accidentally running a destructive command. Today they switch between a file manager, a chatbot, and a shell, copying snippets back and forth.

### Developer

Uses PowerShell cross-platform for repository work. Wants natural language access to git status, diff, and log workflows, code search, test runs, JSON and YAML inspection, and editor opens, with guardrails that prevent dangerous repository mutations from running unattended. Today they either memorise the syntax or paste prompts into a cloud assistant they would rather not feed with private code.

### Platform and admin-adjacent user

Has cloud CLIs and container tooling installed. Wants to inspect resources safely, list configuration, and read state. Must never mutate cloud resources through fast mode and wants clear warnings on anything that could touch shared infrastructure. Today they carefully type commands by hand because cloud assistants are not authorised on managed laptops.

## High-Level Approach

### Platform and runtime

SlashOps is a PowerShell 7+ module published to the PowerShell Gallery. It targets Windows, macOS, Linux, and WSL with one codebase. There is no Windows-only assumption in the core runtime. The repository lives at github.com/andresharpe/SlashOps as a single standalone repo with one Gallery module, one CI pipeline, and one issue tracker.

### Reasoning layer

The default reasoning layer is Ollama running locally on `http://localhost:11434`, called through its OpenAI-compatible `/v1/chat/completions` endpoint. The default model is `qwen3-coder:30b`. The documented small profile is `qwen2.5-coder:7b` for machines with eight to sixteen gigabytes of RAM. The setup wizard detects available memory and recommends the appropriate profile.

A provider abstraction sits behind the Ollama client from day one so that future remote providers can be added without rewriting the planner. v0.1 ships only the local Ollama provider. Remote providers are deferred to a later version, behind explicit opt-in, with prominent warnings about prompt egress.

### UI layer

The terminal UI uses FxConsole for banners, status, step tracking, cards, panels, tables, progress, and themes. For v0.1, FxConsole ships as vendored source under `src/SlashOps/vendor/FxConsole`, with the MIT license preserved and the vendored commit recorded. A later milestone may revisit publishing FxConsole as its own Gallery module and switching SlashOps to a Gallery dependency.

### Major components

1. Prefix parser and mode router. Captures the natural language prompt and the active mode (`/`, `//`, `/x`, `/!`, `/?`).
2. Context collector. Gathers current directory, OS, date, time, timezone, home and downloads paths, available external tools, and the effective policy.
3. Intent classifier. Maps the prompt to one of a fixed taxonomy (shell command, file search, document summary, git read, git mutation, and so on) before any command generation.
4. Planner. Calls the configured model provider with a structured system prompt and returns strict JSON containing either a registered tool plan or a PowerShell command, plus risk metadata, dependencies, and an undo hint.
5. Safety pipeline. Runs static regex checks, PowerShell AST inspection, path policy checks, tool policy checks, and optional AI security review. Produces a final classification that gates execution.
6. Tool registry. Holds built-in, project-signed tools with metadata for inputs, outputs, risk, fast-mode eligibility, dependencies, and redaction rules. Unregistered tool calls from the model are blocked.
7. Execution gate. Runs registered tools or PowerShell commands only when the mode, classification, and policy all allow it.
8. Transcript and audit layer. Writes JSONL records of every prompt, plan, classification, decision, and execution result to `~/.slashops/history.jsonl`, on by default and fully disablable per user.
9. Configuration and policy engine. Layers settings as enterprise, user, then project, with strict narrow-only merging. Project policy can disable or constrain user-enabled tools but cannot enable new ones.

### Built-in tool surface

v0.1 ships shell command generation only. v0.2 adds the local tool surface that does not require external authentication: file search, content search, file open, clipboard read, document text extraction, document summarization with short citation excerpts, Markdown to PDF or DOCX conversion through Pandoc, PDF inspection, CSV inspection, and DuckDB query. v0.2 also introduces a bounded agent loop behind the `experimental.agentLoop` flag, restricted to read-only local tools when enabled. Microsoft 365, GitHub, and structured git tools follow in v0.3.

### Safety model

The default safe write roots are the user profile, explicitly configured project roots, and the temp directory. The current working directory is never implicit. Any wildcard or recursive write requires confirmation or `/!`. `/x` allows a single-file `Move-Item` without confirmation only when both source and destination resolve inside the safe write roots. `/x` may open local files and folders in default GUI applications, with confirmation the first time per session.

Clipboard access is off by default and prompts on first use, with a per-session or persistent choice. Email and document bodies are never logged, even with explicit opt-in. Local document summaries may include short citation excerpts in the UI, but the excerpts are excluded from transcript logs. The logging layer enforces these rules centrally rather than relying on per-call decisions.

### Install model

`Install-Module SlashOps` installs the module but does not register the prefix aliases. The user must run `Initialize-SlashOps` and explicitly confirm before `/`, `//`, `/x`, `/!`, and `/?` are wired up. The init command shows exactly which aliases will be added and where. This avoids surprising shell-grammar conflicts on first install.

## Constraints

### Quality before timeline

There is no fixed ship date. Roadmap framing favours completeness of the safety pipeline, test coverage, and policy enforcement over speed. Milestones are defined by capability (mode coverage, tool coverage, safety coverage), not by calendar dates.

### Cross-platform parity

Every feature in the core product must work on Windows, macOS, Linux, and WSL under PowerShell 7+. Anything Windows-specific lives behind an explicit platform flag and is not on the v0.x critical path. Outlook automation in particular avoids COM and is deferred to v1.x.

### Local-first by principle

Prompts, generated commands, document content, and tool outputs stay on the local machine in v0.x. The provider abstraction is in place for future remote providers but not exercised. Anything that would change this default requires an explicit configuration opt-in and prominent warnings.

### Trust and tool surface

Until v1.0, only built-in, project-signed tools may run. There is no mechanism for users or repositories to register new tools. This keeps the v0.x trust model small enough to reason about and audit.

### Layered policy with narrow-only merge

The policy stack is enterprise, then user, then project. Each layer can narrow the previous one but never widen it. When enterprise policy ships in a later version, it is applied last and wins on conflict. The engine must enforce this order strictly.

### Distribution

SlashOps must remain installable through `Install-Module` from the PowerShell Gallery. The manifest must satisfy Gallery requirements: PSScriptAnalyzer clean, `Test-ModuleManifest` clean, tagged for compatible platforms and PSEditions, license, project URI, and release notes. Vendored dependencies must preserve their original licenses and record the vendored commit.

### Test discipline

No production function lands without a failing Pester v5+ test first. External operations such as Ollama calls, package manager commands, and filesystem writes must be mocked in unit tests. Integration tests cover preflight, install flow, transcript writing, and the end-to-end happy path on each supported platform.

## Open Questions

The seventeen open questions in the PRD have all been resolved during the kickstart interview. The resolutions are recorded in `interview-summary.md` and reflected in the goals, approach, and constraints above. The remaining open items are not blockers for v0.1 but should be revisited as milestones progress:

- When and how to publish FxConsole as its own Gallery module, and the migration path from vendored source to a Gallery dependency.
- The exact shape of the enterprise policy file and signing model, to be designed before the first enterprise-policy release.
- The user-defined tool model for v1.0, including manifest format, signature requirements, and trust prompts.
- The remote provider opt-in flow, including consent UX, prompt egress warnings, and per-provider safety differences.
- The Outlook and Microsoft 365 provider choice for v1.x, between Microsoft Graph and the Microsoft 365 CLI, including authentication and offline behaviour.
