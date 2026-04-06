# Figma Scaffold — Web Design

Instructions for the optional Figma scaffold sub-step after writing `DESIGN.md`. Only applies when `FIGMA_MODE = active`.

---

## Trigger

After writing `DESIGN.md`, ask: *"DESIGN.md is written. Would you like me to scaffold this design in your Figma file? I'll create a page, sync new tokens, and set up frames for each layout. Nothing will be written to Figma until you confirm."*

If the user declines, `DESIGN.md` is the complete output — no further action needed.

---

## Scaffold Steps

If the user confirms:

1. **Preview what will be written**: before any write operation, present a summary of all planned changes:
   - Page to create: `[Feature Name] — Generated`
   - New tokens to sync: list each `★ New` color, text style, and variable from the Design System section
   - Frames to scaffold: list each layout with its dimensions (Desktop `1440 × 900`, Tablet `768 × 1024`, Mobile `375 × 812`)

   Ask: *"Here's what I'll add to your Figma file. Proceed?"*

   **Do not call any write tool until the user explicitly confirms.**

2. **Create a page** in the Figma file named `[Feature Name] — Generated` (never overwrite or rename existing pages).

3. **Sync new design tokens**: for any token marked `★ New` in the Design System section (colors, text styles added for this feature), create them as local styles or variables in Figma so they are available to designers.

4. **Scaffold frames**: for each page layout defined in Step 12, create a frame at the correct dimensions:
   - Desktop: `1440 × 900`
   - Tablet: `768 × 1024`
   - Mobile: `375 × 812`
   Name each frame after its layout (e.g., `Dashboard — Desktop`, `Dashboard — Mobile`).

5. **Add layout annotations**: within each frame, add text annotation nodes labelling the major regions (header, sidebar, content, footer, modal) matching the ASCII wireframe. Keep annotations on a dedicated annotation layer — do not block the design canvas.

6. **Visual verification**: call `get_screenshot` on the created page to verify the scaffold looks correct. Evaluate spacing, alignment, and clipping. Fix any issues before confirming.

7. **Confirm**: *"Scaffolded {N} frames on Figma page `[Feature Name] — Generated` with {M} new styles synced. Open your Figma file to flesh out the designs."*

---

## Error Handling

If any Figma tool call fails mid-scaffold:
1. Log the failure to `DECISION.md`: `Figma scaffold failed at step {X}: {error}`.
2. Complete as many frames as possible.
3. Inform the user: *"Figma scaffold partially completed — {N} of {M} frames created. See DECISION.md for details. You can complete the remaining frames manually."*
