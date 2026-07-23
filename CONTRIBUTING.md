# Contributing

Thanks for improving 9by2 skills.

## Add a skill

1. Copy the template:

   ```bash
   cp -R template "skills/<skill-name>"
   ```

2. Edit `skills/<skill-name>/SKILL.md`:
   - Set `name` to the folder name
   - Write a specific `description` (what + when / triggers)
   - Fill invocation rules, guide discovery, principles, workflow, and checklist

3. Put long-form material under `skills/<skill-name>/reference/`.

4. Add a row to the Available skills table in `README.md`.

5. Self-check with `skills/create-skill/reference/checklist.md`.

## Revise a skill

- Prefer clarifying triggers and progressive disclosure over adding length to `SKILL.md`.
- Move depth into `reference/` instead of growing the entrypoint.
- Keep house conventions: singular support folders, portable Markdown, no project-specific inventories.

## Style

- Imperative instructions
- Relative links from the skill root
- One level of references from `SKILL.md` (avoid deep chains)

## License

Contributions are accepted under the MIT License.
