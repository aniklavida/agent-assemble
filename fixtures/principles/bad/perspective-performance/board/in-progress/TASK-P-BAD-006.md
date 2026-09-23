---
id: "TASK-P-BAD-006"
title: "Add CSV export for large tables"
size: "short"
status: "in-progress"
assigned_role: "reviewer"
created_at: "2026-09-23T00:00:00Z"
updated_at: "2026-09-23T01:00:00Z"
---

## Context & Request

Export large report tables to CSV on user request.

## Acceptance Criteria

- [x] Export produces a valid CSV file

## Principle Verdict (Perspective — deliberately broken: question turned into a verdict)

- MAY ask [Performance]: was the export timed on the largest table, or only a
  small one?

MUST block: no measurement exists for the largest table. The export cannot ship.
