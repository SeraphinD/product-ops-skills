# WCAG 2.1 AA Review Checklist (Web)

Review framework for the `accessibility-review` skill — **web platform**. Defines what WCAG success criteria to check per component type and artifact. The actual standards text is fetched live via `WebSearch`/`WebFetch`.

**Official sources for live lookup:**
- WCAG 2.1: `https://www.w3.org/TR/WCAG21/`
- WCAG 2.2: `https://www.w3.org/TR/WCAG22/`
- WAI-ARIA Authoring Practices: `https://www.w3.org/WAI/ARIA/apg/`
- RGAA 4.1: `https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/`
- Understanding WCAG: `https://www.w3.org/WAI/WCAG21/Understanding/`

---

## WCAG 2.1 AA Success Criteria by Category

### 1. Perceivable

| Criterion | ID | What to check | Common failures |
|---|---|---|---|
| Text Alternatives | 1.1.1 | Images, icons, charts have alt text or aria-label | Decorative images not marked as `role="presentation"` |
| Captions | 1.2.2 | Video content has captions | Auto-generated captions without review |
| Audio Description | 1.2.5 | Video has audio description for visual-only info | Complex visualizations without text alternative |
| Info and Relationships | 1.3.1 | Headings use proper h1-h6, lists use ul/ol, tables have headers | Styled divs instead of semantic elements |
| Meaningful Sequence | 1.3.2 | Reading order matches visual order in DOM | CSS reordering breaks screen reader flow |
| Sensory Characteristics | 1.3.3 | Instructions don't rely solely on shape, size, position, or sound | "Click the red button" without additional identifier |
| Orientation | 1.3.4 | Content works in both portrait and landscape | Fixed orientation without justification |
| Input Purpose | 1.3.5 | Form fields have `autocomplete` attributes | Missing autocomplete on address/payment forms |
| Contrast (Minimum) | 1.4.3 | 4.5:1 for normal text, 3:1 for large text (18pt/14pt bold) | Low-contrast placeholder text, disabled states |
| Resize Text | 1.4.4 | Content readable at 200% zoom | Fixed pixel sizes that break at zoom |
| Images of Text | 1.4.5 | Real text preferred over text in images | Logos are exempt |
| Reflow | 1.4.10 | Content reflows at 320px width without horizontal scroll | Fixed-width layouts |
| Non-text Contrast | 1.4.11 | 3:1 contrast for UI components and graphics | Low-contrast borders, icons, focus indicators |
| Text Spacing | 1.4.12 | Content readable with increased letter/line/word spacing | Overflow or clipping when spacing increased |
| Content on Hover/Focus | 1.4.13 | Tooltips dismissible, hoverable, and persistent | Tooltips that disappear on mouse movement |

### 2. Operable

| Criterion | ID | What to check | Common failures |
|---|---|---|---|
| Keyboard | 2.1.1 | All functionality available via keyboard | Custom components without keyboard handlers |
| No Keyboard Trap | 2.1.2 | Focus can leave every component | Modals, dropdowns trapping focus |
| Timing Adjustable | 2.2.1 | Time limits can be extended or disabled | Session timeouts without warning |
| Pause, Stop, Hide | 2.2.2 | Moving/auto-updating content can be paused | Auto-playing carousels, live feeds |
| Three Flashes | 2.3.1 | No content flashes more than 3 times per second | Animated transitions, loading indicators |
| Bypass Blocks | 2.4.1 | Skip navigation link or landmark regions | No skip link, no ARIA landmarks |
| Page Titled | 2.4.2 | Every page has a descriptive title | Generic "Home" or missing titles |
| Focus Order | 2.4.3 | Tab order follows logical reading order | Tabindex > 0, visual reordering |
| Link Purpose | 2.4.4 | Link text describes destination (in context) | "Click here", "Read more" without context |
| Multiple Ways | 2.4.5 | Multiple ways to find pages (nav, search, sitemap) | Single navigation path only |
| Headings and Labels | 2.4.6 | Headings and labels are descriptive | Vague headings, unlabeled form sections |
| Focus Visible | 2.4.7 | Keyboard focus indicator is visible | `outline: none` without replacement |

### 3. Understandable

| Criterion | ID | What to check | Common failures |
|---|---|---|---|
| Language of Page | 3.1.1 | `lang` attribute on `<html>` | Missing or incorrect language |
| Language of Parts | 3.1.2 | Foreign-language passages marked with `lang` | Mixed-language content without marking |
| On Focus | 3.2.1 | No context change on focus alone | Dropdowns that navigate on focus |
| On Input | 3.2.2 | No unexpected context change on input | Auto-submitting forms |
| Consistent Navigation | 3.2.3 | Navigation in same order across pages | Rearranged navigation between sections |
| Consistent Identification | 3.2.4 | Same function = same label across pages | "Search" vs "Find" for the same feature |
| Error Identification | 3.3.1 | Errors identified and described in text | Color-only error indication |
| Labels or Instructions | 3.3.2 | Form fields have visible labels | Placeholder-only labels that disappear |
| Error Suggestion | 3.3.3 | Error messages suggest corrections | "Invalid input" without guidance |
| Error Prevention | 3.3.4 | Legal/financial submissions: reversible, checked, or confirmed | No confirmation for destructive actions |

### 4. Robust

| Criterion | ID | What to check | Common failures |
|---|---|---|---|
| Parsing | 4.1.1 | Valid HTML (no duplicate IDs, proper nesting) | Duplicate `id` attributes |
| Name, Role, Value | 4.1.2 | Custom components expose name, role, value to AT | Custom dropdowns without ARIA roles |
| Status Messages | 4.1.3 | Status updates announced without focus change | Toast notifications not in `aria-live` region |

---

## RGAA 4.1 Mapping

When French compliance is required, map each WCAG finding to the corresponding RGAA criterion. Key mappings:

| WCAG | RGAA Theme | RGAA Criteria |
|---|---|---|
| 1.1.1 | Images | 1.1–1.9 |
| 1.3.1 | Structure | 9.1–9.4 |
| 1.4.3, 1.4.11 | Colors | 3.1–3.3 |
| 2.1.1, 2.1.2 | Navigation | 12.1–12.14 |
| 2.4.7 | Navigation | 12.7 |
| 3.3.1–3.3.4 | Forms | 11.1–11.13 |
| 4.1.2 | Scripts | 7.1–7.5 |

Consult the official RGAA reference for the complete mapping: `https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/`

---

## Component-Level Checklist

When reviewing a DESIGN, check each component against these patterns:

| Component Type | Key Checks |
|---|---|
| Button | `role="button"`, keyboard Enter/Space activation, visible focus, disabled state announced |
| Link | Descriptive text, `role="link"`, keyboard Enter activation, visited state |
| Form field | Visible label, `aria-describedby` for help text, error association, autocomplete |
| Modal/Dialog | `role="dialog"`, `aria-modal="true"`, focus trap, Escape to close, return focus on close |
| Dropdown/Select | `role="listbox"`, arrow key navigation, type-ahead, `aria-expanded` |
| Tab panel | `role="tablist/tab/tabpanel"`, arrow keys to switch, `aria-selected` |
| Table | `<th>` with scope, `<caption>`, sortable columns announced |
| Toast/Alert | `role="alert"` or `aria-live="assertive"`, auto-dismiss timing |
| Navigation | `<nav>` with `aria-label`, current page indicated with `aria-current` |
| Accordion | `aria-expanded`, keyboard Enter/Space toggle, heading wrapper |
