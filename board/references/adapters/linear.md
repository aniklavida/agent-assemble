# Linear Backend

**Requires:** a Linear MCP server **or** a configured API key. **This backend is
not available in every host** — unlike Markdown and Obsidian, it can fail to be
reachable, and setup says so at the moment of choosing.

Linear was chosen over Notion because its data model is card-shaped. A Linear
*Issue* is a card, a workflow *State* is a column, and a *Comment* is a log row,
so the four contract operations map one-to-one. Notion's block and database model
is more general and would require this skill to pick a database shape before it
could be used; that is a thicker adapter for no gain.

## What the agent needs

- A Linear **MCP server** connected to the host, or
- a **`LINEAR_API_KEY`** present in the environment, configured by the user.

The agent **never reads, prints, stores, or asks for the key**. Setup checks only
that the capability exists. If neither a Linear MCP server nor a configured key
is present, setup refuses the Linear choice, says which capability is missing,
and offers Markdown or Obsidian instead — it does not fail silently later.

## Mapping

| Contract | Linear |
|---|---|
| Card | Issue |
| Column `todo` / `in-progress` / `testing` / `done` | Workflow State with the same name |
| Frontmatter `id`, `title`, `status`, `assigned_role` | Issue identifier/title, state, assignee or label |
| Body (context, criteria, handoff trail) | Issue description |
| Log row | Comment on the issue |
| Log file | The team's issue history |

The `status_mapping` in `.agent-assemble/board-config.md` names the workflow
states; if a state is missing from the target team, setup reports it rather than
creating states unasked.

## Operations

Create, Move, Read and Append Log are the four operations from
[`../board-adapters.md`](../board-adapters.md), invoked through the MCP server or
the API:

- **Create Card:** create an Issue in the configured team/project in the `todo`
  state, with `assigned_role` as a label.
- **Move Card:** set the Issue's workflow state and update the assignee label.
- **Read Card:** fetch the Issue's state, labels, and description.
- **Append Log:** add a Comment; a past Comment is never edited.

## Detecting an existing board

An existing Linear team or project already in use for this work is an existing
board. Connect to it (`existing: true`); never create a second project for the
same work. If more than one candidate exists, ask which one — do not guess.

## Host differences

Markdown and Obsidian work in every host. This backend works only where an MCP
server or API key has already been provided.
