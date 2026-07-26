# Revision diff (global toggle)

The template ships a **Diff** button in the sidebar header. One click re-renders
the whole page as a delta against the **previous revision**:

- `<ins class="diff">` — added text (green highlight)
- `<del class="diff">` — removed text (red strikethrough)
- `.diff-block-added` — whole new block (green left border)
- `.diff-block-removed` — ghost of a deleted block re-inserted in place
  (red border, struck through, `data-diff-ghost="1"`)
- `.diff-block-updated` — non-text block changed (mermaid / image / code):
  dashed yellow outline + "updated" chip
- `#diff-summary` — sidebar line: `diff vs 019f8fc4… · +2 · −1 · ~3`

Everything runs client-side. No Worker changes needed.

## Previous-revision source: snapshot first, fetch fallback

The Worker serves artifact pages with a **sandboxing CSP** (`sandbox
allow-scripts …`), so the page runs with origin `null` and cross-revision
`fetch` of revision HTML is **blocked by CORS** (the JSON `/revisions`
endpoint sends `access-control-allow-origin: *`, revision HTML does not).

Therefore, when republishing with `artifact upload --id`, the agent **must
embed a snapshot of the previous revision's `<main>`** in the new bundle:

```html
<template id="diff-prev-snapshot" data-revision="PREV_REVISION_ID">
  <main> …previous revision's main content, verbatim… </main>
</template>
```

- `<template>` content is inert: scripts don't run, images don't load.
- Get the previous main: `curl -s <prev revisionUrl> | extract <main>…</main>`
  or reuse the prior bundle from the session directory.
- Omit the template on the **first** revision (nothing to diff; button hides).
- The toggle still tries `fetch(prevRevision.revisionPath)` first and falls
  back to the snapshot, so it keeps working if the Worker later adds CORS.

## How it works

1. On load the template fetches `/artifact/:id/revisions` **once** (shared with
   the revision dropdown via `revisionsState`). The Diff button shows when a
   previous revision exists **or** a `#diff-prev-snapshot` template is present.
2. The entry after the current revision (API is newest-first) is the previous
   revision. First revision + no snapshot → button stays hidden.
3. On toggle: load the previous main (fetch → snapshot fallback), then for
   each diff target align child blocks with `Diff.diffArrays` (normalized
   text) and word-diff changed prose with `Diff.diffWords` (jsdiff 7 from
   cdnjs — see `cdn.md`).
4. Toggling off restores the stashed original `innerHTML` — no reload.

## Diff targets — authoring rules

Targets are selected by:

```css
main [data-diff-key], main article.doc > section[id]
```

The template's `section[id]` convention already works with zero effort, but
**stable anchors are the contract**:

1. **Keep `section` ids / `data-diff-key` values stable across revisions.**
   Renaming an id makes the old section read as removed + new one as added.
2. Prefer explicit `data-diff-key="…"` when a section id must change or when
   diffing non-section blocks (e.g. a standalone table or figure).
3. New section in a revision → whole section shows as `.diff-block-added`.
   Deleted section → currently *not* ghosted at page level (only blocks inside
   surviving sections are ghosted); mention removals in a changelog note if
   they matter.
4. Mermaid, images, video, `<pre>` code: marked with the "updated" chip when
   their source/text changed — they are not word-diffed.
5. Do not nest one diff target inside another.
6. Add `data-diff-skip` to any section containing **interactive JS widgets**
   (event listeners attached at load). Toggling the diff off restores stashed
   `innerHTML`, which would orphan those listeners.

## Manual redline (optional, author-time)

For curated review rounds the agent may additionally hand-write
`<ins class="diff">` / `<del class="diff">` in the new revision to explain
*why* something changed (the classes are styled regardless of the toggle).
Keep hand-written redline out of sections you expect the automatic toggle to
word-diff, or the markup will be diffed as text.

## Testing locally

With a `#diff-prev-snapshot` template embedded, the Diff button works on any
`serve`/local preview — just open the page and toggle. Without a snapshot the
button hides itself (revisions API unavailable off-Worker).
