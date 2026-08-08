// Builds docs/catalog.js by scanning the top-level views/ folders.
// Run with: node docs/build-catalog.mjs  (from the project root)
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const viewsDir = path.join(projectDir, "views");
const outFile = path.join(projectDir, "catalog.js");

if (!fs.existsSync(viewsDir)) {
  console.error("No views directory found at " + viewsDir);
  process.exit(1);
}

const entries = [];
for (const category of fs.readdirSync(viewsDir)) {
  const catDir = path.join(viewsDir, category);
  if (category.startsWith(".") || !fs.statSync(catDir).isDirectory()) continue;
  for (const slug of fs.readdirSync(catDir)) {
    const viewDir = path.join(catDir, slug);
    if (slug.startsWith(".") || !fs.statSync(viewDir).isDirectory()) continue;
    entries.push({ slug, category, path: `${category}/${slug}` });
  }
}

const js =
  "/* Generated from views/ by docs/build-catalog.mjs — do not edit manually. */\n" +
  "window.CATALOG = " + JSON.stringify(entries, null, 2) + ";\n";

fs.writeFileSync(outFile, js);
console.log(`Wrote ${entries.length} entries to ${path.relative(projectDir, outFile)}`);
