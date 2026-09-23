| timestamp            | event                | id              | role     | note                                        |
|----------------------|----------------------|-----------------|----------|---------------------------------------------|
| 2026-09-23T09:05:00Z | DIRECT_CLOSED        | TASK-DIRECT-001 | PM       | Direct path; no BA or SQA gate applies      |
| 2026-09-23T10:00:00Z | CARD_CREATED         | TASK-FULL-001   | BA       | Full path; BA elicitation complete          |
| 2026-09-23T12:00:00Z | WORK_STARTED         | TASK-FULL-001   | Engineer | Card moved to in-progress                   |
| 2026-09-23T14:00:00Z | WORK_COMPLETED       | TASK-FULL-001   | Engineer | Card moved to testing                       |
| 2026-09-23T15:30:00Z | VERIFICATION_PASSED  | TASK-FULL-001   | SQA      | Per-criterion sabotage evidence complete    |
| 2026-09-23T16:00:00Z | CARD_CLOSED          | TASK-FULL-001   | PM       | Log trail confirmed unbroken; card done     |
