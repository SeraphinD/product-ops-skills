# EU AI Act Review Checklist

Review framework for the `ai-act-review` skill. Defines **what to check and in what order** per artifact type. The actual regulation text is fetched live via `WebSearch`/`WebFetch` from official sources.

**Official sources for live lookup:**
- EUR-Lex AI Act: `https://eur-lex.europa.eu/eli/reg/2024/1689/oj`
- EU AI Office: `https://digital-strategy.ec.europa.eu/en/policies/european-approach-artificial-intelligence`
- AI Act implementation timeline: search for "AI Act implementation timeline 2024 2025 2026 2027"

---

## AI Detection Signals

Scan artifacts for these indicators of AI/ML usage:

| Category | Signals |
|---|---|
| Explicit AI | AI, artificial intelligence, machine learning, ML, deep learning, neural network |
| NLP/Language | NLP, natural language processing, text classification, sentiment analysis, chatbot, LLM, GPT, language model, generative AI |
| Computer Vision | image recognition, object detection, facial recognition, OCR, computer vision |
| Recommendation | recommendation engine, collaborative filtering, content-based filtering, personalization engine |
| Prediction | predictive model, forecasting, anomaly detection, fraud detection, risk scoring, credit scoring |
| Automation | automated decision-making, automated assessment, automated classification, algorithmic decision |
| Biometric | biometric identification, facial recognition, voice recognition, fingerprint matching |

---

## Checklist by Artifact Type

### BRIEF (Triage Mode)

| BRIEF Section | What to look for |
|---|---|
| Problem Statement | Pain points implying AI solutions (personalization, prediction, automation) |
| Solution | AI/ML components described or implied |
| Scope — In Scope | AI-powered features, model training, data pipelines |
| Scope — Out of Scope | AI features explicitly excluded |
| Assumptions & Risks | Assumptions about AI accuracy, fairness, data availability |
| Success Criteria | Metrics that imply AI (accuracy, precision, recall, F1, recommendation relevance) |

### SPEC (Deep Mode)

Full review in this order:

#### 1. AI System Inventory
For each User Story, identify:
- What AI/ML components are involved
- What type of AI (classification, generation, recommendation, etc.)
- What input data the AI uses
- What output the AI produces
- What decisions the AI influences
- Whether the AI output is user-facing

#### 2. Risk Classification (Art. 5, Art. 6, Annex III)

**Step 1 — Check prohibited practices (Art. 5):**

| Practice | Article | Check |
|---|---|---|
| Subliminal manipulation | Art. 5(1)(a) | Does the AI manipulate beyond a person's consciousness? |
| Exploitation of vulnerabilities | Art. 5(1)(b) | Does the AI target age, disability, or social/economic situation? |
| Social scoring | Art. 5(1)(c) | Does a public authority use AI for social scoring? |
| Predictive policing (individual) | Art. 5(1)(d) | Does AI predict individual criminal behavior from profiling alone? |
| Untargeted facial image scraping | Art. 5(1)(e) | Does the AI build face databases from untargeted scraping? |
| Emotion recognition in workplace/education | Art. 5(1)(f) | Does the AI infer emotions in workplace or educational settings? |
| Biometric categorization (sensitive) | Art. 5(1)(g) | Does AI categorize by race, political opinion, religion, sexual orientation from biometrics? |
| Real-time remote biometric ID in public | Art. 5(1)(h) | Does the AI perform real-time facial recognition in public spaces? |

If any apply → **Unacceptable risk** — the feature cannot proceed as designed.

**Step 2 — Check high-risk (Annex III):**

| Category | Annex III Reference | Examples |
|---|---|---|
| Biometrics | 1 | Remote biometric identification, biometric categorization |
| Critical infrastructure | 2 | Safety components of roads, water, gas, heating, electricity, digital infrastructure |
| Education | 3 | Determining access to education, assessing students, detecting cheating |
| Employment | 4 | Recruitment, job advertising, screening, evaluation, promotion, termination |
| Essential services | 5 | Credit scoring, insurance pricing, emergency services dispatch |
| Law enforcement | 6 | Risk assessment, polygraphs, evidence reliability, profiling |
| Migration | 7 | Risk assessment, application examination, identification |
| Justice | 8 | Sentencing, legal research, legal interpretation |

If any apply → **High-risk** — full compliance obligations.

**Step 3 — Check limited risk (Art. 50):**

| Trigger | Article | Check |
|---|---|---|
| AI-human interaction | Art. 50(1) | Does the AI interact directly with natural persons? |
| Synthetic content | Art. 50(2) | Does the AI generate text, audio, image, or video content? |
| Emotion recognition | Art. 50(3) | Does the AI detect emotions? |
| Deepfakes | Art. 50(4) | Does the AI generate/manipulate images, audio, video resembling real persons/places? |

If any apply → **Limited risk** — transparency obligations.

**Step 4 — Minimal risk** if none of the above apply.

#### 3. Transparency Obligations

| Risk Level | Obligations |
|---|---|
| All AI systems | Art. 50 — inform users of AI interaction, label AI-generated content |
| High-risk | Art. 13 — sufficient transparency for deployers to interpret output; Art. 11 — technical documentation |
| General-purpose AI | Art. 53 — technical documentation, training data summary, copyright compliance |

#### 4. Human Oversight (Art. 14 — high-risk only)

Check these capabilities:
- Humans can fully understand the AI system's capabilities and limitations
- Humans can correctly interpret the AI output
- Humans can decide not to use or override the AI
- Humans can intervene or halt the AI system

#### 5. Data Governance (Art. 10 — high-risk only)

Check:
- Training, validation, and testing datasets meet quality criteria
- Datasets are relevant, representative, and as error-free as possible
- Possible biases have been examined
- Appropriate data governance and management practices

#### 6. Accuracy, Robustness, Cybersecurity (Art. 15 — high-risk only)

Check:
- Appropriate levels of accuracy declared
- Resilient to errors, faults, or inconsistencies
- Robust against unauthorized third-party manipulation

#### 7. Record-Keeping (Art. 12 — high-risk only)

Check:
- Automatic logging of events during operation
- Traceability of AI system functioning

#### 8. Conformity Assessment (Art. 43)

Determine:
- Self-assessment (Annex VI) — most high-risk categories
- Third-party (Annex VII) — biometric identification, critical infrastructure safety
- Not required — limited and minimal risk

### DESIGN (Verify Mode)

| Check | What to look for |
|---|---|
| AI disclosure | Visual indicator that user is interacting with AI |
| Content labeling | AI-generated content marked as such |
| Explainability | UI elements explaining AI decisions/recommendations |
| Confidence display | Uncertainty/confidence indicators for AI output |
| Human override | Controls to override, dismiss, or escalate AI decisions |
| Feedback mechanism | UI to report incorrect or harmful AI output |
| Transparency page | Accessible information about how the AI works |

### PLAN (Verify Mode)

| Check | What to look for |
|---|---|
| Model documentation | Steps for creating model card / technical documentation |
| Bias testing | Steps for testing AI fairness across protected groups |
| Performance metrics | Steps for measuring and documenting accuracy |
| Monitoring | Post-deployment monitoring plan |
| Conformity assessment | Steps for conducting self-assessment or engaging notified body |
| Logging infrastructure | Steps for implementing automatic event logging |
| AI disclosure UI | Steps for building transparency UI elements |
| Verification checklist | AI Act-specific items present |

---

## Implementation Timeline

The AI Act provisions take effect in phases. Always note which provisions are currently applicable:

| Date | What takes effect |
|---|---|
| Aug 1, 2024 | Regulation enters into force |
| Feb 2, 2025 | Prohibited practices (Art. 5) and AI literacy (Art. 4) |
| Aug 2, 2025 | General-purpose AI (Art. 51-55), governance, penalties |
| Aug 2, 2026 | High-risk systems (Annex III), transparency (Art. 50), most obligations |
| Aug 2, 2027 | High-risk systems in Annex I (EU harmonisation legislation) |

Use `WebSearch` to verify the current date against this timeline and note in the review which provisions are in force.
