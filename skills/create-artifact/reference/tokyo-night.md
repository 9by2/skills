# Tokyo Night + Tailwind dark mode

Fixed visual system for every artifact this skill creates. Do not invent a
second palette.

## Force dark

```html
<html lang="en" class="dark" data-theme="tokyo-night">
```

No light theme stylesheet. No `prefers-color-scheme` light branch that flips
the product look.

## Tokens

| Token | Hex | Use |
| --- | --- | --- |
| `tn-bg` | `#1a1b26` | page background |
| `tn-bg-dark` | `#16161e` | sidebar / deep surface |
| `tn-bg-highlight` | `#1f2335` | hover / elevated |
| `tn-fg` | `#a9b1d6` | body text |
| `tn-fg-dim` | `#565f89` | muted / meta |
| `tn-fg-bright` | `#c0caf5` | headings |
| `tn-blue` | `#7aa2f7` | links / accent |
| `tn-cyan` | `#7dcfff` | secondary accent |
| `tn-magenta` | `#bb9af7` | badges / accents |
| `tn-green` | `#9ece6a` | success |
| `tn-yellow` | `#e0af68` | warn |
| `tn-orange` | `#ff9e64` | warn strong |
| `tn-red` | `#f7768e` | danger |
| `tn-comment` | `#565f89` | hairlines / comments |
| `tn-border` | `#3b4261` | borders |

## Tailwind v4 `@theme` snippet

```css
@theme {
  --color-tn-bg: #1a1b26;
  --color-tn-bg-dark: #16161e;
  --color-tn-bg-highlight: #1f2335;
  --color-tn-fg: #a9b1d6;
  --color-tn-fg-dim: #565f89;
  --color-tn-fg-bright: #c0caf5;
  --color-tn-blue: #7aa2f7;
  --color-tn-cyan: #7dcfff;
  --color-tn-magenta: #bb9af7;
  --color-tn-green: #9ece6a;
  --color-tn-yellow: #e0af68;
  --color-tn-orange: #ff9e64;
  --color-tn-red: #f7768e;
  --color-tn-comment: #565f89;
  --color-tn-border: #3b4261;
  --font-sans: ui-sans-serif, system-ui, "Segoe UI", sans-serif;
  --font-mono: "Fira Code", ui-monospace, SFMono-Regular, Menlo, monospace;
}
```

Utility examples: `bg-tn-bg`, `text-tn-fg-bright`, `border-tn-border`,
`bg-tn-blue/15`, `text-tn-green`.

## Mermaid theme

Always pair with `reference/mermaid.md`. Use `startOnLoad: false` and run
`mermaid.run` on the visible doc. Tokyo Night variables:

```js
mermaid.initialize({
  startOnLoad: false,
  theme: "dark",
  securityLevel: "strict",
  themeVariables: {
    primaryColor: "#1f2335",
    primaryTextColor: "#c0caf5",
    primaryBorderColor: "#3b4261",
    lineColor: "#7aa2f7",
    secondaryColor: "#16161e",
    tertiaryColor: "#1a1b26",
    background: "#1a1b26",
    mainBkg: "#1f2335",
    nodeBorder: "#3b4261",
    clusterBkg: "#16161e",
    titleColor: "#c0caf5",
    edgeLabelBackground: "#1a1b26",
  },
});
```

## highlight.js

Use stylesheet
`highlight.js/11.11.1/styles/tokyo-night-dark.min.css` and call
`hljs.highlightAll()` after DOM ready.
