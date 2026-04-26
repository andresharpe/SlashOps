---
id: doc-03
title: docs/TOOLS.md
version: all
group: docs
subgroup: tools
sequence: 3
depends_on: [tr-03]
status: todo
tdd_first: false
prd_refs:
  - "PRD §7.6-§7.8 (lines 1019-1090)"
deliverables:
  - docs/TOOLS.md
tags: [docs, tools, registry]
---

## Overview

Reference for the tool registry: manifest schema, built-in tool list with risk + fast-mode + dependencies, examples of registering and invoking a tool.

## Implementation steps

1. Sections: registry overview, manifest schema, built-in tool catalogue, custom tools (out of scope until v1.0).
2. Tool catalogue table: name, description, risk, fast-mode, dependencies, supported platforms.

## Acceptance criteria

- File present, content-complete.

## Notes / risks

- Keep the catalogue table generated from manifests where possible to avoid drift.
