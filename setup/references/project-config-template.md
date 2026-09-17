# Project Configuration Template

Written to `.agent-assemble/project.md` at the end of setup. Every field must be present; use `(not yet decided)` for any genuinely deferred field rather than leaving it blank.

```markdown
# Project Configuration

Updated: YYYY-MM-DD

## The Project

**Name:** [project name]
**What is being built:** [one or two sentences — what and for whom]
**Core problem:** [the problem this solves]
**Out of scope:** [explicitly excluded from the first version]
**Success looks like:** [what the end of the first version achieves]

## The Way of Working

**Stack:** [language · framework · key libraries — include version if pinned]
**Principles:**
  - [Principle name] — [advisory | prescriptive | perspective]
  - (or: none chosen)
**Definition of done:** [minimum a task must satisfy before it is marked done]
**Default relay depth:** [Direct only | Short | Full | PM decides per request]
**Active perspectives:** [Security | Performance | Accessibility | Researcher | None]

## The Plumbing

**Board backend:** [Markdown | Obsidian | SQLite | External tracker — name it]
**Board root:** [path, e.g. board/ or vault/tasks/]
**Board name:** [human-readable name for the board]
**Branch base:** [e.g. develop or main]
**Branch prefix:** [e.g. feature/ or none]
**PR target:** [branch PRs are opened against]
**Log path:** [e.g. log/LOG.md]

## Detection Notes

Fields detected automatically from the repository are marked (detected).
Fields confirmed by the user without contradiction are marked (confirmed).
Fields corrected by the user are marked (corrected — original: [original value]).
```

## Rules for writing this file

- Write every field. Do not omit sections.
- If a value was detected, append `(detected)` after it.
- If the user confirmed without changing it, append `(confirmed)`.
- If the user corrected it, append `(corrected — original: X)`.
- If a field is genuinely deferred, write `(not yet decided — see decided-deferred.md DEF-XXX)`.
- Never leave a field blank or with a placeholder like `???`.

## After writing

Tell the user the file was written and its path. Do not re-read it back in full — the summary in Step 4 of `setup/SKILL.md` covers this.
