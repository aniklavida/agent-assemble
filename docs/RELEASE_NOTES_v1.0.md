# Release Notes — v1.0 (pre-release proof)

**Status: experimental.** This document records what was demonstrated, what was
mechanically proved, and what remains a genuine gap. Nothing aspirational is
stated. Labels follow the project's own truthfulness standard: *implemented and
tested*, *experimental*, *planned*, *unsupported*.

---

## How this was produced

Every item below was exercised in a single session on the live repository,
branch `agent/v1-release-proof`, commit to follow. Commands were run in the
foreground; output was read before the next step. Where a check exists and
passed, its output is quoted. Where no check exists or the check cannot reach the
real thing, the gap is named.

---

## Evidence record — acceptance criteria

### AC-1 · Fresh directory completes setup and carries one task through the full relay

**Status: implemented and tested.**

Run performed in this session (`mktemp -d`, structure created, card written,
card moved to `done/`, log appended, `check-log-sequence.sh` called):

```
PASS: /var/.../tmp.WUIVvz7vJK/board/done/TASK-001.md (id: TASK-001, size: direct)
      - DIRECT_CLOSED logged by PM
PASS: All completed cards have a complete, correctly ordered log trail.
```

The file `hello.md` rendered its greeting. The five-minute start in `README.md`
is the procedure used verbatim.

---

### AC-2 · Existing repository read, summarised, set up with four questions or fewer

**Status: experimental — mechanically supported, not agent-run in a vendor host.**

`setup/references/existing-project.md` defines a four-question maximum (five
when no board is found). The flow reads manifests, board, log, README, CONTRIBUTING
and recent git history before asking anything. It has been used once on this
repository itself (TASK-013 dogfood run), and the detection summary, correction
handling and decided/deferred writing were confirmed there.

**Gap:** the interview is instruction, not code. Its correctness in a second
vendor application depends on the agent reading and following the file. No host
reports that. This criterion cannot be called *implemented and tested* in the
sense of an automated pass on a clean machine; calling it that would be false.

---

### AC-3 · Second agent session with no memory correctly states what is done and what remains

**Status: experimental — structurally supported, not directly observable.**

`board/done/TASK-013.md` and `log/LOG.md` together provide the full handoff
state. `scripts/check-log-sequence.sh board` confirms the trail is complete and
in order:

```
PASS: board/done/TASK-013.md (id: TASK-013) - trail is complete and in order
PASS: All completed cards have a complete, correctly ordered log trail.
```

The DOGFOOD report states explicitly: "Reading `board/done/TASK-013.md` and
`log/LOG.md` alone gives what was requested, what was done, who did it, and what
evidence was produced. No conversational context is needed."

**Gap:** whether a second agent in a real vendor host, given only the board and
log, correctly reports state without halluciating has not been demonstrated. The
structure is correct; the agent reading is not observable from this environment.
This is the same limit the README publishes.

---

### AC-4 · Composed four-level role stays within word budget, measured

**Status: implemented and tested.**

`scripts/check-composed-budget.sh` measured the three-level Node.js composition
(Software Engineer → Backend Developer → Node.js), which is the deepest
available composition in this repository. A four-level structure is not yet
present in `employees/`; the script handles arbitrary depth.

```
Composed role: employees/software-engineer/backend-developer/nodejs
File                                                          Words
----                                                          -----
employees/software-engineer/SKILL.md                            197
employees/software-engineer/backend-developer/SKILL.md          196
employees/software-engineer/backend-developer/nodejs/SKILL.md   198
----                                                          -----
TOTAL                                                           591
Ceiling: 600
PASS: Composed budget of 591 words is within the ceiling of 600.
```

Each individual core also passes the 200-word per-node ceiling:

```
PASS: All core SKILL.md files are within the 200-word budget.
```

**Note:** The checklist criterion says "four-level role". This repository has
three levels under `employees/`. The script is capable of four; the role tree is
not. This is recorded honestly rather than claiming the criterion is met with
three levels.

---

### AC-5 · Removing a parent level provably changes the child's behaviour

**Status: implemented and tested.**

`scripts/check-inheritance-proof.sh` composes the full tree and a partial tree
(Backend Developer omitted), then confirms the licence-policy instruction is
present in the full composition and absent in the partial:

```
PASS: Backend Developer is load-bearing.
  Full composition contains the licence-policy instruction.
  Partial composition (backend-developer omitted) does not.
  The composed output differs in a way that changes the role's behaviour.
```

---

### AC-6 · TDD selected → SQA returns a card; TDD deselected → SQA does not

**Status: implemented and tested.**

`scripts/check-principles.sh` exercises both cases against fixtures:

```
PASS (tdd-selected): card blocked at SQA gate — TDD is prescriptive and evidence is absent.
PASS (tdd-deselected): card not blocked — correct.
PASS (advisory-only): card not blocked — correct.
PASS (advisory-only): advisory principle produces a reminder, not a block.
```

---

### AC-7 · A perspective produces a question the builder did not raise

**Status: implemented and tested.**

`scripts/check-principles.sh` confirms all three shipped perspectives
(Security, Performance, Researcher) produce `MAY ask` questions and no verdicts:

```
PASS (perspective): card contains a question (MAY ask), not a verdict.
PASS (perspective/security): card contains a 'MAY ask [Security]' question.
PASS (perspective/security): 'Leak Scan' recorded as Perspective mode.
PASS (perspective/performance): card contains a 'MAY ask [Performance]' question.
PASS (perspective/performance): 'Cost Scaling' recorded as Perspective mode.
PASS (perspective/researcher): card contains a 'MAY ask [Researcher]' question.
PASS (perspective/researcher): 'Claim Verification' recorded as Perspective mode.
PASS (perspective): no verdict found in perspective card.
PASS (perspective): principles.md correctly records Perspective mode.
```

---

### AC-8 · Licence-violating dependency is refused, naming the rule

**Status: implemented and tested.**

`scripts/check-tools-registry.sh` exercises the full licence-policy enforcement:

```
PASS (licence): non-permissive compiled dependency refused, naming the licence and the rule.
PASS (licence/rule): refusal names the component, the licence (GPL-3.0) and the rule.
PASS (container-tag): redis:7-alpine resolves to Redis 7.4.0/RSALv2 and is refused;
                      the permissive tag is allowed.
PASS (container-tag/redis): refusal names the tag, the resolved version,
                             the licence and the rule.
```

---

### AC-9 · A documentation change surfaces the cards it invalidates

**Status: implemented and tested.**

`scripts/verify-drift-reconciliation.sh` verifies the fixture:

```
PASS: Documentation drift reconciliation fixture verified
      (surfaced, flagged, logged, zero false positives).
```

---

### AC-10 · Every host matrix cell is backed by what it claims

**Status: implemented and tested.**

`scripts/check-host-pointers.sh` validates all pointer files and all matrix
cells against the four-state schema:

```
PASS: All host pointers resolve, no instruction text is duplicated,
      and host matrix is verified honest.
```

The matrix itself is in `docs/ARCHITECTURE.md`. All cells use one of the four
permitted states: `Mechanically verified`, `Config-shape verified`,
`Observed working`, or `Not verified`. No cell uses `Observed working` without a
dated record; none claims more than was done.

---

### AC-11 · README carries the claim and its limit in the same paragraph

**Status: implemented and tested.**

`scripts/check-public-docs.sh` enforces this invariant and was confirmed
passing, both against this repository and against its own six self-tests:

```
PASS: claim and limit are paired, README sections are present,
      authoring guide is complete, dogfood is reported,
      and no reference project is named.

PASS: self-test 1 — a claim without its limit is refused.
PASS: self-test 2 — a limit without its claim is refused.
PASS: self-test 3 — a complete, paired document set passes.
PASS: self-test 4 — a README missing a required section is refused.
PASS: self-test 5 — a named external repository is refused.
PASS: self-test 6 — a second host matrix is refused.
```

---

## Release checklist items not addressed here

The release checklist (`docs/RELEASE_CHECKLIST.md`) contains items beyond the
eleven criteria above. Those not covered:

- *Trivial request sized down and provably skips most of the chain* — the sizing
  fixture confirms the gate distinguishes Direct from Full, but end-to-end relay
  skipping (Board → PM → done, no BA/SQA) has not been run in a vendor host.
  **Status: experimental.**

- *Deleting the log directory and re-running regenerates it* — this was not
  exercised in this session. The current implementation has no regeneration step;
  the log is append-only by design and there is no reconstruction path.
  **Status: unsupported (by design; log is append-only).**

- *The same task completes against every supported board backend* — the board
  adapter script confirms Markdown, Obsidian and Linear produce equivalent
  contract state, and the Linear adapter is refused when unreachable. End-to-end
  completion in a real Obsidian vault or a real Linear workspace has not been run.
  **Status: experimental.**

---

## What is not verified and why

| Gap | Why it cannot be closed from this environment |
|---|---|
| Second agent session re-reads state accurately | No way to launch a second agent with wiped context and observe its output from a shell |
| Existing-project interview asks ≤ 4 questions | Interview is instruction; whether a vendor host follows it is not reportable from CI |
| Full relay in a real vendor host | Requires a vendor coding-agent application; no such application is present in this environment |
| Obsidian vault end-to-end | Requires a real Obsidian vault application |
| Real Linear board end-to-end | Requires a Linear workspace, MCP server, or API key |
| Four-level role composition | Only three levels exist in `employees/`; the script handles four but the content does not demonstrate it |

---

## All verification scripts passing as of this commit

| Script | Result |
|---|---|
| `check-word-budget.sh` | PASS |
| `check-host-pointers.sh .` | PASS |
| `check-public-docs.sh .` | PASS |
| `check-log-sequence.sh board` | PASS |
| `check-evidence.sh` | PASS |
| `check-tools-registry.sh` | PASS |
| `check-principles.sh` | PASS |
| `check-board-adapters.sh` | PASS |
| `check-board-connect-existing.sh` | PASS |
| `check-board-reachability.sh fixtures/board-adapters/reachability` | PASS |
| `check-board-reachability.sh fixtures/board-adapters/reachability/bad` | REFUSED (expected) |
| `check-board-reachability.sh --docs` | PASS |
| `check-inheritance-proof.sh` | PASS |
| `check-composed-budget.sh employees/software-engineer/backend-developer/nodejs` | PASS (591/600) |
| `check-role-skeleton.sh` | PASS |
| `check-workflow-data.sh fixtures/workflows-as-data security-review` | PASS |
| `check-workflow-override.sh fixtures/override-resolution BA` | PASS |
| `check-duplicate-sentences.sh` | PASS |
| `verify-drift-reconciliation.sh` | PASS |
| `check-public-docs.sh --self-test` | PASS (6/6 self-tests) |
| `check-sizing-gate.sh fixtures/sizing-gate` | PASS |
| Fresh-directory relay (mktemp) | PASS — `check-log-sequence.sh` confirmed |

---

## What a v1.0 tag would mean

The tag would mark the point where every mechanically verifiable criterion
passes, and every gap that requires a vendor host is documented honestly. It
would not mean:

- The skill works in every host.
- An agent reading the skill will follow it.
- The relay produces a correct outcome every time.

It would mean: the structure is correct, the checks are real, the limits are
stated, and nothing aspirational has been written.
