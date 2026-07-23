---
name: create-skill
description: Author, scaffold, or revise skills in the 9by2/skills repository. Use when adding a new skill, editing SKILL.md frontmatter or body, structuring reference/ folders, updating the skills table in README.md, or asking how to package portable Agent Skills for Bridge Platform work.
license: MIT
metadata:
  author: 9by2
  version: "0.1.0"
---

# Create Skill

Scaffold and revise skills so they stay portable across Claude, pi, Codex, OpenCode, Cursor, and other Agent Skills clients.

## Invocation rules

- Use when creating a new skill under `skills/<name>/`.
- Use when rewriting an existing skill for clarity, triggers, or progressive disclosure.
- Use when reviewing whether a skill follows 9by2 conventions.
- Do not encode product-specific routes, APIs, env vars, or repo-only deviations here — those belong in the target project's README.

## Guide discovery

| Need | Load |
| ---- | ---- |
| Anatomy and frontmatter rules | [reference/anatomy.md](reference/anatomy.md) |
| Authoring checklist | [reference/checklist.md](reference/checklist.md) |
| Blank starter | [`../../template/SKILL.md`](../../template/SKILL.md) |

## Core principles

1. **Portable Markdown** — plain `SKILL.md` + YAML frontmatter; no agent-specific APIs.
2. **Concise entrypoint** — invocation rules, guide discovery, core principles, workflow, checklist.
3. **Singular support folders** — use `reference/` (never `references/`). Optional: `script/`, `asset/`.
4. **Progressive disclosure** — keep `SKILL.md` short; put depth in `reference/` and load on demand.
5. **Project facts stay local** — commands, routes, APIs, env vars, and deviations live in the consuming project's README.

## Workflow

1. Name the skill: lowercase, hyphens, max 64 chars; folder name must match `name`.
2. Copy `template/` to `skills/<name>/` (or edit an existing skill in place).
3. Write a pushy `description`: what it does **and** when to use it (trigger phrases).
4. Fill the body sections from the template; move long guidance into `reference/`.
5. Add a row to the Available skills table in the root `README.md`.
6. Validate with the [checklist](reference/checklist.md).

## Checklist

- [ ] `name` matches folder; description includes triggers
- [ ] Body has invocation rules, guide discovery, principles, workflow, checklist
- [ ] Support folder is singular (`reference/`), not plural
- [ ] No product-specific inventories baked into the skill
- [ ] README skills table updated
