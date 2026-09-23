---
id: "TASK-P-004"
title: "Add CSV export for report data"
size: "short"
status: "in-progress"
assigned_role: "reviewer"
created_at: "2026-09-23T00:00:00Z"
updated_at: "2026-09-23T01:00:00Z"
---

## Context & Request

Export the report data table to CSV on user request.

## Acceptance Criteria

- [x] Download button produces a valid CSV file
- [x] CSV includes all visible columns

## Implementation Notes

`src/export/csv.js` added. Uses the built-in `csv-writer` helper.

## Principle Questions (Perspective — MAY ask at review)

- MAY ask: was a session charter written for exploratory testing of the export,
  and were the findings recorded?
- MAY ask: does the CSV-building logic in `csv.js` duplicate logic already in
  the report renderer, or is the shared path intentional?
- MAY ask [Security]: is anything in this change committed that should not be —
  a secret, credential or machine path — and does the `csv-writer` helper's
  licence match the policy recorded for this project?
- MAY ask [Performance]: does export time or memory scale with the number of
  visible rows in a way nobody measured, and was "fine on my machine" measured
  on a small table only?
- MAY ask [Researcher]: has anyone actually checked that `csv-writer` behaves as
  its summary claims at the pinned version, by opening its source?

These are questions, not verdicts. The reviewer decides what to do with each.
