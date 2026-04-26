---
id: doc-04
title: docs/AGENT_RUNTIME.md
version: all
group: docs
subgroup: agent
sequence: 4
depends_on: [tr-08]
status: todo
tdd_first: false
prd_refs:
  - "PRD §7.1-§7.5, §7.12-§7.16 (lines 879-1017, 1173-1269)"
deliverables:
  - docs/AGENT_RUNTIME.md
tags: [docs, agent, runtime]
---

## Overview

Reference for the agent runtime: rationale, architecture, intent taxonomy, planner contract, agent loop, observation handling, tool prompting rules, UI conventions.

## Implementation steps

1. Sections: rationale, architecture, separation of concerns, intent taxonomy, planner contract, agent loop, observations, prompting, UI.
2. Worked example: a multi-step document workflow end-to-end.

## Acceptance criteria

- File present, content-complete.

## Notes / risks

- Keep the agent loop diagram up to date with `Invoke-AgentLoop.ps1`.
