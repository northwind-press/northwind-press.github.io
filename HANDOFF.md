# Article hand-off: editorial → web

Mirror of the editor's wiki `engineering/article-handoff.md` (v3, 2026-11-02). If they differ, the wiki's
editorial rules win; tell tech-lead so this file can be updated.

## Steps
1. **Writer** creates branch `article/<slug>` and adds `_posts/YYYY-MM-DD-<slug>.md`
   (date = intended publish date). If the writer can't push, put the whole file at wiki path
   `articles/<slug>.md` and tech-lead commits it.
2. **Editor** reviews and messages tech-lead: "Approved: article/<slug> at commit <sha>".
   Any change after approval needs re-approval.
3. **Tech-lead** checks the branch (including `tools/check-citations.rb`), merges to `main`
   (merging publishes) and sends the editor the live URL.

## File format
```yaml
---
title: "Plain, specific headline"
author: "Name"
description: "One-sentence summary shown on the home page."
date: 2026-11-03 14:05             # optional, UTC; orders same-day posts newest-first
sources:
  - title: "Exact title of the source"
    url: https://example.com/primary-source
    publisher: "Org or author"   # optional
    date: "2026-10-01"           # optional, source's publication date
    accessed: "2026-11-03"       # optional
corrections: []                  # empty at publication
---
```
Body in Markdown. Use `##` for section headings (the title is the `#`). No raw HTML, scripts or
embeds. Images go in `assets/img/`, always with alt text. The Sources list at the end is generated
from `sources:`; don't write one in the body.

## Citations (house style from 2026-11-02, board instruction)
- **Every factual claim is cited.**
- **Link each source once in the text**: a normal Markdown link on a few words, where the article
  first relies on that source. Example: `Anthropic's [prompt caching guide](https://…) says …`
- **Cite every other claim with a numbered marker**: `{% include cite.html n=1 %}`.
  `n` is the source's position in `sources:` (first entry = 1). Never reorder `sources:` once markers exist.
- **Marker placement:**
  1. Never inside a quotation. The marker goes after the closing quote mark.
  2. By default, use one marker at the end of the sentence, before the full stop (or after the
     closing quote if the sentence ends in one): `Batches cost 50% less{% include cite.html n=1 %}.`
  3. Mid-sentence only when one sentence draws on different sources. Then each marker goes at
     the end of its clause. Two sources backing the same clause sit side by side:
     `{% include cite.html n=1 %}{% include cite.html n=3 %}`
  4. At most one marker per source per sentence.
- The claim carrying the first-use link needs no marker. It may also carry one, if that is the
  source's only claim.
- **Every source in `sources:` is used**: exactly one inline link, and cited at least once.
- Rendering: the include shows a small superscript number linking to `#source-n`
  (aria-label "Source n"). The Sources entry gets a "↩" link back to the first marker.

## Tech-lead checks (`tools/`)
- `check-citations.rb REV PATH` checks a post against the rules above. It flags:
  - markers whose `n` doesn't exist;
  - sources with zero or more than one inline link, or never cited;
  - inline links to URLs not in `sources:`;
  - markers inside quotation marks;
  - more than one marker for the same source in a sentence.
- `check-citations.rb REV PATH --against OLD_REV` also confirms the visible text is unchanged
  apart from removed link markup and added markers.
- `check-link-revision.rb OLD NEW PATH` is for link-only revisions.

## Corrections
Editor sends tech-lead the correction text. It is added to front matter and the body is fixed in
the same commit:
```yaml
corrections:
  - date: 2026-11-10
    text: "An earlier version said X. It is Y ([source](https://…))."
```
It shows at the top of the article and on /corrections/ automatically.
