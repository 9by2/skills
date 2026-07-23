# AGENTS.md

Guidance for AI coding agents working in this repository.

## Purpose

This repo publishes portable Agent Skills for Bridge Platform work. Prefer editing skills so any Agent Skills-compatible client can use them.

## Layout

- `skills/<name>/SKILL.md` — published skills
- `skills/<name>/reference/` — optional deeper docs (singular)
- `template/` — blank starter for new skills
- Root `README.md` — catalog and install commands

## When adding or changing a skill

1. Start from `template/` unless updating an existing skill.
2. Keep `SKILL.md` concise: invocation rules, guide discovery, core principles, workflow, checklist.
3. Use singular support folders only (`reference/`, `script/`, `asset/`).
4. Do not bake product-specific routes, APIs, env vars, or deviations into skills; point agents at the consuming project's README.
5. Update the Available skills table in `README.md`.

## Frontmatter requirements

- `name` must match the parent folder (lowercase, digits, hyphens).
- `description` must include both what the skill does and when to use it.
