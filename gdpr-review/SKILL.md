---
name: gdpr-review
description: Reviews any pipeline artifact (BRIEF, SPEC, DESIGN, or PLAN) for GDPR/RGPD compliance — identifying personal data processing, required legal bases, consent requirements, data subject rights, and DPIA triggers. Adapts review depth to the artifact type. Produces a GDPR-REVIEW.md with findings, compliance ACs, and citations to official sources. Trigger on phrases like "GDPR review", "RGPD review", "data protection check", "privacy review", "check GDPR compliance", "personal data review", "data privacy audit", or when the user wants to assess a feature's data protection implications. Do NOT use for accessibility (use accessibility-review) or AI Act compliance (use ai-act-review). This skill reviews existing artifacts only — it does not generate briefs, specs, or plans.
allowed-tools: "Read Write Glob Grep WebSearch WebFetch"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: compliance
  tags: [gdpr, rgpd, privacy, data-protection, compliance, review, cross-cutting]
---

# GDPR Review Skill

This skill reviews any pipeline artifact for GDPR (General Data Protection Regulation) / RGPD compliance. It identifies personal data processing, assesses legal bases, flags missing consent flows, checks data subject rights coverage, and evaluates DPIA necessity.

This is a **cross-cutting review skill** — it runs alongside the pipeline, not as a sequential stage:

```
[PROBLEM FRAME] → BRIEF → [BENCHMARK] → [OPPORTUNITY] → SPEC → [DESIGN] → PLAN → TASKS → [EXECUTION] → [RETRO]
                     ↑                                      ↑        ↑         ↑
                     └──── GDPR review can run at any of these stages ──────────┘
```

**Artifact produced:** `docs/features/{feature-name}/GDPR-REVIEW.md`

---

## Output Template

**Before writing any output, read `references/template.md` for the exact GDPR-REVIEW.md structure.**

**After writing, run `bash scripts/validate-gdpr-review.sh {path-to-review}` to verify structural completeness.**

---

## Review Depth by Artifact Type

The skill adapts its analysis based on which artifact it reviews:

| Artifact | Review Mode | Depth | What it produces |
|----------|-------------|-------|------------------|
| BRIEF | Triage | Light | Short assessment: does this feature touch personal data? What categories? Flags for Assumptions & Risks |
| SPEC | Deep | Full | Complete review: data inventory, legal basis per processing activity, consent flow ACs, data subject rights ACs, DPIA assessment |
| DESIGN | Verify | Moderate | Checks consent UI, privacy settings page, cookie management, data collection forms |
| PLAN | Verify | Moderate | Checks implementation steps cover all GDPR requirements from prior review. Gap report |

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've identified from the artifact
2. Propose your findings as a draft
3. Ask for confirmation or adjustments before moving on
4. Never skip a section — if you can't assess confidently, ask a targeted question

**Never generate the full review in one shot without confirming each major block** with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the Artifact

Find the target artifact. Look in this order:
1. The path the user provides directly
2. `docs/features/*/` matching any feature name in context — scan for BRIEF.md, SPEC.md, DESIGN.md, PLAN.md
3. Any pipeline artifact in the current working directory

If multiple artifacts exist and the user didn't specify which one to review, ask:
> "I found {list of artifacts} for `{feature-name}`. Which one should I review? (SPEC gives the deepest coverage; BRIEF gives an early triage.)"

If no artifacts are found, ask the user to provide the path.

### Step 2 — Detect Artifact Type

Determine which artifact is being reviewed to set the review depth:

- If the file is named `BRIEF.md` or contains `# Project Brief:` → **Triage mode**
- If the file is named `SPEC.md` or contains `# [` and `- Specifications` → **Deep mode**
- If the file is named `DESIGN.md` or contains `## Design System` → **Verify mode (design)**
- If the file is named `PLAN.md` or contains `# Implementation Plan:` → **Verify mode (plan)**

Announce the mode:
> "Reviewing `{artifact}` in **{mode}** mode. {Brief explanation of what this mode covers.}"

### Step 3 — Load Prior Review

Check if a `GDPR-REVIEW.md` already exists in `docs/features/{feature-name}/`.

If it exists:
1. Read it in full
2. Inform the user: *"A prior GDPR review exists (dated {date}). I'll highlight what's changed since then."*
3. During the review, flag any findings that are new vs. previously identified

If no prior review exists, proceed normally.

### Step 4 — Load Domain Knowledge

Read `references/gdpr-checklist.md` to load the review framework — which GDPR articles to check for this artifact type, in what order, and what to look for.

### Step 5 — Load Prior Decisions

Check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision directly conflicts with a GDPR requirement, flag the conflict: *"Decision {N} says X, but GDPR Article {Y} requires Z. This needs resolution."*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

### Step 6 — Consult Official Sources

For the relevant GDPR articles identified in the checklist, use `WebSearch` and `WebFetch` to consult official sources:
- **EUR-Lex** (`eur-lex.europa.eu`) for the GDPR full text
- **EDPB** (`edpb.europa.eu`) for guidelines and opinions
- **CNIL** (`cnil.fr`) for French-specific guidance

Cite the source URL for each finding in the review artifact.

### Step 7 — Run the Review (Triage Mode — BRIEF)

If reviewing a BRIEF:

1. **Personal Data Detection** — scan the Problem Statement, Solution, Scope, and Success Criteria for mentions of personal data (names, emails, user accounts, behavior tracking, location, device IDs, etc.)
2. **Data Category Classification** — classify detected data into GDPR categories (identification, contact, behavioral, financial, health, biometric, etc.)
3. **Initial Risk Flag** — based on data categories, flag whether the feature likely needs:
   - Consent mechanisms
   - Privacy policy updates
   - DPIA (Data Protection Impact Assessment)
   - DPO notification
4. **Recommendations for SPEC** — list what GDPR-related acceptance criteria should be included when writing the SPEC

Present findings and confirm with the user.

### Step 8 — Run the Review (Deep Mode — SPEC)

If reviewing a SPEC:

1. **Data Inventory** — for each User Story, identify what personal data is collected, processed, or stored. Build a data flow table:

| Data Element | Source | Purpose | Storage | Retention |
|---|---|---|---|---|
| {e.g., email address} | {user input / third-party} | {authentication / notification} | {database / cache} | {specified or unknown} |

2. **Legal Basis Assessment** — for each processing activity, assess which GDPR Art. 6 legal basis applies:
   - (a) Consent
   - (b) Contract performance
   - (c) Legal obligation
   - (d) Vital interests
   - (e) Public interest
   - (f) Legitimate interests

3. **Data Subject Rights Coverage** — check whether the SPEC's acceptance criteria cover:
   - Art. 15: Right of access
   - Art. 16: Right to rectification
   - Art. 17: Right to erasure ("right to be forgotten")
   - Art. 18: Right to restriction of processing
   - Art. 20: Right to data portability
   - Art. 21: Right to object
   - Art. 22: Automated decision-making safeguards

4. **Consent Requirements** — if consent is the legal basis, check for:
   - Freely given, specific, informed, unambiguous (Art. 7)
   - Granular consent per purpose
   - Easy withdrawal mechanism
   - Proof of consent storage

5. **Privacy by Design Assessment** — evaluate against Art. 25:
   - Data minimization (only collect what's needed)
   - Purpose limitation
   - Storage limitation
   - Pseudonymization or encryption where applicable

6. **DPIA Necessity** — assess against Art. 35 triggers:
   - Systematic monitoring of public areas
   - Large-scale processing of special categories
   - Automated decision-making with legal effects
   - New technologies with high risk
   - Profiling

7. **Compliance Acceptance Criteria** — derive concrete Given/When/Then scenarios for missing GDPR requirements

Present each section as a draft. Confirm before moving on.

### Step 9 — Run the Review (Verify Mode — DESIGN)

If reviewing a DESIGN:

1. **Consent UI** — check for consent collection interfaces (cookie banners, consent forms, opt-in checkboxes)
2. **Privacy Settings** — check for user-accessible privacy/data management pages
3. **Data Collection Forms** — check that forms collect only necessary data (data minimization)
4. **Transparency** — check that the UI communicates what data is collected and why
5. **Withdrawal Mechanism** — check for easy consent withdrawal flows

Present findings and confirm.

### Step 10 — Run the Review (Verify Mode — PLAN)

If reviewing a PLAN:

1. **Implementation Coverage** — cross-reference GDPR requirements from prior review (if exists) against planned implementation steps
2. **Missing Steps** — flag any GDPR requirements with no corresponding implementation step
3. **Verification Items** — check that the Verification Checklist includes GDPR-specific items
4. **Data Storage Steps** — check for encryption, access control, and retention policy implementation

Present findings as a gap report and confirm.

### Step 11 — Determine Output Path

The `GDPR-REVIEW.md` is **always** written to:

```
docs/features/{feature-name}/GDPR-REVIEW.md
```

**Resolution logic:**

1. If the reviewed artifact is inside `docs/features/{feature-name}/`, write the review to the same directory.
2. Otherwise, derive `{feature-name}` from the artifact's title and write to `docs/features/{feature-name}/GDPR-REVIEW.md`.
3. Create the directory if it does not exist.
4. If a `GDPR-REVIEW.md` already exists, confirm with the user before overwriting.
5. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the GDPR review to `docs/features/{feature-name}/GDPR-REVIEW.md`."*

### Step 12 — Write the File

1. Assemble the complete `GDPR-REVIEW.md` using the template
2. Show the full content to the user for review
3. Ask: *"Ready to write this GDPR-REVIEW.md?"*
4. Write the file using the Write tool

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Legal basis choices** — which Art. 6 basis applies to each processing activity and why
- **Risk assessments** — whether a DPIA is needed and the reasoning
- **Scope decisions** — data elements classified as personal vs. non-personal when ambiguous
- **Conflict resolutions** — when GDPR requirements conflict with existing decisions or spec constraints

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **Cite official sources** — every GDPR finding must reference the specific article and, when consulted, include the official source URL. Never paraphrase regulations without attribution.
2. **Flag, don't block** — the review identifies compliance gaps and proposes acceptance criteria. It does not prevent the pipeline from proceeding. The user decides what to act on.
3. **Adapt to artifact type** — triage mode for BRIEFs, deep mode for SPECs, verify mode for DESIGNs and PLANs. Never run a deep review on a BRIEF (not enough information) or a triage on a SPEC (wastes the available detail).
4. **No legal advice** — this skill identifies GDPR-relevant concerns and maps them to specific articles. It is not a substitute for legal counsel. Include this disclaimer in every review artifact.
5. **Interactive and thorough** — confirm each section with the user before moving on. Never generate the full review in one shot.
6. **English always** — write the GDPR-REVIEW.md in English regardless of the language used in the conversation.
7. **Prior review awareness** — when a prior GDPR-REVIEW.md exists, highlight what's new vs. previously identified. Don't re-report unchanged findings without noting they were already flagged.
8. **Don't modify other artifacts** — this skill reads pipeline artifacts but never changes them. If the SPEC is missing a consent flow, note it in the review; don't edit the SPEC.

---

## Pipeline Iteration

This skill can trigger upstream revisions when it finds compliance gaps.

### When to Flag Upstream Issues

- **BRIEF missing data protection context** — flag in the review: *"The BRIEF doesn't mention personal data handling, but the feature clearly processes {data type}. Consider updating the BRIEF's Assumptions & Risks section."*
- **SPEC missing consent ACs** — the review proposes concrete Given/When/Then scenarios. Flag: *"These acceptance criteria should be added to the SPEC before implementation."*
- **PLAN missing GDPR implementation steps** — flag in the gap report: *"The PLAN has no steps for implementing {requirement}. Consider updating the PLAN."*

These findings are captured in GDPR-REVIEW.md. The user decides whether to act on them.

For the universal rollback protocol (should it be needed), see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: Triage review of a BRIEF
User says: "GDPR review on the user registration brief"
Actions:
1. Locate `docs/features/user-registration/BRIEF.md`, read it
2. Triage mode — detect personal data: email, password, name, IP address
3. Classify data categories: identification, contact, technical
4. Flag: consent mechanism needed, privacy policy update required, no DPIA likely needed
5. Recommend SPEC acceptance criteria for consent and data subject rights
6. Write to `docs/features/user-registration/GDPR-REVIEW.md`
Result: Short triage assessment with 4 recommendations for the SPEC

### Example 2: Deep review of a SPEC
User says: "Run a GDPR review on the analytics dashboard spec"
Actions:
1. Locate `docs/features/analytics-dashboard/SPEC.md`, read it
2. Deep mode — build data inventory: page views, click events, user sessions, device info
3. Legal basis: legitimate interests (Art. 6(1)(f)) for analytics, consent for tracking cookies
4. Data subject rights: no erasure AC, no access AC, no portability AC — all flagged
5. Privacy by design: data retention not specified — flagged
6. DPIA: systematic monitoring of user behavior — DPIA likely needed
7. Produce 6 compliance acceptance criteria in Given/When/Then format
8. Write to `docs/features/analytics-dashboard/GDPR-REVIEW.md`
Result: Full GDPR review with data inventory, legal basis assessment, 6 compliance ACs, and DPIA recommendation

### Example 3: Verify review of a PLAN
User says: "Check GDPR compliance of the notification system plan"
Actions:
1. Locate `docs/features/notification-system/PLAN.md`, read it
2. Load prior `GDPR-REVIEW.md` — found, with 4 requirements
3. Verify mode — check plan steps against requirements
4. Gap: no step for consent withdrawal implementation, no step for data retention policy
5. Verification checklist missing GDPR items
6. Produce gap report with 2 missing implementation steps
7. Write updated `docs/features/notification-system/GDPR-REVIEW.md`
Result: Gap report showing 2 of 4 GDPR requirements not covered in the PLAN

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
