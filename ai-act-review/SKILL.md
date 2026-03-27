---
name: ai-act-review
description: Reviews any pipeline artifact (BRIEF, SPEC, DESIGN, or PLAN) for EU AI Act compliance — identifying AI system classification, risk level, transparency requirements, human oversight obligations, and conformity assessment needs. Adapts review depth to the artifact type. Produces an AI-ACT-REVIEW.md with findings, compliance ACs, and citations to official sources. Trigger on phrases like "AI Act review", "AI compliance check", "AI risk assessment", "AI Act compliance", "check AI regulations", "EU AI regulation review", or when the user wants to assess a feature's AI Act implications. Do NOT use for GDPR (use gdpr-review) or accessibility (use accessibility-review). This skill reviews existing artifacts only — it does not generate briefs, specs, or plans.
allowed-tools: "Read Write Glob Grep WebSearch WebFetch"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: compliance
  tags: [ai-act, artificial-intelligence, compliance, review, cross-cutting, transparency, risk-classification]
---

# AI Act Review Skill

This skill reviews any pipeline artifact for EU AI Act (Regulation (EU) 2024/1689) compliance. It classifies AI systems by risk level, assesses transparency and human oversight obligations, evaluates data governance requirements, and determines conformity assessment needs.

This is a **cross-cutting review skill** — it runs alongside the pipeline, not as a sequential stage:

```
[PROBLEM FRAME] → BRIEF → [BENCHMARK] → [OPPORTUNITY] → SPEC → [DESIGN] → PLAN → TASKS → [EXECUTION] → [RETRO]
                     ↑                                      ↑        ↑         ↑
                     └──── AI Act review can run at any of these stages ────────┘
```

**Artifact produced:** `docs/features/{feature-name}/AI-ACT-REVIEW.md`

## Performance Notes

- Take your time with every classification step. An incorrect risk level (e.g., classifying a high-risk system as limited risk) can lead to missing mandatory obligations like conformity assessments and human oversight.
- Quality and completeness are more important than speed. Check every AI component against every relevant article and Annex III category.
- Do not skip validation steps or collapse the risk classification into a quick judgment. Walk through prohibited practices, high-risk categories, and limited-risk triggers systematically.
- When uncertain about the risk classification or whether a transparency obligation applies, err on the side of the higher risk level — downgrading after review is safer than missing an obligation.

---

## Output Template

**Before writing any output, read `references/template.md` for the exact AI-ACT-REVIEW.md structure.**

**After writing, run `bash scripts/validate-ai-act-review.sh {path-to-review}` to verify structural completeness.**

---

## Review Depth by Artifact Type

| Artifact | Review Mode | Depth | What it produces |
|----------|-------------|-------|------------------|
| BRIEF | Triage | Light | Short assessment: does this use AI/ML? What type? Preliminary risk classification |
| SPEC | Deep | Full | Complete review: risk classification, transparency obligations, human oversight ACs, data governance, conformity assessment |
| DESIGN | Verify | Moderate | Checks explainability UI, human override controls, transparency indicators |
| PLAN | Verify | Moderate | Checks model card tasks, conformity assessment steps, monitoring plan. Gap report |

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
2. `docs/features/*/` matching any feature name in context
3. Any pipeline artifact in the current working directory

If multiple artifacts exist, ask which one to review. If none found, ask for the path.

### Step 2 — Detect Artifact Type

Determine which artifact is being reviewed to set the review depth:

- `BRIEF.md` or `# Project Brief:` → **Triage mode**
- `SPEC.md` or `Specifications` in title → **Deep mode**
- `DESIGN.md` or `## Design System` → **Verify mode (design)**
- `PLAN.md` or `# Implementation Plan:` → **Verify mode (plan)**

Announce the mode:
> "Reviewing `{artifact}` in **{mode}** mode for AI Act compliance."

### Step 3 — Load Prior Review

Check if an `AI-ACT-REVIEW.md` already exists in `docs/features/{feature-name}/`.

If it exists:
1. Read it in full
2. Inform the user: *"A prior AI Act review exists (dated {date}). I'll highlight what's changed."*
3. Mark findings as "Previously identified" or "New finding"

### Step 4 — Load Domain Knowledge

Read `references/ai-act-checklist.md` to load the review framework.

### Step 5 — Load Prior Decisions

Check whether a `DECISION.md` exists in `docs/features/{feature-name}/`.

If it exists, read it in full:
- Treat every ✅ Accepted decision as a hard constraint
- If a prior decision conflicts with an AI Act requirement, flag it

### Step 6 — Consult Official Sources

Use `WebSearch` and `WebFetch` to consult official sources:
- **EUR-Lex** (`eur-lex.europa.eu`) for the AI Act full text (Regulation (EU) 2024/1689)
- **EU AI Office** for guidelines and implementation guidance
- **Harmonized standards** as they become available

Cite the source URL for each finding.

### Step 7 — Run the Review (Triage Mode — BRIEF)

If reviewing a BRIEF:

1. **AI Detection** — scan for mentions of AI, ML, machine learning, neural networks, deep learning, NLP, computer vision, recommendation engines, generative AI, LLMs, chatbots, automated decision-making, predictive models, classification, clustering
2. **AI System Type** — classify: generative AI, predictive/classification, recommendation system, computer vision, NLP, robotic system, biometric identification, other
3. **Preliminary Risk Classification** — based on the AI system type and intended use, provide an initial risk level:
   - Unacceptable (Art. 5 — prohibited)
   - High-risk (Art. 6, Annex III)
   - Limited risk (Art. 50 — transparency obligations)
   - Minimal risk (no specific obligations)
4. **Recommendations for SPEC** — list what AI Act-related ACs should be included

Present findings and confirm.

### Step 8 — Run the Review (Deep Mode — SPEC)

If reviewing a SPEC:

1. **AI System Inventory** — for each User Story, identify AI components:

| AI Component | Type | Input Data | Output | Decision Impact |
|---|---|---|---|---|
| {e.g., recommendation engine} | {classification} | {user behavior data} | {product recommendations} | {influences purchase decisions} |

2. **Risk Classification** — apply the full AI Act risk framework:

   **Prohibited practices (Art. 5):**
   - Subliminal manipulation
   - Exploitation of vulnerabilities
   - Social scoring by public authorities
   - Real-time remote biometric identification in public spaces (with exceptions)

   **High-risk (Art. 6 + Annex III):**
   - Biometric identification and categorization
   - Critical infrastructure management
   - Education and vocational training (access/assessment)
   - Employment, worker management, self-employment (recruitment, evaluation)
   - Access to essential services (credit scoring, insurance pricing)
   - Law enforcement
   - Migration, asylum, border control
   - Administration of justice

   **Limited risk (Art. 50):**
   - AI systems that interact with natural persons (chatbots)
   - Emotion recognition systems
   - Biometric categorization systems
   - AI-generated or manipulated content (deepfakes)
   - General-purpose AI models

   **Minimal risk:**
   - AI systems not falling into above categories

3. **Transparency Requirements** — based on risk level:

   **For all AI systems (Art. 50):**
   - Users must be informed they're interacting with AI
   - AI-generated content must be labeled

   **For high-risk (Art. 13):**
   - Sufficient transparency for deployers to interpret output
   - Instructions for use
   - Technical documentation

4. **Human Oversight Requirements** — for high-risk systems (Art. 14):
   - Human oversight measures appropriate to the risks
   - Ability to fully understand AI system capabilities and limitations
   - Ability to correctly interpret output
   - Ability to decide not to use or override the system
   - Ability to intervene or halt the system

5. **Data Governance** — for high-risk systems (Art. 10):
   - Training data quality requirements
   - Data representativeness
   - Bias examination and mitigation
   - Data governance practices

6. **Technical Documentation** — for high-risk systems (Art. 11):
   - General description of the AI system
   - Detailed description of elements and development process
   - Monitoring, functioning, and control information
   - Risk management documentation

7. **Conformity Assessment** — determine which procedure applies:
   - Self-assessment (most high-risk categories)
   - Third-party assessment (biometric identification, critical infrastructure)

8. **Compliance Acceptance Criteria** — derive concrete Given/When/Then scenarios

Present each section as a draft. Confirm before moving on.

### Step 9 — Run the Review (Verify Mode — DESIGN)

If reviewing a DESIGN:

1. **Transparency UI** — check for indicators that the user is interacting with AI
2. **Explainability** — check for UI elements that explain AI decisions or recommendations
3. **Human Override** — check for controls that allow users to override AI decisions
4. **Confidence Display** — check whether AI output confidence/uncertainty is communicated
5. **Feedback Mechanism** — check for UI to report incorrect AI outputs

Present findings and confirm.

### Step 10 — Run the Review (Verify Mode — PLAN)

If reviewing a PLAN:

1. **Implementation Coverage** — cross-reference AI Act requirements against planned steps
2. **Model Card** — check for model documentation steps (training data, performance metrics, limitations)
3. **Monitoring Plan** — check for post-deployment monitoring steps
4. **Conformity Assessment** — check for conformity assessment steps if high-risk
5. **Verification Items** — check for AI Act-specific items in the checklist

Present findings as a gap report and confirm.

### Step 11 — Determine Output Path

The `AI-ACT-REVIEW.md` is **always** written to:

```
docs/features/{feature-name}/AI-ACT-REVIEW.md
```

Resolution logic follows the same pattern as other skills.

### Step 12 — Write the File

1. Assemble the complete `AI-ACT-REVIEW.md` using the template
2. Show the full content to the user for review
3. Ask: *"Ready to write this AI-ACT-REVIEW.md?"*
4. Write the file

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`.

### What to log

- **Risk classification** — which risk level applies and why
- **AI system type** — how the AI component was classified
- **Transparency scope** — what transparency measures are required
- **Conflict resolutions** — when AI Act requirements conflict with existing decisions

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **Cite official sources** — every finding must reference the specific AI Act article and include the official source URL when consulted.
2. **Flag, don't block** — the review identifies gaps and proposes ACs. It does not prevent the pipeline from proceeding.
3. **Adapt to artifact type** — triage for BRIEFs, deep for SPECs, verify for DESIGNs and PLANs.
4. **No legal advice** — this skill identifies AI Act-relevant concerns. It is not a substitute for legal counsel. Include the disclaimer in every review.
5. **Interactive and thorough** — confirm each section before moving on.
6. **English always** — write in English regardless of conversation language.
7. **Prior review awareness** — highlight what's new vs. previously identified.
8. **Don't modify other artifacts** — read only.
9. **Regulation is evolving** — the AI Act's implementation is phased (2024–2027). Use `WebSearch` to check which provisions are currently in force and which are upcoming. Note the applicability timeline in findings.

---

## Pipeline Iteration

### When to Flag Upstream Issues

- **BRIEF doesn't acknowledge AI usage** — flag: *"The feature uses AI but the BRIEF doesn't address AI-specific risks or transparency. Consider updating Assumptions & Risks."*
- **SPEC missing transparency ACs** — propose Given/When/Then scenarios: *"Users must be informed they're interacting with AI. These ACs should be added to the SPEC."*
- **PLAN missing model documentation** — flag: *"No model card or technical documentation step in the PLAN."*

Findings are captured in AI-ACT-REVIEW.md. The user decides whether to act on them.

For the universal rollback protocol, see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: Triage review of a BRIEF
User says: "AI Act review on the product recommendation brief"
Actions:
1. Locate BRIEF, detect AI: "recommendation engine", "user behavior analysis"
2. Classify: recommendation system, likely limited risk (Art. 50 transparency)
3. Flag: transparency obligation — users must know recommendations are AI-generated
4. Recommend SPEC ACs for transparency indicator and user notification
5. Write to `docs/features/product-recommendations/AI-ACT-REVIEW.md`
Result: Triage with limited-risk classification and 3 recommendations

### Example 2: Deep review of a SPEC
User says: "Run an AI Act compliance review on the credit scoring spec"
Actions:
1. Locate SPEC, detect AI: "automated credit scoring", "ML model", "applicant risk assessment"
2. Deep mode — classify as high-risk (Annex III: access to essential services — credit scoring)
3. Full review: transparency (Art. 13), human oversight (Art. 14), data governance (Art. 10), technical docs (Art. 11), conformity assessment
4. Produce 8 compliance ACs covering transparency, override, monitoring, bias testing
5. Write to `docs/features/credit-scoring/AI-ACT-REVIEW.md`
Result: Comprehensive high-risk AI assessment with conformity assessment requirement

### Example 3: Verify review of a DESIGN
User says: "Check AI Act compliance of the chatbot design"
Actions:
1. Locate DESIGN, detect AI: chatbot interface
2. Verify: check for AI interaction disclosure, confidence display, human escalation option
3. Find: no indicator that user is talking to AI (Art. 50 violation), no escalation to human
4. Produce gap report with 2 missing UI elements
5. Write to `docs/features/customer-chatbot/AI-ACT-REVIEW.md`
Result: Verify report flagging transparency and human override gaps in the design

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
