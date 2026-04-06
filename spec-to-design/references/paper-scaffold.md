# Paper Scaffold — Web Design

Instructions for the optional Paper scaffold sub-step after writing `DESIGN.md`. Only applies when `PAPER_MODE = active`.

---

## Trigger

After writing `DESIGN.md`, ask: *"DESIGN.md is written. Would you like me to scaffold this design in Paper? I'll create artboards, write layout structure, and apply design tokens. Nothing will be written to Paper until you confirm."*

If the user declines, `DESIGN.md` is the complete output — no further action needed.

---

## Scaffold Steps

If the user confirms:

1. **Preview what will be written**: before any write operation, present a summary of all planned changes:
   - Artboards to create: list each layout with its dimensions (Desktop `1440 × 900`, Tablet `768 × 1024`, Mobile `375 × 812`)
   - New tokens to apply: list each `★ New` color, text style, and spacing value from the Design System section
   - Layout structure: list the major regions per artboard (header, sidebar, content, footer, etc.)

   Ask: *"Here's what I'll add to your Paper file. Proceed?"*

   **Do not call any write tool until the user explicitly confirms.**

2. **Create artboards** for each page layout defined in Step 12, at the correct dimensions:
   - Desktop: `1440 × 900`
   - Tablet: `768 × 1024`
   - Mobile: `375 × 812`
   Name each artboard after its layout (e.g., `Dashboard — Desktop`, `Dashboard — Mobile`).

2. **Write layout structure**: for each artboard, use `write_html` to create the major layout regions (header, sidebar, content area, footer, modal placeholders) matching the ASCII wireframe from the DESIGN.md. Use semantic HTML structure — Paper renders it into design nodes.

3. **Apply design tokens**: use `update_styles` to apply the Design System tokens (colors, typography, spacing) from the DESIGN.md to the scaffolded nodes. For tokens marked `★ New`, apply them directly. For tokens marked `✦ Existing`, reference the values already documented.

4. **Add text annotations**: use `set_text_content` on annotation nodes to label major regions, matching the wireframe labels.

5. **Review checkpoint** (mandatory): after every 2–3 modifications, call `get_screenshot` and evaluate as a senior designer:
   - **Spacing**: even gaps, clear visual rhythm
   - **Typography**: readable sizes, clear hierarchy
   - **Contrast**: text legible against backgrounds
   - **Alignment**: elements sharing consistent lanes
   - **Clipping**: no content cut off at artboard edges (fix with `update_styles` → height/width `fit-content` if needed)
   Fix any issues before continuing.

6. **Finish**: call `finish_working_on_nodes` for each artboard when done.

7. **Confirm**: *"Scaffolded {N} artboards in Paper ({Desktop + Tablet + Mobile counts}) with layout structure and design tokens applied. Review the artboards to flesh out the designs."*

---

## Error Handling

If any Paper tool call fails mid-scaffold:
1. Log the failure to `DECISION.md`: `Paper scaffold failed at step {X}: {error}`.
2. Complete as many artboards as possible.
3. Inform the user: *"Paper scaffold partially completed — {N} of {M} artboards created. See DECISION.md for details. You can complete the remaining artboards manually."*
