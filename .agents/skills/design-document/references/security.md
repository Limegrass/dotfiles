# Security Considerations

Threat-model the design; don't defer to a launch review. Security retrofits are costly and
leave exposure in the interim. Select by system nature; mark N/A with reason.

## Trust Boundaries

- Where does untrusted input enter (users, other services, queues, files, config)?
- What is inside vs outside the trust boundary? Validate and normalize at every crossing.
- Tenancy isolation: can one tenant reach another's data or starve their capacity?

## Authentication / Authorization

- How is caller identity established (user auth, service-to-service)?
- Authorization model: least privilege, deny by default, per-resource checks.
- Privilege-escalation paths; separation of duties for sensitive actions.

## Secrets & Keys

- Stored in a secrets manager -- never in code, config, or logs.
- Rotation policy; blast radius of a leaked credential.
- Key management for encryption: ownership, rotation, access scope.

## Data Protection

- Encryption in transit and at rest; what is exempt and why.
- Field-level protection for the most sensitive data.

## Dependencies / Supply Chain

- Third-party and transitive dependency risk; pinned, scanned versions.
- Build and deploy integrity; provenance of artifacts.

## Auditability

- Tamper-evident log of who did what, when, for sensitive operations.
- Sufficient to investigate an incident after the fact.

## Abuse / Resilience to Attack

- Input validation against injection (query, command, deserialization, path traversal).
- Rate limiting, quotas, and denial-of-service resistance.
- Failure mode under attack: fail closed for authorization; degrade safely.
