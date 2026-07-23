# Authoring checklist

Use before merging a new or revised skill.

## Structure

- [ ] Skill lives at `skills/<name>/SKILL.md`
- [ ] Folder name equals frontmatter `name`
- [ ] Optional depth is under singular `reference/` (not `references/`)
- [ ] Optional executables under `script/`; static files under `asset/`

## Frontmatter

- [ ] `description` states what + when (triggers, Bridge Platform contexts)
- [ ] Description is specific enough that agents will not under-trigger
- [ ] `license` / `metadata.author` / `metadata.version` set when publishing

## Body

- [ ] Invocation rules present
- [ ] Guide discovery table points at the right reference files
- [ ] Core principles are durable and portable
- [ ] Workflow is actionable
- [ ] Closing checklist exists
- [ ] SKILL.md stays short; long material is in `reference/`

## Boundaries

- [ ] No hard-coded product route inventories, API catalogs, or env var lists
- [ ] Skill tells agents to prefer the target project's README for local facts
- [ ] No malware, exploit payloads, or surprising destructive steps

## Repo hygiene

- [ ] Root `README.md` Available skills table updated
- [ ] Template was used or intentionally diverged with a reason
- [ ] Links from `SKILL.md` to `reference/` resolve
