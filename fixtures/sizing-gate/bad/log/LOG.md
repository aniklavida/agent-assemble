| timestamp            | event                | id                  | role     | note                                           |
|----------------------|----------------------|---------------------|----------|------------------------------------------------|
| 2026-09-23T09:00:00Z | CARD_CREATED         | TASK-DIRECT-BAD-001 | BA       | BA erroneously ran on a Direct-sized card      |
| 2026-09-23T09:05:00Z | DIRECT_CLOSED        | TASK-DIRECT-BAD-001 | PM       | Direct path closed                             |
| 2026-09-23T10:00:00Z | CARD_CREATED         | TASK-FULL-BAD-001   | BA       | Full path; BA elicitation complete             |
| 2026-09-23T12:00:00Z | WORK_STARTED         | TASK-FULL-BAD-001   | Engineer | Card moved to in-progress                      |
| 2026-09-23T14:00:00Z | WORK_COMPLETED       | TASK-FULL-BAD-001   | Engineer | Card moved to testing                          |
| 2026-09-23T17:00:00Z | CARD_CLOSED          | TASK-FULL-BAD-001   | PM       | Closed without SQA verification — bad fixture  |
