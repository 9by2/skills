# Planning Template

Use this template structure for every artifact plan. Replace `[…]` with
context from the user's request.

---

```markdown
# Artifact Plan: [Artifact Title]

## Summary
[1-2 sentences: what this artifact does and who it's for]

## Structure

### Shell
- Sidebar navigation with:
  - [Section 1 name]
  - [Section 2 name]
  - [Section N name]
  - Status badge: "[Status]" (e.g., Proposed, In Review, Completed, RFC)
  - Revision dropdown (required)
- Main content area (full-width beside sidebar)
- Dark/light theme switcher (Tokyo Night)

### Sections
1. **[Section Name]**
   - Purpose: [what this section conveys]
   - Content: [prose / tables / diagrams / code / callouts]
   - Visuals: [Mermaid diagram type, images, etc.]

2. **[Section Name]**
   - Purpose: [what this section conveys]
   - Content: [prose / tables / diagrams / code / callouts]
   - Visuals: [Mermaid diagram type, images, etc.]

[… repeat for each section]

## Content Requirements
- [ ] [Specific content item 1 — e.g., design file, schema, metrics]
- [ ] [Specific content item 2]
- [ ] [Specific content item N]

**Ask user for missing content:**
[If any requirements are unclear or unavailable, list clarifying questions here]

## Diagrams (Mermaid)
1. **[Diagram Name]** ([type: flowchart/sequence/ER/Gantt]) — [what it shows]
2. **[Diagram Name]** ([type]) — [what it shows]
[… minimum 1 diagram; prefer diagrams over long prose for architecture/flow/data]

## Evidence (eval)
[Choose one:]
- Not required (internal review / proposal)
- Desktop screenshot (if stakeholder wants proof of polish)
- Desktop + mobile screenshots (if responsive requirements)
- Desktop + mobile + walkthrough video (if interactive features need demonstration)

## Complexity
**[Simple / Moderate / Complex]** — [brief justification]

- **Simple:** 1-3 sections, 1 diagram, mostly prose/tables
- **Moderate:** 4-5 sections, 2-3 diagrams, some interactivity (tabs, toggles)
- **Complex:** multi-document, 4+ diagrams, custom interactivity, eval evidence

## Next Steps
[Choose one:]
1. **If content is complete:** Review this plan. If approved, I'll implement
   it with `create-artifact` and publish to artifact.9by2.workers.dev.
2. **If content is missing:** Provide the content listed in **Content
   Requirements**. Once you approve the structure, I'll proceed with
   implementation.
3. **If updates needed:** Let me know which sections to adjust, add, or
   remove. I'll revise the plan before implementation.
```

---

## Field Guidance

### Summary
- Keep it to 1-2 sentences
- Include **what** (type of artifact) and **who** (audience)
- Example: "Interactive review bundle for the product team to explore the
  proposed CMS integration architecture and timeline."

### Structure → Shell
- Always include: sidebar nav, status badge, revision dropdown, theme switcher
- Status badge should match the artifact's purpose:
  - Proposals: "Proposed", "RFC", "Draft"
  - Reviews: "In Review", "Pending Approval"
  - Reports: "Completed", "Final"
  - Internal docs: "Living Document", "Reference"

### Structure → Sections
- Each section needs:
  - **Name** (sidebar anchor)
  - **Purpose** (why this section exists)
  - **Content** (prose, tables, diagrams, code, callouts, checklists)
  - **Visuals** (Mermaid diagrams, images, charts)
- Order sections logically: Overview → Details → Risks/Next Steps

### Content Requirements
- Be **specific**: don't say "design specs" — say "Figma file URL or exported
  frames for homepage redesign"
- Use checkboxes for missing items
- If the user's request is vague, add clarifying questions below the checklist

### Diagrams
- **Minimum 1 diagram** if the content involves architecture, flow, timeline,
  data, or dependencies
- Prefer diagrams over prose paragraphs for those concepts
- Specify the **Mermaid type**:
  - `flowchart` — architecture, process, dependencies
  - `sequenceDiagram` — request/response flows, interactions
  - `erDiagram` or `classDiagram` — data models, entity relationships
  - `gantt` — timelines, roadmaps, phases
  - `stateDiagram` — state machines, workflows
- Example: "**Request Flow** (sequence diagram) — Client → Worker → Database → Response"

### Evidence
- Default: "Not required (internal review)"
- Desktop screenshot: stakeholder wants proof of polish
- Desktop + mobile: responsive design review
- Desktop + mobile + video: interactive features need demonstration
- Only request evidence when the user **explicitly asked for eval/verify** or
  the artifact's purpose demands visual proof

### Complexity
- **Simple:** 1-3 sections, 1 diagram, mostly static content
- **Moderate:** 4-5 sections, 2-3 diagrams, standard interactivity (tabs, theme toggle)
- **Complex:** 6+ sections or multi-document, 4+ diagrams, custom data viz,
  heavy interactivity, eval evidence
- Include a **brief justification** for the rating

### Next Steps
- Always end with **one of three paths**:
  1. Content is ready → approve → implement
  2. Content is missing → user provides → approve → implement
  3. Plan needs revision → user requests changes → iterate
- Never implement without explicit approval: "yes", "go ahead", "build it",
  "implement this", "looks good"

---

## When to Deviate

The template is a starting point. Adjust when:

- **Multi-document artifacts:** Replace "Sections" with "Documents", each with
  its own section list
- **Data-heavy artifacts:** Add a "Visualizations" subsection under Structure
  (charts, graphs, custom SVG)
- **Living docs:** Note that revision history/diff toggle is especially
  important (artifact may be republished frequently)
- **Comparison artifacts:** Structure may need side-by-side columns or
  before/after tabs

Always preserve the **Summary → Structure → Content → Diagrams → Evidence →
Complexity → Next Steps** flow.
