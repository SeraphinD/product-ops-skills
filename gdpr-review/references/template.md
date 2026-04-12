# GDPR-REVIEW.md Output Template

The final `GDPR-REVIEW.md` adapts its structure based on the review mode (triage, deep, or verify). All modes share the header and disclaimer. Deep mode includes all sections; triage and verify include a subset.

## Full Template (Deep Mode — SPEC review)

```markdown
# GDPR Review: {Feature Name}

> Reviewed artifact: {relative path to reviewed artifact}
> Review mode: {Triage | Deep | Verify}
> Date: {YYYY-MM-DD}
> Prior review: {Yes (dated YYYY-MM-DD) | No}

> **Disclaimer:** This review identifies GDPR-relevant concerns and maps them to specific regulation articles. It is not legal advice and does not replace consultation with a Data Protection Officer or legal counsel.

---

## Personal Data Inventory

| Data Element | Category | Source | Purpose | Legal Basis (Art. 6) | Storage | Retention |
|---|---|---|---|---|---|---|
| {e.g., email address} | Identification | {user input} | {authentication} | {(b) Contract} | {database} | {specified / unknown} |

---

## Legal Basis Assessment

For each processing activity identified above:

### {Processing Activity Name}
- **Legal basis:** Art. 6(1)({letter}) — {basis name}
- **Justification:** {why this basis applies}
- **Source:** {official source URL}
- **Risk:** {Low / Medium / High} — {brief explanation}

---

## Data Subject Rights Coverage

| Right | GDPR Article | Covered in Artifact? | Finding |
|---|---|---|---|
| Right of access | Art. 15 | {Yes / No / Partial} | {what's present or missing} |
| Right to rectification | Art. 16 | {Yes / No / Partial} | {finding} |
| Right to erasure | Art. 17 | {Yes / No / Partial} | {finding} |
| Right to restriction | Art. 18 | {Yes / No / Partial} | {finding} |
| Right to data portability | Art. 20 | {Yes / No / Partial} | {finding} |
| Right to object | Art. 21 | {Yes / No / Partial} | {finding} |
| Automated decision-making | Art. 22 | {Yes / No / Partial / N/A} | {finding} |

---

## Consent Assessment

<!-- Include only if consent (Art. 6(1)(a)) is a legal basis for any processing activity -->

| Requirement | GDPR Reference | Status | Finding |
|---|---|---|---|
| Freely given | Art. 7, Recital 42 | {Met / Not met / Unknown} | {detail} |
| Specific per purpose | Art. 6(1)(a) | {status} | {detail} |
| Informed | Art. 13 | {status} | {detail} |
| Unambiguous | Art. 4(11) | {status} | {detail} |
| Withdrawable | Art. 7(3) | {status} | {detail} |
| Proof of consent stored | Art. 7(1) | {status} | {detail} |

---

## Privacy by Design Assessment

| Principle | GDPR Reference | Status | Finding |
|---|---|---|---|
| Data minimization | Art. 5(1)(c), Art. 25 | {Met / Not met / Unknown} | {detail} |
| Purpose limitation | Art. 5(1)(b) | {status} | {detail} |
| Storage limitation | Art. 5(1)(e) | {status} | {detail} |
| Pseudonymization / encryption | Art. 25, Art. 32 | {status} | {detail} |

---

## DPIA Assessment

**DPIA required:** {Yes / No / Likely / Needs further assessment}

| Trigger (Art. 35) | Applies? | Evidence |
|---|---|---|
| Systematic monitoring | {Yes / No} | {detail} |
| Large-scale special categories | {Yes / No} | {detail} |
| Automated decisions with legal effect | {Yes / No} | {detail} |
| New technologies with high risk | {Yes / No} | {detail} |
| Profiling | {Yes / No} | {detail} |

---

## Compliance Acceptance Criteria

Concrete scenarios that should be added to the SPEC or verified in the PLAN:

### Scenario {N}: {Scenario Name}
**GIVEN** {precondition}
**WHEN** {action}
**THEN** {expected GDPR-compliant outcome}
**GDPR Reference:** Art. {N}

---

## Summary

| Area | Status | Key Findings |
|---|---|---|
| Personal data identified | {N} data elements | {brief summary} |
| Legal basis coverage | {N}/{M} activities assessed | {brief summary} |
| Data subject rights | {N}/{7} rights covered | {brief summary} |
| Consent requirements | {Met / Gaps found / N/A} | {brief summary} |
| Privacy by design | {Met / Gaps found} | {brief summary} |
| DPIA | {Required / Not required / Needs assessment} | {brief summary} |
| Compliance ACs proposed | {N} scenarios | {brief summary} |
```

---

## Triage Mode Template (BRIEF review)

Use a subset of the full template:

```markdown
# GDPR Review: {Feature Name}

> Reviewed artifact: {relative path to BRIEF.md}
> Review mode: Triage
> Date: {YYYY-MM-DD}

> **Disclaimer:** This review identifies GDPR-relevant concerns and maps them to specific regulation articles. It is not legal advice and does not replace consultation with a Data Protection Officer or legal counsel.

---

## Personal Data Detection

| Data Element | Category | Detected In | Confidence |
|---|---|---|---|
| {data element} | {category} | {which BRIEF section} | {High / Medium / Low} |

---

## Initial Risk Assessment

| Area | Risk Level | Reasoning |
|---|---|---|
| Consent mechanism needed | {Yes / No / Likely} | {why} |
| Privacy policy update | {Yes / No / Likely} | {why} |
| DPIA likely needed | {Yes / No / Likely} | {why} |
| DPO notification needed | {Yes / No / Likely} | {why} |

---

## Recommendations for SPEC

- {Recommendation 1 — what GDPR-related ACs to include when writing the SPEC}
- {Recommendation 2}
- ...

---

## Summary

{2–3 sentences summarizing the triage findings and recommended next steps.}
```

---

## Verify Mode Template (DESIGN or PLAN review)

```markdown
# GDPR Review: {Feature Name}

> Reviewed artifact: {relative path to reviewed artifact}
> Review mode: Verify
> Prior review: {relative path to prior GDPR-REVIEW.md}
> Date: {YYYY-MM-DD}

> **Disclaimer:** This review identifies GDPR-relevant concerns and maps them to specific regulation articles. It is not legal advice and does not replace consultation with a Data Protection Officer or legal counsel.

---

## Coverage Check

| GDPR Requirement (from prior review) | Covered in {artifact type}? | Evidence | Gap? |
|---|---|---|---|
| {requirement from prior review} | {Yes / No / Partial} | {specific step, component, or section} | {description of gap if any} |

---

## New Findings

<!-- Findings not covered in the prior review -->

- {New finding 1}
- {New finding 2}

---

## Gap Report

| Gap | Severity | Recommendation |
|---|---|---|
| {missing item} | {Critical / High / Medium / Low} | {what to add or change} |

---

## Summary

{2–3 sentences: how many requirements are covered, how many gaps remain, recommended actions.}
```

## Constraints

- **Disclaimer always present** — every review mode includes the legal advice disclaimer
- **Prior review reference** — verify mode must reference the prior review artifact
- **Official source citations** — deep mode findings must cite the GDPR article and, where consulted, the official source URL
- **Acceptance criteria format** — compliance ACs use the same Given/When/Then format as the SPEC
- **No legal conclusions** — findings describe compliance status and gaps, not legal opinions
