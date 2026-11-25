# No Personal Data in Logs

A log call whose output includes personal data is a blocking finding -- once written, it cannot be
scoped to least privilege or purged without a cross-system effort.

## Why

Personal data flows through most services and is governed by privacy and employment regulation
(GDPR, CCPA, equal-employment law). Application logs land in aggregators with broad read access and
long retention. Redact at the log call, never at the sink.

## Diff scope

Flag only a log call on a line this change adds or modifies. A logging statement on an unchanged
context line stays untouched even where the change edits code around it -- rewriting an untouched
pre-existing log line is a drive-by edit that widens the change past its purpose.

## Log sinks in scope

A logging statement is a call to a log, console, or stdout sink:

- structured loggers: `log` / `logger` / `LOG` / `LOGGER` `.trace` / `.debug` / `.info` / `.warn` /
  `.warning` / `.error` / `.fatal` / `.log(...)` (SLF4J, Log4j, Logback, `java.util.logging`,
  KLogging);
- Python `logging` (`logging.info(...)`, `logger.debug(...)`, `log.exception(...)`) and `print(...)`;
- JavaScript and TypeScript `console.log` / `.info` / `.warn` / `.error` / `.debug` / `.trace(...)`;
- Rust `log` and `tracing` macros (`info!`, `warn!`, `error!`, `debug!`, `trace!`, `tracing::info!`)
  and `println!` / `eprintln!`;
- Go `log`, `slog`, and `fmt.Print*` (`log.Printf`, `slog.Info`, `fmt.Println`);
- direct stdout or stderr writes (`System.out.println`, `System.err.println`).

## What counts as personal data

Flag where the logged expression -- a positional argument, a format substitution, an interpolated
variable, or the whole logged object -- carries personal data, evidenced in the diff by a field,
getter, variable, or key name denoting:

- direct identifiers: full, first, or last name; email address; phone number; physical or mailing
  address; government identifier (national insurance or social security number, national ID,
  passport, tax ID); date of birth;
- sensitive personal data: compensation, salary, or pay; background-check results; health or
  disability information; assessment or application answers; evaluative feedback about a person;
  free-text documents a person authored about themselves (resume, cover letter, personal statement);
- protected-class data: race, ethnicity, gender, age, disability, veteran status, religion.

Two flaggable shapes:

1. A named personal-data value passed to a sink: `log.info("email={}", user.getEmail())`,
   `logger.debug("contact phone " + phoneNumber)`, `log.info(f"dob={date_of_birth}")`, or the same
   value substituted into a template literal or interpolated string.
2. A whole domain entity known to carry personal data, logged without projecting to a safe field --
   `person`, `user`, `profile`, `customer`, `employee`, `account`, or a request or DTO embedding one.
   Default `toString` or serialization dumps every field, so `log.info("processing {}", person)` and
   `console.log(customer)` leak the whole record.

## Remedy

- Log a non-identifying reference instead -- an opaque domain identifier (`personId`, `userId`,
  `accountId`, `orderId`) a reader joins to the record through an access-controlled store, never the
  personal-data value itself.
- Where a value must be logged to debug, mask or redact it: last four characters only, a hash, or the
  project's redaction helper.
- For a whole-entity log, replace the object with its identifier field or fields.
- Where a field's classification is unclear, point the author to the organization's data-classification
  catalog and standard, which define the sensitivity levels and the controls each level requires.

## Do NOT flag

- Opaque internal surrogate identifiers logged alone: `personId`, `userId`, `accountId`,
  `customerId`, `orderId`, `jobId`, correlation, trace, and request identifiers, resource identifiers
  of infrastructure. A tokenized or pseudonymized internal identifier cannot re-identify an individual
  without an access-controlled internal join, so it carries no personal data on its own. This covers
  opaque surrogates only: a field named like an identifier that instead holds a government or direct
  identifier (`ssn`, `nationalId`, `passportNumber`, `taxId`) is a direct identifier and remains a
  finding whatever the `Id` suffix suggests.
- A value already masked, hashed, redacted, or truncated at the call site (`maskEmail(email)`,
  `hash(ssn)`, `email.slice(-4)`, a literal `***`).
- Personal data in non-logging code -- assignment, persistence to the datastore, a request or response
  payload to a downstream service, or a template rendered to the authorized user. This rule is about
  log output; personal data that never reaches a log, console, or stdout sink is not a finding.
- A variable whose name gives no personal-data signal (`id`, `count`, `status`, `type`, `size`).
  Absent a name denoting personal data, do not guess.
