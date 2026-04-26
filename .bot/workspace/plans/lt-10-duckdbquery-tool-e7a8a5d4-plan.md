## Overview

Run SQL against local CSV / Parquet / JSON via DuckDB. Read-only by default; output to a new file is a separate `benign-write` invocation flag. Refuses statements that mutate persistent state.

## TDD test list

- `SELECT` over a CSV file (mocked) returns rows.
- `INSERT`, `UPDATE`, `DELETE`, `DROP` are blocked unless `-AllowMutation`.
- Missing `duckdb` → `needs_dependency` observation.
- Manifest passes validation.

## Implementation steps

1. Author `Private/Tools/Data/Invoke-DuckDbQuery.ps1` invoking `duckdb -c "SQL"`.
2. Parse statement to detect mutation keywords before invocation.
3. Author manifest with `required_commands: ['duckdb']`.
4. Tests mock duckdb invocation.

## PRD references

- §7.7 — tool list.

## Acceptance criteria

- TDD tests pass.
- Mutation detection robust.

## Notes / risks

- SQL parsing is regex-based here; consider a stricter parser if abuse becomes an issue.

