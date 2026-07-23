# Tokyo Night + Tailwind class theme

Fixed visual system for every artifact this skill creates. Dark = high-contrast
Tokyo Night. Light = Tokyo Night Light. Do not invent a third palette.

## Theme bootstrap

Apply class strategy **before first paint** so FOUC does not flash the wrong
mode. Default to the browser preference; persist explicit picks.

```html
<html lang="en" data-theme="tokyo-night">
<head>
  <script>
    (function () {
      var key = "artifact-theme";
      var stored = null;
      try { stored = localStorage.getItem(key); } catch (e) {}
      var dark = stored === "dark" || stored === "light"
        ? stored === "dark"
        : window.matchMedia("(prefers-color-scheme: dark)").matches;
      document.documentElement.classList.toggle("dark", dark);
      document.documentElement.setAttribute(
        "data-theme",
        dark ? "tokyo-night" : "tokyo-night-light"
      );
      document.documentElement.style.colorScheme = dark ? "dark" : "light";
    })();
  </script>
```

Do **not** hardcode `class="dark"` on `<html>` — the bootstrap script owns it.
Ship a dark/light switcher that writes `localStorage["artifact-theme"]` to
`"dark"` or `"light"`, then re-applies the same class / `data-theme` /
`color-scheme` rules (and swaps highlight.js + Mermaid — see below).

## Dark tokens (high contrast)

| Token | Hex | Use |
| --- | --- | --- |
| `tn-bg` | `#0d0f17` | page background |
| `tn-bg-dark` | `#06070c` | sidebar / deep surface |
| `tn-bg-highlight` | `#1a1e2e` | hover / elevated |
| `tn-fg` | `#c0caf5` | body text |
| `tn-fg-dim` | `#7a8199` | muted / meta |
| `tn-fg-bright` | `#eef1ff` | headings |
| `tn-blue` | `#7aa2f7` | links / accent |
| `tn-cyan` | `#7dcfff` | secondary accent |
| `tn-magenta` | `#bb9af7` | badges / accents |
| `tn-green` | `#9ece6a` | success |
| `tn-yellow` | `#e0af68` | warn |
| `tn-orange` | `#ff9e64` | warn strong |
| `tn-red` | `#f7768e` | danger |
| `tn-comment` | `#7a8199` | hairlines / comments |
| `tn-border` | `#4a5270` | borders |

## Light tokens (Tokyo Night Light)

| Token | Hex | Use |
| --- | --- | --- |
| `tn-bg` | `#e6e7ed` | page background |
| `tn-bg-dark` | `#d6d8df` | sidebar / deep surface |
| `tn-bg-highlight` | `#f0f1f5` | hover / elevated |
| `tn-fg` | `#40434f` | body text |
| `tn-fg-dim` | `#6c6e75` | muted / meta |
| `tn-fg-bright` | `#1a1b26` | headings |
| `tn-blue` | `#2959aa` | links / accent |
| `tn-cyan` | `#0f4b6e` | secondary accent |
| `tn-magenta` | `#5a3e8e` | badges / accents |
| `tn-green` | `#33635c` | success |
| `tn-yellow` | `#8f5e15` | warn |
| `tn-orange` | `#965027` | warn strong |
| `tn-red` | `#8c4351` | danger |
| `tn-comment` | `#6c6e75` | hairlines / comments |
| `tn-border` | `#c1c2c7` | borders |

## Tailwind v4 `@theme` snippet

Map utilities to CSS variables, then set light defaults on `:root` and dark
overrides on `.dark`:

```css
@theme {
  --color-tn-bg: var(--tn-bg);
  --color-tn-bg-dark: var(--tn-bg-dark);
  --color-tn-bg-highlight: var(--tn-bg-highlight);
  --color-tn-fg: var(--tn-fg);
  --color-tn-fg-dim: var(--tn-fg-dim);
  --color-tn-fg-bright: var(--tn-fg-bright);
  --color-tn-blue: var(--tn-blue);
  --color-tn-cyan: var(--tn-cyan);
  --color-tn-magenta: var(--tn-magenta);
  --color-tn-green: var(--tn-green);
  --color-tn-yellow: var(--tn-yellow);
  --color-tn-orange: var(--tn-orange);
  --color-tn-red: var(--tn-red);
  --color-tn-comment: var(--tn-comment);
  --color-tn-border: var(--tn-border);
  --font-sans: ui-sans-serif, system-ui, "Segoe UI", sans-serif;
  --font-mono: "Fira Code", ui-monospace, SFMono-Regular, Menlo, monospace;
}

:root {
  --tn-bg: #e6e7ed;
  --tn-bg-dark: #d6d8df;
  --tn-bg-highlight: #f0f1f5;
  --tn-fg: #40434f;
  --tn-fg-dim: #6c6e75;
  --tn-fg-bright: #1a1b26;
  --tn-blue: #2959aa;
  --tn-cyan: #0f4b6e;
  --tn-magenta: #5a3e8e;
  --tn-green: #33635c;
  --tn-yellow: #8f5e15;
  --tn-orange: #965027;
  --tn-red: #8c4351;
  --tn-comment: #6c6e75;
  --tn-border: #c1c2c7;
}

.dark {
  --tn-bg: #0d0f17;
  --tn-bg-dark: #06070c;
  --tn-bg-highlight: #1a1e2e;
  --tn-fg: #c0caf5;
  --tn-fg-dim: #7a8199;
  --tn-fg-bright: #eef1ff;
  --tn-blue: #7aa2f7;
  --tn-cyan: #7dcfff;
  --tn-magenta: #bb9af7;
  --tn-green: #9ece6a;
  --tn-yellow: #e0af68;
  --tn-orange: #ff9e64;
  --tn-red: #f7768e;
  --tn-comment: #7a8199;
  --tn-border: #4a5270;
}
```

Utility examples: `bg-tn-bg`, `text-tn-fg-bright`, `border-tn-border`,
`bg-tn-blue/15`, `text-tn-green`.

## Mermaid theme

Always pair with `reference/mermaid.md`. Use `startOnLoad: false` and run
`mermaid.run` on the visible doc. Swap variables when the theme changes;
stash each node's source before the first render so diagrams can re-run.

### Dark

```js
{
  theme: "dark",
  themeVariables: {
    primaryColor: "#1a1e2e",
    primaryTextColor: "#eef1ff",
    primaryBorderColor: "#4a5270",
    lineColor: "#7aa2f7",
    secondaryColor: "#06070c",
    tertiaryColor: "#0d0f17",
    background: "#0d0f17",
    mainBkg: "#1a1e2e",
    nodeBorder: "#4a5270",
    clusterBkg: "#06070c",
    titleColor: "#eef1ff",
    edgeLabelBackground: "#0d0f17",
  },
}
```

### Light (Tokyo Night Light)

```js
{
  theme: "base",
  themeVariables: {
    primaryColor: "#f0f1f5",
    primaryTextColor: "#1a1b26",
    primaryBorderColor: "#c1c2c7",
    lineColor: "#2959aa",
    secondaryColor: "#d6d8df",
    tertiaryColor: "#e6e7ed",
    background: "#e6e7ed",
    mainBkg: "#f0f1f5",
    nodeBorder: "#c1c2c7",
    clusterBkg: "#d6d8df",
    titleColor: "#1a1b26",
    edgeLabelBackground: "#e6e7ed",
  },
}
```

## highlight.js

Load both stylesheets from cdnjs; enable one at a time via `disabled` (or swap
`href` on a single `#hljs-theme` link):

- Dark: `highlight.js/11.11.1/styles/tokyo-night-dark.min.css`
- Light: `highlight.js/11.11.1/styles/tokyo-night-light.min.css`

Call `hljs.highlightAll()` after DOM ready. On theme toggle, flip which
stylesheet is active (no re-highlight required).
