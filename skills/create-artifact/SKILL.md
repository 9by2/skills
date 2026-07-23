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
5. **CLI:** Assume the CLI may be missing. Run `script/ensure-cli.sh` (or
   the inline install below) **before** `artifact id` / `artifact upload`.
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
artifact --version
```

Preferred: run `script/ensure-cli.sh` from this skill folder. It installs
into `~/.local/bin` when missing and prints the resolved `artifact` path.

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

- Sticky sidebar: brand, status badges, doc nav + section anchors
- Main: one `<article>` per doc; toggle `.active` via small inline JS
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

ARTIFACT_ID="${ARTIFACT_ID:-$(artifact id)}"
# ARTIFACT_PASSCODE must be set (env / .dev.vars local / user secret)
# ARTIFACT_ENDPOINT defaults to https://artifact.9by2.workers.dev

artifact upload "$ROOT" \
  --id "$ARTIFACT_ID" \
  --yes \
  --json
```

Rules from the product CLI:

- `--id` required (UUID v4 / v7 / 21-char NanoID). Prefer `artifact id`.
- Omit `--revision` to create a new revision; retries of identical bytes are
  idempotent; changed bytes under the same revision → `409`.
- Passcode: `ARTIFACT_PASSCODE` or `--passcode` (never commit secrets).
- Local Worker: `--endpoint http://localhost:8787`.
- Print the returned `url` / `revisionUrl` to the user.

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
3. `sessionId` / local path `/tmp/{sessionId}`
4. Whether evidence was included

## Anti-patterns

- Single-file paste upload via `POST /artifact` when a folder exists — use CLI
- Writing the bundle into the repo working tree by default
- Loading scripts from non-Cloudflare CDNs
- Non–Tokyo Night light themes / purple-gradient / cream-serif redesigns
- Skipping CLI install check
- Claiming eval passed without image/video files in `evidence/`
- Leaving Mermaid source unrendered (no script, or hidden-doc `startOnLoad` only)

## Progressive disclosure

| Need | Open |
| --- | --- |
| Pinned CDN URLs | `reference/cdn.md` |
| Color tokens / Tailwind theme | `reference/tokyo-night.md` |
| Mermaid init + markup | `reference/mermaid.md` |
| HTML shell | `asset/index.template.html` |
| CLI bootstrap | `script/ensure-cli.sh` |
| Screenshots / video | `script/capture-evidence.mjs` |
