# Workflow Registry

**Status:** experimental.

Each entry is a named workflow. A project adds its own by appending a row here;
no `SKILL.md` file needs to change.

The `roles` list is the ordered relay. Sizing decides *which* workflow runs;
the workflow decides *who* runs and in what order.

---

## Built-in workflows

### full

**Description:** New capabilities or cross-cutting changes. All gates active.

**Roles (in order):**
1. PM
2. BA
3. Employee
4. SQA
5. PM

---

### short

**Description:** Bounded 1–2 file changes. BA writes criteria directly into the
card; no separate plan document.

**Roles (in order):**
1. PM
2. BA
3. Employee
4. SQA
5. PM

---

### direct

**Description:** Trivial single-line fixes. BA and SQA gates skipped.

**Roles (in order):**
1. PM
2. Employee
3. PM

---

### hotfix

**Description:** Critical defect in production requiring immediate remediation.
SQA gate retained; BA elicitation skipped.

**Roles (in order):**
1. PM
2. Employee
3. SQA
4. PM

---

### research

**Description:** Spike or discovery work producing a decision record rather than
a code change.

**Roles (in order):**
1. PM
2. BA
3. Researcher
4. PM

---

## Project workflows

### security-review

**Description:** Dedicated security pass on a completed feature. No new code;
SQA and Security both gate before PM closes.

**Roles (in order):**
1. PM
2. SQA
3. Security
4. PM
