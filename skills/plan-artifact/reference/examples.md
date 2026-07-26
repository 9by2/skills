# Plan Examples

Example artifact plans for common use cases.

## Example 1: Design Review

```markdown
# Artifact Plan: Homepage Redesign Review

## Summary
Interactive review bundle for the product team to explore the proposed
homepage redesign, including mockups, component breakdown, and accessibility
considerations.

## Structure

### Shell
- Sidebar: Overview, Design System, Components, Accessibility, Timeline
- Status: "In Review" badge
- Theme: Tokyo Night dark/light

### Sections
1. **Overview** — redesign goals, user feedback summary, success metrics
2. **Design System** — color palette, typography, spacing (embed Figma frames or images)
3. **Components** — hero, nav, footer, CTA cards (screenshots + specs)
4. **Accessibility** — WCAG compliance checklist, keyboard nav, screen reader notes
5. **Timeline** — implementation phases, dependencies

## Content Requirements
- [ ] Figma design file (for screenshots/embeds)
- [ ] User feedback summary (from research team)
- [ ] Component specs (dimensions, states, interactions)
- [ ] WCAG audit results
- [ ] Implementation timeline (from engineering)

## Diagrams (Mermaid)
1. **Component Hierarchy** (flowchart) — Page → Sections → Components
2. **User Flow** (sequence diagram) — Landing → CTA → Conversion path

## Evidence
Desktop and mobile screenshots of the artifact shell (requested by stakeholder).

## Complexity
**Moderate** — 5 sections, 2 diagrams, image embeds, standard navigation.

## Next Steps
Provide the missing content (Figma file, audit results, timeline). Once
ready, I'll implement with `create-artifact`.
```

---

## Example 2: Code Review

```markdown
# Artifact Plan: API Migration Review

## Summary
Technical review bundle for the engineering team to evaluate the proposed
migration from REST to GraphQL, including schema design, resolver
architecture, and rollout plan.

## Structure

### Shell
- Sidebar: Overview, Schema, Architecture, Rollout, Risks
- Status: "RFC" badge
- Theme: Tokyo Night dark/light

### Sections
1. **Overview** — migration goals, API comparison table (REST vs GraphQL)
2. **Schema** — GraphQL schema definition (syntax-highlighted), entity relationships
3. **Architecture** — resolver flow diagram, caching strategy, auth layer
4. **Rollout** — phased migration plan, backward compatibility, feature flags
5. **Risks** — performance concerns, client migration, monitoring

## Content Requirements
- [ ] GraphQL schema (`.graphql` file or paste)
- [ ] Current REST endpoint inventory
- [ ] Resolver implementation plan (which resolvers, data sources)
- [ ] Rollout phases (dates, milestones)
- [ ] Performance benchmarks (if available)

## Diagrams (Mermaid)
1. **Request Flow** (sequence diagram) — Client → Gateway → GraphQL → Resolvers → Data
2. **Schema Relationships** (ER or class diagram) — User, Post, Comment, etc.
3. **Rollout Timeline** (Gantt or flowchart) — Phase 1 → Phase 2 → Phase 3

## Evidence
Not required (internal technical review).

## Complexity
**Moderate** — 5 sections, 3 diagrams, code highlighting, tables.

## Next Steps
Paste the GraphQL schema and resolver outline. I'll structure the artifact
and implement with `create-artifact` once you approve.
```

---

## Example 3: Proposal

```markdown
# Artifact Plan: Q2 Roadmap Proposal

## Summary
Executive proposal bundle for leadership to review the Q2 product roadmap,
including feature priorities, resource allocation, and success metrics.

## Structure

### Shell
- Sidebar: Vision, Features, Resources, Metrics, Risks
- Status: "Proposal" badge
- Theme: Tokyo Night dark/light

### Sections
1. **Vision** — Q2 goals, strategic alignment, market context
2. **Features** — prioritized feature list (tables), impact scores, dependencies
3. **Resources** — team allocation, hiring plan, budget
4. **Metrics** — KPIs, success criteria, tracking plan
5. **Risks** — technical debt, scope creep, external dependencies

## Content Requirements
- [ ] Q2 strategic goals (from leadership deck)
- [ ] Feature list with impact/effort scores
- [ ] Team allocation plan (current + needed headcount)
- [ ] KPI definitions and targets
- [ ] Risk register

## Diagrams (Mermaid)
1. **Feature Dependencies** (flowchart) — which features block others
2. **Timeline** (Gantt or sequence) — Month 1 → Month 2 → Month 3 milestones

## Evidence
Not required (proposal document).

## Complexity
**Simple** — 5 sections, 2 diagrams, mostly tables and prose.

## Next Steps
Provide the feature list, team plan, and KPIs. Once you approve the
structure, I'll implement with `create-artifact`.
```

---

## Example 4: Performance Audit

```markdown
# Artifact Plan: Web Performance Audit Report

## Summary
Performance audit bundle for the frontend team, showing Core Web Vitals
analysis, bottleneck identification, and optimization recommendations.

## Structure

### Shell
- Sidebar: Summary, Metrics, Bottlenecks, Recommendations, Evidence
- Status: "Completed" badge
- Theme: Tokyo Night dark/light

### Sections
1. **Summary** — audit scope, test conditions, key findings
2. **Metrics** — LCP, INP, CLS tables (before/after if available)
3. **Bottlenecks** — render-blocking resources, network waterfalls, layout shifts
4. **Recommendations** — prioritized action items (callouts), expected impact
5. **Evidence** — Chrome DevTools screenshots, Lighthouse reports

## Content Requirements
- [ ] Lighthouse JSON (or key metrics extract)
- [ ] Chrome DevTools Performance trace (for waterfall diagram)
- [ ] Identified bottlenecks (script URLs, image sizes, etc.)
- [ ] Proposed optimizations (defer scripts, lazy load, etc.)

## Diagrams (Mermaid)
1. **Request Waterfall** (Gantt-style timeline) — HTML → CSS → JS → Images
2. **Optimization Flow** (flowchart) — Current → Fix 1 → Fix 2 → Target state

## Evidence
Desktop DevTools screenshots (Performance panel, Network tab), Lighthouse report PNG.

## Complexity
**Moderate** — 5 sections, 2 diagrams, embedded images, syntax-highlighted code.

## Next Steps
Extract the Lighthouse metrics and DevTools screenshots. I'll structure the
artifact and implement with `create-artifact` once you approve.
```

---

## Planning Principles (Derived from Examples)

1. **Structure matches content:** Review bundles have "status" badges and
   evidence sections; proposals emphasize vision and metrics.

2. **Diagrams serve clarity:** Every plan includes at least 1-2 Mermaid
   diagrams where they replace paragraphs of explanation (architecture,
   timelines, flows, dependencies).

3. **Content requirements are explicit:** List what's missing or needed from
   the user **before** implementation — avoid guessing or inventing data.

4. **Complexity is realistic:** Simple = 1-3 sections, minimal diagrams.
   Moderate = 4-5 sections, 2-3 diagrams. Complex = multi-document, heavy
   interactivity, custom data viz.

5. **Evidence matches purpose:** Internal reviews skip screenshots; external
   proposals or exec reviews may need proof of polish.

6. **Next steps are clear:** Always close with "provide X, Y, Z → approve →
   implement with `create-artifact`."
