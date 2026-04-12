# ACCESSIBILITY-REVIEW.md Output Template

The final `ACCESSIBILITY-REVIEW.md` adapts based on review mode (triage, deep, or verify) and platform (web, iOS, Android, cross-platform). All modes share the header. Deep mode includes all sections; triage and verify include a subset.

## Full Template (Deep Mode — SPEC or DESIGN review)

```markdown
# Accessibility Review: {Feature Name}

> Reviewed artifact: {relative path to reviewed artifact}
> Review mode: {Triage | Deep | Verify}
> Platform: {Web | iOS | Android | Cross-platform (React Native) | Cross-platform (Flutter)}
> Standards: {WCAG 2.1 AA | WCAG 2.1 AA + RGAA | iOS HIG Accessibility | Android Accessibility | WCAG2ICT}
> Date: {YYYY-MM-DD}
> Prior review: {Yes (dated YYYY-MM-DD) | No}

---

## Accessibility Audit

### {Component / Page / User Story Name}

| Criterion | Standard | Status | Finding | Severity |
|---|---|---|---|---|
| {e.g., Text alternatives} | {WCAG 1.1.1 / VoiceOver accessibilityLabel} | {Pass / Fail / N/A} | {detail} | {Critical / Major / Minor} |

---

## Platform-Specific Findings

<!-- Include only the sections relevant to the detected platform -->

### Web Findings
| Area | WCAG Criterion | RGAA Criterion | Status | Finding |
|---|---|---|---|---|
| Keyboard navigation | 2.1.1 Keyboard | {RGAA N} | {Pass / Fail} | {detail} |
| Focus visible | 2.4.7 Focus Visible | {RGAA N} | {Pass / Fail} | {detail} |
| Color contrast | 1.4.3 Contrast (Minimum) | {RGAA N} | {Pass / Fail} | {detail} |
| ARIA roles | 4.1.2 Name, Role, Value | {RGAA N} | {Pass / Fail} | {detail} |

### iOS Findings (VoiceOver)
| Area | Guideline | Status | Finding |
|---|---|---|---|
| accessibilityLabel | HIG — Labels | {Pass / Fail} | {detail} |
| accessibilityTraits | HIG — Traits | {Pass / Fail} | {detail} |
| Dynamic Type | HIG — Typography | {Pass / Fail} | {detail} |
| Focus order | HIG — Navigation | {Pass / Fail} | {detail} |
| Reduced motion | HIG — Motion | {Pass / Fail} | {detail} |
| Custom actions | HIG — Gestures | {Pass / Fail / N/A} | {detail} |

### Android Findings (TalkBack)
| Area | Guideline | Status | Finding |
|---|---|---|---|
| contentDescription | Material — Descriptions | {Pass / Fail} | {detail} |
| Role semantics | Material — Roles | {Pass / Fail} | {detail} |
| Touch targets (48x48dp) | Material — Touch | {Pass / Fail} | {detail} |
| Font scaling | Material — Typography | {Pass / Fail} | {detail} |
| Reduced motion | Material — Motion | {Pass / Fail} | {detail} |

### Cross-Platform Findings
<!-- For React Native or Flutter — include both iOS and Android sections above, plus: -->
| Area | Framework Pattern | Status | Finding |
|---|---|---|---|
| {e.g., accessibilityLabel prop (RN)} | {React Native Accessibility API} | {Pass / Fail} | {detail} |
| {e.g., Semantics widget (Flutter)} | {Flutter Semantics API} | {Pass / Fail} | {detail} |

---

## Color Contrast Analysis

<!-- Include when reviewing a DESIGN or when SPEC specifies colors -->

| Element | Foreground | Background | Ratio | Required | Status |
|---|---|---|---|---|---|
| {e.g., Body text} | {#hex} | {#hex} | {N:1} | {4.5:1 / 3:1} | {Pass / Fail} |

---

## Compliance Acceptance Criteria

Concrete scenarios that should be added to the SPEC or verified in the PLAN:

### Scenario {N}: {Scenario Name}
**GIVEN** {precondition}
**WHEN** {action}
**THEN** {expected accessible outcome}
**Standard Reference:** {WCAG X.X.X / HIG Accessibility / Material Accessibility}

---

## Summary

| Area | Status | Key Findings |
|---|---|---|
| Platform | {platform} | {standards applied} |
| Components audited | {N} | {pass/fail counts} |
| Critical findings | {N} | {brief summary} |
| Major findings | {N} | {brief summary} |
| Minor findings | {N} | {brief summary} |
| Compliance ACs proposed | {N} scenarios | {brief summary} |

**Overall assessment:** {Compliant / Partially compliant / Non-compliant — with explanation}
```

---

## Triage Mode Template (BRIEF review)

```markdown
# Accessibility Review: {Feature Name}

> Reviewed artifact: {relative path to BRIEF.md}
> Review mode: Triage
> Platform: {detected platform or "To be determined"}
> Date: {YYYY-MM-DD}

---

## UI Detection

- **Has UI:** {Yes / No}
- **Platform:** {Web / iOS / Android / Cross-platform / Unknown}
- **Detection basis:** {what signals were found}

<!-- If no UI: "This feature has no user interface. Accessibility review is not applicable." — stop here -->

---

## Initial Assessment

| Area | Relevance | Reasoning |
|---|---|---|
| Form accessibility | {High / Medium / Low / N/A} | {why} |
| Navigation / focus management | {relevance} | {why} |
| Screen reader support | {relevance} | {why} |
| Color / contrast | {relevance} | {why} |
| Motion / animation | {relevance} | {why} |
| Media (audio/video) | {relevance} | {why} |

---

## Recommendations for SPEC

- {Recommendation 1 — what accessibility ACs to include}
- {Recommendation 2}
- ...

---

## Summary

{2–3 sentences summarizing triage findings and recommended next steps.}
```

---

## Verify Mode Template (PLAN review)

```markdown
# Accessibility Review: {Feature Name}

> Reviewed artifact: {relative path to PLAN.md}
> Review mode: Verify
> Platform: {platform}
> Prior review: {relative path to prior ACCESSIBILITY-REVIEW.md}
> Date: {YYYY-MM-DD}

---

## Testing Coverage

| Testing Method | Present in PLAN? | Tool/Approach |
|---|---|---|
| Automated testing | {Yes / No} | {axe-core / Lighthouse / Accessibility Scanner / Accessibility Inspector} |
| Manual keyboard testing | {Yes / No} | {description} |
| Screen reader testing | {Yes / No} | {VoiceOver / TalkBack / NVDA} |
| Color contrast check | {Yes / No} | {tool or manual} |

---

## Coverage Check

| A11Y Requirement (from prior review) | Covered in PLAN? | Evidence | Gap? |
|---|---|---|---|
| {requirement} | {Yes / No / Partial} | {specific plan step} | {gap description} |

---

## Gap Report

| Gap | Severity | Recommendation |
|---|---|---|
| {missing item} | {Critical / High / Medium / Low} | {what to add} |

---

## Summary

{2–3 sentences: testing coverage status, gaps remaining, recommended actions.}
```

## Constraints

- **Platform always stated** — every review mode must declare the detected platform in the header
- **Standards always stated** — the header lists which accessibility standards were applied
- **Severity classification** — findings use Critical (blocks users), Major (significant barrier), Minor (inconvenience)
- **RGAA mapping** — when French compliance is relevant, include RGAA criterion alongside WCAG
- **Acceptance criteria format** — compliance ACs use the same Given/When/Then format as the SPEC
- **Color contrast data** — when auditing design, include actual hex values and computed ratios
