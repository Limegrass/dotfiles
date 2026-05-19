# Eval Guide

Systematic eval-driven iteration for skill quality. Load when investing in rigorous skill improvement.

## When to Use Evals

- Skill produces inconsistent results across varied prompts
- Need to prove skill adds value over no-skill baseline
- Iterating and unsure which version is better
- Skill is mature enough to warrant formal testing

## Test Case Structure

```json
{
  "skill_name": "<skill-name>",
  "evals": [
    {
      "id": 1,
      "prompt": "<realistic user message>",
      "expected_output": "<human-readable success description>",
      "files": ["evals/files/<input>"],
      "assertions": ["<specific verifiable statement about output>"]
    }
  ]
}
```

Store in `evals/evals.json` inside skill directory.

## Designing Test Prompts

Start with 2-3 cases. Expand after first results.

Vary along:

- **Phrasing**: formal, casual, typos, abbreviations
- **Explicitness**: names domain directly vs describes need obliquely
- **Detail**: terse one-liners vs context-heavy paragraphs
- **Complexity**: single-step vs multi-step chains

Most useful should-trigger queries: skill would help but connection isn't obvious.
Most useful should-not-trigger queries: near-misses sharing keywords but needing something different.

## Writing Assertions

Add after first run. Good assertions are:

- Programmatically verifiable: "output is valid JSON"
- Specific and observable: "chart has labeled axes"
- Countable: "report includes at least 3 recommendations"

Bad assertions:

- Too vague: "output is good"
- Too brittle: "uses exactly the phrase 'Total: $X'"

## Evaluation Loop

1. Run each test with-skill and without-skill (clean context each run)
2. Grade assertions: PASS/FAIL with concrete evidence
3. Aggregate: pass_rate, time, tokens for each configuration
4. Compute delta: what skill costs vs what it buys
5. Identify patterns: always-pass (remove), always-fail (fix), inconsistent (tighten)
6. Human review: catches what assertions miss
7. Feed signals + current SKILL.md to LLM for improvement proposals
8. Apply, rerun, repeat until stable

## Grading Principles

- Require concrete evidence for PASS
- Quote/reference output, not opinions
- Review assertions themselves during grading (too easy? too hard? unverifiable?)

## Description Trigger Testing

Separate concern from output quality. Test with eval queries:

```json
[
  { "query": "<should trigger>", "should_trigger": true },
  { "query": "<near-miss, should NOT trigger>", "should_trigger": false }
]
```

Aim: ~20 queries (10 should, 10 shouldn't). Run 3x each (nondeterministic).
Split 60/40 train/validation to avoid overfitting.

Trigger rate threshold: 0.5 default.

## Iteration Signals

Three sources after grading:

1. **Failed assertions**: specific gaps (missing step, unclear instruction)
2. **Human feedback**: broader quality issues (wrong approach, poor structure)
3. **Execution transcripts**: reveals why (ambiguous instruction, unproductive steps)

Fix guidelines:

- Generalize from failures. Don't add keywords from specific test queries.
- Keep lean. Fewer, better instructions often outperform exhaustive rules.
- If plateau despite adding rules, try removing instructions.
- Structurally different approach > incremental tweaks after several stuck iterations.

## Workspace Structure

```
skill-name/
├── SKILL.md
└── evals/
    └── evals.json

skill-name-workspace/
└── iteration-N/
    ├── eval-<name>/
    │   ├── with_skill/
    │   │   ├── outputs/
    │   │   ├── timing.json
    │   │   └── grading.json
    │   └── without_skill/
    │       └── ...
    └── benchmark.json
```
