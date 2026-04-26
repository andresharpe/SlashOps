---
id: exe-01
title: Invoke-GeneratedCommand (run + capture)
version: v0.1
group: execution
subgroup: invoke
sequence: 1
depends_on: [saf-07]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.14 Execution transcript (lines 799-832)"
  - "PRD §9.4 execution captureStdoutStderr / maxStdoutBytes / maxStderrBytes (lines 1718-1721)"
deliverables:
  - src/SlashOps/Private/Execution/Invoke-GeneratedCommand.ps1
  - src/SlashOps/Public/Invoke-SlashOpsCommand.ps1
  - tests/Unit/Execution.Invoke.Tests.ps1
tags: [execution, invoke, capture]
---

## Overview

Run a generated command in-process via `&{ ... }` or via `pwsh -Command` (configurable). Capture stdout, stderr, and exit code. Per-run logs land at `~/.slashops/runs/<id>/{stdout,stderr}.txt`. Truncate per `execution.maxStdoutBytes` / `maxStderrBytes` with a marker.

## TDD test list

- Successful command returns `ExitCode = 0` and captured stdout.
- Failing command returns non-zero exit code and captured stderr.
- Stdout above `maxStdoutBytes` truncated with marker.
- Per-run directory created under `runs/<id>/`.
- Run id is unique per invocation.
- Function refuses to run when gate decision is not `auto`/`ask-confirmed`.

## Implementation steps

1. Author `Private/Execution/Invoke-GeneratedCommand.ps1` accepting `(CommandPlan, GateDecision)`.
2. Public `Invoke-SlashOpsCommand` thin wrapper for explicit invocation.
3. Tests use `TestDrive:` for runs root.

## PRD references

- §6.14 — transcript schema includes `stdout_log` / `stderr_log` paths.
- §9.4 — capture and byte limits.

## Acceptance criteria

- TDD tests pass.
- Per-run logs landed.
- Truncation marked.

## Notes / risks

- Decide between in-process invocation and child `pwsh` carefully — in-process inherits scope and is faster but exposes the SlashOps process to side effects. Default to child `pwsh` for v0.1; revisit in v0.4.
