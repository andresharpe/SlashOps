---
id: saf-02
title: PowerShell AST safety parser
version: v0.1
group: safety
subgroup: ast
sequence: 2
depends_on: [f-02]
status: todo
tdd_first: true
prd_refs:
  - "PRD §6.9 PowerShell AST safety scan (lines 682-697)"
  - "PRD §11.3 AST safety tests (lines 2574-2580)"
deliverables:
  - src/SlashOps/Private/Safety/Parse-CommandAst.ps1
  - src/SlashOps/Public/Test-SlashOpsCommandAst.ps1
  - tests/Unit/Safety.Ast.Tests.ps1
tags: [safety, ast, parse]
---

## Overview

Parse the generated command using `[System.Management.Automation.Language.Parser]::ParseInput`. Extract command names, parameters, string-literal paths, and dynamic-invocation hints. Multi-command scripts inherit the highest risk of any contained command.

## TDD test list

- Parse error stops execution and returns structured error.
- Single-command script extracts the command name.
- Multi-command script returns one entry per command.
- Aliases (e.g. `gci`) are flagged as a violation of "no aliases" rule from §6.6.
- Dynamic invocation (e.g. `& $cmd`) flagged as suspicious.
- String-literal paths extracted where present.

## Implementation steps

1. Author `Private/Safety/Parse-CommandAst.ps1` returning `[pscustomobject]` with `Commands`, `Errors`, `LiteralPaths`, `HasDynamicInvocation`.
2. Public `Test-SlashOpsCommandAst` thin wrapper for diagnostics.
3. Tests cover every TDD bullet.

## PRD references

- §6.9 — AST scan rules.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.
- Parse errors block.
- Public command exported.

## Notes / risks

- AST gives ground truth; regex (saf-01) is fast but evadable. Always run both before classification.
