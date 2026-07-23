# Skill anatomy

## Layout

```text
skills/
  <skill-name>/
    SKILL.md           # Required entrypoint
    reference/         # Optional deeper docs (singular)
      overview.md
      ...
    script/            # Optional executables (singular)
    asset/             # Optional static templates/resources (singular)
```

Root helpers:

```text
template/              # Blank starter copied into skills/<name>/
README.md              # Catalog + install instructions
AGENTS.md              # Conventions for agents editing this repo
CONTRIBUTING.md        # Human contribution guide
```

## Frontmatter

Required:

| Field | Rules |
| ----- | ----- |
| `name` | 1–64 chars; `a-z`, `0-9`, hyphens; no leading/trailing/consecutive hyphens; must match folder name |
| `description` | 1–1024 chars; say what the skill does **and** when to use it; include trigger phrases |

Recommended:

```yaml
---
name: example-skill
description: ...
license: MIT
metadata:
  author: 9by2
  version: "0.1.0"
---
```

Optional spec fields (`compatibility`, `allowed-tools`) are allowed when needed; prefer omitting them.

## SKILL.md body shape

Keep the entrypoint concise (well under 500 lines):

1. **Invocation rules** — when to use / when not to
2. **Guide discovery** — table of which `reference/` files to load
3. **Core principles** — short durable rules
4. **Workflow** — numbered steps
5. **Checklist** — final verification

## Progressive disclosure

1. Agents always see `name` + `description`.
2. On activation they load `SKILL.md`.
3. They load `reference/` files only when pointed there.

Point to reference files with relative links and say *when* to open them.

## Portability

- Write imperative instructions agents can follow without Cursor-/Claude-only APIs.
- Prefer relative paths from the skill root.
- Keep one level of references from `SKILL.md` (avoid deep chains).
- Spec uses plural folder names (`references/`, `scripts/`, `assets/`); **this repo standardizes on singular** (`reference/`, `script/`, `asset/`) for consistency.
