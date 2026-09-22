# Role File Skeleton

Every role file in this project uses the five sections below. A role file that
omits a required section fails `scripts/check-role-skeleton.sh`.

This skeleton makes inheritance visible: remove a parent role file and the
child's behaviour changes, because the child does not restate the parent.

---

## Required sections

### Purpose

One or two sentences. What this role is for, and what it is *not* for.
A reader who knows nothing about the project learns what problems this role
solves and nothing else.

### Preconditions

What MUST be true before this role begins work. A role that starts without its
preconditions met will produce incomplete or incorrect output.

Examples: a task card in the correct column, a log entry for the prior
transition, a durable plan document.

### Steps

The ordered actions this role MUST, SHOULD, or MAY take.

**RFC 2119 usage in this project:**

| Keyword | Mode | Meaning |
|---|---|---|
| **MUST** | Prescriptive | Required at a handoff gate; blocks if skipped. |
| **SHOULD** | Advisory | Recommended while working; never blocks. |
| **MAY** | Perspective | Applies at review; opens a different angle. |

The mode is not a label in the specification. It becomes the actual word an agent
reads in the instruction. A MUST at a gate means the card goes back if violated.
A SHOULD while working means the agent is reminded but not stopped.

### Completion signal

How this role knows it is finished. One or more measurable conditions.
Conditions MUST be verifiable without asking the next role.

### Failure handling

What MUST happen when this role cannot complete. Options:
- Return the card to the prior column with explicit defect notes.
- Block with `assigned_role: "user"` and `blocked_on: <reason>`.
- Escalate to PM with the specific blocker named.

The role MAY append a `ROLE_BLOCKED` event to the log as supplementary context.
The log entry is not a substitute for moving the card.

---

## Always-loaded core vs. references

The always-loaded core (the role's own `SKILL.md`) MUST stay under 200 words.
Role-specific steps belong in a `references/` document, linked from the core.
The five section headings appear in the core; the detail lives in the reference.

---

## Inheritance rule

A child role MUST NOT restate what its parent already states. If removing a
parent node leaves the child's behaviour unchanged, the parent was not
load-bearing and the structure is wrong.
