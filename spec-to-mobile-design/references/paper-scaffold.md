# Paper Scaffold — Mobile Design

Instructions for the optional Paper scaffold sub-step after writing `DESIGN.md`. Only applies when `PAPER_MODE = active`.

---

## Trigger

After writing `DESIGN.md`, ask: *"DESIGN.md is written. Would you like me to scaffold the mobile screens in Paper? I'll create artboards, write screen structure, and apply design tokens with safe area guides. Nothing will be written to Paper until you confirm."*

If the user declines, `DESIGN.md` is the complete output — no further action needed.

---

## Scaffold Steps

If the user confirms:

1. **Preview what will be written**: before any write operation, present a summary of all planned changes:
   - Artboards to create: list each screen with platform and dimensions (iOS `390 × 844`, Android `360 × 800`)
   - New tokens to apply: list each `★ New` color, text style, and spacing value from the Design System section
   - Screen structure: list the major regions per artboard (navigation bar, content, tab bar, safe areas, etc.)

   Ask: *"Here's what I'll add to your Paper file. Proceed?"*

   **Do not call any write tool until the user explicitly confirms.**

2. **Create artboards** for each screen layout defined in Step 12, at the correct mobile dimensions:
   - iOS: `390 × 844` (iPhone 14/15 base) — include safe area guides (top: 59pt, bottom: 34pt)
   - Android: `360 × 800` (Material baseline) — include status bar guide (24dp) and nav bar guide (48dp)
   - If the SPEC targets only one platform, scaffold only that platform's artboards
   Name each artboard: `[Screen Name] — iOS` / `[Screen Name] — Android`.

2. **Write screen structure**: for each artboard, use `write_html` to create the major screen regions (navigation bar, content area, tab bar, bottom sheet, FAB placeholders) matching the ASCII wireframe from the DESIGN.md. Use semantic HTML structure — Paper renders it into design nodes. Include safe area spacers as empty containers at the correct heights.

3. **Apply design tokens**: use `update_styles` to apply the Design System tokens (colors, typography in platform-native units, spacing) from the DESIGN.md to the scaffolded nodes. For tokens marked `★ New`, apply them directly. For tokens marked `✦ Existing`, reference the values already documented.

4. **Add text annotations**: use `set_text_content` on annotation nodes to label major regions (navigation bar, content, tab bar, safe areas), matching the wireframe labels.

5. **Review checkpoint** (mandatory): after every 2–3 modifications, call `get_screenshot` and evaluate as a senior designer:
   - **Spacing**: even gaps, clear visual rhythm, safe areas respected
   - **Typography**: readable sizes in platform-native units, clear hierarchy
   - **Contrast**: text legible against backgrounds
   - **Alignment**: elements sharing consistent lanes
   - **Clipping**: no content cut off at artboard edges (fix with `update_styles` → height/width `fit-content` if needed)
   Fix any issues before continuing.

6. **Finish**: call `finish_working_on_nodes` for each artboard when done.

7. **Confirm**: *"Scaffolded {N} screens ({M} iOS + {K} Android) in Paper with layout structure, design tokens, and safe area guides applied. Review the artboards to flesh out the designs."*

---

## Error Handling

If any Paper tool call fails mid-scaffold:
1. Log the failure to `DECISION.md`: `Paper scaffold failed at step {X}: {error}`.
2. Complete as many artboards as possible.
3. Inform the user: *"Paper scaffold partially completed — {N} of {M} screens created. See DECISION.md for details. You can complete the remaining screens manually."*
