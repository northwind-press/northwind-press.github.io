# Article hand-off: editorial → web

Mirror of the editor's wiki `engineering/article-handoff.md` (v5, 2026-11-02). If they differ, the wiki's
editorial rules win; tell tech-lead so this file can be updated.

## Steps
1. **Writer** creates branch `article/<slug>` and adds `_posts/YYYY-MM-DD-<slug>.md`
   (date = intended publish date). If the writer can't push, put the whole file at wiki path
   `articles/<slug>.md` and tech-lead commits it.
2. **Editor** reviews and messages tech-lead: "Text approved: article/<slug> at commit <sha>".
   From here the text is frozen. Any text change needs re-approval.
3. **Tech-lead** runs `tools/check-citations.rb`, checks layout, links and accessibility, merges to `main`
   (merging publishes) and sends the editor the live URL. **Audio is not required to publish.** A post with
   no `audio:` field merges on the text approval alone.

### Adding audio (optional; before or after publication)
Audio is gated **only for posts that have an `audio:` field**. It can be added on the article branch before
merge, or later on a branch `audio/<slug>` cut from `main` once the post is live.
- A. The **audio producer** narrates exactly the text-approved version (for a live post, the version on `main`).
  They add the MP3 and the `audio:` block in **one commit** that touches nothing else, and tell the editor its sha.
- B. The **editor (or a delegate)** spot-checks the narration and messages tech-lead:
  "Audio approved: <branch> at commit <sha>".
- C. **Tech-lead** merges only if this passes:
  `tools/check-audio.rb TEXT_SHA AUDIO_SHA _posts/… --branch origin/<branch>`
  TEXT_SHA is the text-approved sha, or for a live post the last approved commit of that post on `main`.
  The gate requires:
  - the tip is the audio-approved sha;
  - it's a single commit sitting either directly on TEXT_SHA, or on a `main` commit where the post is
    byte-identical to TEXT_SHA;
  - it changes only `assets/audio/<file>` and the `audio:` block;
  - `narrated_from` equals TEXT_SHA.

  On a post without `audio:` the gate reports "doesn't apply" and passes.

No audio producer is on the roster yet (CEO/board confirming). Until then, all posts publish text-only.

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

## Audio
Added in step 3 only, as a block with all four fields (no shorthand):
```yaml
audio:
  src: /assets/audio/2026-11-03-slug.mp3   # same name as the post; or a full https:// URL
  duration: "12:34"                        # required, QUOTED "m:ss" or "h:mm:ss"
  narrator: "Name"                         # required
  narrated_from: <text-approved sha>       # required; not shown to readers
```
- **File:** `assets/audio/YYYY-MM-DD-slug.mp3`, the same name as the post. MP3, mono, 64–96 kbps: a
  15-minute read is about 7–10 MB. GitHub rejects files over 100 MB, and the gate warns above 25 MB.
  For long or frequent episodes, host externally and put a full `https://` URL in `src`.
- **Quote the duration.** Unquoted, YAML reads `12:34` as 12 hours 34 minutes. Both checkers reject it.
- **What is narrated:** the title, then the body, word for word as approved (including "Our view").
  Citation markers and the Sources list are not read. Nothing is added, cut or paraphrased. A spoken
  intro or outro needs the editor's approval of its exact wording.
- **Spot-check before merge** (editor or delegate): opening, closing, every number and quote, and a sample
  in between. Diff a speech-to-text transcript against the text if one is available. Any departure means
  the audio is re-recorded.
- **Corrections after publication:** either re-record (new file, new `narrated_from`, same review), or keep
  the old audio and add `audio_note: "Audio reflects the article before the correction of YYYY-MM-DD."`.
  The player shows the note. It works as a top-level field or inside `audio:`.
- The page shows "Listen to this article (12:34)", "Read by …", the note if any, a native player that loads
  nothing until play is pressed, a download link, and "Transcript: read the article text". Posts without
  `audio:` are unchanged.

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
- `check-audio.rb TEXT_SHA AUDIO_SHA PATH --branch REF` is the audio merge gate ("Adding audio" C). It passes, as not applicable, on posts without `audio:`.

## Corrections
Editor sends tech-lead the correction text. It is added to front matter and the body is fixed in
the same commit:
```yaml
corrections:
  - date: 2026-11-10
    text: "An earlier version said X. It is Y ([source](https://…))."
```
It shows at the top of the article and on /corrections/ automatically.
