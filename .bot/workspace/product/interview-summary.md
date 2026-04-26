---
generated_at: "2026-04-26T09:27:42.0282791Z"
generator: "dotbot-kickstart"
model: "opus"
phase: "interview"
process_id: "proc-d65aa9"
---

# SlashOps Kickstart Interview Summary

This summary captures the verbatim answers across two interview rounds and translates each one into project implications. It is intended to be used directly by Phase 1 product planning.

The answers resolve all sixteen open questions in PRD section 17 plus scoping decisions about how the product plan itself should be produced.

---

## Round 1 - Scoping the project plan

### Q1. What scope should the product plan cover?

**Answer (verbatim):** "the tasks are already planned and in the todo so the planner can just compile the document from the tasks."

**Interpretation:** Phase 1 does not need to derive a new task breakdown. The implementation task plan already exists in the dotbot task store. The product planner should compile the product documents (mission, roadmap, tech-stack, etc.) from the existing tasks plus the PRD and these answers, rather than re-planning the work. This affects the Phase 1 workflow but not the product itself.

### Q2. How should the seventeen open questions in PRD section 17 be resolved?

**Answer (verbatim):** "B: Resolve every open question now in a dedicated Q&A round before product planning"

**Interpretation:** Every open question in the PRD must be answered before product documents are generated. This is what Round 2 did. The product plan should treat the answers below as fixed inputs, not as future decisions.

### Q3. Where does SlashOps live as code?

**Answer (verbatim):** "A: Standalone repo at github.com/andresharpe/SlashOps"

**Interpretation:** SlashOps is a single standalone GitHub repository under the andresharpe account. The product plan should assume one repo, one PowerShell Gallery module, one CI pipeline, and one issue tracker. There is no monorepo or multi-package layout to plan around.

### Q4. What is the FxConsole distribution status today?

**Answer (verbatim):** "A: Vendor FxConsole source under vendor/ and revisit later"

**Interpretation:** FxConsole ships as vendored source under `vendor/` for v0.1. The product plan should not depend on FxConsole being on the PowerShell Gallery yet. A later milestone can revisit publishing FxConsole separately and switching SlashOps to a gallery dependency. This also resolves PRD Q1.

### Q5. Is there a target ship date or external constraint driving v0.1 timing?

**Answer (verbatim):** "A: No fixed deadline - quality and safety coverage take priority"

**Interpretation:** There is no external ship date. Roadmap framing should emphasize completeness of the safety pipeline, test coverage, and policy enforcement over speed. Milestones can be defined by capability (mode coverage, tool coverage, safety coverage) rather than calendar dates.

---

## Round 2 - Resolving PRD section 17 open questions

### Q1. Should `/x` allow `Move-Item` by default for single explicit files, or require confirmation for every move?

**Answer (verbatim):** "B: Allow single-file moves without confirmation when source and destination are inside safe write roots"

**Interpretation:** `Move-Item` is permitted by `/x` without confirmation only when both source and destination paths resolve inside the configured safe write roots and the move targets a single explicit file. Wildcard moves, recursive moves, and moves crossing the safe-roots boundary still require either confirmation or `/!`. The path policy engine must check both endpoints, not only the source. Resolves PRD Q2.

### Q2. Should SlashOps default safe write roots include the current working directory?

**Answer (verbatim):** "A: No - default safe roots are user profile, configured project roots, and temp; current directory is not implicit"

**Interpretation:** The default safe write roots are the user profile, explicitly configured project roots, and the temp directory. The current working directory is never implicit. Users who want write access in arbitrary directories must add them to project roots or use `/!`. Documentation must state this explicitly because it differs from how most shells behave. Resolves PRD Q3.

### Q3. What is the smallest recommended Qwen model profile for lower-memory laptops (8 to 16 GB RAM)?

**Answer (verbatim):** "A: Qwen2.5-Coder 7B as the documented small profile, Qwen3-Coder 30B as default on capable hardware"

**Interpretation:** Two documented profiles: Qwen3-Coder 30B as the default for capable hardware, Qwen2.5-Coder 7B as the small profile for laptops with eight to sixteen gigabytes of RAM. Both profiles must be tested against the same prompt suite. The setup wizard should detect available memory and recommend the appropriate profile. Resolves PRD Q4.

### Q4. Should transcript logging be mandatory, or can users fully disable it?

**Answer (verbatim):** "A: On by default, fully disablable per user via config"

**Interpretation:** Transcript logging is on by default but can be fully disabled by per-user configuration. The disable switch must be obvious and documented. Audit-sensitive deployments can rely on enterprise policy (see Q7) to lock the setting on. Resolves PRD Q5.

### Q5. Should aliases (`/`, `//`, `/x`, `/!`, `/?`) be installed automatically by `Install-Module`, or only by `Initialize-SlashOps` with confirmation?

**Answer (verbatim):** "A: Only by `Initialize-SlashOps`, with explicit confirmation"

**Interpretation:** `Install-Module SlashOps` does not register the prefix aliases. The user must run `Initialize-SlashOps` and explicitly confirm before `/`, `//`, `/x`, `/!`, and `/?` are wired up. This avoids surprising shell-grammar conflicts on first install. The init command must show exactly which aliases will be added and where. Resolves PRD Q6.

### Q6. Should SlashOps support remote LLM providers (such as OpenAI or Anthropic) later, or remain local-only by product principle?

**Answer (verbatim):** "A: Design a provider abstraction now, ship local-only in v0.1, allow remote providers in a later version behind explicit opt-in"

**Interpretation:** A provider abstraction is required from day one, but only the local Ollama provider is shipped in v0.1. Remote providers are a later-version capability behind explicit opt-in, with prominent warnings about prompt egress. The abstraction must accommodate streaming, tool/function calling, and per-provider safety differences. Resolves PRD Q7.

### Q7. If managed enterprise policy files are added later, should they merge before or after user policy?

**Answer (verbatim):** "A: Enterprise policy is applied last and wins on conflict; user policy can only narrow, not widen"

**Interpretation:** When enterprise policy ships in a later version, it is applied last and wins on conflict. User policy can only narrow what enterprise allows, never widen it. The same constraint applies further down: project policy can only narrow user policy (see Q9). The policy engine must therefore implement a strict layered "narrow only" merge. Resolves PRD Q8.

### Q8. Should user-defined tools be allowed before v1.0?

**Answer (verbatim):** "A: No - only built-in, signed-by-the-project tools until v1.0"

**Interpretation:** Until v1.0, the tool registry contains only built-in tools shipped and signed by the project. No third-party or user-authored tools are loaded. This simplifies the v0.x trust model and means the tool policy engine can hard-code the allowed tool set. User-defined tools are a v1.0 design problem, not a v0.x one. Resolves PRD Q9.

### Q9. Should project-level config (per-repo `.slashops`) be able to enable tools, or only disable or narrow them?

**Answer (verbatim):** "A: Project config can only disable or narrow user-enabled tools, never enable new ones"

**Interpretation:** A `.slashops` file in a repository can disable a tool, narrow its allowed paths, or tighten its arguments, but it cannot enable a tool the user has not already enabled. This prevents a checked-out repository from silently expanding the agent's authority. Combined with Q7, the policy stack is enterprise -> user -> project, each layer narrowing the previous one. Resolves PRD Q10.

### Q10. Should Outlook support start with Microsoft Graph directly, or with the Microsoft 365 CLI?

**Answer (verbatim):** "C: Skip Outlook entirely until v1.x"

**Interpretation:** No Outlook capability in v0.x. The roadmap should explicitly defer Outlook (and any related Microsoft 365 mail/calendar work) to v1.x. The provider abstraction from Q6 should not pretend to model Outlook yet. Resolves PRD Q11.

### Q11. Should clipboard access be enabled by default?

**Answer (verbatim):** "A: Off by default, prompt-on-first-use to enable per session or persist"

**Interpretation:** Clipboard access is off by default. The first time a request would touch the clipboard, SlashOps prompts the user, who can enable it for the current session only or persist the choice. The transcript should record the decision but not the clipboard contents. Resolves PRD Q12.

### Q12. Should email or document bodies ever be logged?

**Answer (verbatim):** "B: Never log bodies, even with opt-in"

**Interpretation:** Email and document bodies are never written to the transcript or any other log, even if the user explicitly opts in. Logs may record metadata (subject, sender, path, length) but not body content. This is a hard rule the logging layer must enforce centrally, not a per-call decision. Resolves PRD Q13.

### Q13. Should `/x` be allowed to open files or folders in GUI apps?

**Answer (verbatim):** "A: Yes for local paths, with confirmation the first time per session"

**Interpretation:** `/x` may open local files and folders in GUI applications (default handler). The first such open in a session prompts for confirmation; subsequent opens in the same session do not. Remote URIs and network paths are not in scope for this rule. Resolves PRD Q14.

### Q14. Should document summarization include citations and snippets by default?

**Answer (verbatim):** "A: Yes for local documents, with short excerpts only and excerpts excluded from transcript logs"

**Interpretation:** Local document summarization includes citations and short excerpts by default, so the user can verify claims. The excerpts are shown in the UI but excluded from transcript logs (consistent with Q12). The summarizer must enforce a short maximum excerpt length. Resolves PRD Q15.

### Q15. Should the agent loop ship in v0.2 or sit behind an `experimental.agentLoop` flag?

**Answer (verbatim):** "A: Behind `experimental.agentLoop` in v0.2; read-only local tools only when enabled"

**Interpretation:** The agent loop ships in v0.2 but only behind the `experimental.agentLoop` configuration flag. When enabled, the loop may call read-only local tools only - no writes, no remote tools, no clipboard. This keeps the v0.2 surface area small enough to test thoroughly while letting interested users exercise it. Resolves PRD Q16.

---

## Synthesis - unified project direction

SlashOps is a single standalone PowerShell 7+ module hosted at github.com/andresharpe/SlashOps. It vendors FxConsole under `vendor/` for v0.1 and may switch to a gallery dependency later. There is no fixed ship date - quality, safety coverage, and test depth take priority over calendar.

The runtime model is local-first by principle but built on a provider abstraction from day one. v0.1 ships only the Ollama local provider with two documented model profiles: Qwen3-Coder 30B as default and Qwen2.5-Coder 7B as the small-laptop profile. Remote providers (OpenAI, Anthropic, others) are a later-version capability behind explicit opt-in. Outlook and Microsoft 365 mail are deferred to v1.x.

The safety model is strict and layered. Default safe write roots are the user profile, explicitly configured project roots, and the temp directory - never the current working directory. `/x` allows single-file `Move-Item` without confirmation only when both endpoints are inside safe write roots. `/x` may open local files and folders in GUI apps, with confirmation the first time per session. Clipboard access is off by default with prompt-on-first-use. Email and document bodies are never logged, even with opt-in. Local document summarization includes short citation excerpts in the UI but those excerpts are excluded from transcripts. Transcript logging itself is on by default but fully disablable per user.

The tool model is conservative until v1.0. Only built-in, project-signed tools are loaded - no user-defined tools. The agent loop ships in v0.2 behind `experimental.agentLoop` and is restricted to read-only local tools when enabled.

The policy stack is enterprise -> user -> project, each layer able to narrow but never widen the previous one. Project `.slashops` files can disable or constrain user-enabled tools but cannot enable new ones. Enterprise policy, when added later, is applied last and wins on conflict.

The install model avoids shell-grammar surprises. `Install-Module` does not register prefix aliases. Users must run `Initialize-SlashOps` and explicitly confirm before `/`, `//`, `/x`, `/!`, and `/?` are wired up.

For Phase 1 product planning: the implementation task plan already exists in the dotbot task store. The product planner should compile mission, roadmap, and tech-stack documents from those tasks, the PRD, and the decisions captured here, rather than re-deriving the breakdown.
