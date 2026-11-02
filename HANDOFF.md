# Article hand-off: editorial → web

Mirror of the editor's wiki `engineering/article-handoff.md` (v8, 2026-11-02). If they differ, the wiki's
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
  - `narrated_from` equals TEXT_SHA;
  - the post on **current** `main` (run `git fetch` first) is byte-identical to TEXT_SHA, ignoring any
    existing `audio:` block, so audio of an older text can't be attached to a post that has since changed.

  On a post without `audio:` the gate reports "doesn't apply" and passes.


## File format
```yaml
---
title: "Plain, specific headline"
author: "Name"
description: "One-sentence summary shown on the home page."   # required
categories: [security]             # required: exactly ONE section, see below
subsection: applied                # optional; only where the section has one (today: applied, under ai)
kind: news                         # required: news | feature | briefing | digest
date: 2026-11-03 14:05             # UTC; REQUIRED with a time for news, optional otherwise
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

## Sections and kinds (from 2026-11-02; spec for T-42)
The site is organised by desk. These fields drive the nav, the section pages, the home page, the
badges and the per-section feeds. The allowed values live in `_data/sections.yml` and `_data/kinds.yml`,
and `tools/check-citations.rb` rejects anything else.

| `categories:` | Section | Page | Desk |
|---|---|---|---|
| `[ai]` | AI | /ai/ | ai-editor |
| `[ai]` + `subsection: applied` | Applied AI (part of AI) | /ai/applied/ | ai-editor |
| `[software]` | Software & Dev | /software/ | software-editor |
| `[security]` | Security | /security/ | security-editor |
| `[infra]` | Infra & Cloud | /infra/ | infra-editor |

- **Exactly one section per post**, written as a one-item list (`categories: [infra]`). Applied AI
  posts are `categories: [ai]` with `subsection: applied`, and they appear on both /ai/ and /ai/applied/.
- **`kind:`** sets the badge and where the post sits on the home page:
  - `news`: a report of something that happened. Listed first on the home page, newest first. Needs `date:`
    **with a time** (UTC), e.g. `date: 2026-11-03 14:05`.
  - `feature`: an in-depth, explanatory piece (like the three launch articles).
  - `briefing`: a short explainer or backgrounder on a topic in the news.
  - `digest`: a round-up of several items.
  The standards editor owns these definitions; tell tech-lead if they change.
- **URLs don't change.** Posts stay at `/YYYY/MM/DD/slug/` whatever their section, because the section
  isn't part of the URL. Moving a post to another section later never breaks links.
- Each section gets a feed at `/feeds/<slug>.xml` (Applied AI: `/feeds/ai-applied.xml`). The site-wide
  feed stays at `/feed.xml`.
- **You can file now.** The current site ignores these fields until the redesign lands (by Wed 11-04
  12:00 UTC). Posts filed with them will slot into the right section automatically.
- Everything else (sources, numbered citations, corrections, audio) is unchanged and applies to news too.

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
- **What is narrated** (board instruction, 2026-11-02):
  - **Prose:** the title, then the body, word for word as approved (including "Our view"). Numbers,
    dates, quotes and values are read exactly. Nothing is added, cut or paraphrased.
  - **Inline code names:** said the way an engineer would, e.g. `output_config.format` → "output config
    dot format", `max_tokens: 0` → "max tokens zero". Don't say "underscore" or "open brace".
  - **Acronyms:** wherever an acronym should be read as letters, the TTS input spells it letter by letter:
    A-P-I, A-P-Is, J-S-O-N, S-D-K, T-T-L, U-R-L, K-V, P-H-I. Other spelling hints are allowed (e.g. "cash"
    for "cache"). They change only how words are pronounced, never which words are spoken.
  - **Tables:** one sentence saying what the table shows. It isn't read row by row, adds no claims, and
    uses figures only if the article's text states them.
  - **Code blocks and long code-like literals (e.g. JSON):** one sentence saying what they are or do.
  - **Not read:** citation markers, link URLs, the Sources list. No intro or outro unless the editor
    approves its exact wording.
- **Check before merge:** the audio producer runs speech-to-text (Whisper) on the finished MP3 and posts
  every pass raw and unedited at wiki `audio/transcripts/<slug>.md`, with each table and code description
  word for word. The editor diffs it against the text and checks each description. Any departure means
  re-recording or re-splicing the passage.
  - **Odd words are possibly real.** Treat any transcript word that differs from the script as a possible
    narration error, especially around acronyms and names. Confirm it with an isolated clip transcribed on
    its own before calling it a Whisper error. Only well-established artifacts (e.g. "Clawed" for Claude,
    "cash" for cache) may be waived without a clip.
  - If no independent check is possible, the post carries
    `audio_note: "This narration has not yet been independently checked against the text; the text is authoritative."`
- `narrator:` must say if the voice is synthetic.
- check-audio's speaking-rate estimate follows these rules: tables and code blocks count as about 15 words
  each, and inline code counts as its spoken parts. It warns only outside 100–200 words/min. That's a
  sanity check for truncation or the wrong file, not a narration check.
- **Corrections after publication:** either re-record (new file, new `narrated_from`, same review), or keep
  the old audio and add `audio_note: "Audio reflects the article before the correction of YYYY-MM-DD."`.
  The player shows the note. It works as a top-level field or inside `audio:`.
- The page shows "Listen to this article (12:34)", "Read by …", the note if any, a native player that loads
  nothing until play is pressed, a download link, and "Transcript: read the article text". Posts without
  `audio:` are unchanged.

## Tech-lead checks (`tools/`)
- `check-citations.rb` also checks sections and kinds: exactly one valid section, a subsection valid for
  it, a valid kind, a `description:`, and a time on news dates.
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
