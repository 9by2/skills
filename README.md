# 9by2 Skills

Reusable [Agent Skills](https://agentskills.io/) for Bridge Platform work. Each skill is a plain Markdown folder with a `SKILL.md` file and YAML frontmatter, so Claude, pi, Codex, OpenCode, Cursor, and other compatible agents can load them the same way.

## Repository layout

```text
skills/                 # Published skills (one folder per skill)
  <skill-name>/
    SKILL.md            # Entrypoint: frontmatter + concise instructions
    reference/          # Optional deeper docs (singular folder name)
template/               # Starter copied when creating a new skill
AGENTS.md               # Conventions for agents working in this repo
CONTRIBUTING.md         # How to add or revise skills
```

## Available skills

| Skill | Path | Use when |
| ----- | ---- | -------- |
| create-skill | [`skills/create-skill/SKILL.md`](skills/create-skill/SKILL.md) | Authoring or revising skills in this repository. |

## Installation

List skills in this package:

```bash
bunx --bun skills add git@github.com:9by2/skills.git --list
```

Install one skill:

```bash
bunx --bun skills add git@github.com:9by2/skills.git --skill create-skill
```

Install for a specific agent or globally as needed:

```bash
bunx --bun skills add git@github.com:9by2/skills.git --skill create-skill -a cursor -g
```

You can also vendor a skill folder into a project's `.agents/skills/` or `.cursor/skills/` directory.

## Creating a skill

1. Copy the template: `cp -R template skills/<skill-name>`
2. Rename frontmatter `name` to match the folder
3. Follow [`skills/create-skill/SKILL.md`](skills/create-skill/SKILL.md) (or invoke the create-skill skill)
4. Add a row to the table above

## Maintenance

- Keep each `SKILL.md` as a concise entrypoint with invocation rules, guide discovery, core principles, workflow, and a final checklist.
- Use singular support folders such as `reference/`; do not introduce plural support folder names.
- Put larger reusable guidance in `skills/<name>/reference/` so agents load only relevant context.
- Keep product-specific facts, commands, route inventories, API details, environment variables, and documented deviations in each target project's README.
- Keep skills plain Markdown and avoid agent-specific APIs so they remain portable across Claude, pi, Codex, OpenCode, and Cursor.

## Spec alignment

Skills follow the [Agent Skills specification](https://agentskills.io/specification) with one intentional house rule: support directories are **singular** (`reference/`, `script/`, `asset/`) instead of the plural names in the upstream examples.
