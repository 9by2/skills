---
name: create-artifact
description: >
  Create and publish a Claude-style interactive HTML artifact via the
  artifact CLI. Use when the user asks to create an artifact, review bundle,
  HTML report, proposal viewer, or upload a static folder to
  artifact.9by2.workers.dev. Opinionated: Tailwind class theme + Tokyo Night
  (high-contrast dark) / Tokyo Night Light, with dark/light switcher defaulting
  to prefers-color-scheme; CSS/JS only from cdnjs.cloudflare.com. Writes to
  /tmp/{sessionId}, optionally captures Playwright/ffmpeg evidence for eval,
  then uploads the whole folder with the artifact CLI (auto-installs CLI).
  Directory names are singular (asset/, reference/, script/) per repo rules.
---

# Create Artifact

Ship a static interactive HTML folder (Claude-style review bundle) to the
Artifact Worker using this product's CLI.

Reference shape: https://artifact.9by2.workers.dev/artifact/019f8d42-27fc-703c-af5f-d1554fb7f20d
(sidebar + multi-doc shell, status pills, callouts, tables, mermaid, code).

## Non-negotiables

1. **Theme:** Tailwind **class** strategy + **Tokyo Night** (dark, high
   contrast) / **Tokyo Night Light**. Bootstrap from `prefers-color-scheme`
   (persist via `localStorage["artifact-theme"]`); include a dark/light
   switcher. Never invent a third palette.
2. **CDN:** Load CSS/JS only from `cdnjs.cloudflare.com` (Cloudflare CDN).
   No jsDelivr, unpkg, Google Fonts, `cdn.tailwindcss.com`, or npm-bundled
   browser assets inside the artifact.
3. **Workspace:** Write every file under `/tmp/{sessionId}/` (that folder is
   the upload root). Must include root `index.html`.
4. **Upload:** Publish with the `artifact` CLI (`artifact upload …`), never
   raw `curl` to the Worker unless debugging the CLI itself.
5. **CLI:** Assume the CLI may be missing or stale. Run `script/ensure-cli.sh`
   (or the inline install below) **before** `artifact upload`. Prefer
   `artifact update` when a binary already exists.
6. **Eval evidence:** If the user asks for eval / verification / screenshots /
   video proof, capture evidence into `/tmp/{sessionId}/evidence/` with
   Playwright (images) and/or ffmpeg (video), reference it in the HTML, and
   upload it with the folder.

## When to use

- "Create an artifact", "publish a review bundle", "upload this HTML report"
- Design/doc review pages similar to the Contract × CMS example
- Any static folder that should live at `/artifact/:id`

## Session directory

```bash
SESSION_ID="${ARTIFACT_SESSION_ID:-${CURSOR_CONVERSATION_ID:-}}"
if [ -z "$SESSION_ID" ]; then
  SESSION_ID="$(script/ensure-cli.sh >/dev/null && artifact id)"
fi
# sanitize path segment
SESSION_ID="$(printf '%s' "$SESSION_ID" | tr -c 'A-Za-z0-9._-' '-')"
ROOT="/tmp/${SESSION_ID}"
mkdir -p "$ROOT"
```

All generated HTML, CSS/JS you author locally, media, and evidence go under
`$ROOT`. Do not write the bundle into the git repo unless the user asks.

## Step 0 — Ensure CLI (always)

```bash
# from skill root, or inline:
command -v artifact >/dev/null 2>&1 || \
  curl -fsSL https://artifact.9by2.workers.dev/install.sh | sh
export PATH="${ARTIFACT_INSTALL_DIR:-$HOME/.local/bin}:$PATH"
# refresh an existing install when the Worker has a newer release
command -v artifact >/dev/null 2>&1 && artifact update
artifact --version
```

Preferred: run `script/ensure-cli.sh` from this skill folder. It installs
into `~/.local/bin` when missing and prints the resolved `artifact` path.
When the binary already exists, run `artifact update` so agents pick up CLI
changes (optional `--id`, API key auth, etc.).

## Step 1 — Scaffold

Copy `asset/index.template.html` → `$ROOT/index.html`, then replace
placeholders (`{{TITLE}}`, docs, sections). Keep the CDN pins from
`reference/cdn.md`.

Folder layout:

```text
/tmp/{sessionId}/
  index.html              # required entry
  asset/                  # optional local image/css/js you author
  evidence/               # only when eval requested
    desktop.png
    mobile.png
    walkthrough.webm
  README.txt              # optional one-line title + purpose
```

Multi-file is fine; the CLI uploads the **whole folder**. `index.html` must
sit at the folder root.

## Step 2 — Author content (Tokyo Night + Tailwind)

Follow `reference/tokyo-night.md` and the template.

Layout pattern (match the example's job, not its green paper theme):

- Sticky sidebar: brand, status badges, **revision dropdown**, doc nav +
  section anchors
- Main: one `<article>` per doc; toggle `.active` via small inline JS
- **No width caps on `<article>`:** never add `max-w-*` (or similar) to the
  article / main content column — it should use the full width beside the
  sidebar. `max-w-full` on media/SVG to prevent overflow is fine.
- **Revision switcher (required in template):** when hosted at
  `/artifact/:id` or `/artifact/:id/revision/:rev`, fetch
  `/artifact/:id/revisions` and render a sidebar `<select>` that navigates to
  each entry's `revisionPath`. Hide the control when the list is unavailable
  (local preview). Keep the template JS aligned with the Worker payload:
  `{ id, published, revisions: [{ id, status, createdAt, publishedAt, revisionPath }] }`
  (`createdAt` / `publishedAt` are Unix seconds).
- **Revision diff toggle (required in template):** sidebar **Diff** button that
  re-renders the whole page as a delta vs the previous revision — word-level
  `<ins class="diff">` / `<del class="diff">`, block add/remove ghosts, and
  "updated" chips for mermaid/images/code (jsdiff 7 via cdnjs; client-side
  only). Hidden on the first revision. **When republishing with `--id`, embed
  the previous revision's `<main>` in `<template id="diff-prev-snapshot">`** —
  the Worker's sandbox CSP blocks cross-revision fetch, so the snapshot is the
  reliable diff source. **Keep section `id`s / `data-diff-key` values stable
  across revisions** — they are the diff anchors. See `reference/diff.md`.
- Sections: eyebrow + heading + prose / tables / callouts / checklists
- **Mermaid (required):** `<pre class="mermaid">…</pre>` + cdnjs Mermaid 11,
  initialized with `startOnLoad: false` and `mermaid.run` on the active doc
  (see `reference/mermaid.md`). Flowcharts and sequence diagrams at minimum.
- Code: `<pre><code class="language-…">` + highlight.js tokyo-night dark/light
  stylesheets (toggle with theme) — never put Mermaid source inside `<code>`
  or highlight.js will claim it
- Theme switcher in the shell (see template); follow `reference/tokyo-night.md`

Allowed CDN libs (pin versions — see `reference/cdn.md`):

| Lib | Role |
| --- | --- |
| `tailwindcss-browser` | Tailwind v4 browser runtime |
| `highlight.js` + tokyo-night dark **and** light CSS | Code highlighting |
| `mermaid` **required** | Client-side diagram rendering |
| `jsdiff` **required** | Revision diff toggle (word/block delta) |
| `firacode` | Monospace |

### Mermaid checklist

1. Script tag from cdnjs (`mermaid/11.12.0/mermaid.min.js`)
2. Dark + light Tokyo Night `themeVariables` (copy from template /
   `tokyo-night.md`); re-init + re-run on theme change
3. `startOnLoad: false` + `mermaid.run({ nodes })` after doc becomes visible
4. At least one real diagram when the content involves architecture, flow,
   sequence, or state — prefer diagrams over long prose for those bits
5. On eval: `waitForSelector(".mermaid svg")` before evidence screenshots

## Step 3 — Eval evidence (only if requested)

Trigger phrases: eval, evaluate, verify, screenshot, evidence, record, video.

```bash
# serve the folder, then capture
npx --yes serve "$ROOT" -l 4173
# or: python3 -m http.server 4173 --directory "$ROOT"

node script/capture-evidence.mjs --root "$ROOT" --base http://127.0.0.1:4173
```

`capture-evidence.mjs` writes Playwright PNGs under `$ROOT/evidence/` and,
when `--video` is set, a WebM walkthrough (Playwright video) plus an optional
ffmpeg re-encode to MP4.

Embed evidence in the HTML (relative paths), e.g.:

```html
<figure>
  <img src="./evidence/desktop.png" alt="Desktop artifact shell" />
  <figcaption>Eval evidence — desktop shell</figcaption>
</figure>
<video controls src="./evidence/walkthrough.webm"></video>
```

If Playwright or ffmpeg is missing, install what you need for the session
(`npx playwright install chromium`, `ffmpeg` on PATH) rather than skipping
evidence when the user required eval.

## Step 4 — Upload with CLI

```bash
script/ensure-cli.sh
export PATH="${ARTIFACT_INSTALL_DIR:-$HOME/.local/bin}:$PATH"
artifact update >/dev/null 2>&1 || true

# ARTIFACT_API_KEY must be set (Studio API key / user secret)
# ARTIFACT_ENDPOINT defaults to https://artifact.9by2.workers.dev

artifact upload "$ROOT" \
  --yes \
  --json
```

To publish another revision of an existing artifact, pass the prior id:

```bash
artifact upload "$ROOT" --id "$ARTIFACT_ID" --yes --json
```

Rules from the product CLI:

- `--id` **optional** (UUID v4 / v7 / 21-char NanoID). Omit to let the CLI
  generate one; pass it only when updating an existing artifact. `artifact id`
  remains available when you need a NanoID ahead of time (e.g. session paths).
- Omit `--revision` to create a new revision; retries of identical bytes are
  idempotent; changed bytes under the same revision → `409`.
- Auth: `ARTIFACT_API_KEY` or `--api-key` (never commit secrets).
- Local Worker: `--endpoint http://localhost:8787`.
- Print the returned `url` / `revisionUrl` (and `id`) to the user.

Example success payload:

```json
{
  "id": "…",
  "revision": "…",
  "url": "https://artifact.9by2.workers.dev/artifact/…",
  "revisionUrl": "https://artifact.9by2.workers.dev/artifact/…/revision/…",
  "files": 4,
  "bytes": 12345
}
```

## Step 5 — Report back

Give the user:

1. Public URL (`url`)
2. Immutable revision URL (`revisionUrl`)
3. Artifact `id` (needed for later revisions)
4. `sessionId` / local path `/tmp/{sessionId}`
5. Whether evidence was included

## Anti-patterns

- Single-file paste upload via `POST /artifact` when a folder exists — use CLI
- Writing the bundle into the repo working tree by default
- Loading scripts from non-Cloudflare CDNs
- Non–Tokyo Night light themes / purple-gradient / cream-serif redesigns
- Putting `max-w-*` on `<article>` / the main content column
- Skipping CLI install / update check
- Renaming section ids / `data-diff-key` between revisions (breaks diff toggle)
- Dropping the Diff button or the `jsdiff` script when re-publishing with `--id`
- Republishing with `--id` without the `#diff-prev-snapshot` template (diff
  toggle will have nothing to compare against under the sandbox CSP)
- Claiming eval passed without image/video files in `evidence/`
- Leaving Mermaid source unrendered (no script, or hidden-doc `startOnLoad` only)

## Progressive disclosure

| Need | Open |
| --- | --- |
| Pinned CDN URLs | `reference/cdn.md` |
| Color tokens / Tailwind theme | `reference/tokyo-night.md` |
| Mermaid init + markup | `reference/mermaid.md` |
| Revision list API + dropdown | `reference/revisions.md` |
| Revision diff toggle + authoring rules | `reference/diff.md` |
| HTML shell | `asset/index.template.html` |
| CLI bootstrap | `script/ensure-cli.sh` |
| Screenshots / video | `script/capture-evidence.mjs` |
