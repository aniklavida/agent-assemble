---
id: "TASK-P-BAD-001"
title: "Add user registration endpoint"
size: "short"
status: "in-progress"
assigned_role: "SQA"
created_at: "2026-09-23T00:00:00Z"
updated_at: "2026-09-23T01:00:00Z"
---

## Context & Request

Implement a POST /users endpoint that creates a new user account.

## Acceptance Criteria

- [x] POST /users with valid payload returns HTTP 201
- [x] POST /users with missing email returns HTTP 400

## Implementation Notes

Endpoint added in `src/routes/users.js`. Returns 201 on success and 400 on
validation failure.

## Principle Evidence

tdd_evidence: none
