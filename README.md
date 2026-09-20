# Agent Assemble

**A company your agent can work inside.**

Agent Assemble is a skill — plain Markdown, no server and no runtime — that gives a coding agent the three things it does not have: **a role, a place in a process, and a memory.**

> **Status: planned.** Nothing here is implemented yet. This repository currently contains the specification, architecture and roadmap only. Every claim below describes the intended product, not working software.

## The problem

An agent given a task today behaves like a capable generalist with no colleagues and no memory.

- **No role.** The same agent writes the API, the tests and the UI, applying the same general knowledge to each.
- **No handoff.** It writes the code and reviews its own code. A second pair of eyes with a different brief is the highest-yield practice in software, and there is nobody to provide it.
- **No memory.** The session ends and everything goes — what was decided, what was tried, what was rejected and why.
- **No organisational knowledge.** A model knows what .NET is. It does not know what "done" means in your team.

That last point is the sharpest. **The model's general knowledge is excellent and freely available. The knowledge that is missing is always local.**

## What it is not

There are good projects that teach an agent *how* to work — test-driven development, systematic debugging, writing a plan. Agent Assemble does not compete with them and does not restate them. Where such a skill already teaches a practice well, this one points at it.

Other projects in this space ship skills that teach an agent how to work inside one specific product. This one teaches how a company works, independent of any single product.

Agent Assemble answers the questions those cannot: **who is doing this, where does the work stand, and what has already happened.**

## The shape

A company.

| Part | What it holds |
|---|---|
| **Employees** | Role knowledge, with inheritance |
| **Principles** | The craft — chosen per project, never imposed |
| **Tools** | What this project uses, what it rejected, and the constraints |
| **Documentation** | Plans and decisions — durable, edited |
| **Workflow** | How work changes hands |
| **Board** | Cards — the handoff vehicle |
| **Log** | What happened — append-only |

## How work moves

```
a request arrives
      ↓
BA + PM          ask what is actually wanted
      ↓
BA               writes the plan into documentation
      ↓
BA               creates cards on the board
      ↓
the employee     the card names the role; that role's knowledge loads
      ↓
SQA              tests
      ↓
Security         tests
      ↓
PM               closes it
      ↓
LOG              records what happened
```

**The chain scales to the request.** A typo does not pass through six roles.

## Principles, three ways

| Mode | Where | Behaviour |
|---|---|---|
| **Advisory** | while the employee works | reminds; never blocks |
| **Prescriptive** | at a handoff gate | blocks; the card goes back |
| **Perspective** | at review | asks a different question |

A developer may experiment freely. The gate is where the chosen principles bite. Perspectives — Security, Performance, Accessibility, Researcher — only ever ask.

## Design commitments

- **A skill, not a server.** Markdown only. Any agent that can read files and run commands can use it.
- **Never restate what the model already knows.** A node summarising framework documentation is wasted context.
- **The log is a by-product, never a step.** If writing it can be skipped when the agent is in a hurry, it will be.
- **Ask once, remember forever.** Setup is an interview. Daily work is not.
- **Detect before asking.** A `.csproj` means .NET. Do not ask what can be read.

## The claim, and its limit

**What it will provide:** a role, a place in a process, and a memory that survives the session.

**What it cannot provide:** any guarantee that the agent read the skill, followed it, or did what it said. No agent host reports this. A skill that fires and is ignored is indistinguishable from one that never fired.

Both sentences belong together. Neither will be published without the other.

## Documentation

- [Specification](docs/SPEC.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Release checklist](docs/RELEASE_CHECKLIST.md)

## Licence

MIT. See [LICENSE](LICENSE).
