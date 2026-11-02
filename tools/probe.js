// In-page checks for a locally rendered post. Results go into <pre id="probe"> (read with --dump-dom).
// With ?focus=1 the first citation is focused (for a focus-ring screenshot); ?jump=N scrolls to #source-N.
(function () {
  const out = [];
  const q = new URLSearchParams(location.search);
  const cites = [...document.querySelectorAll(".cite a")];
  out.push(`viewport ${innerWidth}x${innerHeight}; page scrollWidth ${document.documentElement.scrollWidth} (horizontal overflow: ${document.documentElement.scrollWidth > innerWidth})`);
  out.push(`citations: ${cites.length}`);
  let broken = 0, minW = 1e9, minH = 1e9, glyphH = 0;
  cites.forEach(a => {
    const id = a.getAttribute("href").slice(1);
    if (!document.getElementById(id)) broken++;
    const after = getComputedStyle(a, "::after");
    const r = a.getBoundingClientRect();
    minW = Math.min(minW, Math.max(r.width, parseFloat(after.width) || 0));
    minH = Math.min(minH, Math.max(r.height, parseFloat(after.height) || 0));
    glyphH = Math.max(glyphH, parseFloat(getComputedStyle(a).fontSize));
  });
  out.push(`citation links with missing target: ${broken}`);
  out.push(`citation glyph font-size: ${glyphH}px; smallest hit area: ${minW.toFixed(1)}x${minH.toFixed(1)}px`);
  const labels = cites.slice(0, 3).map(a => a.getAttribute("aria-label")).join(" | ");
  out.push(`first aria-labels: ${labels}`);
  const backs = [...document.querySelectorAll(".cite-back")];
  out.push(`back links: ${backs.length}; missing targets: ${backs.filter(b => !document.getElementById(b.getAttribute("href").slice(1))).length}`);
  const ids = [...document.querySelectorAll("[id]")].map(e => e.id);
  out.push(`duplicate ids: ${ids.length - new Set(ids).size}`);
  const p = document.querySelector(".post-body p");
  if (p) {
    const lh = getComputedStyle(p).lineHeight;
    const withCite = [...document.querySelectorAll(".post-body p")].find(x => x.querySelector(".cite"));
    const lines = el => { const r = document.createRange(); r.selectNodeContents(el); return [...r.getClientRects()].map(c => Math.round(c.top)); };
    if (withCite) {
      const tops = [...new Set(lines(withCite))].sort((a, b) => a - b);
      const gaps = tops.slice(1).map((t, i) => t - tops[i]).filter(g => g > 2);
      out.push(`paragraph line-height ${lh}; line gaps in a cited paragraph: ${[...new Set(gaps)].join(",")}px`);
    }
  }
  const linkCount = document.querySelectorAll(".post-body a").length;
  out.push(`focusable links in body: ${linkCount}`);
  if (q.get("focus") && cites[0]) { cites[0].scrollIntoView({ block: "center" }); cites[0].focus(); out.push(`focused first citation; :focus-visible=${cites[0].matches(":focus-visible")}; outline=${getComputedStyle(cites[0]).outlineStyle} ${getComputedStyle(cites[0]).outlineWidth}`); }
  if (q.get("jump")) { location.hash = "source-" + q.get("jump"); out.push(`jumped to #source-${q.get("jump")}`); }
  const pre = document.createElement("pre"); pre.id = "probe"; pre.textContent = out.join("\n");
  pre.style.cssText = "position:absolute;left:-9999px"; document.body.appendChild(pre);
})();
