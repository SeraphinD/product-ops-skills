# Figma Scaffold — Mobile Design

Instructions for the optional Figma scaffold sub-step after writing `DESIGN.md`. Only applies when `FIGMA_MODE = active`.

---

## Trigger

After writing `DESIGN.md`, ask: *"DESIGN.md is written. Would you like me to scaffold the mobile screens in your Figma file? I'll create a page, sync new tokens, and set up frames with safe area guides. Nothing will be written to Figma until you confirm."*

If the user declines, `DESIGN.md` is the complete output — no further action needed.

---

## Scaffold Steps

If the user confirms:

1. **Preview what will be written**: before any write operation, present a summary of all planned changes:
   - Page to create: `[Feature Name] — Generated`
   - New tokens to sync: list each `★ New` color, text style, and variable from the Design System section (with platform mode assignments if the file uses iOS/Android variable sets)
   - Frames to scaffold: list each screen with platform and dimensions (iOS `390 × 844`, Android `360 × 800`)

   Ask: *"Here's what I'll add to your Figma file. Proceed?"*

   **Do not call any write tool until the user explicitly confirms.**

2. **Create a page** in the Figma file named `[Feature Name] — Generated` (never overwrite or rename existing pages).

3. **Sync new design tokens**: for any token marked `★ New` in the Design System section (colors, text styles added for this feature), create them as local styles or variables in Figma. If the file uses platform modes (iOS/Android variable sets), add the new tokens to the correct mode.

4. **Scaffold frames**: for each screen layout defined in Step 12, create frames at the correct mobile dimensions:
   - iOS: `390 × 844` (iPhone 14/15 base) — include safe area guides (top: 59pt, bottom: 34pt)
   - Android: `360 × 800` (Material baseline) — include status bar guide (24dp) and nav bar guide (48dp)
   - If the SPEC targets only one platform, scaffold only that platform's frames
   - Name each frame: `[Screen Name] — iOS` / `[Screen Name] — Android`

5. **Add layout annotations**: within each frame, add text annotation nodes labelling the major regions (navigation bar, content area, tab bar, bottom sheet, FAB) matching the ASCII wireframe. Keep annotations on a dedicated annotation layer.

6. **Visual verification**: call `get_screenshot` on the created page to verify the scaffold looks correct. Evaluate spacing, alignment, safe area placement, and clipping. Fix any issues before confirming.

7. **Confirm**: *"Scaffolded {N} screens ({M} iOS + {K} Android) on Figma page `[Feature Name] — Generated` with {L} new styles synced. Safe area guides are set. Open your Figma file to flesh out the designs."*

---

## Error Handling

If any Figma tool call fails mid-scaffold:
1. Log the failure to `DECISION.md`: `Figma scaffold failed at step {X}: {error}`.
2. Complete as many screens as possible.
3. Inform the user: *"Figma scaffold partially completed — {N} of {M} screens created. See DECISION.md for details. You can complete the remaining screens manually."*
