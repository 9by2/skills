# Pinned CDN asset (cdnjs / Cloudflare only)

All artifact browser dependencies must come from
`https://cdnjs.cloudflare.com/…`.

Update pins deliberately; prefer these exact versions unless broken.

## Required

```html
<link id="hljs-theme-dark" rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/tokyo-night-dark.min.css"
  crossorigin="anonymous" referrerpolicy="no-referrer" />
<link id="hljs-theme-light" rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/tokyo-night-light.min.css"
  crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/firacode/6.2.0/fira_code.css"
  crossorigin="anonymous" referrerpolicy="no-referrer" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss-browser/4.3.2/index.global.min.js"
  crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js"
  crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/11.12.0/mermaid.min.js"
  crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jsdiff/7.0.0/diff.min.js"
  crossorigin="anonymous" referrerpolicy="no-referrer"></script>
```

Enable only the active highlight.js theme (`link.disabled = true` on the
other) when the shell is light or dark. Mermaid is **required** for
architecture / flow / sequence content. Init and markup rules: `mermaid.md`.
jsdiff powers the global revision diff toggle (`Diff.diffWords` /
`Diff.diffArrays`); rules: `diff.md`.

## Tailwind browser config

Configure **before** first paint classes matter. Use a
`<script type="text/tailwindcss">` block (Tailwind v4 browser) with Tokyo
Night `@theme` tokens from `tokyo-night.md`. Keep `darkMode` as **class**
strategy; bootstrap `.dark` from `prefers-color-scheme` / localStorage (do
not hardcode `class="dark"` on `<html>`).

## Optional language packs

Only if needed, still from cdnjs highlight.js:

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/go.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/sql.min.js"></script>
```

## Forbidden

- `cdn.tailwindcss.com`
- `unpkg.com`, `jsdelivr.net`, `esm.sh`, `skypack`
- `fonts.googleapis.com` / `fonts.gstatic.com`
- Inline `npm`/`bun` bundled vendor chunks copied into the artifact unless the
  user explicitly asks for a self-contained offline bundle (still prefer CDN)
