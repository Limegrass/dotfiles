# Security & Privacy Review: <title>

Companion to design-<name>.md. Required before build. The core doc carries the decision-shaping
security/privacy posture (per-approach hooks); this is the detailed assurance.
See references/security.md, references/data-privacy.md, references/compliance.md.

## Security (Threat Model)

Trust boundaries: <where untrusted input enters; inside vs outside; validation at crossings; tenant isolation>

Authentication / authorization: <identity verification; least-privilege authorization; escalation paths; separation of duties>

Secrets & keys: <secrets-manager storage, rotation; key management; leaked-credential blast radius>

Data protection: <encryption in transit + at rest; field-level for most sensitive; what's exempt and why>

Dependencies / supply chain: <third-party + transitive risk; pinned, scanned versions; artifact integrity>

Audit: <tamper-evident who-did-what for sensitive actions; sufficient to investigate>

Abuse / denial-of-service: <input validation vs injection; rate limits, quotas; fail closed on authorization>

## Data Privacy Assessment [if: personal/sensitive data]

Inventory & flow: <personal/sensitive data collected/derived/stored; where it flows incl. logs, backups, third parties; map every copy>

Classification: <sensitivity tiers; regulated categories (identifiers, financial, health, biometric, location)>

Minimization & purpose: <collect only what's needed; purpose limitation>

Retention & deletion: <retention per class; deletion/erasure path incl. backups + derived data>

Access & audit: <least privilege; purpose-bound access; access logging + review>

Residency & sovereignty: <where data lives/processes; cross-border transfer constraints>

Protection: <encryption; pseudonymization/masking/tokenization; de-identification for analytics; re-identification risk>

## Compliance & Regulatory [if: regulated scope]

Applicable standards: <which regimes apply -- payment-card, health-data, data-protection/privacy, information-security, government-cloud, and similar; which specific controls>

Audit & evidence: <what must be demonstrable; logging/retention for audit; control ownership + cadence>

Certifications & attestations: <required sign-offs before launch; data-processing agreements; third-party attestations>

Licensing: <open-source license obligations (copyleft, attribution); third-party/vendor contractual terms>
