# PM Sizing Gate Fixtures

Two fixture requests demonstrate PM's routing decision mechanically.

## Fixture A — Direct path: trivial one-line fix

**Request:** Fix the typo "recieve" → "receive" in `api/responses.py` line 42.

**PM scoring (sizing-rubric.md):**

| Dimension | Score | Reason |
|---|---|---|
| Blast Radius | Low | 1 file, 1 character change |
| Ambiguity | Low | Intent and solution are obvious |
| Architecture | None | No schema, interface, or pattern change |
| Verification | Low | Visual inspection of the corrected string |

**Result: Direct**

**Path taken:** PM → Employee immediately. BA is bypassed (no card created by BA,
no plan document). SQA is bypassed (no sabotage gate). PM appends `DIRECT_CLOSED`
to `log/LOG.md` after the fix is applied.

**Card created by PM (not BA):** See `TASK-DIRECT-001.md`.

---

## Fixture B — Full path: substantial feature

**Request:** Add a webhook notification system: when a task card moves to `done`,
POST the card summary to a configurable URL with retry logic on failure.

**PM scoring (sizing-rubric.md):**

| Dimension | Score | Reason |
|---|---|---|
| Blast Radius | High | New module, 3+ files, API surface change |
| Ambiguity | High | Retry behaviour, payload schema, and auth unspecified |
| Architecture | High | New system pattern; configurable external integration |
| Verification | High | Full test suite plus sabotage test required |

**Result: Full**

**Path taken:** PM → BA (elicitation first, then plan in `documentation/plans/`,
then card). BA → Employee → SQA (with per-criterion sabotage evidence) → PM closure
with log audit.

**No direct or short bypass applies.** All roles engage.

**Card created by BA:** See `TASK-FULL-001.md`.

---

## Mechanical verification

```sh
# Direct fixture: must not contain a Sabotage Evidence section (Direct bypasses SQA)
grep -c "## Sabotage Evidence" fixtures/sizing-gate/TASK-DIRECT-001.md
# Expected output: 0  (exit status 1 from grep, meaning not found)

# Full fixture: must contain a Sabotage Evidence section with evidence filled in
grep -c "## Sabotage Evidence" fixtures/sizing-gate/TASK-FULL-001.md
# Expected output: 1

# Both fixtures must pass check-evidence.sh (Direct cards are exempt; Full must have evidence)
bash scripts/check-evidence.sh fixtures/sizing-gate
```
