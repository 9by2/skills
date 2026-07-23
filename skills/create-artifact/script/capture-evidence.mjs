#!/usr/bin/env node
/**
 * Capture eval evidence for an artifact folder.
 *
 * Usage:
 *   node script/capture-evidence.mjs --root /tmp/SESSION --base http://127.0.0.1:4173
 *   node script/capture-evidence.mjs --root /tmp/SESSION --base http://127.0.0.1:4173 --video
 *
 * Writes PNGs (and optional WebM/MP4) under {root}/evidence/.
 */
import { spawnSync } from "node:child_process";
import { mkdirSync, existsSync, readdirSync, renameSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";

const __dirname = dirname(fileURLToPath(import.meta.url));

function parseArgs(argv) {
  const options = {
    root: "",
    base: "http://127.0.0.1:4173",
    video: false,
    path: "/",
  };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--root") options.root = argv[++i];
    else if (arg === "--base") options.base = argv[++i];
    else if (arg === "--path") options.path = argv[++i];
    else if (arg === "--video") options.video = true;
    else if (arg === "-h" || arg === "--help") {
      console.log(`Usage: capture-evidence.mjs --root <dir> [--base url] [--path /] [--video]`);
      process.exit(0);
    } else {
      throw new Error(`unknown argument: ${arg}`);
    }
  }
  if (!options.root) throw new Error("--root is required");
  return options;
}

function ensurePlaywright() {
  try {
    const require = createRequire(import.meta.url);
    return require("playwright");
  } catch {
    console.error("playwright not found; installing into skill script dir via npx…");
    const result = spawnSync(
      "npx",
      ["--yes", "playwright@1.52.0", "install", "chromium"],
      { stdio: "inherit", cwd: __dirname },
    );
    if (result.status !== 0) {
      throw new Error("failed to install Playwright Chromium");
    }
    const installPkg = spawnSync(
      "npm",
      ["install", "--no-save", "--prefix", __dirname, "playwright@1.52.0"],
      { stdio: "inherit" },
    );
    if (installPkg.status !== 0) {
      throw new Error("failed to install playwright package");
    }
    const require = createRequire(join(__dirname, "package.json"));
    return require("playwright");
  }
}

function reencodeWithFfmpeg(webmPath, mp4Path) {
  if (!existsSync(webmPath)) return;
  const hasFfmpeg = spawnSync("ffmpeg", ["-version"], { stdio: "ignore" });
  if (hasFfmpeg.status !== 0) {
    console.warn("ffmpeg not on PATH; keeping WebM only");
    return;
  }
  const result = spawnSync(
    "ffmpeg",
    ["-y", "-i", webmPath, "-c:v", "libx264", "-pix_fmt", "yuv420p", "-an", mp4Path],
    { stdio: "inherit" },
  );
  if (result.status !== 0) {
    console.warn("ffmpeg re-encode failed; WebM retained");
  }
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  const evidenceDir = join(options.root, "evidence");
  mkdirSync(evidenceDir, { recursive: true });

  const { chromium } = ensurePlaywright();
  const videoDir = join(evidenceDir, ".video-raw");
  if (options.video) mkdirSync(videoDir, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 1440, height: 900 },
    recordVideo: options.video
      ? { dir: videoDir, size: { width: 1440, height: 900 } }
      : undefined,
  });
  const page = await context.newPage();
  const url = new URL(options.path, options.base).toString();
  await page.goto(url, { waitUntil: "networkidle" });
  // Mermaid is required; wait for SVG when diagrams exist, else brief settle.
  const mermaidBlocks = await page.locator("pre.mermaid, .mermaid").count();
  if (mermaidBlocks > 0) {
    await page.waitForSelector(".mermaid svg", { timeout: 8000 });
  } else {
    await page.waitForTimeout(500);
  }

  await page.screenshot({
    path: join(evidenceDir, "desktop.png"),
    fullPage: true,
  });

  await page.setViewportSize({ width: 390, height: 844 });
  await page.waitForTimeout(300);
  await page.screenshot({
    path: join(evidenceDir, "mobile.png"),
    fullPage: true,
  });

  await context.close();
  await browser.close();

  if (options.video) {
    const files = readdirSync(videoDir).filter((name) => name.endsWith(".webm"));
    if (files[0]) {
      const webmPath = join(evidenceDir, "walkthrough.webm");
      renameSync(join(videoDir, files[0]), webmPath);
      reencodeWithFfmpeg(webmPath, join(evidenceDir, "walkthrough.mp4"));
    }
  }

  console.log(JSON.stringify({ evidenceDir, video: options.video }, null, 2));
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
