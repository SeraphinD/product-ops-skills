# Feature Retrospective — Troubleshooting

Common issues encountered during retrospective generation and how to resolve them.

---

## Artifact Issues

### BRIEF.md not found
**Symptom:** Can't evaluate success criteria because BRIEF.md is missing.
**Cause:** The feature directory doesn't contain a BRIEF.md, or it's at a different path.
**Fix:** Ask the user for the BRIEF.md path. If no BRIEF exists, the retro can still run but must skip the Success Criteria Evaluation section entirely — note this limitation in the RETRO.md header.

### TASKS.md not found
**Symptom:** Can't compute metrics or determine retro mode.
**Cause:** Tasks were never generated, or execution was tracked outside the pipeline.
**Fix:** Run without TASKS.md. Default to Checkpoint mode. Metrics section will be limited to SPEC and DECISION data. Note: "No TASKS.md found — task metrics unavailable."

### DECISION.md is empty or missing
**Symptom:** No rollback data, no decision history.
**Cause:** Decisions weren't logged during the pipeline run, or no decisions were needed.
**Fix:** This is valid — a clean pipeline run may produce no decisions. Report: "0 decisions logged — either the pipeline ran without controversies or decisions weren't tracked."

---

## Evaluation Issues

### Can't map success criterion to SPEC acceptance criteria
**Symptom:** A BRIEF success criterion doesn't have a clear counterpart in the SPEC.
**Cause:** The SPEC was generated without full coverage of BRIEF objectives, or the criterion is at a different level of abstraction.
**Fix:** Mark as UNTESTABLE with evidence: "No AC coverage in SPEC.md for this criterion." Flag in Lessons Learned: "BRIEF criterion '{X}' had no SPEC coverage — run validate-coverage.sh to catch this."

### User disagrees with a verdict
**Symptom:** The user says a criterion should be PASS but you assessed it as PARTIAL.
**Cause:** The user has context not captured in artifacts (e.g., manual testing, user feedback).
**Fix:** Adjust the verdict based on the user's evidence. Log the override in DECISION.md: "Verdict override: '{criterion}' changed from PARTIAL to PASS based on user-provided evidence: {description}."

### All criteria are UNTESTABLE
**Symptom:** Every success criterion gets UNTESTABLE verdict.
**Cause:** BRIEF criteria were written at too high a level (e.g., "users are satisfied") or the SPEC didn't break them into verifiable scenarios.
**Fix:** Proceed with the retro but flag this prominently in Lessons Learned: "All success criteria were untestable from artifacts alone. Future briefs should include measurable, artifact-verifiable criteria."

---

## Metrics Issues

### Task counts don't match between TASKS.md header and table
**Symptom:** The summary line says 15 tasks but the table has 17 rows.
**Cause:** TASKS.md header wasn't updated after execution or was manually edited.
**Fix:** Count from the actual table rows. Report the discrepancy: "TASKS.md header shows {N} total but table has {M} tasks. Using table count." Suggest running `validate-execution.sh` to fix.

### No dates in DECISION.md for duration calculation
**Symptom:** Can't compute pipeline stage durations because decisions lack dates.
**Cause:** The Date field was omitted or uses inconsistent formats.
**Fix:** Skip duration metrics. Note: "Pipeline stage durations unavailable — DECISION.md entries lack consistent dates."

### OPPORTUNITY.md effort score doesn't map to task count
**Symptom:** Effort was scored on a 1-5 Fibonacci scale but tasks are counted in absolute numbers.
**Cause:** Different units — OPPORTUNITY uses relative scoring, TASKS uses absolute counts.
**Fix:** Report both values side by side without computing a ratio. Note the unit mismatch: "Effort score ({N}) uses RICE relative scale; task count ({M}) is absolute. Direct comparison is approximate."

---

## Output Issues

### RETRO.md is too long
**Symptom:** The generated retro has 300+ lines and is hard to read.
**Cause:** Large feature with many stories, scenarios, and decisions.
**Fix:** Summarize where possible. Group similar AC scenarios instead of listing each one. Aggregate blocked tasks by root cause instead of listing individually. Keep the full data in tables but use summary bullets in narrative sections.

### User wants to add context not in artifacts
**Symptom:** The user mentions team dynamics, timeline pressure, or other factors.
**Cause:** Not all project context lives in pipeline artifacts.
**Fix:** Add a "Context" section after the header with user-provided information. Frame it as: "Additional context provided during retrospective (not from pipeline artifacts)."
