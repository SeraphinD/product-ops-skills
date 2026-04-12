# AI-ACT-REVIEW.md Output Template

The final `AI-ACT-REVIEW.md` adapts based on review mode (triage, deep, or verify). All modes share the header and disclaimer.

## Full Template (Deep Mode — SPEC review)

```markdown
# AI Act Review: {Feature Name}

> Reviewed artifact: {relative path to reviewed artifact}
> Review mode: {Triage | Deep | Verify}
> Date: {YYYY-MM-DD}
> Prior review: {Yes (dated YYYY-MM-DD) | No}

> **Disclaimer:** This review identifies EU AI Act-relevant concerns and maps them to specific regulation articles. It is not legal advice and does not replace consultation with legal counsel. The AI Act's implementation is phased (2024–2027) — check which provisions are currently in force.

---

## AI System Inventory

| AI Component | Type | Input Data | Output | Decision Impact | User-Facing? |
|---|---|---|---|---|---|
| {e.g., recommendation engine} | {recommendation} | {user behavior} | {product suggestions} | {influences purchases} | {Yes / No} |

---

## Risk Classification

**Overall risk level:** {Unacceptable | High-risk | Limited risk | Minimal risk}

### Classification Reasoning

| Criterion | AI Act Reference | Applies? | Evidence |
|---|---|---|---|
| Prohibited practice (Art. 5) | Art. 5({N}) | {Yes / No} | {detail} |
| High-risk — Annex III | Annex III, {category} | {Yes / No} | {detail} |
| Limited risk — transparency | Art. 50 | {Yes / No} | {detail} |
| General-purpose AI model | Art. 51-55 | {Yes / No} | {detail} |

---

## Transparency Requirements

| Requirement | AI Act Reference | Status | Finding |
|---|---|---|---|
| AI interaction disclosure | Art. 50(1) | {Met / Not met / N/A} | {detail} |
| AI-generated content labeling | Art. 50(2) | {Met / Not met / N/A} | {detail} |
| Emotion recognition disclosure | Art. 50(3) | {Met / Not met / N/A} | {detail} |
| Technical documentation | Art. 11 | {Met / Not met / N/A} | {detail} |
| Instructions for use | Art. 13 | {Met / Not met / N/A} | {detail} |

---

## Human Oversight Assessment

<!-- Include for high-risk systems -->

| Requirement | AI Act Reference | Status | Finding |
|---|---|---|---|
| Understanding of system capabilities | Art. 14(4)(a) | {Met / Not met} | {detail} |
| Ability to interpret output | Art. 14(4)(b) | {Met / Not met} | {detail} |
| Ability to override/not use | Art. 14(4)(c-d) | {Met / Not met} | {detail} |
| Ability to intervene/halt | Art. 14(4)(e) | {Met / Not met} | {detail} |

---

## Data Governance Assessment

<!-- Include for high-risk systems -->

| Requirement | AI Act Reference | Status | Finding |
|---|---|---|---|
| Training data quality | Art. 10(2) | {Met / Not met / Unknown} | {detail} |
| Data representativeness | Art. 10(3) | {Met / Not met / Unknown} | {detail} |
| Bias examination | Art. 10(2)(f) | {Met / Not met / Unknown} | {detail} |
| Data governance practices | Art. 10(2) | {Met / Not met / Unknown} | {detail} |

---

## Conformity Assessment

**Assessment type required:** {Self-assessment | Third-party | Not required}
**AI Act Reference:** Art. 43

| Factor | Detail |
|---|---|
| Risk category | {category from Annex III} |
| Assessment procedure | {internal control (Annex VI) / third-party (Annex VII)} |
| Notified body needed | {Yes / No} |
| Timeline | {when this obligation takes effect} |

---

## Compliance Acceptance Criteria

Concrete scenarios that should be added to the SPEC or verified in the PLAN:

### Scenario {N}: {Scenario Name}
**GIVEN** {precondition}
**WHEN** {action}
**THEN** {expected AI Act-compliant outcome}
**AI Act Reference:** Art. {N}

---

## Summary

| Area | Status | Key Findings |
|---|---|---|
| AI components identified | {N} | {brief summary} |
| Risk classification | {level} | {brief summary} |
| Transparency requirements | {Met / Gaps found} | {brief summary} |
| Human oversight | {Met / Gaps found / N/A} | {brief summary} |
| Data governance | {Met / Gaps found / N/A} | {brief summary} |
| Conformity assessment | {Required / Not required} | {brief summary} |
| Compliance ACs proposed | {N} scenarios | {brief summary} |
| Applicability timeline | {date range} | {which provisions are in force now vs upcoming} |
```

---

## Triage Mode Template (BRIEF review)

```markdown
# AI Act Review: {Feature Name}

> Reviewed artifact: {relative path to BRIEF.md}
> Review mode: Triage
> Date: {YYYY-MM-DD}

> **Disclaimer:** This review identifies EU AI Act-relevant concerns and maps them to specific regulation articles. It is not legal advice and does not replace consultation with legal counsel.

---

## AI Detection

| AI Signal | Detected In | Type | Confidence |
|---|---|---|---|
| {e.g., recommendation engine} | {Solution section} | {recommendation system} | {High / Medium / Low} |

<!-- If no AI detected: "This feature does not appear to use AI or automated decision-making. AI Act review is not applicable." — stop here -->

---

## Preliminary Risk Classification

**Estimated risk level:** {Unacceptable | High-risk | Limited risk | Minimal risk}

| Factor | Assessment | Reasoning |
|---|---|---|
| Prohibited practice? | {Yes / No / Unlikely} | {why} |
| High-risk category? | {Yes / No / Possible} | {which Annex III category, if any} |
| Transparency obligation? | {Yes / No / Likely} | {why} |

---

## Recommendations for SPEC

- {Recommendation 1 — what AI Act ACs to include}
- {Recommendation 2}
- ...

---

## Summary

{2–3 sentences summarizing triage findings, risk level, and recommended next steps.}
```

---

## Verify Mode Template (DESIGN or PLAN review)

```markdown
# AI Act Review: {Feature Name}

> Reviewed artifact: {relative path to reviewed artifact}
> Review mode: Verify
> Prior review: {relative path to prior AI-ACT-REVIEW.md}
> Date: {YYYY-MM-DD}

> **Disclaimer:** This review identifies EU AI Act-relevant concerns and maps them to specific regulation articles. It is not legal advice and does not replace consultation with legal counsel.

---

## Coverage Check

| AI Act Requirement (from prior review) | Covered? | Evidence | Gap? |
|---|---|---|---|
| {requirement} | {Yes / No / Partial} | {specific step/component} | {gap description} |

---

## New Findings

- {Finding not in prior review}

---

## Gap Report

| Gap | Severity | Recommendation |
|---|---|---|
| {missing item} | {Critical / High / Medium / Low} | {what to add} |

---

## Summary

{2–3 sentences: coverage status, gaps, recommended actions.}
```

## Constraints

- **Disclaimer always present** — every review includes the legal advice and phased implementation disclaimer
- **Risk classification always stated** — even triage mode must provide a preliminary risk level
- **Applicability timeline** — deep mode must note which AI Act provisions are currently in force
- **Acceptance criteria format** — compliance ACs use the same Given/When/Then format as the SPEC
- **No legal conclusions** — findings describe compliance status, not legal opinions
