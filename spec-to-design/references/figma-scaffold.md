# Figma Scaffold — Web Design

Instructions for the optional Figma scaffold sub-step after writing `DESIGN.md`. Only applies when `FIGMA_MODE = active`.

---

## Trigger

After writing `DESIGN.md`, ask: *"DESIGN.md is written. Would you like me to scaffold this design in your Figma file?"*

If the user declines, `DESIGN.md` is the complete output — no further action needed.

---

## Scaffold Steps

If the user confirms:

1. **Create a page** in the Figma file named `[Feature Name] — Generated` (never overwrite or rename existing pages).

2. **Sync new design tokens**: for any token marked `★ New` in the Design System section (colors, text styles added for this feature), create them as local styles or variables in Figma so they are available to designers.

3. **Scaffold frames**: for each page layout defined in Step 12, create a frame at the correct dimensions:
   - Desktop: `1440 × 900`
   - Tablet: `768 × 1024`
   - Mobile: `375 × 812`
   Name each frame after its layout (e.g., `Dashboard — Desktop`, `Dashboard — Mobile`).

4. **Add layout annotations**: within each frame, add text annotation nodes labelling the major regions (header, sidebar, content, footer, modal) matching the ASCII wireframe. Keep annotations on a dedicated annotation layer — do not block the design canvas.

5. **Confirm**: *"Scaffolded {N} frames on Figma page `[Feature Name] — Generated` with {M} new styles synced. Open your Figma file to flesh out the designs."*
