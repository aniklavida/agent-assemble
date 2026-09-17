# Sizing Rubric

This reference defines how incoming requests are sized by the Project Manager (PM) and specifies what each path skips.

## Evaluation Dimensions

Every request is evaluated across four dimensions:

| Dimension | Low (Direct) | Medium (Short) | High (Full) |
|---|---|---|---|
| **Blast Radius** | 1 file; single line or comment | 1–2 files; localized logic | 3+ files; cross-cutting or API change |
| **Ambiguity** | Zero; intent and solution obvious | Low; bounded scope, clear fix | Moderate to high; requires user elicitation |
| **Architecture** | None | None | New schemas, interfaces, or system patterns |
| **Verification** | Smoke check or visual inspection | Targeted test or isolated check | Full test suite plus sabotage test |

## Path Determination

| Path | Criteria | Skipped Phases | Executed Phases |
|---|---|---|---|
| **Direct** | Low across all four dimensions | BA elicitation, durable plan doc, multi-item breakdown, SQA gate | PM intake → Employee edit & self-verify → PM closure & log append |
| **Short** | Medium in blast radius or verification; Low in ambiguity and architecture | Extended BA elicitation interview, standalone plan document | PM intake → BA task card creation → Employee implementation → SQA test → PM closure & log append |
| **Full** | High in any dimension, or Medium across ambiguity/architecture | None | PM intake → BA elicitation → BA durable plan → BA card creation → Employee implementation → SQA verification & sabotage test → PM closure & log append |

## Skipping Rules and Rationale

1. **Direct Path Skipping:** A typo or one-line comment change does not warrant four handoffs. Routing directly to the executing role avoids process drag while preserving the immutable log entry at closure.
2. **Short Path Skipping:** When a bug or minor tweak is well understood, requiring a formal plan document in `documentation/plans/` introduces ceremony without clarity. The acceptance criteria belong directly inside a task card.
3. **Full Path Preservation:** When requirements carry ambiguity or architectural consequences, skipping elicitation or SQA review introduces defects. All roles must engage.
