## Overview

Validate the strict JSON contract emitted by the planner: required fields per §7.4, registered tool names only, command steps include `shell` and `command`, max steps / tool calls bounded, mutations flagged. Reject Markdown, prose outside JSON, or unregistered tool names.

## TDD test list

- Valid plan passes.
- Plan missing `steps` fails.
- Plan with step missing `type` fails.
- Plan with command step missing `shell` / `command` fails.
- Plan calling unregistered tool fails.
- Plan exceeding `agent.maxSteps` fails.
- Plan exceeding `agent.maxToolCalls` fails.
- Plan that pauses before mutation passes.

## Implementation steps

1. Author both private helpers.
2. Tests cover every TDD bullet.

## PRD references

- §7.4 — schema.
- §11.3 — required tests.

## Acceptance criteria

- TDD tests pass.

## Notes / risks

- Plans must round-trip through validation before reaching the agent loop.

