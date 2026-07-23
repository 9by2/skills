# Mermaid rendering (required)

Every artifact this skill ships must load Mermaid from cdnjs and render
diagrams client-side. Do not leave raw `flowchart` / `sequenceDiagram` source
as plain `<pre>` without the Mermaid runtime.

## CDN pin

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/11.12.0/mermaid.min.js"
  crossorigin="anonymous" referrerpolicy="no-referrer"></script>
```

## Markup

Use a `<pre class="mermaid">` (or `<div class="mermaid">`) with the diagram
source as text content. Prefer wrapping in a `<figure>` with a caption.

```html
<figure>
  <pre class="mermaid">flowchart LR
  A[Author] --> B[Upload]
  B --> C[Public URL]
</pre>
  <figcaption>Publish path</figcaption>
</figure>
```

Supported diagram kinds (use freely when they clarify the review):

- `flowchart` / `graph`
- `sequenceDiagram`
- `classDiagram`
- `stateDiagram-v2`
- `erDiagram`
- `gantt`
- `pie`
- `mindmap` (when Mermaid 11 supports it in this pin)

## Init rules (multi-doc shells)

Hidden articles use `display: none`. `startOnLoad: true` mis-measures those
nodes. Always:

1. `mermaid.initialize({ startOnLoad: false, theme: "dark", … })`
2. Call `mermaid.run({ nodes })` for the **visible** doc after show
3. Skip nodes that already have `data-processed`

```js
mermaid.initialize({
  startOnLoad: false,
  theme: "dark",
  securityLevel: "strict",
  themeVariables: { /* Tokyo Night — see tokyo-night.md */ },
});

function renderMermaid(root) {
  const nodes = [...root.querySelectorAll("pre.mermaid, .mermaid")]
    .filter((n) => !n.getAttribute("data-processed"));
  if (!nodes.length) return;
  return mermaid.run({ nodes });
}
```

Call `renderMermaid(activeArticle)` from the doc-switcher and once on boot for
the initially active article.

## Theme

Keep Mermaid on `theme: "dark"` plus Tokyo Night `themeVariables` from
`tokyo-night.md`. Do not use the default light Mermaid palette.

## Eval checks

When eval/evidence is requested, assert at least one `.mermaid svg` exists in
the Playwright page before screenshotting:

```js
await page.waitForSelector(".mermaid svg", { timeout: 5000 });
```

## Anti-patterns

- Shipping diagram source without the Mermaid script tag
- `startOnLoad: true` alone in a multi-doc `display:none` shell
- Loading Mermaid from jsDelivr / unpkg
- Putting Mermaid source inside `<code>` (highlight.js will steal it)
