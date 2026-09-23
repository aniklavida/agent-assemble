---
id: "TASK-BA-001"
title: "Add configurable session timeout to the authentication module"
size: "short"
status: "todo"
assigned_role: "software-engineer"
created_at: "2026-09-23T10:00:00Z"
updated_at: "2026-09-23T10:15:00Z"
---

## Context & Request

The user requested a configurable session timeout. Tokens currently expire after
a hardcoded 24 hours. BA elicitation confirmed: timeout is set per project in
the config file; default is 24 hours if unset; no per-user override in scope.

## Acceptance Criteria

- [ ] Session timeout is read from the project config file
- [ ] Default of 24 hours applies when the config key is absent
- [ ] Tokens issued after the config change expire at the new interval

## Sabotage Evidence

<!-- Filled by SQA. Not yet started. -->

## Handoff Trail

### Analysis Handoff (BA)
- Notes: Short path — criteria inline; no plan document. Config key is
  `session_timeout_hours`. Scope boundary confirmed: no per-user override.
