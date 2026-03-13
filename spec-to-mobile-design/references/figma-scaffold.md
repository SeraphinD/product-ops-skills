# Figma Scaffold — Mobile Design

Instructions for the optional Figma scaffold sub-step after writing `DESIGN.md`. Only applies when `FIGMA_MODE = active`.

---

## Trigger

After writing `DESIGN.md`, ask: *"DESIGN.md is written. Would you like me to scaffold the mobile screens in your Figma file?"*

If the user declines, `DESIGN.md` is the complete output — no further action needed.

---

## Scaffold Steps

If the user confirms:

1. **Create a page** in the Figma file named `[Feature Name] — Generated` (never overwrite or rename existing pages).

2. **Sync new design tokens**: for any token marked `★ New` in the Design System section (colors, text styles added for this feature), create them as local styles or variables in Figma. If the file uses platform modes (iOS/Android variable sets), add the new tokens to the correct mode.

3. **Scaffold frames**: for each screen layout defined in Step 12, create frames at the correct mobile dimensions:
   - iOS: `390 × 844` (iPhone 14/15 base) — include safe area guides (top: 59pt, bottom: 34pt)
   - Android: `360 × 800` (Material baseline) — include status bar guide (24dp) and nav bar guide (48dp)
   - If the SPEC targets only one platform, scaffold only that platform's frames
   - Name each frame: `[Screen Name] — iOS` / `[Screen Name] — Android`

4. **Add layout annotations**: within each frame, add text annotation nodes labelling the major regions (navigation bar, content area, tab bar, bottom sheet, FAB) matching the ASCII wireframe. Keep annotations on a dedicated annotation layer.

5. **Confirm**: *"Scaffolded {N} screens ({M} iOS + {K} Android) on Figma page `[Feature Name] — Generated` with {L} new styles synced. Safe area guides are set. Open your Figma file to flesh out the designs."*
