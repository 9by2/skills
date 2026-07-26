# Handoff to create-artifact

How to transition from planning to implementation.

## When to hand off

Hand off to `create-artifact` **only when the user explicitly approves**:

- "yes", "build it", "go ahead", "implement this", "looks good"
- "create the artifact", "make it", "let's do it"
- "proceed with implementation"

**Do NOT hand off when:**

- User says "interesting", "thanks", "let me think about it"
- User asks follow-up questions about the plan
- User requests revisions ("can we add X?", "remove Y")
- User hasn't responded to your plan yet

## Approval signals

| User says | Interpretation | Action |
| --- | --- | --- |
| "yes", "build it", "go ahead" | **Approved** | Hand off to `create-artifact` |
| "looks good", "implement this" | **Approved** | Hand off to `create-artifact` |
| "can we add X?" | **Revise plan** | Update plan, wait for approval |
| "what about Y?" | **Clarify plan** | Answer question, wait for approval |
| "let me think" | **Pending** | Wait for user response |
| "thanks" (no commitment) | **Ambiguous** | Ask "Would you like me to proceed with implementation?" |

## Handoff checklist

Before invoking `create-artifact`, ensure:

- [ ] User explicitly approved the plan
- [ ] All content requirements are satisfied (or user confirmed they'll provide during implementation)
- [ ] Plan includes clear structure (sections, diagrams, evidence)
- [ ] Complexity estimate is realistic
- [ ] You've loaded `create-artifact` skill via `read` tool

## Passing context

When handing off, provide `create-artifact` with:

1. **The full plan document** (markdown from `plan-artifact`)
2. **User-provided content** (schemas, specs, images, data)
3. **Any clarifications** from the planning discussion
4. **Explicit approval confirmation** ("User approved the plan on [date/time]")

Example handoff message:

> User approved the artifact plan. Proceeding to implement with `create-artifact`.
>
> **Approved Plan:**
> [paste full plan markdown]
>
> **User-provided content:**
> - GraphQL schema: [paste or reference]
> - Timeline data: [paste or reference]
>
> **Implementation notes:**
> - User prefers desktop screenshots only (skip mobile)
> - Emphasize the migration risks section (add callouts)

## What create-artifact expects

`create-artifact` will use your plan to:

1. Bootstrap the session directory (`/tmp/{sessionId}`)
2. Scaffold `index.html` from the template
3. Implement the shell (sidebar nav, status badge, theme switcher)
4. Author each section (headings, prose, tables, callouts, Mermaid diagrams)
5. Capture eval evidence (if planned)
6. Upload with the artifact CLI

Your plan's **Structure → Sections** becomes the HTML document structure.
Your plan's **Diagrams** become `<pre class="mermaid">…</pre>` blocks.
Your plan's **Evidence** determines whether Playwright captures screenshots.

## Iterating after implementation

If the user requests changes **after** the artifact is built:

1. `create-artifact` handles updates (republish with `--id`)
2. You may be invoked again if the user says "plan the next revision"
3. For minor tweaks (fix typo, adjust color), skip planning — go straight to `create-artifact`

## When NOT to hand off

**Re-planning scenarios:**

- User rejects the plan: "no, that's not what I want"
- User requests major structural changes: "replace the timeline with a roadmap"
- User provides new requirements that invalidate the plan

In these cases, **iterate the plan** within `plan-artifact` instead of handing off.

**Out-of-scope scenarios:**

- User asks to implement something that isn't an artifact (e.g., a Worker, a database schema)
- User wants to modify an existing artifact but doesn't need planning (already knows the structure)

## Anti-patterns

- Handing off without explicit approval ("I think they want this, so I'll build it")
- Skipping the plan entirely and jumping to `create-artifact` when the user asked for design/outline
- Passing an incomplete plan (missing diagrams, content requirements, or structure)
- Implementing during the planning phase (writing HTML/CSS in `plan-artifact`)
- Forgetting to load `create-artifact` before invoking it

## Example handoff flow

### User request
> "I need an artifact to review our new API design."

### Your response (plan-artifact)
> [Deliver plan using template — structure, diagrams, content requirements, etc.]

### User approval
> "Looks good, let's build it."

### Your handoff
> Great! I'll implement this with `create-artifact` now.
>
> [Load `create-artifact` skill, pass the approved plan + any user-provided content]

### create-artifact output
> Published to https://artifact.9by2.workers.dev/artifact/{id}

---

## Summary

- **Plan first** (this skill) when user asks to "plan" or describes content without saying "build"
- **Wait for approval** ("yes", "build it", "go ahead")
- **Hand off context** (full plan + content + clarifications)
- **Let create-artifact handle implementation** (HTML, diagrams, upload)
- **Iterate in plan-artifact** if user rejects or requests major changes
