# DESIGN.md Output Template

The final `DESIGN.md` must follow **exactly** this structure:

```markdown
# Design: {Feature Name}

> Generated from: {relative path to SPEC.md}
> Date: {YYYY-MM-DD}

---

## Design Overview
{Brief overview of the design approach and philosophy — derived from SPEC user stories and functional scope}

## Design Goals
<!-- 3 to 6 goals -->
- {Goal 1 — tied to a SPEC user story benefit or functional requirement}
- {Goal 2}
- {Goal 3}
- ...

---

## Design System

### Color Palette
| Role | Color | Hex | Usage | Contrast Ratio |
|------|-------|-----|-------|----------------|
| **Primary** | {Color name} | `#XXXXXX` | {Usage} | {ratio} ≥ 4.5:1 |
| **Secondary** | {Color name} | `#XXXXXX` | {Usage} | {ratio} ≥ 4.5:1 |
| **Success** | {Color name} | `#XXXXXX` | {Usage} | {ratio} ≥ 4.5:1 |
| **Error** | {Color name} | `#XXXXXX` | {Usage} | {ratio} ≥ 4.5:1 |
| **Neutral** | {Color name} | `#XXXXXX` | {Usage} | {ratio} ≥ 4.5:1 |

### Typography
| Element | Font | Size | Weight | Line Height | Usage |
|---------|------|------|--------|-------------|-------|
| **H1** | {Font} | {Size} | {Weight} | {Line height} | Page titles |
| **H2** | {Font} | {Size} | {Weight} | {Line height} | Section headings |
| **Body** | {Font} | {Size} | {Weight} | {Line height} | Paragraph text |
| **Button** | {Font} | {Size} | {Weight} | {Line height} | Button labels |
| **Caption** | {Font} | {Size} | {Weight} | {Line height} | Help text, labels |

### Spacing & Layout
- **Base Unit:** {e.g., 8px}
- **Spacing Scale:** {e.g., 4, 8, 12, 16, 24, 32, 48, 64}
- **Breakpoints:**
  - Mobile: < 640px
  - Tablet: 640px – 1024px
  - Desktop: > 1024px

---

## Components

### {Component Name}
**Source Story:** User Story {N} — {MUST | SHOULD | COULD}
**States:** {default, hover, active, disabled, loading, error, ...}
**Variants:** {primary, secondary, danger, ...}

```
{ASCII wireframe of the component if complex}
```

**Usage:** {When and where to use this component}
**Accessibility:** {Keyboard support, ARIA labels, focus management}

{repeat for each component derived from SPEC functional scope}

---

## Page Layouts

### {Page Name}: {Purpose}
**Source Story:** User Story {N} — {MUST | SHOULD | COULD}
**URL/Route:** {Route if applicable}
**Description:** {What this page does}

```
{ASCII box-drawing diagram showing component placement}
```

**Key Elements:**
- {Component 1: location and purpose}
- {Component 2: location and purpose}

**Responsive Behavior:**
- Mobile (< 640px): {Layout changes}
- Desktop (> 1024px): {Default layout}

{repeat for each page/screen}

---

## User Flows

### {Flow Name}: {User Goal}
**Source Story:** User Story {N} — {MUST | SHOULD | COULD}

```
{ASCII flow diagram: Start → Step 1 → Step 2 → Success}
                                ↓
                          Error Handling
```

**Steps:**
1. User performs {action}
2. System shows {feedback}
3. Success condition: {what success looks like}

**Error Path:**
- {Error condition}: {what happens}

{repeat for each major user flow}

---

## Interactions & Animations

### Page Transitions
- **Type:** {Fade, slide, none, etc.}
- **Duration:** {ms}
- **Easing:** {ease-in-out, cubic-bezier, etc.}

### Hover Effects
- **Buttons:** {Description}
- **Cards:** {Description}

### Loading States
- **Spinner:** {When to use, animation details}
- **Skeleton:** {When to use, placeholder design}

### Error States
- **Animation:** {Shake, highlight, etc.}
- **Message placement:** {Above/below input, toast, inline}
- **Auto-dismiss:** {Duration or manual dismiss}

---

## Accessibility Requirements

- [ ] **WCAG 2.1 Level AA** compliance target
- [ ] **Keyboard Navigation:** All interactive elements accessible via Tab
- [ ] **Focus Indicators:** Visible focus states on all interactive elements
- [ ] **Color Contrast:** Minimum 4.5:1 for normal text, 3:1 for large text
- [ ] **Screen Reader Support:** Semantic HTML, ARIA labels where needed
- [ ] **Form Labels:** Every input has an associated label
- [ ] **Error Messages:** Programmatically associated with form fields
- [ ] **Skip Links:** Skip to main content link on pages with navigation
- [ ] **Motion:** Respects `prefers-reduced-motion` media query

{add feature-specific accessibility items derived from SPEC}

---

## Dark Mode *(if applicable)*

### Color Mapping
| Element | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Background | {Color} | {Color} |
| Surface | {Color} | {Color} |
| Text Primary | {Color} | {Color} |
| Text Secondary | {Color} | {Color} |
| Accent | {Color} | {Color} |

### Implementation Notes
- {Toggle mechanism}
- {Persistence strategy}

---

## Responsive Design Details

### Mobile (< 640px)
- {Layout: single column}
- {Navigation: hamburger menu / bottom nav}
- {Typography adjustments}
- {Touch target sizes: minimum 44x44px}

### Tablet (640px – 1024px)
- {Layout adjustments}
- {Navigation changes}

### Desktop (> 1024px)
- {Full layout}
- {Navigation: full horizontal nav}
- {Optimal content width}

---

## Design Files & References

- **Figma:** {Link or "N/A — design defined in this document"}
- **Design System:** {Link to external system or "Defined above"}
- **Brand Guidelines:** {Link or "N/A"}
- **Benchmark References:** {Reference to BENCHMARK.md visual references if used, or "N/A"}

---

## Checklist for Design Approval

- [ ] All pages/screens have layouts with ASCII diagrams
- [ ] All components have states and variants documented
- [ ] Color palette meets WCAG AA contrast ratios
- [ ] Typography scale is complete
- [ ] User flows cover happy path and error paths
- [ ] Responsive behavior defined for mobile and desktop
- [ ] Accessibility requirements specified
- [ ] Interactive states documented (hover, focus, loading, error)
- [ ] Design approved by stakeholders
```
