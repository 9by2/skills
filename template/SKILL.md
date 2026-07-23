---
name: template-skill
description: Replace with what this skill does and when to use it. Include trigger phrases and Bridge Platform contexts that should activate it.
license: MIT
metadata:
  author: 9by2
  version: "0.1.0"
---

# Template Skill

One or two sentences on what this skill does.

## Invocation rules

- Use this skill when: {trigger conditions}.
- Do not use this skill when: {out of scope cases}.
- Prefer project README facts over anything hard-coded here.

## Guide discovery

Load only what the task needs:

| Need | Load |
| ---- | ---- |
| Core workflow | This file |
| Deeper detail | [reference/overview.md](reference/overview.md) |

Keep product-specific commands, routes, APIs, env vars, and deviations in the target project's README.

## Core principles

1. {Principle one — portable, agent-agnostic guidance.}
2. {Principle two — progressive disclosure; load reference files on demand.}
3. {Principle three — keep SKILL.md concise; move depth to `reference/`.}

## Workflow

1. Confirm the task matches the invocation rules.
2. Read only the relevant `reference/` files.
3. Apply the principles and produce the expected output.
4. Run the checklist before finishing.

## Checklist

- [ ] Skill was applicable (or you explained why not)
- [ ] Only necessary reference files were loaded
- [ ] Project README was checked for local facts
- [ ] Output matches the skill's expected format
