#!/usr/bin/env node
// Pre-deploy correctness gate for the Hugo site.
//
//   1. Syntax-checks every inline <script> in the BUILT output (public/**/*.html).
//      This catches the class of bug that has shipped broken before: an unescaped
//      apostrophe in a JS string, a stray brace, etc. -- things Hugo renders happily
//      but that break the page in the browser.
//   2. Flags non-ASCII "smart" punctuation in layouts/ (code + template markup),
//      per the ASCII-only house rule. Scoped to layouts/ so legitimate Unicode in
//      content prose / data is not touched.
//
// Run locally:  node scripts/check-build.mjs   (after `hugo --gc --minify`)
// Exit non-zero on any problem so CI fails before deploy.

import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import vm from "node:vm";

const root = process.cwd();
let problems = 0;

function walk(dir, exts, out = []) {
  for (const name of readdirSync(dir)) {
    const p = join(dir, name);
    const st = statSync(p);
    if (st.isDirectory()) walk(p, exts, out);
    else if (exts.some((e) => name.endsWith(e))) out.push(p);
  }
  return out;
}

// ---- 1. Inline JS syntax check on built HTML ----
const publicDir = join(root, "public");
let htmlFiles = [];
try {
  htmlFiles = walk(publicDir, [".html"]);
} catch {
  console.error("check-build: public/ not found -- run `hugo --gc --minify` first.");
  process.exit(2);
}

// Match <script> blocks, capturing the opening tag attributes and the body.
const scriptRe = /<script\b([^>]*)>([\s\S]*?)<\/script>/gi;
for (const file of htmlFiles) {
  const html = readFileSync(file, "utf8");
  let m;
  while ((m = scriptRe.exec(html))) {
    const attrs = m[1];
    const body = m[2];
    // Skip external scripts and non-JS blocks (e.g. application/ld+json).
    if (/\bsrc\s*=/.test(attrs)) continue;
    if (/\btype\s*=/.test(attrs) && !/type\s*=\s*["']?(text\/javascript|module|application\/javascript)/i.test(attrs)) continue;
    if (!body.trim()) continue;
    try {
      // Compile only -- does not execute. Throws SyntaxError on bad JS.
      new vm.Script(body, { filename: relative(root, file) });
    } catch (e) {
      problems++;
      console.error(`JS syntax error in ${relative(root, file)}:\n    ${e.message}`);
    }
  }
}

// ---- 2. ASCII-punctuation check on layouts/ ----
const banned = {
  "—": "em-dash (U+2014) -> use -- or -",
  "–": "en-dash (U+2013) -> use -",
  "‘": "left smart quote (U+2018) -> use '",
  "’": "right smart quote (U+2019) -> use '",
  "“": "left smart quote (U+201C) -> use \"",
  "”": "right smart quote (U+201D) -> use \"",
  "…": "ellipsis (U+2026) -> use ...",
};
const bannedRe = new RegExp("[" + Object.keys(banned).join("") + "]");

let layoutFiles = [];
try {
  layoutFiles = walk(join(root, "layouts"), [".html"]);
} catch { /* no layouts dir */ }

for (const file of layoutFiles) {
  const lines = readFileSync(file, "utf8").split("\n");
  lines.forEach((line, i) => {
    if (!bannedRe.test(line)) return;
    for (const [ch, msg] of Object.entries(banned)) {
      if (line.includes(ch)) {
        problems++;
        console.error(`Non-ASCII punctuation in ${relative(root, file)}:${i + 1} -- ${msg}`);
      }
    }
  });
}

if (problems) {
  console.error(`\ncheck-build: ${problems} problem(s) found.`);
  process.exit(1);
}
console.log("check-build: OK (inline JS syntax + ASCII punctuation).");
