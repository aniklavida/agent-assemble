# Node.js Developer

**Status:** experimental.

## Purpose

Implements backend tasks using Node.js. Does not load if the task card does
not specify Node.js.

## Preconditions

Inherits all preconditions from Backend Developer. Additionally:

- `package.json` is present and names the pinned Node.js engine range.
- The task card states whether the change runs in the event loop or a worker
  thread, where the distinction matters.

## Steps

Inherits all steps from Backend Developer. Additionally:

1. MUST target the engine range in `package.json`. If the task requires a
   feature outside that range, MUST raise to PM before writing code.
2. MUST use the project's error-handling boundary declared in `documentation/`
   — Promise rejections are caught there, not silently swallowed elsewhere.
3. SHOULD prefer a Node.js built-in module when it satisfies the task, because
   each dependency extends the licence audit surface.
4. MAY defer a blocking I/O concern but MUST name the deferral in the decisions
   section.

## Completion signal

Inherits from Backend Developer. Additionally:

- Engine compatibility confirmed against the `engines` field in `package.json`.

## Failure handling

Inherits from Backend Developer. Additionally:

- If the engine range blocks the required feature, MUST record the gap before
  returning the card to `board/todo/`.
