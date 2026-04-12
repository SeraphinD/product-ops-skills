# GDPR Review Checklist

Review framework for the `gdpr-review` skill. Defines **what to check and in what order** per artifact type. The actual regulation text is fetched live via `WebSearch`/`WebFetch` from official sources during the review.

**Official sources for live lookup:**
- EUR-Lex GDPR full text: `https://eur-lex.europa.eu/eli/reg/2016/679/oj`
- EDPB guidelines: `https://edpb.europa.eu/our-work-tools/general-guidance_en`
- CNIL (FR-specific): `https://www.cnil.fr/en/gdpr-guidelines`

---

## Checklist by Artifact Type

### BRIEF (Triage Mode)

Scan these sections for personal data signals:

| BRIEF Section | What to look for |
|---|---|
| Problem Statement | User pain points that imply data collection (tracking, monitoring, profiling) |
| Solution | Data processing described or implied (analytics, personalization, notifications) |
| Scope — In Scope | Explicit data handling items (user accounts, data export, reporting) |
| Scope — Out of Scope | Data handling explicitly excluded (may still be relevant) |
| Assumptions & Risks | Assumptions about data availability or user consent |
| Success Criteria | Metrics that require data collection (conversion rates, engagement, retention) |

**Data category triggers** — flag if any of these appear:

| Category | GDPR Relevance | Example signals |
|---|---|---|
| Identification | Art. 4(1) | name, username, user ID, account |
| Contact | Art. 4(1) | email, phone, address |
| Behavioral | Art. 5, Art. 6 | page views, clicks, session data, navigation patterns |
| Financial | Art. 9 (if health-linked) | payment info, billing, transactions |
| Location | Art. 5(1)(c) | GPS, IP-based location, geofencing |
| Device/Technical | Art. 4(1) | device ID, browser fingerprint, cookies, IP address |
| Health | Art. 9 (special category) | medical data, fitness data, health metrics |
| Biometric | Art. 9 (special category) | fingerprints, facial recognition, voice patterns |

---

### SPEC (Deep Mode)

Full review against these GDPR articles, in order:

#### 1. Data Inventory (Art. 4, Art. 30)
For each User Story, identify:
- What personal data is collected
- From whom (data subject categories)
- For what purpose
- Where it's stored
- How long it's retained
- Who has access

#### 2. Legal Basis (Art. 6)
For each processing activity, assess which basis applies:

| Basis | Art. 6(1) | When it applies |
|---|---|---|
| Consent | (a) | User actively opts in; must be freely given, specific, informed, unambiguous |
| Contract | (b) | Processing necessary to fulfill a contract with the data subject |
| Legal obligation | (c) | Processing required by law (tax, employment, AML) |
| Vital interests | (d) | Protecting life — rarely applicable in software features |
| Public interest | (e) | Public authority tasks — rarely applicable in private sector |
| Legitimate interests | (f) | Business need balanced against data subject rights; requires balancing test |

#### 3. Transparency (Art. 13, Art. 14)
Check if the feature provides:
- Identity of the controller
- Purpose of processing
- Legal basis
- Data retention period
- Data subject rights information
- Right to lodge a complaint

#### 4. Consent Requirements (Art. 7, Art. 8)
If consent is the legal basis:
- Freely given (no bundling, no imbalance of power)
- Specific (per purpose, not blanket)
- Informed (clear language, accessible)
- Unambiguous (affirmative action, no pre-ticked boxes)
- Withdrawable (as easy to withdraw as to give)
- Age verification for children under 16 (Art. 8) if applicable

#### 5. Data Subject Rights (Art. 15–22)
Check AC coverage for each right:

| Right | Article | What the feature must support |
|---|---|---|
| Access | Art. 15 | User can request a copy of their personal data |
| Rectification | Art. 16 | User can correct inaccurate data |
| Erasure | Art. 17 | User can request deletion ("right to be forgotten") |
| Restriction | Art. 18 | User can request processing limitation |
| Portability | Art. 20 | User can export data in machine-readable format |
| Object | Art. 21 | User can object to processing (especially direct marketing) |
| Automated decisions | Art. 22 | User can request human review of automated decisions with legal effects |

#### 6. Privacy by Design (Art. 25)
Assess:
- Data minimization — only collect what's necessary
- Purpose limitation — don't repurpose data without new basis
- Storage limitation — define retention periods
- Pseudonymization — where feasible
- Encryption — at rest and in transit

#### 7. Security (Art. 32)
Check for:
- Encryption of personal data
- Access controls
- Breach notification procedures
- Regular security testing

#### 8. DPIA Triggers (Art. 35)
Assess whether any trigger applies:

| Trigger | Description |
|---|---|
| Systematic monitoring | Systematic monitoring of a publicly accessible area |
| Large-scale special categories | Processing special category data (health, biometric, etc.) at scale |
| Automated decisions | Automated decision-making with legal or significant effects |
| New technologies | New technologies that may pose high risk |
| Profiling | Profiling that produces legal or significant effects |
| Large-scale processing | Large-scale processing of personal data |
| Matching/combining datasets | Combining datasets from different sources |

If any trigger applies → DPIA is required.

#### 9. International Transfers (Art. 44–49)
If data leaves the EEA:
- Adequacy decision exists for the destination country?
- Standard Contractual Clauses in place?
- Binding Corporate Rules?

---

### DESIGN (Verify Mode)

Check the design artifact for:

| Check | What to look for |
|---|---|
| Consent UI | Cookie banner, consent form, opt-in/opt-out toggles, granular consent per purpose |
| Privacy settings | Dedicated page/screen for data management, preferences, account deletion |
| Data collection forms | Fields collect only necessary data; optional fields clearly marked |
| Transparency | UI communicates what data is collected and why; links to privacy policy |
| Withdrawal | Easy-to-find mechanism to withdraw consent; not buried in settings |
| Data access | UI for users to view their personal data |
| Data export | UI for users to export their data (portability) |
| Account deletion | Clear path to delete account and all associated data |

---

### PLAN (Verify Mode)

Cross-reference implementation steps against GDPR requirements:

| Check | What to look for in the PLAN |
|---|---|
| Consent implementation | Steps for building consent collection and storage |
| Data subject rights endpoints | Steps for building access, rectification, erasure, portability APIs |
| Encryption | Steps for implementing encryption at rest and in transit |
| Access controls | Steps for implementing role-based access to personal data |
| Retention policy | Steps for implementing data retention and automatic deletion |
| Breach notification | Steps for implementing breach detection and notification |
| DPIA execution | If DPIA was flagged, step for conducting it |
| Privacy policy update | Step for updating the privacy policy |
| Verification checklist | GDPR-specific items in the checklist |
