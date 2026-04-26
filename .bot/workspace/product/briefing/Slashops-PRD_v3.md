# SlashOps PRD

**Product name:** SlashOps  
**Repository target:** `andresharpe/SlashOps` or a new `/SlashOps` module folder inside a parent repository  
**Primary runtime:** PowerShell 7+ (`pwsh`)  
**Supported platforms:** Windows, macOS, Linux, WSL where PowerShell 7+ runs  
**Primary model runtime:** Ollama local API  
**Default model:** `qwen3-coder:30b`  
**UI layer:** FxConsole  
**Testing:** Pester-first TDD  
**Distribution:** PowerShell Gallery module  
**Document status:** Draft PRD v0.3 — tool-oriented agent runtime expanded  
**Prepared:** 2026-04-26

---

## 1. Executive summary

SlashOps is a cross-platform PowerShell 7+ utility that lets a user type natural language into `pwsh` using short prefixes such as `/`, `//`, `/x`, `/!`, and `/?`. SlashOps began as an English-to-PowerShell command generator, but the full product is a **local-first tool-using terminal agent**: it classifies the user's intent, chooses either command generation or a registered tool workflow, validates the plan through layered safety gates, displays the plan with FxConsole, and executes only when the selected mode and policy allow it.

Ollama/Qwen is the local reasoning layer. PowerShell is the runtime. SlashOps is the planner, tool registry, safety gate, configuration manager, and audit layer.

SlashOps must support both simple shell-like prompts and richer business/dev requests:

```powershell
/x find the latest two markdown files i just downloaded and convert them to pdf and store them in ~/work/cv
/ find the quote that I downloaded today
/ summarize this doc
/ find an outlook email about AI call answering and mark it
```

Expected behavior for the first example:

1. SlashOps captures the text after `/x`.
2. It collects environment context: current directory, OS, date/time, timezone, home path, downloads path, installed tools, project context, and SlashOps policy.
3. It classifies the request as `document_conversion`.
4. It asks local Ollama/Qwen to return structured JSON containing a plan, PowerShell command or registered tool calls, summary, required tools, estimated risk, and undo hint.
5. It parses generated PowerShell with AST where applicable.
6. It runs static safety checks, path checks, tool allowlist checks, and optional AI security review.
7. It classifies the workflow as `read-only`, `benign-write`, `risky-write`, or `blocked`.
8. Because `/x` is fast mode, it auto-executes only if classification is `read-only` or policy-approved `benign-write`.
9. It logs the prompt, plan, command/tool calls, risk decision, execution result, and output metadata.

Expected behavior for the Outlook example:

1. SlashOps classifies the request as `email_search` plus requested `email_mutation`.
2. It uses a registered Outlook/Microsoft 365 provider rather than asking Qwen to invent shell commands.
3. It searches mail read-only and displays ranked results.
4. It requires explicit confirmation before marking any email.
5. It logs the selected message metadata and mutation result without storing message bodies unless policy allows it.

SlashOps aims to provide a Warp AI-like experience while remaining PowerShell-native, local-first, auditable, TDD-built, and safe by default.

---
## 2. Goals

### 2.1 Product goals

SlashOps must:

1. Make PowerShell feel natural-language capable without replacing PowerShell.
2. Run fully locally by default using Ollama and Qwen.
3. Use local environment context to support natural prompts such as "today", "yesterday", "here", "my downloads", "latest", and "this repo".
4. Provide fast execution for safe and benign tasks.
5. Require confirmation or block dangerous tasks.
6. Be installable from PowerShell Gallery.
7. Be test-driven with Pester from the first commit.
8. Be cross-platform: no Windows-only assumptions except where explicitly gated.
9. Use FxConsole for attractive, readable terminal UX.
10. Produce an auditable local transcript of every generated and executed command.
11. Provide a transparent, layered, editable configuration system with user, project, environment, and CLI overrides.

### 2.2 Non-goals

SlashOps v1 will not:

1. Be a general autonomous agent that chains arbitrary multi-step work without approval.
2. Replace PowerShell command discovery, help, or manual scripting.
3. Execute privileged/admin commands automatically.
4. Store cloud API keys or integrate cloud-hosted LLMs by default.
5. Depend on Windows PowerShell 5.1.
6. Mutate cloud infrastructure in `/x` mode.
7. Bypass enterprise security controls.
8. Guarantee perfect safety; it must reduce risk through layered controls and explicit policy.

---

## 3. Source research and design assumptions

### 3.1 FxConsole integration

SlashOps should use FxConsole as its terminal rendering and progress UI layer.

FxConsole is a PowerShell 7+ terminal output module providing themed text, animated spinners, styled cards, step tracking, tables, progress bars, banners, and color presets. Its README describes it as "Theme-aware terminal output for PowerShell 7+" with zero external dependencies and built-in/custom themes.

FxConsole currently exports functions including:

- `Set-FxTheme`
- `Get-FxTheme`
- `Format-Fx`
- `Write-Fx`
- `Write-FxStatus`
- `Write-FxStep`
- `Write-FxShimmer`
- `Invoke-FxJob`
- `Write-FxBanner`
- `Write-FxCard`
- `Write-FxPanel`
- `Write-FxTable`
- `Write-FxGrid`
- `Write-FxProgress`
- `Invoke-FxProgress`
- `Invoke-FxScript`

FxConsole’s manifest targets PowerShell 7.0 and exports public functions without aliases. SlashOps should not fork terminal UI primitives unless FxConsole lacks a required capability.

FxConsole usage pattern:

```powershell
Import-Module ./src/FxConsole/FxConsole.psd1
Set-FxTheme
Invoke-FxScript {
    Write-FxBanner 'SLASHOPS' -Subtitle 'local-first shell AI'
    Write-FxHeader 'Preflight'
    Write-FxStatus 'Ollama is running' Success
}
```

### 3.2 Ollama integration

Ollama provides local model execution and an OpenAI-compatible API. SlashOps should call Ollama using the OpenAI-compatible `/v1/chat/completions` endpoint at:

```text
http://localhost:11434/v1/chat/completions
```

Ollama’s OpenAI-compatible client examples use `base_url='http://localhost:11434/v1/'` and `api_key='ollama'`, where the key is required by OpenAI-compatible clients but ignored by Ollama.

SlashOps must support:

- health check: `GET http://localhost:11434/v1/models`
- command generation: `POST http://localhost:11434/v1/chat/completions`
- JSON-mode output where supported
- configurable model name
- configurable endpoint
- timeout and retry settings

### 3.3 Default model

Default model should be:

```text
qwen3-coder:30b
```

Rationale:

- Ollama lists `qwen3-coder:30b` as a 19GB model.
- It has a 256K context window in the Ollama library listing.
- It is described as optimized for agentic and coding tasks.
- It is a practical default for command generation on capable local hardware.

SlashOps must also allow lower-resource alternatives, for example:

- `qwen3-coder:30b` as recommended default
- `qwen3:30b` for more general command/chat behavior
- user-specified model via config
- future smaller model profile, such as a 7B/14B command mode, once selected and tested

### 3.4 PowerShell Gallery requirements

SlashOps must be packaged as a module with a manifest because PowerShell Gallery publishing requires module metadata. Publishing must use `Publish-Module`, and pre-publish checks must include `Test-ModuleManifest` and PSScriptAnalyzer.

PowerShell Gallery best-practice requirements include:

- use PSScriptAnalyzer
- include documentation and examples
- provide a project site
- tag compatible platforms and PSEditions
- include tests
- include license terms
- follow SemVer
- test publishing using a local repository first
- use PowerShellGet publishing commands

### 3.5 Pester and TDD

SlashOps must be test-driven with Pester. The test design must use Pester v5+ style with:

- `Describe`
- `Context`
- `It`
- `BeforeAll`
- `BeforeEach`
- `AfterEach`
- `Mock`
- `Should -Invoke`
- coverage for command generation, parsing, safety classification, install flows, preflight, config, logging, and execution gating

External operations such as Ollama calls, package manager commands, and filesystem writes must be mocked in unit tests.

---

## 4. User personas

### 4.1 Business power user

A business user comfortable with documents and PowerShell basics but not advanced scripting.

Needs:

- convert files
- find recent downloads
- prepare folders
- compress deliverables
- extract text from PDFs
- search files
- avoid accidental destructive commands

Example prompts:

```text
/x convert the latest cv markdown to pdf in ~/work/cv
/ find all pdfs I downloaded today and show sizes
/ zip the proposal folder into a dated archive
```

### 4.2 Developer

A developer who uses PowerShell cross-platform for repo work.

Needs:

- git status/diff/log workflows
- search code
- run tests
- inspect JSON/YAML
- open files in editor
- avoid dangerous repo mutations without approval

Example prompts:

```text
/x show changed files in this repo
/ find TODO comments added this week
/? create a safe command to summarize this branch diff
```

### 4.3 Platform/admin-adjacent user

A technical user who may have cloud CLIs and container tooling installed.

Needs:

- inspect resources safely
- list configuration
- never mutate cloud resources through fast mode
- clear warnings for risky operations

Example prompts:

```text
/x list kubernetes pods in this namespace
/x show docker containers using most memory
/ explain what this terraform plan would do
```

---

## 5. User experience

### 5.1 Prefixes

SlashOps must define these aliases or functions:

| Prefix | Function | Behavior |
|---|---|---|
| `/` | `Invoke-SlashOps` | Generate, scan, display, ask before execution. |
| `//` | `Invoke-SlashOpsGenerateOnly` | Generate and display only. Never execute. |
| `/x` | `Invoke-SlashOpsFast` | Generate, scan, and auto-execute only read-only or policy-approved benign commands. |
| `/!` | `Invoke-SlashOpsStrict` | Strict mode. Generate, scan, AI-review, never auto-execute. |
| `/?` | `Invoke-SlashOpsExplain` | Generate and explain what would run. Never execute. |

PowerShell alias compatibility must be tested. If aliases such as `//`, `/x`, or `/?` are not reliable on a target platform or shell host, SlashOps must provide fallback commands:

```powershell
slash "find latest markdown files"
slashx "find latest markdown files"
slashq "explain find latest markdown files"
slashgen "find latest markdown files"
```

### 5.2 Example interaction: safe fast execution

Input:

```powershell
/x show the latest 5 markdown files in downloads
```

Generated command:

```powershell
Get-ChildItem -Path (Join-Path $HOME 'Downloads') -Filter '*.md' -File |
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object -First 5 -Property Name, LastWriteTime, Length, FullName
```

Classification:

```text
read-only
```

Behavior:

- auto-execute
- render result table using FxConsole if possible
- log transcript

### 5.3 Example interaction: benign write fast execution

Input:

```powershell
/x convert the latest two markdown downloads to pdf in ~/work/cv
```

Generated command:

```powershell
$dest = Join-Path $HOME 'work/cv'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Get-ChildItem -Path (Join-Path $HOME 'Downloads') -Filter '*.md' -File |
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object -First 2 |
    ForEach-Object {
        pandoc $_.FullName -o (Join-Path $dest ($_.BaseName + '.pdf'))
    }
```

Classification:

```text
benign-write
```

Required conditions:

- `pandoc` exists
- output path is inside safe write root
- source file count is bounded with `Select-Object -First 2`
- no deletion
- no overwrite unless explicitly allowed or output path does not exist

Behavior:

- auto-execute only if policy permits benign writes in `/x`
- display warning if output files already exist
- log transcript and undo hint

### 5.4 Example interaction: blocked

Input:

```powershell
/x download this installer and run it
```

Generated risk:

```text
blocked
```

Behavior:

- never execute
- show reason: remote code execution
- offer safer alternative: download to a file and verify hash manually

---

## 6. Functional requirements

### 6.1 Module commands

SlashOps module must export these public functions.

#### Core UX

```powershell
Invoke-SlashOps
Invoke-SlashOpsFast
Invoke-SlashOpsGenerateOnly
Invoke-SlashOpsStrict
Invoke-SlashOpsExplain
```

#### Setup and configuration

```powershell
Install-SlashOpsRuntime
Initialize-SlashOps
Test-SlashOpsPreflight
Get-SlashOpsConfig
Set-SlashOpsConfig
Edit-SlashOpsConfig
Reset-SlashOpsConfig
Test-SlashOpsConfig
Get-SlashOpsPolicy
Set-SlashOpsPolicy
Edit-SlashOpsPolicy
Test-SlashOpsPolicy
Get-SlashOpsEffectiveConfig
```

#### Model and Ollama

```powershell
Test-SlashOpsOllama
Start-SlashOpsOllama
Install-SlashOpsOllama
Install-SlashOpsModel
Get-SlashOpsModel
Invoke-SlashOpsModel
```

#### Safety

```powershell
ConvertTo-SlashOpsPromptContext
New-SlashOpsCommandPlan
Test-SlashOpsCommandAst
Test-SlashOpsCommandSafety
Test-SlashOpsPathPolicy
Test-SlashOpsToolPolicy
Invoke-SlashOpsSecurityReview
Get-SlashOpsRiskClassification
```

#### Execution and logging

```powershell
Invoke-SlashOpsCommand
Write-SlashOpsTranscript
Get-SlashOpsHistory
Clear-SlashOpsHistory
Export-SlashOpsHistory
```

#### Utility

```powershell
Get-SlashOpsToolInventory
Test-SlashOpsTool
Get-SlashOpsSafeWriteRoot
Add-SlashOpsSafeWriteRoot
Remove-SlashOpsSafeWriteRoot
```


#### Agent and registered tools

```powershell
Resolve-SlashOpsIntent
New-SlashOpsPlan
Invoke-SlashOpsPlan
Get-SlashOpsTool
Register-SlashOpsTool
Invoke-SlashOpsTool
Test-SlashOpsToolManifest
Invoke-SlashOpsDocumentSummary
Find-SlashOpsDocument
Search-SlashOpsMail
```

### 6.2 Natural language input capture

Requirement:

SlashOps must accept all remaining arguments after the command prefix as the prompt.

Implementation pattern:

```powershell
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Prompt
)
$text = ($Prompt -join ' ')
```

Acceptance criteria:

- `/ find files` sends `find files` to the planner.
- `/ "find files with spaces"` preserves quoted text.
- Empty prompt displays help and exits with non-zero code only when used in non-interactive mode.
- Prompt capture works on Windows, macOS, Linux, and WSL under PowerShell 7+.

### 6.3 Environment context

SlashOps must collect and pass the following context to the model:

```json
{
  "current_datetime": "2026-04-26 14:30:00 +02:00",
  "timezone": "Europe/Zurich",
  "current_directory": "/Users/user/work/repo",
  "home_directory": "/Users/user",
  "downloads_directory": "/Users/user/Downloads",
  "os": "...",
  "platform": "Windows|macOS|Linux",
  "powershell_version": "7.x.x",
  "safe_write_roots": ["~/work", "~/Downloads", "~/Desktop"],
  "protected_roots": ["/", "~", "~/.ssh", "C:\\", "C:\\Windows"],
  "available_tools": ["git", "gh", "rg", "fd", "jq", "pandoc"],
  "mode": "/x",
  "policy_version": "1"
}
```

Acceptance criteria:

- `today`, `yesterday`, `this morning`, `last week`, and `recently` are resolvable from local date/time.
- `here` resolves to current directory.
- `downloads` resolves to platform-correct downloads path.
- unavailable tools are not used unless the model returns a dependency-needed plan.

### 6.4 Tool inventory

SlashOps must detect external tools using `Get-Command`.

Default tool inventory list:

```powershell
git, gh, rg, fd, fzf, jq, yq, pandoc, 7z, curl, code,
pdftotext, pdfinfo, magick, ffmpeg, duckdb, python, uv,
node, npm, pnpm, docker, kubectl, helm, terraform,
az, aws, gcloud, psql, sqlite3, sqlcmd, winget, scoop, choco, brew, apt, dnf, yum, pacman
```

Requirements:

- Inventory must be cached for a configurable duration, default 10 minutes.
- Inventory must include command name and resolved source path where possible.
- Inventory must distinguish required tools from optional tools.
- Missing tools must cause a `needs_dependency` response, not unsafe improvisation.

### 6.5 Model request contract

SlashOps must request structured JSON from the model.

Generation schema:

```json
{
  "schema_version": "1",
  "summary": "Short summary of intended action.",
  "command": "PowerShell 7 command or script block.",
  "risk_guess": "read-only|benign-write|risky-write|blocked|unknown",
  "requires_tools": ["pandoc"],
  "writes_files": true,
  "reads_files": true,
  "network_access": false,
  "cloud_mutation": false,
  "needs_dependency": false,
  "dependency_instructions": [],
  "expected_outputs": ["~/work/cv/file.pdf"],
  "undo_hint": "Delete the generated PDF files if needed.",
  "notes": []
}
```

Hard requirements:

- Model output must be parsed as JSON.
- Invalid JSON must trigger one repair attempt.
- If repair fails, SlashOps must not execute.
- Command must be PowerShell 7 syntax.
- Command must avoid aliases in generated output.
- Model must not return Markdown fences.
- Model must not return explanatory prose outside JSON.

### 6.6 Model system prompt

SlashOps must include a strong system prompt. Baseline:

```text
You convert natural language into PowerShell 7 commands for SlashOps.

Return only JSON matching the provided schema. Do not use Markdown. Do not include prose outside JSON.

Rules:
- Generate PowerShell 7 syntax only.
- Prefer full cmdlet names, not aliases.
- Use only tools listed as available in context.
- If a needed external tool is missing, set needs_dependency=true and provide dependency instructions; do not invent alternatives unless they are safe PowerShell-native equivalents.
- Prefer bounded operations.
- For file operations, use explicit paths and create destination folders if needed.
- Do not delete, overwrite, move broad paths, change permissions, install software, mutate cloud resources, change registry/system settings, elevate privileges, or execute remote scripts unless explicitly requested.
- For ambiguous cleanup/fix/sync requests, generate a preview/listing command rather than a mutation.
- Resolve relative time phrases using supplied local date/time/timezone.
- Resolve "here" as current_directory.
- Resolve "downloads" as downloads_directory.
- For "latest" or "newest", sort by LastWriteTime descending.
- For "today", use local calendar day from midnight to now.
- For "yesterday", use the previous local calendar day.
- For "this morning", use today from 00:00 to 12:00.
```

### 6.7 Safety classification

SlashOps must classify commands into exactly one of:

| Class | Meaning | `/x` behavior |
|---|---|---|
| `read-only` | No state change beyond reading/listing/opening. | Auto-execute. |
| `benign-write` | Bounded local write with no deletion, no privilege change, no remote mutation. | Auto-execute only if policy allows. |
| `risky-write` | Mutation that may overwrite, move broad sets, alter repo state, install packages, or change external state. | Require explicit confirmation. |
| `blocked` | Remote code execution, destructive broad delete, secrets exfiltration, privilege escalation, system mutation, encoded execution, or policy-denied operation. | Refuse execution. |
| `unknown` | Parser or policy cannot decide. | Treat as risky or blocked based on mode. |

### 6.8 Static safety scan

SlashOps must implement static safety patterns for at least:

#### Blocked patterns

- `Invoke-Expression`
- `iex`
- `curl ... | sh/bash/pwsh/powershell/iex`
- `Invoke-WebRequest ... | Invoke-Expression`
- `Set-ExecutionPolicy`
- `Format-Volume`
- `Clear-Disk`
- `Initialize-Disk`
- registry edits such as `reg add`, `reg delete`, `Set-ItemProperty` against registry providers
- `Start-Process -Verb RunAs`
- `sudo` unless explicitly configured and never in `/x`
- encoded commands such as `-EncodedCommand`
- credential/token scraping patterns
- deletion of protected roots
- unknown remote script execution

#### Risky patterns

- `Remove-Item`
- `Move-Item` with wildcards or recursion
- `Copy-Item -Force`
- `Set-Content` to existing files
- `Out-File` to existing files
- `git reset --hard`
- `git clean -f`
- `git push --force`
- `docker rm`, `docker rmi`, `docker system prune`
- `kubectl apply/delete/patch/scale`
- `terraform apply/destroy`
- `az/aws/gcloud create/update/delete/set`
- `rclone sync/delete/purge`
- `robocopy /MIR`
- package installs/upgrades/removals

#### Benign patterns

- `Set-Location`
- `Get-ChildItem`
- `Get-Content`
- `Select-String`
- `Sort-Object`
- `Select-Object`
- `Measure-Object`
- `git status/diff/log/show`
- `rg`
- `fd`
- `jq` read transforms
- `pandoc input -o output` when source and output are bounded
- `New-Item -ItemType Directory` inside safe write roots
- `Copy-Item` to explicit safe path without force
- `Move-Item` for explicit single file to safe path without force

### 6.9 PowerShell AST safety scan

SlashOps must parse generated commands using:

```powershell
[System.Management.Automation.Language.Parser]::ParseInput(...)
```

Requirements:

- Parse errors must prevent execution.
- Command AST nodes must be extracted.
- Command names and parameters must be compared to policy.
- String literal paths should be extracted where possible.
- Dynamic invocation should be suspicious.
- Script blocks with multiple commands must classify by highest risk.

### 6.10 Path policy

Default safe write roots:

- `~/work`
- `~/Downloads`
- `~/Desktop`
- current directory, if not a protected root and not under protected root exceptions

Default protected roots:

- `$HOME` itself as a broad target
- `~/.ssh`
- `~/.gnupg`
- `~/.aws`
- `~/.azure`
- `~/.kube`
- `~/.config` unless explicitly allowed
- `/`
- `/etc`
- `/usr`
- `/bin`
- `/sbin`
- `/System`
- `/Applications` for mutation
- `C:\`
- `C:\Windows`
- `C:\Program Files`
- `C:\Program Files (x86)`
- PowerShell profile paths unless explicitly requested

Requirements:

- Normalize `~`, `$HOME`, relative paths, and environment variables before policy checks where possible.
- `/x` must not write outside safe write roots.
- `/x` must not overwrite existing files unless policy explicitly allows and request explicitly asks.
- Broad wildcard writes must require confirmation.

### 6.11 AI security review

SlashOps must support optional AI security review. It is required for:

- `/!` strict mode
- `/` normal mode when classification is `risky-write` or `unknown`
- `/x` benign-write unless policy disables it for speed
- any command touching cloud, git mutation, packages, sync tools, or remote URLs

Security review schema:

```json
{
  "risk": "low|medium|high|block",
  "summary": "...",
  "reasons": ["..."],
  "safer_alternative": "..."
}
```

Rules:

- AI review cannot lower a blocked static classification.
- AI review can raise risk.
- AI review failure must prevent `/x` execution for write operations.

### 6.12 Execution gating

| Mode | read-only | benign-write | risky-write | blocked | unknown |
|---|---|---|---|---|---|
| `/` | Ask | Ask | Ask with warning | Refuse | Ask or refuse per policy |
| `//` | Never execute | Never execute | Never execute | Never execute | Never execute |
| `/x` | Auto | Auto if policy-approved | Stop and require normal `/` | Refuse | Stop |
| `/!` | Ask | Ask | Ask with strict warning | Refuse | Refuse |
| `/?` | Explain only | Explain only | Explain only | Explain only | Explain only |

### 6.13 Confirmation UX

Normal confirmation:

```text
Execute? [y/N]
```

High-risk confirmation:

```text
Type exactly EXECUTE to run this risky command:
```

Package install confirmation:

```text
This will install software. Type INSTALL to continue:
```

Cloud mutation confirmation:

```text
Cloud mutation is not allowed in fast mode. Type CLOUD to continue in normal mode:
```

### 6.14 Execution transcript

Every generated plan must be logged to JSONL.

Default path:

```text
~/.slashops/history.jsonl
```

Record fields:

```json
{
  "timestamp": "2026-04-26T12:30:00.0000000+02:00",
  "slashops_version": "0.1.0",
  "mode": "/x",
  "cwd": "...",
  "prompt": "...",
  "context_hash": "...",
  "model": "qwen3-coder:30b",
  "endpoint": "http://localhost:11434/v1/chat/completions",
  "generated_command": "...",
  "classification": "benign-write",
  "static_findings": [],
  "ai_review": {},
  "executed": true,
  "exit_code": 0,
  "duration_ms": 1234,
  "stdout_log": "~/.slashops/runs/<id>/stdout.txt",
  "stderr_log": "~/.slashops/runs/<id>/stderr.txt",
  "undo_hint": "..."
}
```

Requirements:

- Sensitive values must be redacted where detectable.
- Logs must be local only.
- User can disable transcript command output capture, but prompt/command/risk metadata should remain enabled by default.

### 6.15 Output rendering with FxConsole

SlashOps must use FxConsole for:

- banner during setup
- preflight checklist
- dependency status table
- generated command card
- risk summary card
- confirmation prompts
- execution spinner/progress
- success/error status
- transcript location panel

Example output sections:

```text
SLASHOPS // local-first pwsh AI

Preflight
✓ PowerShell 7.5.0
✓ Ollama reachable
✓ qwen3-coder:30b installed
✓ FxConsole loaded
✓ pandoc available

Generated Command
<command>

Safety
Risk: benign-write
Reason: bounded local PDF generation inside ~/work/cv

Result
✓ Completed in 1.8s
```

---

## 7. Tool-oriented agent runtime

### 7.1 Rationale

SlashOps must not treat every natural-language request as a shell command. Some requests are better served by registered tools that can search email, inspect local documents, extract PDF text, summarize files, or manipulate known business systems through authenticated APIs.

Examples that must not be solved by blind command generation alone:

```text
find an outlook email to mark about AI call answering
find the quote that I downloaded today
summarize this doc
draft a reply to the latest supplier quote
show me the PRs I reviewed yesterday
```

For these requests, Qwen should act as planner, classifier, translator, and summarizer. SlashOps must remain responsible for tool registration, tool execution, authentication boundaries, risk classification, confirmations, audit logging, and policy enforcement.

### 7.2 Agent architecture

The runtime flow is:

```text
User prompt
  -> Prefix/mode parser
  -> Context collector
  -> Intent classifier
  -> Planner
  -> Tool/command policy validation
  -> Execution gate
  -> Tool or command execution
  -> Observation capture
  -> Optional follow-up planning
  -> Final answer / result rendering
  -> Transcript logging
```

The model may propose tool calls, but the model must never execute tools directly. SlashOps executes only registered tools whose schemas, risk levels, and policy requirements are known.

### 7.3 Core principle

SlashOps must separate four concerns:

| Concern | Owner |
|---|---|
| Natural language interpretation | Qwen via Ollama |
| Tool schemas and execution | SlashOps PowerShell runtime |
| Safety, auth, confirmation, logging | SlashOps policy engine |
| Local system effects | PowerShell commands and registered provider modules |

### 7.4 Planner response contract

The planner must return strict JSON. Markdown is not allowed in model responses.

Minimum planner schema:

```json
{
  "schema_version": "1.0",
  "request_id": "generated-guid",
  "intent": "document_conversion",
  "summary": "Convert the two newest Markdown downloads to PDFs in ~/work/cv.",
  "risk_guess": "benign-write",
  "requires_confirmation": false,
  "requires_tools": ["local.files.search", "doc.markdown.convert"],
  "steps": [
    {
      "type": "tool_call",
      "tool": "local.files.search",
      "args": {
        "root": "~/Downloads",
        "extensions": ["md", "markdown"],
        "sort": "LastWriteTimeDescending",
        "limit": 2
      }
    },
    {
      "type": "tool_call",
      "tool": "doc.markdown.convert",
      "args": {
        "input_from_step": 1,
        "output_directory": "~/work/cv",
        "format": "pdf"
      }
    }
  ],
  "fallback_command": null,
  "undo_hint": "Delete the generated PDFs from ~/work/cv if needed."
}
```

For pure shell requests, the planner may return:

```json
{
  "schema_version": "1.0",
  "intent": "shell_command",
  "summary": "List the ten largest files in the current directory tree.",
  "risk_guess": "read-only",
  "requires_confirmation": false,
  "requires_tools": ["pwsh"],
  "steps": [
    {
      "type": "command",
      "shell": "pwsh",
      "command": "Get-ChildItem -Path . -File -Recurse | Sort-Object Length -Descending | Select-Object -First 10 FullName,Length"
    }
  ],
  "undo_hint": null
}
```

### 7.5 Intent taxonomy

SlashOps must classify requests before command generation. Initial intent types:

| Intent | Description | Typical risk |
|---|---|---|
| `shell_command` | Direct PowerShell command or script block | varies |
| `file_search` | Local file/path search | read-only |
| `document_text_search` | Search inside local documents | read-only |
| `document_summary` | Extract and summarize a document | read-only |
| `document_conversion` | Convert files, e.g. Markdown to PDF | benign-write if bounded |
| `email_search` | Search mail | read-only |
| `email_mutation` | Mark, move, categorize, archive mail | risky-write |
| `email_draft` | Draft email or reply without sending | benign-write/risky-write |
| `email_send` | Send mail | high-risk, confirmation required |
| `calendar_search` | Search calendar | read-only |
| `calendar_mutation` | Create/update/delete calendar items | risky-write |
| `git_read` | Status, diff, log, blame, show | read-only |
| `git_mutation` | commit, merge, rebase, reset, push | risky-write/high-risk |
| `github_read` | PR/issue/release search or view | read-only |
| `github_mutation` | Comment, label, merge, close | risky-write |
| `cloud_read` | Azure/AWS/GCP list/show/get | read-only/medium |
| `cloud_mutation` | Create/update/delete cloud resources | high-risk |
| `package_install` | Install/upgrade/uninstall tools | high-risk |
| `unknown` | Classification uncertain | fail closed |

The classifier must output confidence. Low confidence must downgrade execution mode to plan-only or confirmation-required.

### 7.6 Tool registry

SlashOps must include a tool registry. A tool is a PowerShell function plus metadata.

Tool metadata schema:

```json
{
  "name": "local.files.search",
  "display_name": "Search local files",
  "description": "Search local files by root, extension, date, name, and optional content.",
  "category": "local",
  "implemented_by": "PowerShell",
  "entrypoint": "Invoke-SlashOpsToolLocalFilesSearch",
  "mutates_state": false,
  "default_risk": "read-only",
  "requires_confirmation": false,
  "supports_fast_mode": true,
  "requires_auth": false,
  "required_commands": [],
  "supported_platforms": ["Windows", "Linux", "macOS"],
  "input_schema": {},
  "output_schema": {}
}
```

Registry requirements:

- Tools must be discoverable through `Get-SlashOpsTool`.
- Tool schemas must be serializable to JSON for prompting.
- Tools must declare whether they mutate state.
- Tools must declare whether `/x` may run them.
- Tools must declare dependency commands.
- Tools must declare authentication requirements.
- Tools must declare redaction rules for logs.
- Unregistered tools must never run.
- Unknown tool calls from the model must be blocked.

### 7.7 Required v0.2 local tools

These tools should be added before external business connectors:

| Tool | Purpose | Risk |
|---|---|---|
| `local.files.search` | Search files by path, date, extension, name | read-only |
| `local.files.content_search` | Search text within extracted/known text files | read-only |
| `local.files.open` | Open a file/folder in default app or VS Code | benign |
| `local.clipboard.read` | Read clipboard text/path where supported | read-only, privacy-sensitive |
| `doc.text.extract` | Extract text from TXT, MD, HTML, PDF, DOCX where supported | read-only |
| `doc.summarize` | Chunk and summarize local document text | read-only |
| `doc.markdown.convert` | Convert Markdown to PDF/DOCX/HTML via Pandoc | benign-write |
| `doc.pdf.inspect` | PDF metadata/text extraction via Poppler where available | read-only |
| `csv.inspect` | Inspect CSV shape/header/sample | read-only |
| `duckdb.query` | Query local CSV/Parquet/JSON with SQL | read-only unless output requested |

### 7.8 Optional v0.3 business/dev tools

| Tool | Provider | Purpose |
|---|---|---|
| `outlook.mail.search` | Microsoft Graph or Microsoft 365 CLI | Search mail |
| `outlook.mail.get` | Microsoft Graph or Microsoft 365 CLI | Fetch selected message metadata/body |
| `outlook.mail.mark` | Microsoft Graph or Microsoft 365 CLI | Mark/categorize/flag selected message |
| `outlook.mail.draft_reply` | Microsoft Graph or Microsoft 365 CLI | Draft reply, never send by default |
| `calendar.search` | Microsoft Graph or Microsoft 365 CLI | Search calendar |
| `calendar.draft_event` | Microsoft Graph or Microsoft 365 CLI | Draft event payload |
| `github.pr.search` | GitHub CLI | Search PRs |
| `github.issue.search` | GitHub CLI | Search issues |
| `github.pr.comment` | GitHub CLI | Add comment after confirmation |
| `git.status` | Git | Structured status |
| `git.diff` | Git | Structured diff summary |
| `git.branch_switch` | Git | Switch branch with guardrails |

### 7.9 Outlook/Microsoft 365 handling

SlashOps must remain cross-platform. Outlook automation must therefore avoid Windows-only COM automation for the core product.

Provider preference:

1. Microsoft Graph provider.
2. Microsoft 365 CLI provider if installed and authenticated.
3. Future optional Windows-only Outlook COM provider behind explicit platform flag.

Email flow requirements:

- `email_search` is read-only and may run in `/x`.
- `email_mutation` must require explicit confirmation.
- `email_send` must never run via `/x`.
- Search results must show sender, subject, received time, folder, and short snippet.
- Full body logging must be disabled by default.
- Message IDs may be logged; subject/sender logging is configurable.
- Marking/categorizing/moving a message must show selected message before mutation.
- Drafting a reply must create a draft only, never send unless a future high-risk confirmed send flow is implemented.

Example flow:

```text
/ find an outlook email to mark about AI call answering
```

Expected behavior:

1. Classify as `email_search` plus requested `email_mutation`.
2. Search Outlook/Microsoft 365 for `"AI call answering"`.
3. Display top ranked matches.
4. Ask user to choose message.
5. Display proposed mutation: mark/flag/categorize.
6. Require explicit confirmation.
7. Apply mutation.
8. Log minimal metadata.

### 7.10 Document resolution

For prompts such as `summarize this doc`, SlashOps must resolve "this" deterministically.

Resolution order:

1. Explicit path in prompt.
2. Pipeline input.
3. Last SlashOps result.
4. Current directory if exactly one likely document is present.
5. Clipboard path/text if clipboard access is enabled.
6. Most recent downloaded document.
7. Interactive choice list.
8. Ask for clarification.

Likely document extensions:

```text
.pdf, .docx, .txt, .md, .markdown, .html, .htm, .rtf, .csv, .json, .yaml, .yml
```

Document tasks must not send raw documents outside the local Ollama endpoint. For very large documents, SlashOps must chunk locally and summarize in stages.

### 7.11 Local document search

For prompts such as:

```text
find the quote that I downloaded today
```

SlashOps should:

1. Resolve date phrase using local date/time/timezone context.
2. Resolve `downloaded` to configured Downloads directory.
3. Search files modified or created today.
4. Prefer business document names containing `quote`, `quotation`, `proposal`, `estimate`, `invoice`, `pricing`, or user-provided keywords.
5. Extract text where possible.
6. Rank by filename, metadata, text matches, recency, and file type.
7. Show ranked candidates and snippets.
8. Open/summarize/convert only after next instruction or explicit mode.

This flow is `/x` eligible when read-only.

### 7.12 Agent loop

v0.4 should support a bounded agent loop:

```text
plan -> execute registered tool -> observe -> re-plan -> execute registered tool -> final response
```

Hard limits:

- max steps default: 5
- max tool calls default: 8
- max model calls default: 5
- max wall clock default: configurable, default 120 seconds
- any mutation pauses the loop for confirmation
- any unknown risk stops the loop
- any auth prompt stops and asks user to authenticate manually

### 7.13 Observation handling

Tool outputs must be converted into structured observations before being returned to the planner.

Observation schema:

```json
{
  "step_id": "step-1",
  "tool": "local.files.search",
  "success": true,
  "risk": "read-only",
  "items": [],
  "summary": "Found 3 matching documents downloaded today.",
  "redactions_applied": []
}
```

Raw stdout should not be sent back to the model if a structured object is available. Large outputs must be summarized or truncated with user-visible note.

### 7.14 Safety matrix for tools

| Tool/action category | `/x` allowed | Confirmation |
|---|---:|---:|
| Local file search | Yes | No |
| Local content search | Yes | No |
| Local summarize | Yes | No |
| Local conversion to new file | Yes if bounded | Maybe |
| Open file/folder | Yes if local | Maybe |
| Clipboard read | Configurable | Maybe |
| Email search | Yes | No |
| Email mark/move/categorize | No | Yes |
| Email draft | No by default | Yes |
| Email send | Never | Always / future only |
| Calendar search | Yes | No |
| Calendar create/update/delete | No | Yes |
| Git status/diff/log | Yes | No |
| Git commit/merge/rebase/reset/push | No | Yes/high-risk |
| Cloud list/show | Configurable | Maybe |
| Cloud create/update/delete | No | Always |
| Package install/upgrade/uninstall | No | Always |
| Delete files | No | Always or blocked |
| Remote script execution | Never | Blocked |

### 7.15 Tool prompting rules

When registered tools are available, the model prompt must include:

- the intent taxonomy
- the current execution mode
- relevant environment context
- effective policy summary
- registered tool schemas
- available external CLI tools
- examples of valid tool-call JSON
- rules that unregistered tools are forbidden
- rules that mutations require confirmation unless policy explicitly permits

The model must be told:

```text
You may propose registered tool calls or a PowerShell command.
You do not execute anything.
SlashOps will validate and execute only registered tools or safe PowerShell.
Return JSON only.
```

### 7.16 Tool result UI

FxConsole should render tool workflows as:

- banner: SlashOps plan
- intent and risk card
- step table
- dependency status table
- search results table
- confirmation card for mutations
- execution result card
- warning panel for blocked/risky actions

### 7.17 Tool privacy

Tool outputs may contain sensitive business data. SlashOps must:

- keep local by default
- avoid logging full email/document bodies by default
- log file paths and hashes rather than full content where possible
- redact secrets before prompt/logging
- allow `config.privacy.logContent = false`
- allow `config.privacy.sendDocumentTextToModel = true` only for local Ollama by default
- require explicit policy to use any future remote provider for document/email contents

---

## 8. Installation and setup requirements

### 8.1 PowerShell Gallery installation

Primary user install:

```powershell
Install-Module SlashOps -Scope CurrentUser
Import-Module SlashOps
Initialize-SlashOps
```

Upgrade:

```powershell
Update-Module SlashOps
```

Uninstall:

```powershell
Uninstall-Module SlashOps
```

### 8.2 Module manifest requirements

`SlashOps.psd1` must include:

```powershell
@{
    RootModule = 'SlashOps.psm1'
    ModuleVersion = '0.1.0'
    GUID = '<stable-guid>'
    Author = 'Andre Sharpe'
    CompanyName = 'Unknown or personal'
    Copyright = '(c) 2026 Andre Sharpe. All rights reserved.'
    Description = 'Local-first natural language command assistant for cross-platform PowerShell 7+, powered by Ollama and Qwen.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @(...)
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @('/', '//', '/x', '/!', '/?')
    PrivateData = @{
        PSData = @{
            Tags = @('PowerShell', 'AI', 'Ollama', 'Qwen', 'CLI', 'Terminal', 'Automation', 'CrossPlatform')
            LicenseUri = 'https://github.com/andresharpe/SlashOps/blob/main/LICENSE'
            ProjectUri = 'https://github.com/andresharpe/SlashOps'
            ReleaseNotes = 'Initial preview release.'
        }
    }
}
```

### 8.3 Dependency strategy

SlashOps has three dependency categories.

#### Required runtime dependencies

- PowerShell 7+
- Ollama executable and running service/app
- configured local model, default `qwen3-coder:30b`

#### Bundled or required module dependency

- FxConsole

Recommended v1 approach:

1. Vendor FxConsole source under `src/SlashOps/vendor/FxConsole` or `src/FxConsole` with license preserved.
2. Import FxConsole internally from vendored path.
3. Revisit as a gallery dependency once FxConsole itself is published and versioned as a module.

Rationale:

- FxConsole README currently says to copy `src/FxConsole/` into a project.
- FxConsole currently has zero external module dependencies.
- Vendoring ensures Gallery users get a working UI without manual GitHub cloning.

Required compliance:

- Preserve FxConsole MIT license.
- Document the vendored source version/commit.
- Add tests to ensure `Import-Module` works with vendored FxConsole.

#### Optional external CLIs

Detected but not installed by default unless user confirms:

- `git`
- `gh`
- `rg`
- `fd`
- `fzf`
- `jq`
- `yq`
- `pandoc`
- `7z`
- `pdftotext`
- `pdfinfo`
- `magick`
- `ffmpeg`
- `duckdb`
- `python`
- `uv`
- `node`
- `docker`
- `kubectl`
- cloud CLIs

### 8.4 Initialize-SlashOps flow

`Initialize-SlashOps` must be idempotent and interactive by default.

Steps:

1. Display FxConsole banner.
2. Check PowerShell version.
3. Check OS/platform.
4. Check terminal capabilities.
5. Check whether Ollama is installed.
6. If missing, offer install instructions or guided install.
7. Check whether Ollama server is reachable.
8. If installed but not running, offer to start it.
9. Check whether default model exists.
10. If missing, ask to pull model.
11. Check optional CLI inventory.
12. Ask whether to add aliases to profile.
13. Load effective configuration from defaults, user config, user policy, project config, environment variables, and command parameters.
14. Write or validate default config at `~/.slashops/config.json`.
15. Write or validate default policy at `~/.slashops/policy.json`.
16. Run preflight test using effective configuration.
17. Display final success panel.

### 8.5 Ollama installation behavior

`Install-SlashOpsOllama` must never install silently.

Behavior by platform:

#### Windows

Preferred:

- detect `ollama` using `Get-Command`
- if missing, detect `winget`
- offer:

```powershell
winget install Ollama.Ollama
```

Fallback:

- print official download URL and instructions
- do not download EXE directly unless explicitly implemented with checksum verification

#### macOS

Preferred:

- detect `ollama`
- if missing, detect `brew`
- offer:

```powershell
brew install --cask ollama
```

Fallback:

- print official download instructions
- optionally support official install script only with explicit confirmation

#### Linux

Preferred:

- detect `ollama`
- offer official install command only after warning:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Security requirement:

- Because this is remote script execution, SlashOps must not auto-run it in `/x` or setup without explicit typed confirmation.
- Display the command and link to official docs.
- Allow user to copy/paste manually.

### 8.6 Model installation behavior

`Install-SlashOpsModel` must:

1. Check model presence via `ollama list` or `/v1/models`.
2. If missing, show model size and expected disk requirements.
3. Ask confirmation:

```text
Pull qwen3-coder:30b using Ollama? This may download about 19GB. Type PULL to continue:
```

4. Run:

```powershell
ollama pull qwen3-coder:30b
```

5. Verify model appears after pull.
6. Run a small test prompt.

### 8.7 Optional CLI installation behavior

SlashOps must not install optional CLIs during module install.

`Initialize-SlashOps -InstallRecommendedTools` may offer a menu:

- document tools: `pandoc`, `poppler`, `7zip`
- dev tools: `git`, `gh`, `rg`, `fd`, `jq`, `yq`, `fzf`
- data tools: `duckdb`, `xsv` or `csvkit`
- media tools: `imagemagick`, `ffmpeg`

Rules:

- Show package manager command before execution.
- Require confirmation.
- Prefer platform package manager.
- Never use curl-piped shell for optional tools.
- Continue gracefully when a package manager is unavailable.

### 8.8 Profile setup

SlashOps should provide:

```powershell
Install-SlashOpsProfile
Uninstall-SlashOpsProfile
Test-SlashOpsProfile
```

Profile install behavior:

- Detect `$PROFILE.CurrentUserCurrentHost`.
- Create profile if missing after confirmation.
- Add a clearly marked block:

```powershell
# >>> SlashOps >>>
Import-Module SlashOps
Set-Alias / Invoke-SlashOps
Set-Alias // Invoke-SlashOpsGenerateOnly
Set-Alias /x Invoke-SlashOpsFast
Set-Alias /! Invoke-SlashOpsStrict
Set-Alias /? Invoke-SlashOpsExplain
# <<< SlashOps <<<
```

- Do not duplicate blocks.
- Support removal.

### 8.9 Preflight test

`Test-SlashOpsPreflight` must validate:

- PowerShell 7+
- module manifest loads
- FxConsole loads
- config readable/writable
- policy readable/writable
- effective config merge succeeds
- project config is applied or skipped according to settings
- history path writable
- Ollama executable found
- Ollama server reachable
- default model installed
- model can return valid JSON
- static safety scanner works
- AST parser works
- aliases installed if requested
- optional tools inventory works

Output must include:

- status table
- remediation commands
- final pass/fail boolean

Example:

```powershell
Test-SlashOpsPreflight -Detailed
```

Returns object:

```powershell
[pscustomobject]@{
    Passed = $true
    Checks = @(...)
    MissingRequired = @()
    MissingOptional = @('pandoc')
    Remediation = @(...)
}
```

---

## 9. Configuration

Configuration is a first-class SlashOps subsystem. It must be predictable, editable, inspectable, testable, and safe. Configuration must not be hidden inside the PowerShell profile. The profile may only import the module and create aliases; all behavior must be controlled by JSON config, environment variables, command parameters, and built-in defaults.

### 9.1 Configuration principles

SlashOps configuration must follow these principles:

1. **Safe by default:** first-run defaults must prevent destructive execution, remote script execution, privilege elevation, and broad writes.
2. **Local-first:** config files live under the user profile by default and do not require cloud storage.
3. **Layered:** command-line flags override environment variables, which override project config, which override user config, which override module defaults.
4. **Explicit policy separation:** user preferences and safety policy must be separate files so users can adjust UI/model settings without accidentally weakening safety policy.
5. **Human-editable:** JSON must be formatted with stable ordering and indentation.
6. **Script-editable:** every important setting must be readable and writable with SlashOps commands.
7. **Cross-platform:** paths must support Windows, macOS, Linux, and WSL under PowerShell 7+.
8. **Schema-versioned:** every persisted config file must include `schema_version`.
9. **Migration-ready:** older schema versions must be migrated or rejected with clear remediation.
10. **Fail closed:** unreadable, invalid, or policy-invalid configuration must prevent execution unless the operation is strictly read-only and policy permits fallback defaults.

### 9.2 Configuration files and directories

Default directory:

```text
~/.slashops/
```

Default files:

```text
~/.slashops/config.json       user preferences and model/runtime settings
~/.slashops/policy.json       safety policy, command classes, protected roots
~/.slashops/history.jsonl     append-only execution transcript
~/.slashops/cache.json        non-sensitive cache metadata
~/.slashops/runs/             per-run stdout/stderr logs
~/.slashops/backups/          timestamped backups before config migrations
```

Optional project file:

```text
./.slashops.json
```

Environment overrides:

```text
SLASHOPS_HOME                 override ~/.slashops directory
SLASHOPS_CONFIG               override user config path
SLASHOPS_POLICY               override user policy path
SLASHOPS_PROJECT_CONFIG       override project config path
SLASHOPS_MODEL                override generation model
SLASHOPS_REVIEW_MODEL         override security-review model
SLASHOPS_ENDPOINT             override chat completions endpoint
SLASHOPS_NO_PROJECT_CONFIG    when set to 1, disable project config loading
SLASHOPS_NO_AI_REVIEW         when set to 1, disable optional AI review only where policy permits
SLASHOPS_NONINTERACTIVE       when set to 1, no prompts; require explicit flags for setup actions
```

Acceptance criteria:

- `Get-SlashOpsConfigPath` resolves the same default paths on all platforms using `$HOME`.
- `SLASHOPS_HOME` changes all default paths consistently.
- `SLASHOPS_CONFIG` and `SLASHOPS_POLICY` may point outside `SLASHOPS_HOME`, but must still be readable and schema-valid.
- No config write may occur during `Import-Module`; writes only occur during `Initialize-SlashOps`, explicit setters, migration, or setup commands.

### 9.3 Configuration precedence

Effective configuration must be composed in this order, lowest to highest precedence:

```text
1. Module defaults
2. User config: ~/.slashops/config.json
3. User policy: ~/.slashops/policy.json
4. Project config: ./.slashops.json
5. Environment variables
6. Explicit command parameters
```

Important rules:

- Safety policy can only be weakened by files explicitly allowed by policy.
- By default, project config may make policy stricter but may not weaken protected roots, enable dangerous `/x` behavior, or disable blocked patterns.
- A project config can add safe write roots relative to the project, but cannot remove global protected roots unless `policy.allowProjectPolicyRelaxation` is true in the user policy.
- CLI flags may temporarily change runtime behavior but must not persist unless `Set-SlashOpsConfig` or `Set-SlashOpsPolicy` is used.
- `Get-SlashOpsEffectiveConfig` must show the final merged config and include source metadata for each resolved value when `-Detailed` is used.

Example precedence behavior:

```powershell
# Temporary only. Does not write config.
/ -Model qwen3-coder:30b find markdown files from today

# Persistent user config change.
Set-SlashOpsConfig model.generationModel qwen3-coder:30b
```

### 9.4 User config schema

Default `~/.slashops/config.json`:

```json
{
  "schema_version": "1",
  "model": {
    "provider": "ollama",
    "endpoint": "http://localhost:11434/v1/chat/completions",
    "modelsEndpoint": "http://localhost:11434/v1/models",
    "apiKey": "ollama",
    "generationModel": "qwen3-coder:30b",
    "reviewModel": "qwen3-coder:30b",
    "temperature": 0.1,
    "topP": null,
    "timeoutSeconds": 60,
    "repairAttempts": 1,
    "jsonMode": true
  },
  "execution": {
    "defaultMode": "/",
    "allowFastExecution": true,
    "fastModeAllowsBenignWrites": true,
    "fastModeRequiresAiReviewForWrites": true,
    "confirmReadOnlyInNormalMode": true,
    "confirmBenignWriteInNormalMode": true,
    "captureStdoutStderr": true,
    "maxStdoutBytes": 1048576,
    "maxStderrBytes": 1048576,
    "defaultNonInteractiveAction": "refuse"
  },
  "ui": {
    "useFxConsole": true,
    "theme": "amber",
    "showGeneratedCommand": true,
    "showRiskSummary": true,
    "showUndoHints": true,
    "showContextSummary": false,
    "showDependencyTable": true,
    "tableBorderStyle": "Rounded"
  },
  "context": {
    "includeDateTime": true,
    "includeTimezone": true,
    "includeCurrentDirectory": true,
    "includeHomeDirectory": true,
    "includeDownloadsDirectory": true,
    "includeOs": true,
    "includePowerShellVersion": true,
    "includeAvailableTools": true,
    "includeGitContext": true,
    "includePolicySummary": true,
    "maxContextBytes": 32768
  },
  "tools": {
    "inventoryCacheMinutes": 10,
    "preferredTools": [
      "git", "gh", "rg", "fd", "fzf", "jq", "yq", "pandoc", "7z",
      "curl", "code", "pdftotext", "pdfinfo", "magick", "ffmpeg",
      "duckdb", "python", "uv", "node", "npm", "pnpm", "docker",
      "kubectl", "helm", "terraform", "az", "aws", "gcloud",
      "psql", "sqlite3", "sqlcmd", "winget", "scoop", "choco",
      "brew", "apt", "dnf", "yum", "pacman"
    ],
    "installRecommendedToolsByDefault": false
  },
  "logging": {
    "enabled": true,
    "historyPath": "~/.slashops/history.jsonl",
    "runsPath": "~/.slashops/runs",
    "captureCommandOutput": true,
    "redactSecrets": true,
    "retentionDays": 90,
    "maxRunLogBytes": 1048576
  },
  "cache": {
    "enabled": true,
    "path": "~/.slashops/cache.json",
    "ollamaHealthSeconds": 300,
    "toolInventorySeconds": 600,
    "environmentContextSeconds": 30,
    "safetyReviewSeconds": 3600
  }
}
```


### 9.5 Tool runtime configuration

The main config must include a tool-runtime subsection. This section controls registered tool availability, agent loop limits, document handling, Outlook provider preferences, and privacy defaults.

Example addition:

```json
{
  "agent": {
    "enabled": true,
    "maxSteps": 5,
    "maxToolCalls": 8,
    "maxModelCalls": 5,
    "maxWallClockSeconds": 120,
    "allowMultiStepReadOnlyFastMode": true,
    "pauseBeforeMutation": true,
    "failOnUnknownTool": true,
    "failOnLowIntentConfidence": true,
    "minimumIntentConfidence": 0.65
  },
  "toolRegistry": {
    "enabled": true,
    "registryPath": "~/.slashops/tools",
    "allowUserTools": false,
    "allowProjectTools": false,
    "enabledTools": [
      "local.files.search",
      "local.files.content_search",
      "doc.text.extract",
      "doc.summarize",
      "doc.markdown.convert",
      "doc.pdf.inspect",
      "csv.inspect",
      "duckdb.query"
    ],
    "disabledTools": []
  },
  "documents": {
    "downloadsDirectory": "~/Downloads",
    "defaultSummaryStyle": "business",
    "maxDocumentBytes": 52428800,
    "maxExtractedTextBytes": 2097152,
    "chunkSizeChars": 12000,
    "chunkOverlapChars": 800,
    "preferPandoc": true,
    "preferPoppler": true,
    "summarizeWithCitations": true
  },
  "outlook": {
    "enabled": false,
    "provider": "graph",
    "allowSearchFastMode": true,
    "allowMutationFastMode": false,
    "logSubjects": true,
    "logSenders": false,
    "logBody": false,
    "maxSearchResults": 10,
    "requireConfirmationForMark": true,
    "requireConfirmationForMove": true,
    "requireConfirmationForSend": true
  },
  "privacy": {
    "logContent": false,
    "logDocumentText": false,
    "logEmailBody": false,
    "sendDocumentTextToModel": true,
    "sendEmailBodyToModel": false,
    "allowRemoteProviderForSensitiveContent": false,
    "redactBeforeModel": true
  }
}
```

Tool configuration requirements:

- Tool runtime must be enabled by default for local read-only tools.
- Outlook/email tools must be disabled by default until configured.
- Project config must not be allowed to enable user tools or Outlook tools by default.
- User-defined tools are out of scope for v0.1 and v0.2.
- All tool config must be visible through `Get-SlashOpsEffectiveConfig`.
- All tool config must be covered by Pester tests.
- Privacy defaults must prefer minimal logging and local-only model calls.

Naming convention:

- JSON persisted config uses camelCase.
- PowerShell parameters use PascalCase.
- Public setting paths are dot-separated camelCase, such as `model.generationModel`.

### 9.6 Policy config schema

Default `~/.slashops/policy.json`:

```json
{
  "schema_version": "1",
  "policy": {
    "allowProjectPolicyRelaxation": false,
    "safeWriteRoots": [
      "~/work",
      "~/Downloads",
      "~/Desktop"
    ],
    "allowCurrentDirectoryAsSafeWriteRoot": true,
    "protectedRoots": [
      "~",
      "~/.ssh",
      "~/.gnupg",
      "~/.aws",
      "~/.azure",
      "~/.kube",
      "~/.config",
      "/",
      "/etc",
      "/usr",
      "/bin",
      "/sbin",
      "/System",
      "/Applications",
      "C:/",
      "C:/Windows",
      "C:/Program Files",
      "C:/Program Files (x86)"
    ],
    "neverFastExecute": [
      "Remove-Item",
      "Set-ExecutionPolicy",
      "Invoke-Expression",
      "Start-Process -Verb RunAs",
      "sudo",
      "git push",
      "git reset",
      "git clean",
      "kubectl apply",
      "kubectl delete",
      "terraform apply",
      "terraform destroy",
      "az * delete",
      "aws * delete",
      "gcloud * delete",
      "rclone sync",
      "rclone delete",
      "robocopy /MIR"
    ],
    "fastAllowedCommands": [
      "Set-Location",
      "Get-Location",
      "Get-ChildItem",
      "Get-Content",
      "Select-String",
      "Sort-Object",
      "Select-Object",
      "Measure-Object",
      "New-Item",
      "Copy-Item",
      "Move-Item",
      "pandoc",
      "git",
      "gh",
      "rg",
      "fd",
      "jq",
      "yq",
      "pdfinfo",
      "pdftotext",
      "code"
    ],
    "blockedRegexPatterns": [
      "(?i)\\bInvoke-Expression\\b",
      "(?i)\\biex\\b",
      "(?i)\\bSet-ExecutionPolicy\\b",
      "(?i)\\b-EncodedCommand\\b",
      "(?i)(curl|Invoke-WebRequest|iwr|wget).*\\|.*(sh|bash|pwsh|powershell|iex|Invoke-Expression)",
      "(?i)\\bFormat-Volume\\b",
      "(?i)\\bClear-Disk\\b",
      "(?i)\\bInitialize-Disk\\b",
      "(?i)\\bStart-Process\\b.*\\b-Verb\\s+RunAs\\b"
    ],
    "riskyRegexPatterns": [
      "(?i)\\bRemove-Item\\b",
      "(?i)\\bMove-Item\\b.*[*]",
      "(?i)\\bCopy-Item\\b.*\\b-Force\\b",
      "(?i)\\bgit\\s+reset\\s+--hard\\b",
      "(?i)\\bgit\\s+clean\\b.*-f",
      "(?i)\\bgit\\s+push\\b.*--force",
      "(?i)\\bdocker\\s+(rm|rmi|system\\s+prune)\\b",
      "(?i)\\bkubectl\\s+(apply|delete|patch|scale)\\b",
      "(?i)\\bterraform\\s+(apply|destroy)\\b",
      "(?i)\\b(az|aws|gcloud)\\b.*\\b(create|update|delete|set)\\b",
      "(?i)\\brclone\\s+(sync|delete|purge)\\b",
      "(?i)\\brobocopy\\b.*\\/MIR\\b"
    ],
    "blockedBehavior": {
      "blockRemoteScriptExecution": true,
      "blockPrivilegeElevation": true,
      "blockEncodedCommands": true,
      "blockCloudMutationInFastMode": true,
      "blockPackageInstallInFastMode": true,
      "blockSecretsExfiltration": true
    },
    "confirmation": {
      "riskyWriteToken": "EXECUTE",
      "packageInstallToken": "INSTALL",
      "cloudMutationToken": "CLOUD",
      "modelPullToken": "PULL"
    }
  }
}
```

### 9.7 Project config schema

Project config lives at `./.slashops.json`. It is optional and must be discovered by walking upward from the current directory until a file is found or the filesystem root is reached.

Example:

```json
{
  "schema_version": "1",
  "execution": {
    "allowFastExecution": false
  },
  "context": {
    "includeGitContext": true
  },
  "tools": {
    "preferredTools": [
      "git", "gh", "rg", "fd", "jq", "pandoc", "docker"
    ]
  },
  "policy": {
    "safeWriteRoots": [
      ".",
      "./docs",
      "./reports"
    ],
    "additionalBlockedRegexPatterns": [
      "(?i)\\bterraform\\b"
    ]
  }
}
```

Project config rules:

- Relative project paths resolve relative to the project config file location.
- Project config may disable `/x` for a repository.
- Project config may add additional blocked/risky patterns.
- Project config may add safe write roots inside the project.
- Project config may not remove user protected roots by default.
- Project config may not disable transcript logging unless user config allows project logging overrides.

### 9.8 Config commands

SlashOps must expose these public commands:

```powershell
Get-SlashOpsConfig
Get-SlashOpsEffectiveConfig
Set-SlashOpsConfig
Edit-SlashOpsConfig
Reset-SlashOpsConfig
Test-SlashOpsConfig
Get-SlashOpsPolicy
Set-SlashOpsPolicy
Edit-SlashOpsPolicy
Test-SlashOpsPolicy
Get-SlashOpsConfigPath
```

Command requirements:

#### `Get-SlashOpsConfig`

- Returns user config as an object.
- Supports `-Raw` to return raw JSON text.
- Supports `-Path` for alternate config.

#### `Get-SlashOpsEffectiveConfig`

- Returns fully merged config.
- Supports `-Detailed` to include source attribution for settings.
- Must include whether project config was found and applied.

#### `Set-SlashOpsConfig`

Examples:

```powershell
Set-SlashOpsConfig model.generationModel qwen3-coder:30b
Set-SlashOpsConfig ui.theme cyan
Set-SlashOpsConfig execution.allowFastExecution true
Set-SlashOpsConfig tools.preferredTools -Value @('git','rg','fd','jq','pandoc')
```

Requirements:

- Accept dot-path setting names.
- Validate setting exists unless `-AllowNew` is used.
- Preserve JSON formatting.
- Create timestamped backup before write.
- Validate schema after write.
- Fail and restore backup on invalid result.

#### `Edit-SlashOpsConfig` and `Edit-SlashOpsPolicy`

- Open config in `$env:EDITOR`, `$env:VISUAL`, VS Code if `code` exists, or platform default editor.
- Before opening, ensure file exists.
- After editor exits, validate schema.
- If invalid, show errors and offer to restore backup.

#### `Reset-SlashOpsConfig`

- Requires confirmation.
- Backs up old config.
- Rewrites defaults.
- Does not delete history.

#### `Test-SlashOpsConfig` and `Test-SlashOpsPolicy`

- Validate JSON parse.
- Validate schema version.
- Validate required fields.
- Validate endpoint URI format.
- Validate model names are non-empty strings.
- Validate timeout and cache durations are non-negative.
- Validate paths can be expanded.
- Validate regex patterns compile.
- Validate protected roots do not overlap unsafe wildcard patterns.
- Return structured result with `Passed`, `Errors`, `Warnings`, and `Path`.

### 9.9 First-run config creation

`Initialize-SlashOps` must create config files before runtime/model setup so all later steps can use configured values.

Required order:

1. Resolve `SLASHOPS_HOME`.
2. Create SlashOps directory.
3. Create `config.json` from defaults if missing.
4. Create `policy.json` from defaults if missing.
5. Validate both files.
6. Load effective config.
7. Continue Ollama/model/tool/profile setup.
8. Run preflight test using effective config.

Interactive first-run prompts:

```text
Create SlashOps config at ~/.slashops/config.json? [Y/n]
Create SlashOps safety policy at ~/.slashops/policy.json? [Y/n]
Use qwen3-coder:30b as default local model? [Y/n]
Enable /x fast mode for read-only and bounded benign local writes? [Y/n]
Add SlashOps aliases to your PowerShell profile? [y/N]
```

Non-interactive first-run behavior:

- If `-AcceptDefaults` is supplied, create defaults without prompting.
- If `SLASHOPS_NONINTERACTIVE=1` and no `-AcceptDefaults`, fail with remediation instructions.
- Never pull models, install Ollama, or modify profile without explicit flags in non-interactive mode.

### 9.10 Config migration

SlashOps must include migration support from schema version to schema version.

Requirements:

- `Test-SlashOpsConfig` detects older schema versions.
- `Initialize-SlashOps` offers migration when old schema is found.
- Migration creates backup first.
- Migration writes a `migration_log` entry in config or history.
- Unknown future schema versions must not be modified automatically.

Example backup path:

```text
~/.slashops/backups/config.2026-04-26T143012.v1.json
```

### 9.11 Cache config

Cache must never be the source of truth. It may only speed up:

- Ollama health checks
- model list results
- tool inventory
- environment context
- safety review result for exact command hash

Cache invalidation rules:

- Config mtime change invalidates effective config cache.
- Policy mtime change invalidates safety and review cache.
- Tool inventory cache expires after `tools.inventoryCacheMinutes`.
- Safety review cache key includes generated command, policy version, review model, and normalized path context.

### 9.12 Config and safety interaction

Configuration must not allow trivial bypass of core safety. Hard-coded safety floor:

- Remote script execution remains blocked by default and cannot be allowed in `/x`.
- Privilege elevation remains blocked in `/x`.
- Encoded command execution remains blocked in `/x`.
- Broad deletion of protected roots remains blocked in all modes.
- Cloud mutation remains blocked in `/x`.
- Package install remains blocked in `/x`.

Config can make SlashOps stricter than defaults at any level. Config can make SlashOps less strict only where the safety floor explicitly permits it and only from user policy, not project config.

### 9.13 Config TDD requirements

Pester tests must cover:

- default path resolution
- `SLASHOPS_HOME` override
- `SLASHOPS_CONFIG` override
- `SLASHOPS_POLICY` override
- missing config creation
- missing policy creation
- valid config load
- invalid JSON failure
- invalid schema failure
- future schema refusal
- migration backup creation
- project config discovery
- disabling project config with `SLASHOPS_NO_PROJECT_CONFIG`
- precedence order across defaults, user, project, env, and CLI
- project config cannot weaken protected roots by default
- project config can make policy stricter
- `Set-SlashOpsConfig` writes backup and validates result
- `Edit-SlashOpsConfig` validates after edit
- `Reset-SlashOpsConfig` preserves history
- regex patterns in policy compile
- effective config source attribution

---

## 10. Architecture

### 10.1 Proposed repository structure

```text
SlashOps/
  README.md
  LICENSE
  PRD.md
  CHANGELOG.md
  src/
    SlashOps/
      SlashOps.psd1
      SlashOps.psm1
      Public/
        Invoke-SlashOps.ps1
        Invoke-SlashOpsFast.ps1
        Invoke-SlashOpsGenerateOnly.ps1
        Invoke-SlashOpsStrict.ps1
        Invoke-SlashOpsExplain.ps1
        Initialize-SlashOps.ps1
        Install-SlashOpsRuntime.ps1
        Test-SlashOpsPreflight.ps1

        # Config/public state
        Get-SlashOpsConfig.ps1
        Set-SlashOpsConfig.ps1
        Edit-SlashOpsConfig.ps1
        Reset-SlashOpsConfig.ps1
        Test-SlashOpsConfig.ps1
        Get-SlashOpsPolicy.ps1
        Set-SlashOpsPolicy.ps1
        Test-SlashOpsPolicy.ps1
        Get-SlashOpsEffectiveConfig.ps1
        Get-SlashOpsHistory.ps1

        # Tool runtime
        Get-SlashOpsTool.ps1
        Test-SlashOpsTool.ps1
        Invoke-SlashOpsTool.ps1
        Register-SlashOpsTool.ps1
        Resolve-SlashOpsIntent.ps1
        New-SlashOpsPlan.ps1
        Invoke-SlashOpsPlan.ps1

      Private/
        Config/
          Get-ConfigPath.ps1
          Read-Config.ps1
          Write-Config.ps1
          Merge-Config.ps1
          Test-ConfigSchema.ps1
          Test-PolicySchema.ps1
          ConvertTo-ConfigBackup.ps1
          Invoke-ConfigMigration.ps1
          Resolve-ProjectConfig.ps1
          Set-ConfigValue.ps1
          Get-EffectiveConfig.ps1

        Context/
          ConvertTo-PromptContext.ps1
          Get-ToolInventory.ps1
          Get-GitContext.ps1
          Get-TimeContext.ps1
          Get-LocationContext.ps1
          Resolve-DownloadsPath.ps1

        Model/
          Invoke-OllamaChat.ps1
          Invoke-IntentClassifier.ps1
          Invoke-Planner.ps1
          Invoke-Summarizer.ps1
          Repair-ModelJson.ps1
          Test-Ollama.ps1

        Agent/
          Resolve-Intent.ps1
          New-Plan.ps1
          Test-PlanSchema.ps1
          Invoke-AgentLoop.ps1
          ConvertTo-Observation.ps1
          Compress-Observation.ps1
          Resolve-DocumentReference.ps1
          Resolve-ToolCall.ps1

        Tools/
          Registry/
            Get-ToolRegistry.ps1
            Read-ToolManifest.ps1
            Test-ToolManifest.ps1
            Resolve-Tool.ps1
          Local/
            Invoke-LocalFilesSearch.ps1
            Invoke-LocalFilesContentSearch.ps1
            Invoke-LocalFileOpen.ps1
            Invoke-ClipboardRead.ps1
          Documents/
            Invoke-DocumentTextExtract.ps1
            Invoke-DocumentSummarize.ps1
            Invoke-MarkdownConvert.ps1
            Invoke-PdfInspect.ps1
            Split-DocumentText.ps1
          Data/
            Invoke-CsvInspect.ps1
            Invoke-DuckDbQuery.ps1
          Outlook/
            Invoke-OutlookMailSearch.ps1
            Invoke-OutlookMailGet.ps1
            Invoke-OutlookMailMark.ps1
            Invoke-OutlookDraftReply.ps1
            Test-OutlookProvider.ps1
          Git/
            Invoke-GitStatus.ps1
            Invoke-GitDiff.ps1
            Invoke-GitBranchSwitch.ps1
          GitHub/
            Invoke-GitHubPrSearch.ps1
            Invoke-GitHubIssueSearch.ps1

        Safety/
          Parse-CommandAst.ps1
          Test-StaticSafety.ps1
          Test-PathPolicy.ps1
          Test-ToolPolicy.ps1
          Test-ToolCallPolicy.ps1
          Test-AgentPlanPolicy.ps1
          Invoke-SecurityReview.ps1
          Resolve-RiskClassification.ps1
          Resolve-MutationClassification.ps1

        Execution/
          Invoke-GeneratedCommand.ps1
          Invoke-RegisteredTool.ps1
          Confirm-Execution.ps1
          Confirm-Mutation.ps1
          Write-Transcript.ps1
          Write-ObservationLog.ps1

        Setup/
          Install-Ollama.ps1
          Install-Model.ps1
          Install-Profile.ps1
          Install-RecommendedTool.ps1

        UI/
          Write-SlashOpsBanner.ps1
          Write-SlashOpsPlan.ps1
          Write-SlashOpsToolPlan.ps1
          Write-SlashOpsRisk.ps1
          Write-SlashOpsPreflight.ps1
          Write-SlashOpsSearchResults.ps1
          Write-SlashOpsObservation.ps1

      ToolManifests/
        local.files.search.json
        local.files.content_search.json
        doc.text.extract.json
        doc.summarize.json
        doc.markdown.convert.json
        doc.pdf.inspect.json
        csv.inspect.json
        duckdb.query.json
        outlook.mail.search.json
        outlook.mail.mark.json

      vendor/
        FxConsole/
          FxConsole.psd1
          FxConsole.psm1
          Public/
          Private/
          theme-config.json
          LICENSE

  tests/
    Unit/
      Config.Tests.ps1
      Context.Tests.ps1
      IntentClassifier.Tests.ps1
      PlannerJson.Tests.ps1
      ToolRegistry.Tests.ps1
      ToolManifest.Tests.ps1
      ToolPolicy.Tests.ps1
      LocalFilesTool.Tests.ps1
      DocumentTools.Tests.ps1
      OutlookTools.Mocked.Tests.ps1
      AgentLoop.Tests.ps1
      Observation.Tests.ps1
      StaticSafety.Tests.ps1
      AstSafety.Tests.ps1
      PathPolicy.Tests.ps1
      ExecutionGate.Tests.ps1
      Transcript.Tests.ps1
      ProfileInstall.Tests.ps1
    Integration/
      Preflight.Tests.ps1
      Ollama.Contract.Tests.ps1
      EndToEnd.Mocked.Tests.ps1
      LocalDocumentWorkflow.Tests.ps1
      Outlook.Provider.Tests.ps1
  examples/
    basic.ps1
    document-conversion.ps1
    document-summary.ps1
    local-document-search.ps1
    outlook-search-mock.ps1
    git-workflow.ps1
  build/
    build.ps1
    publish.ps1
    test.ps1
  docs/
    SAFETY.md
    CONFIGURATION.md
    TOOLS.md
    AGENT_RUNTIME.md
    OUTLOOK.md
    DOCUMENTS.md
    PUBLISHING.md
    EXAMPLES.md
```

### 10.2 Request pipeline

```text
User prefix + prompt
  -> prompt capture
  -> config load
  -> context collection
  -> tool inventory
  -> intent classification
  -> planner JSON generation
  -> JSON validation/repair
  -> plan schema validation
  -> registered tool resolution
  -> command AST parse for command steps
  -> static safety scan for command steps
  -> path policy scan
  -> tool-call policy scan
  -> optional AI security review for mutations/writes
  -> final workflow risk classification
  -> mode-specific execution gate
  -> execute registered tools and/or commands
  -> capture structured observations
  -> optional bounded re-plan
  -> final answer/result rendering
  -> transcript
```

### 10.3 Performance requirements

Target timings on a machine where the model is already loaded:

| Operation | Target |
|---|---:|
| read-only `/x` after model response | < 300ms local policy overhead |
| context + tool inventory with warm cache | < 100ms |
| static/AST safety scan | < 100ms |
| transcript write | < 50ms |
| model JSON parse/repair | < 100ms excluding model call |

Caching requirements:

- tool inventory cache: 10 minutes default
- Ollama health cache: 5 minutes default
- config cache: current process only, invalidated by mtime
- safety review cache: hash of generated command + policy version

---

## 11. TDD plan with Pester

### 11.1 TDD rule

No production function may be added without at least one failing Pester test first.

Development loop:

1. Write or update test.
2. Run targeted test.
3. Observe failure.
4. Implement minimum code.
5. Run targeted test.
6. Refactor.
7. Run full unit suite.
8. Run integration suite when needed.

### 11.2 Pester conventions

- Tests use Pester 5+ syntax.
- All external commands must be mocked in unit tests.
- Tests must not require Ollama except contract/integration tests marked separately.
- Tests must be cross-platform.
- Tests must avoid writing outside `TestDrive:` or temp directories.

### 11.3 Required unit tests

#### Prompt capture

- captures remaining args
- handles empty prompt
- preserves quoted arguments
- routes to correct mode

#### Config

- creates default config
- creates default policy
- reads config
- reads policy
- writes config
- writes policy
- expands `~`
- respects `SLASHOPS_HOME`
- respects `SLASHOPS_CONFIG`
- respects `SLASHOPS_POLICY`
- discovers project config
- can disable project config with `SLASHOPS_NO_PROJECT_CONFIG`
- merges defaults, user config, user policy, project config, environment variables, and CLI overrides in correct precedence
- prevents project config from weakening safety policy by default
- rejects invalid JSON
- rejects invalid schema
- refuses unknown future schema
- creates backups before mutation
- validates regex patterns
- returns source attribution for effective config

#### Context

- includes current date/time
- includes timezone
- includes current directory
- includes home directory
- detects Downloads path
- detects PowerShell version
- detects tools from mocked `Get-Command`

#### Model JSON

- accepts valid JSON
- rejects Markdown-wrapped JSON unless repair succeeds
- performs one repair attempt
- fails closed if JSON remains invalid
- rejects missing `command`
- rejects non-PowerShell shell commands unless clearly external executable within pwsh syntax

#### Static safety

- blocks `Invoke-Expression`
- blocks curl-pipe-shell
- blocks encoded commands
- blocks disk format commands
- flags `Remove-Item` as risky
- allows `Get-ChildItem`
- allows bounded `pandoc` conversion
- treats unknown dynamic invocation as risky/blocked

#### AST safety

- parse errors prevent execution
- command names extracted
- parameters extracted
- multi-command scripts classified by highest risk
- alias output rejected when generated command uses aliases

#### Path policy

- normalizes `~`
- prevents writes to protected roots
- permits writes to safe roots
- blocks broad home mutation
- blocks overwrite unless explicit

#### Tool policy

- missing required tool prevents execution
- available required tool passes
- package manager commands require confirmation
- cloud mutation blocked in `/x`


#### Intent classifier

- classifies direct command prompts as `shell_command`
- classifies document summary prompts as `document_summary`
- classifies quote/download prompts as `document_text_search`
- classifies Outlook search prompts as `email_search`
- classifies Outlook mark/move prompts as `email_mutation`
- returns confidence score
- downgrades low-confidence prompts to confirmation-required
- never executes when intent is `unknown`

#### Planner and agent plan

- planner accepts valid strict JSON
- planner rejects unregistered tool names
- planner rejects missing `steps`
- planner rejects steps without type
- planner rejects command steps without `shell` and `command`
- planner rejects tool calls without registered tool manifest
- planner preserves original user request
- planner emits summary and undo hint where required
- planner respects max steps
- planner respects max tool calls
- planner pauses before mutation
- agent loop stops on unknown risk
- agent loop stops on mutation until confirmation
- observations are converted to structured JSON

#### Tool registry

- loads built-in tool manifests
- rejects invalid tool manifest schema
- resolves enabled tool
- refuses disabled tool
- refuses unknown tool
- reports missing dependency commands
- supports platform filtering
- exposes registry through `Get-SlashOpsTool`
- prevents project config from enabling user-defined tools by default

#### Local/document tools

- local file search resolves `~/Downloads`
- local file search filters by local day
- local file search handles "today" using timezone context
- local file search ranks by recency and keyword match
- document resolver uses explicit path first
- document resolver uses pipeline input second
- document resolver uses last SlashOps result third
- document resolver asks when multiple candidates exist
- text extraction handles missing optional tools gracefully
- summarization chunks large documents
- summarization never logs full document text by default
- Markdown conversion requires Pandoc or returns dependency guidance

#### Outlook tools mocked

- Outlook tools are disabled by default
- email search is read-only
- email mark requires confirmation
- email move requires confirmation
- email send is blocked/out of scope
- provider auth failure stops workflow
- message body is not logged by default
- search results render sender/subject/date/snippet metadata

#### Execution gate

- `/x` auto-runs read-only
- `/x` auto-runs benign-write when enabled
- `/x` stops risky-write
- `/x` refuses blocked
- `/` asks for all non-blocked
- `//` never executes
- `/?` never executes
- `/!` never auto-executes

#### Transcript

- writes JSONL
- redacts secrets
- records exit code
- records risk class
- records prompt and generated command
- can read history

#### Setup

- detects missing Ollama
- suggests platform-specific install
- never silently runs remote install script
- pulls model only after confirmation
- creates profile block idempotently
- removes profile block cleanly

### 11.4 Integration tests

Integration tests may require local Ollama and are skipped by default unless enabled:

```powershell
$env:SLASHOPS_RUN_INTEGRATION = '1'
Invoke-Pester -Tag Integration
```

Integration coverage:

- Ollama `/v1/models` reachable
- configured model returns valid JSON for simple prompt
- configured model returns valid intent JSON for tool-oriented prompt
- preflight returns passed on configured machine
- dry-run SlashOps command generates expected safe command class
- local document search finds a seeded downloaded test file
- local document summary summarizes a seeded Markdown file
- mocked Outlook provider returns search results and requires confirmation for mark
- agent loop respects max step/tool-call limits

### 11.5 Build/test commands

```powershell
Invoke-Pester -Path ./tests/Unit
Invoke-Pester -Path ./tests/Integration -Tag Integration
Invoke-ScriptAnalyzer -Path ./src/SlashOps -Recurse
Test-ModuleManifest ./src/SlashOps/SlashOps.psd1
```

---

## 12. Publishing requirements

### 12.1 Pre-publish checklist

Before publishing to PowerShell Gallery:

1. `Invoke-Pester` passes.
2. `Invoke-ScriptAnalyzer` has no errors.
3. `Test-ModuleManifest` passes.
4. README has installation, quick start, safety model, examples.
5. LICENSE exists.
6. FxConsole vendored license preserved.
7. `CHANGELOG.md` updated.
8. `ReleaseNotes` updated in manifest.
9. Version bumped according to SemVer.
10. Local repository publish test completed.

### 12.2 Local publish test

Build script should support a local repository test:

```powershell
$repo = Join-Path $PWD '.local-psrepo'
New-Item -ItemType Directory -Force -Path $repo | Out-Null
Register-PSRepository -Name SlashOpsLocal -SourceLocation $repo -PublishLocation $repo -InstallationPolicy Trusted
Publish-Module -Path ./src/SlashOps -Repository SlashOpsLocal
Find-Module SlashOps -Repository SlashOpsLocal
Install-Module SlashOps -Repository SlashOpsLocal -Scope CurrentUser -Force
```

### 12.3 Gallery publish

Publishing command:

```powershell
Publish-Module \
  -Path ./src/SlashOps \
  -NuGetApiKey $env:PSGALLERY_API_KEY \
  -Repository PSGallery
```

Requirements:

- API key must come from environment variable or SecretManagement; never hard-code.
- Publish script must require clean git working tree unless `-Force`.
- Publish script must display module version and target repository before publish.
- Preview mode must support `-WhatIf` where possible.

---

## 13. Security and privacy

### 13.1 Local-first principle

SlashOps defaults to local Ollama. User prompts, generated commands, environment context, and history remain local unless the user explicitly configures a remote provider in a future version.

### 13.2 Secret redaction

SlashOps must redact likely secrets from logs and UI:

- API keys
- tokens
- passwords
- bearer tokens
- AWS access keys
- GitHub tokens
- Azure tokens
- private key blocks
- connection strings where detectable

### 13.3 Remote execution policy

SlashOps must block:

- `curl | sh`
- `iwr | iex`
- remote script execution
- encoded commands
- unknown installers

Setup may display official install commands but must require explicit confirmation and should prefer package managers.

### 13.4 Enterprise compatibility

SlashOps must:

- support proxy configuration by relying on system environment variables where possible
- avoid writing outside user profile except when user explicitly requests
- not require admin privileges
- not bypass execution policies
- not auto-install software silently

---

## 14. Error handling

SlashOps must fail closed.

Failure scenarios:

| Failure | Behavior |
|---|---|
| Ollama missing | Show install/setup instructions. Do not execute. |
| Ollama down | Offer start command if installed. Do not execute generated command. |
| Model missing | Offer pull with confirmation. |
| Model timeout | Show retry guidance. Do not execute. |
| Invalid JSON | Attempt repair once, then stop. |
| AST parse error | Stop. |
| Safety unknown | Treat as risky/blocked depending on mode. |
| Missing tool | Show dependency instruction. Do not execute. |
| Path policy violation | Stop or require non-fast explicit confirmation. |
| Transcript write failure | Warn; configurable whether to continue for read-only. |

---

## 15. Acceptance criteria

### 15.1 v0.1 preview acceptance

SlashOps v0.1 is acceptable when:

1. Module installs locally with `Import-Module` on Windows, macOS, Linux.
2. Module manifest passes `Test-ModuleManifest`.
3. Unit tests cover all public functions.
4. Pester tests pass on at least two platforms before public publish.
5. `Initialize-SlashOps` creates config and runs preflight.
6. `Test-SlashOpsPreflight` accurately reports Ollama/model/tool status.
7. `/` can generate a command and ask before execution.
8. `//` generates only.
9. `/x` auto-executes read-only commands.
10. `/x` auto-executes bounded benign-write command when policy permits.
11. `/x` refuses destructive command.
12. Safety scan blocks remote script execution.
13. History is written to JSONL.
14. FxConsole renders setup/preflight/plan/risk/result output.
15. Gallery packaging scripts exist.
16. README includes clear safety warnings and examples.

### 15.2 v0.2 local tool runtime acceptance

SlashOps v0.2 is acceptable when:

1. Intent classifier distinguishes `shell_command`, `file_search`, `document_text_search`, `document_summary`, and `document_conversion`.
2. Planner can return multi-step registered tool plans.
3. Tool registry loads built-in manifests and refuses unknown tools.
4. `/x find the quote that I downloaded today` runs as read-only local file/document search.
5. `/ summarize this doc` resolves explicit paths, pipeline input, last result, and latest downloaded document.
6. Document summarization chunks large files and produces a final summary.
7. Markdown conversion uses Pandoc only when available and generates dependency guidance when missing.
8. Tool outputs are represented as structured observations.
9. Agent loop respects max steps, max tool calls, and mutation pause rules.
10. Config includes `agent`, `toolRegistry`, `documents`, and `privacy` sections.
11. Pester tests cover tool registry, document resolution, local tools, observations, and agent loop.

### 15.3 v0.3 Outlook/business connector acceptance

SlashOps v0.3 is acceptable when:

1. Outlook tooling is disabled by default.
2. User can explicitly configure an Outlook/Microsoft 365 provider.
3. Email search is read-only and may run in `/x` if policy allows.
4. Email mark/move/categorize requires explicit confirmation.
5. Email send is blocked or future-only.
6. Email search result UI shows ranked candidates.
7. Email body is not logged by default.
8. Mocked Pester tests cover all Outlook workflows.
9. Provider auth failures stop workflow safely.
10. Documentation explains Graph/Microsoft 365 CLI setup and privacy model.

---
## 16. Roadmap

### v0.1 Preview — command runtime

- local Ollama/Qwen only
- JSON command generation
- static/AST safety
- `/`, `//`, `/x`, `/!`, `/?`
- config/history
- preflight
- FxConsole UI
- PowerShell Gallery publishing

### v0.2 — local tool runtime

- intent classifier
- registered tool manifests
- local files search
- local content search
- document resolver for "this doc"
- document text extraction
- document summarization
- Markdown conversion via Pandoc
- PDF inspection/extraction via Poppler when available
- structured observations
- bounded agent loop for read-only and benign local workflows
- privacy controls for document text
- TDD coverage for tools and agent loop

### v0.3 — business/dev connectors

- Outlook/Microsoft 365 provider abstraction
- Outlook mail search
- Outlook mail mark/categorize/move with confirmation
- draft-only email reply support
- calendar search and draft event support
- Git/GitHub tool wrappers beyond shell commands
- provider auth checks
- connector privacy controls
- mocked connector test suites

### v0.4 — mature agent workflows

- multi-step plan/observe/re-plan loop
- richer ranking and result selection UI
- tool-result memory within a session
- undo metadata for benign mutations
- plugin policy packs
- enterprise policy file support
- SecretManagement integration
- richer transcript viewer

### v1.0

- stable config schema
- stable policy schema
- stable tool manifest schema
- cross-platform CI matrix
- signed module option
- full docs site
- security review completed
- PowerShell Gallery stable release

---
## 17. Open questions

1. Should FxConsole be vendored permanently or published as a separate PowerShell Gallery dependency first?
2. Should `/x` allow `Move-Item` by default for single explicit files, or should all moves require confirmation?
3. Should SlashOps default safe write roots include current directory?
4. What is the smallest recommended Qwen model profile for lower-memory laptops?
5. Should transcript logging be mandatory, or can it be fully disabled?
6. Should aliases be installed automatically by `Install-Module`, or only by `Initialize-SlashOps` with confirmation? Recommended: only by `Initialize-SlashOps`.
7. Should SlashOps support remote LLM providers later, or remain local-only by product principle?
8. Should enterprise policy files be merged before or after user policy if managed deployment is added later?
9. Should user-defined tools be allowed before v1.0? Recommended: no.
10. Should project-level config be able to enable tools, or only disable/narrow them? Recommended: only disable/narrow by default.
11. Should Outlook support start with Microsoft Graph directly or Microsoft 365 CLI? Recommended: provider abstraction, Graph-first long term.
12. Should clipboard access be enabled by default? Recommended: no or prompt-on-first-use.
13. Should email/document bodies ever be logged? Recommended: disabled by default with explicit opt-in.
14. Should `/x` be allowed to open files/folders in GUI apps? Recommended: yes for local paths, maybe confirmation first time.
15. Should document summarization include citations/snippets by default? Recommended: yes for local docs, with small excerpts only.
16. Should the agent loop be enabled in v0.2 or hidden behind `experimental.agentLoop`? Recommended: enabled only for read-only local tools.

---
## 18. Reference links

- FxConsole repository: https://github.com/andresharpe/FxConsole
- FxConsole README: https://github.com/andresharpe/FxConsole/blob/main/README.md
- FxConsole MIT license: https://github.com/andresharpe/FxConsole/blob/main/LICENSE
- Ollama OpenAI compatibility docs: https://docs.ollama.com/openai
- Ollama API OpenAI compatibility docs: https://docs.ollama.com/api/openai-compatibility
- Ollama Qwen3-Coder library page: https://ollama.com/library/qwen3-coder
- Ollama Qwen3-Coder 30B page: https://ollama.com/library/qwen3-coder:30b
- Ollama Linux install docs: https://docs.ollama.com/linux
- Ollama macOS docs: https://docs.ollama.com/macos
- Ollama FAQ: https://docs.ollama.com/faq
- PowerShell Gallery publishing guidelines: https://learn.microsoft.com/en-us/powershell/gallery/concepts/publishing-guidelines
- Publish-Module docs: https://learn.microsoft.com/en-us/powershell/module/powershellget/publish-module
- PowerShell Gallery FAQ: https://learn.microsoft.com/en-us/powershell/gallery/faqs
- PowerShell module manifest docs: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_module_manifests
- Pester docs: https://pester.dev/docs/usage/setup-and-teardown
- Pester mocking docs: https://pester.dev/docs/usage/mocking
- Microsoft Graph mail API docs: https://learn.microsoft.com/en-us/graph/api/resources/mail-api-overview
- Microsoft Graph message resource: https://learn.microsoft.com/en-us/graph/api/resources/message
- Microsoft 365 CLI: https://pnp.github.io/cli-microsoft365/
