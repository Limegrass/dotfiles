# Data Privacy Considerations

Apply when the design touches personal or otherwise sensitive data. Privacy is designed in,
not bolted on; retrofits require migrations and leak in the meantime. Mark N/A with reason.

## Data Inventory & Flow

- What personal/sensitive data is collected, derived, or stored?
- Where does it flow -- services, logs, backups, analytics, third parties?
- Map every copy; copies are the hardest part of deletion and residency.

## Classification

- Sensitivity tiers; regulated categories (identifiers, financial, health, biometric, location).
- The strictest-handling requirement drives the controls.

## Minimization & Purpose

- Collect only what's needed for a stated purpose; avoid speculative retention.
- Purpose limitation: data used only for what it was collected for.

## Retention & Deletion

- Retention period per data class; automatic expiry.
- Deletion / erasure path including backups, caches, and derived data (right to be forgotten).

## Access Control & Audit

- Who can access; least privilege; purpose-bound access.
- Access logging for sensitive data; periodic review.

## Residency & Sovereignty

- Where data is stored and processed; cross-border transfer constraints.
- Regional isolation requirements.

## Protection Techniques

- Encryption at rest and in transit.
- Pseudonymization, masking, tokenization, aggregation; de-identification for analytics.
- Re-identification risk assessment.
