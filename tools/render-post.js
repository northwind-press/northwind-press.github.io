// Approximate local render of a post, for checking in a browser when Jekyll isn't available.
// NOT Jekyll: Markdown via `marked` (GFM) instead of kramdown; the layouts' Liquid is re-implemented below.
// Usage: node tools/render-post.js POST.md OUT_DIR [--to-citations]
//   --to-citations: test fixture only; replaces each [text](url) with text + {% include cite.html n=K %}
//                   where K is the url's position in front-matter sources.
// Writes OUT_DIR/light.html, OUT_DIR/dark.html (dark media query forced on), OUT_DIR/style*.css
const fs = require("fs"), path = require("path"), { execFileSync } = require("child_process");
const MARKED = process.env.MARKED || "/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/node_modules/marked";
const { marked } = require(MARKED);

const [postPath, outDir, flag] = process.argv.slice(2);
const src = fs.readFileSync(postPath, "utf8");
const m = src.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
const fm = JSON.parse(execFileSync("ruby", ["-ryaml", "-rjson", "-rdate", "-e",
  "puts JSON.generate(YAML.safe_load(STDIN.read, [Date, Time]))"], { input: m[1] }).toString());
let body = m[2];
const sources = fm.sources || [];

if (flag === "--to-citations") {
  body = body.replace(/\[((?:[^\[\]]|\[[^\]]*\])*)\]\(([^)\s]+)\)/g, (all, text, url) => {
    const k = sources.findIndex(s => s.url === url) + 1;
    return k ? `${text}{% include cite.html n=${k} %}` : all;
  });
}

// Re-implementation of _includes/cite.html (keep in sync).
const seen = new Set();
body = body.replace(/\{%-?\s*include\s+cite\.html\s+n=(\d+)\s*-?%\}/g, (_, n) => {
  n = Number(n); const first = !seen.has(n); seen.add(n);
  return `<sup class="cite"><a href="#source-${n}"${first ? ` id="cite-${n}"` : ""} aria-label="Source ${n}">${n}</a></sup>`;
});
if (/\{%|\{\{/.test(body)) console.error("WARNING: unrendered Liquid left in body");

let html = marked.parse(body, { gfm: true });
html = html.replace(/<table>/g, '<div class="table-wrap" role="region" aria-label="Table" tabindex="0"><table>')
           .replace(/<\/table>/g, "</table></div>");
const esc = s => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/"/g, "&quot;");
const fmtDate = d => { const t = new Date(d + "T00:00:00Z"); return isNaN(t) ? d : t.toLocaleDateString("en-GB", { day: "numeric", month: "long", year: "numeric", timeZone: "UTC" }); };
const date = path.basename(postPath).slice(0, 10);
const srcItems = sources.map((s, i) => {
  const n = i + 1;
  const back = html.includes(`id="cite-${n}"`) ? ` <a class="cite-back" href="#cite-${n}" aria-label="Back to where source ${n} is first cited">↩</a>` : "";
  return `<li id="source-${n}"><a href="${esc(s.url)}">${esc(s.title)}</a>${s.publisher ? ", " + esc(s.publisher) : ""}${s.date ? ` (<span class="nowrap">${fmtDate(s.date)}</span>)` : ""}.${s.accessed ? ` Accessed <span class="nowrap">${fmtDate(s.accessed)}</span>.` : ""}${back}</li>`;
}).join("\n");

const page = css => `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="${css}"><title>${esc(fm.title)}</title></head><body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header"><div class="wrap"><a class="site-title" href="#">Northwind <span class="press">Press</span></a>
<nav aria-label="Main"><ul><li><a href="#">Articles</a></li><li><a href="#">About</a></li><li><a href="#">Corrections</a></li></ul></nav></div></header>
<main id="main" class="wrap" tabindex="-1"><article class="post"><header class="post-header"><h1>${esc(fm.title)}</h1>
${fm.description ? `<p class="dek">${esc(fm.description)}</p>` : ""}
<p class="meta">By <span class="byline">${esc(fm.author || "Northwind Press")}</span> · <span class="nowrap"><time>${fmtDate(date)}</time></span> · <span class="nowrap">${sources.length} sources</span></p></header>
<div class="post-body">${html}</div>
<section class="sources" aria-labelledby="sources-heading"><h2 id="sources-heading">Sources</h2><ol>${srcItems}</ol></section>
<p class="report">Spotted an error? See our <a href="#">corrections policy</a>.</p></article></main>
<footer class="site-footer"><div class="wrap"><p>Northwind Press</p></div></footer>
<script src="probe.js"></script></body></html>`;

fs.mkdirSync(outDir, { recursive: true });
const css = fs.readFileSync(path.join(__dirname, "..", "assets/css/style.css"), "utf8");
fs.writeFileSync(path.join(outDir, "style.css"), css);
fs.writeFileSync(path.join(outDir, "style-dark.css"), css.replace(/@media \(prefers-color-scheme: dark\)/g, "@media all"));
fs.copyFileSync(path.join(__dirname, "probe.js"), path.join(outDir, "probe.js"));
fs.writeFileSync(path.join(outDir, "light.html"), page("style.css"));
fs.writeFileSync(path.join(outDir, "dark.html"), page("style-dark.css"));
console.log(`rendered ${sources.length} sources, ${seen.size} cited, ${(html.match(/class="cite"/g) || []).length} citation markers -> ${outDir}`);
