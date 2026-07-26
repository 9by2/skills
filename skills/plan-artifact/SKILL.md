---
name: plan-artifact
description: >
  Plan artifact implementations without writing code. Use when the user asks
  to plan, design, outline, or spec an artifact, review bundle, HTML report,
  or interactive document — but hasn't explicitly said "implement" or "build
  it". Produces a structured plan that can be handed to create-artifact.
  Trigger phrases: "plan an artifact", "outline the structure", "what would
  this artifact look like", "design proposal", "spec this out".
license: MIT
metadata:
  author: 9by2
  version: "1.0.0"
---

# Plan Artifact

Plan and spec interactive HTML artifacts **without writing code** until the
user explicitly approves implementation.

## Purpose

When someone asks about creating an artifact but hasn't committed to building
it yet, this skill produces a **structured implementation plan** that can be
approved, iterated, or handed directly to `create-artifact`.

## Invocation rules

**Use this skill when:**

- User asks to "plan", "design", "outline", or "spec" an artifact
- User describes content ("I want to show X, Y, Z") without saying "build it"
- User asks "what would an artifact for X look like?"
- Uncertainty about artifact scope, structure, or feasibility
- User wants to review the approach before committing to implementation

**Do NOT use this skill when:**

- User explicitly says "implement", "build", "create", or "make the artifact"
- User has already approved a plan and is ready for code
- User is updating/republishing an existing artifact (go straight to `create-artifact`)

**Handoff to create-artifact:**

- Only after user explicitly approves the plan: "yes", "build it", "go ahead",
  "implement this", "looks good, let's do it"
- Pass the full plan context when invoking `create-artifact`

## Planning workflow

### 1. Understand the request

Extract from the user's input:

- **Purpose:** What is this artifact for? (review, proposal, report, demo)
- **Audience:** Who will view it? (stakeholders, team, customers)
- **Content type:** What information does it convey? (design, code, data, analysis)
- **Interactivity:** Do users need to explore, compare, drill down, or filter?

### 2. Propose structure

Outline the artifact's **information architecture** without writing HTML:

```markdown
## Proposed Artifact Structure

### Shell
- Sidebar navigation with:
  - [list sections/documents]
  - Status badges (if applicable)
  - Revision dropdown (required)
- Main content area (full-width beside sidebar)
- Dark/light theme switcher (Tokyo Night)

### Documents / Sections
1. **[Section name]**
   - Purpose: [what this conveys]
   - Content: [prose/tables/diagrams/code]
   - Visuals: [mermaid diagram type, callouts, etc.]

2. **[Section name]**
   - …

### Diagrams (Mermaid)
- [Type: flowchart/sequence/etc.] showing [what concept]
- [Another diagram if needed]

### Evidence (if eval requested)
- Desktop screenshot
- Mobile screenshot (if responsive requirements)
- Walkthrough video (if interactive features)
```

### 3. Identify content needs

List **what content must be provided or extracted** before implementation:

- Design specs (if artifact reviews a design)
- Code samples (if showcasing implementation)
- Metrics/data (if reporting results)
- Business context (if proposal/review)
- Assets (logos, images, etc.)

If content is missing, ask clarifying questions **before** proposing implementation.

### 4. Highlight create-artifact constraints

Remind the user of non-negotiable rules (keep brief):

- Tokyo Night theme (dark + light, no custom palettes)
- CDN-only (cdnjs.cloudflare.com)
- Mermaid diagrams required
- Revision dropdown required
- No `max-w-*` on main content column
- Diff toggle required when republishing with `--id`

### 5. Estimate complexity

Give the user a rough sense of scope:

- **Simple:** 1-2 sections, minimal diagrams, static content
- **Moderate:** 3-5 sections, multiple diagrams, some interactivity (tabs, toggles)
- **Complex:** Multi-document, heavy interactivity, eval evidence, custom data viz

### 6. Output the plan

Deliver a **markdown planning document** with:

1. **Summary** (1-2 sentences: what this artifact does)
2. **Structure** (shell + sections outline)
3. **Content requirements** (what you need from the user)
4. **Diagrams** (which Mermaid diagrams will be included)
5. **Evidence** (whether eval screenshots/video are needed)
6. **Complexity** (simple/moderate/complex)
7. **Next steps** (user approves → implement with `create-artifact`)

Example output:

```markdown
# Artifact Plan: Contract × CMS Integration Review

## Summary
Interactive review bundle for stakeholders to explore the proposed CMS
integration architecture, data flow, and implementation timeline.

## Structure

### Shell
- Sidebar: Overview, Architecture, Data Model, Timeline, Risks
- Status: "Proposed" badge
- Theme: Tokyo Night dark/light

### Sections
1. **Overview** — business context, goals, success criteria
2. **Architecture** — system diagram (Mermaid flowchart), component breakdown
3. **Data Model** — entity diagram (Mermaid ER), schema tables
4. **Timeline** — checklist with phases and milestones
5. **Risks** — callout boxes with mitigation strategies

## Content Requirements
- [ ] CMS integration goals (from product brief)
- [ ] System component list (backend, frontend, CMS API)
- [ ] Data entities and relationships
- [ ] Timeline phases (with dates if available)
- [ ] Known risks and constraints

## Diagrams (Mermaid)
1. **System Architecture** (flowchart) — Request → Worker → CMS → D1 → Response
2. **Data Model** (ER or class diagram) — User, Contract, CMS Entry relationships

## Evidence
Not required unless you want proof of rendering quality.

## Complexity
**Moderate** — 5 sections, 2 diagrams, standard navigation, no custom interactivity.

## Next Steps
Review this plan. If approved, I'll implement it with `create-artifact` and
publish to artifact.9by2.workers.dev.
```

## When to load create-artifact

**Do NOT load `create-artifact` during planning** unless:

- User explicitly asks "how would this be built?" (load for context only)
- You need to verify a constraint or feasibility detail

**Always load `create-artifact`** when:

- User approves the plan and says to proceed
- Handing off implementation after plan approval

## Checklist before finishing

- [ ] Extracted purpose, audience, content type from user request
- [ ] Proposed clear structure (shell + sections)
- [ ] Identified missing content or asked clarifying questions
- [ ] Specified which Mermaid diagrams will be included
- [ ] Estimated complexity (simple/moderate/complex)
- [ ] Delivered markdown planning doc (not code)
- [ ] Explained next steps (user must approve before implementation)
- [ ] Did NOT invoke `create-artifact` without explicit user approval

## Anti-patterns

- Writing HTML/CSS/JS during planning phase
- Loading `create-artifact` skill when user only asked for a plan
- Implementing immediately without user approval
- Skipping content requirements (missing specs, data, or context)
- Proposing custom themes or non-Mermaid diagram libraries
- Ignoring complexity — setting unrealistic expectations
- Forgetting required elements (revision dropdown, diff toggle for updates)

## Progressive disclosure

| Need | Open |
| --- | --- |
| Tokyo Night colors/constraints | Load `create-artifact` → `reference/tokyo-night.md` |
| Mermaid diagram syntax | Load `create-artifact` → `reference/mermaid.md` |
| Revision/diff requirements | Load `create-artifact` → `reference/revisions.md`, `reference/diff.md` |
| CDN pinning rules | Load `create-artifact` → `reference/cdn.md` |
