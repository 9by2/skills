# 9by2 Skills

This repository contains reusable agent skills for Bridge Platform work. Skills are plain Markdown directories with a `SKILL.md` file and simple YAML frontmatter, so they can be used by Claude, pi, Codex, OpenCode, or any LLM agent that can read files.

## Available skills

| Skill                | Path                                   | Use when             |
| -------------------- | -------------------------------------- | -------------------- |
| {example-skill-name} | `skills/{example-skill-path}/SKILL.md` | Example description. |

## Installation

Install the 9by2 skill:

```bash
bunx --bun skills add git@github.com:9by2/skills.git --skill {skill-name}
```

## Maintenance

- Keep each `SKILL.md` as a concise entrypoint with invocation rules, guide discovery, core principles, and a final checklist.
- Use singular skill support folders such as `reference/`; do not introduce plural support folder names.
- Put larger reusable guidance in `skills/<name>/reference/` so agents can load only relevant context.
- Keep product-specific facts, commands, route inventories, API details, environment variables, and documented deviations in each target project's README.
- Keep skills plain Markdown and avoid agent-specific APIs so they remain portable across Claude, pi, Codex, and OpenCode.
