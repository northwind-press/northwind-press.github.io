# Article hand-off: editorial → web

Mirror of the editor's wiki `engineering/article-handoff.md` (v17, 2026-11-02). If they differ, the wiki's
editorial rules win; tell tech-lead so this file can be updated. Editorial standards: wiki standards/style.md.

## Steps
1. **Reporter or writer** creates branch `article/<slug>` and adds `_posts/YYYY-MM-DD-<slug>.md`
   (the filed date is provisional: production-editor resets `date:` and the filename to the actual UTC merge
   time, see "Publication date"). If they can't push, they put the whole file at wiki path
   `articles/<slug>.md` and production-editor commits it.
2. **Desk edit.** The approving editor reviews sourcing and fairness. For **news, briefings and digests**
   that's the **desk editor** (ai-, software-, security- or infra-editor). For **features**, it's the
   features editor, then the editor in chief.
3. **Copy check.** standards-editor (or a copy editor) checks the piece against standards/style.md and this
   file. They commit style and front-matter fixes on the branch themselves, and send anything that changes
   meaning back to the desk.
4. **Text approval.** The approving editor messages: "Text approved: article/<slug> at commit <post-copy sha>,
   copy OK". From here the text is frozen. Any text change needs a new copy check and re-approval.
5. **Publishing** (production-editor; tech-lead only for code and design branches, or when a build breaks): run `tools/build.sh` (must end `BUILD OK`; see "Pre-publish build") and `tools/check-citations.rb`, check layout, links and
   accessibility, rebase on the latest `main`, merge (merging publishes), and send the approving editor the
   live URL. **Audio is not required to publish.** A post with no `audio:` field merges on the text approval
   alone.

### Publication date (board instruction, 2026-11-02; handoff v12)
- **News is dated at publication and never scheduled.** At merge, production-editor sets `date:` to the actual
  merge time (UTC, hours and minutes) and renames the file to the same day. That front-matter-only change
  needs no re-approval.
- **No future dates**, and no merging early to go live later. An embargoed story is merged after the embargo
  lifts. The same rule applies to briefings, features and digests.
- Why the check matters: `_config.yml` has `future: true`, so Jekyll publishes a future-dated post
  immediately, with a false date. `tools/check-citations.rb` therefore FAILS a post whose `date:` is more than
  10 minutes ahead of now, whose filename date is in the future, or whose filename date doesn't match
  `date:`. Run it at merge time.

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
title: "Plain, specific headline"          # ≤ 90 characters, sentence case
author: "Northwind Security Desk"   # desk byline, set by the rule in "Bylines" below
description: "One-sentence summary shown on the home page."   # required, ≤ 200 characters
categories: [security]             # required: exactly ONE section, see below
kind: news                         # required: news | feature | briefing | digest
placement: lead                    # optional: lead | top. Promotes the story on the front page (see below)
date: 2026-11-03 14:05             # UTC publication time, set by production-editor at merge; required with a time for news
sources:
  - title: "Exact title of the source"
    url: https://example.com/primary-source
    publisher: "Org or author"   # optional
    date: "2026-10-01"           # optional, source's publication date
    accessed: "2026-11-03"       # required (style.md §3): when you checked the source
corrections: []                  # empty at publication
updates: []                      # optional; dated notes after publication, see "Updates" (never a body line)
---
```
Body in Markdown. Use `##` for section headings (the title is the `#`). No raw HTML, scripts or
embeds. Images go in `assets/img/`, always with alt text. The Sources list at the end is generated
from `sources:`; don't write one in the body.

## Bylines (board, 2026-11-02 23:43; handoff v16)
`author:` is a desk byline, never a person:
| Post | `author:` |
|---|---|
| `kind: news`, `categories: [ai]` | Northwind AI Desk |
| `kind: news`, `categories: [software]` | Northwind Software & Dev Desk |
| `kind: news`, `categories: [security]` | Northwind Security Desk |
| `kind: news`, `categories: [infra]` | Northwind Infra & Cloud Desk |
| `kind: feature` | Northwind Features |
| `kind: briefing` or `digest` | Northwind Press |
The values live in `_data/sections.yml` (`byline:`) and `_data/kinds.yml` (`byline:`). `check-citations.rb`
WARNS when `author:` doesn't match. The byline isn't narrated. Changing it, or any front matter
(`author`, `updates`, `corrections`, `date`, `placement`, `categories`, `kind`, `description`, `sources`),
never invalidates audio: only the title and body are narrated.

## Sections and kinds (from 2026-11-02; spec for T-42)
The site is organized by desk. These fields drive the nav, the section pages, the home page, the
badges and the per-section feeds. The allowed values live in `_data/sections.yml` and `_data/kinds.yml`,
and `tools/check-citations.rb` rejects anything else.

| `categories:` | Section | Page | Desk |
|---|---|---|---|
| `[ai]` | AI | /ai/ | ai-editor |
| `[software]` | Software & Dev | /software/ | software-editor |
| `[security]` | Security | /security/ | security-editor |
| `[infra]` | Infra & Cloud | /infra/ | infra-editor |

- **Exactly one section per post**, written as a one-item list (`categories: [infra]`).
  **No subsections** (retired 2026-11-02, board): don't set `subsection:`. Former Applied AI stories are
  plain AI stories; /ai/applied/ redirects to /ai/. The checker only warns on an old `subsection:` line.
- **`kind:`** (`news`, `briefing`, `feature` or `digest`) sets the badge and where the post sits on the home
  page. `news` is listed first, newest first, and needs `date:` **with a time** (UTC), e.g.
  `date: 2026-11-03 14:05`. The definitions of each kind are in **standards/style.md §1** (standards-editor
  owns them).
- **`placement:`** (optional) lets editors steer the front page. Leave it out and the newest stories fill
  the slots automatically. **Who sets it** (handoff v13): the editor in chief picks the lead at the morning
  meeting; desks propose top stories; production-editor sets the field at merge, or later in a
  placement-only commit, with no re-approval. `placement:` and `date:` changes never trip check-audio.
  - `lead`: the newest `lead` story is the home page's lead, and its section page's lead. Use it for the
    day's most important story; a newer `lead` replaces an older one automatically.
  - With no `lead` set, the lead is the newest story **not** marked `top` (desks propose top stories; only the
    editor in chief picks a lead). If every story is marked `top`, it's simply the newest.
  - `top`: a candidate for the 3–4 top stories beside the lead. Any empty slots fill with the newest
    other stories.
  - Every story also appears in the Latest river and its section block, whatever its placement.
- **URLs don't change.** Posts stay at `/YYYY/MM/DD/slug/` whatever their section, because the section
  isn't part of the URL. Moving a post to another section later never breaks links.
- Each section gets a feed at `/feeds/<slug>.xml` (`/feeds/ai-applied.xml` is kept as an alias of the AI feed). The site-wide
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
  - **Not read:** the byline, update and correction notes, citation markers, link URLs, the Sources list. No intro or outro unless the editor
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

## Pre-publish build (board, 2026-11-02)
Every merge to `main`, editorial or code, is built locally first, exactly as GitHub Pages will build it.
- **Once per workspace** (and again whenever `Gemfile.lock` changes): `tools/build.sh --install`. Gems install
  into `vendor/bundle` (gitignored, excluded from the site), with bundler's state in `.bundle-home`.
- **Before every merge**, on the rebased branch: `tools/build.sh`. It runs
  `bundle exec jekyll build --strict_front_matter` into `.render/_site`, then `tools/check-all-posts.rb`, then
  checks the key pages and feeds exist and no unrendered Liquid leaked through.
  **Don't merge unless it ends with `BUILD OK`.** If it fails and the cause isn't the post's own content,
  hand it to tech-lead.
- Versions: the `Gemfile` targets the system Ruby 2.6, and the committed `Gemfile.lock` pins the exact
  github-pages release. Only tech-lead changes them.
- After the push, production-editor checks the live URL themselves; they now have web access.

## Tech-lead checks (`tools/`)
- Links to our own pages (a path like `/2026/11/02/prompt-caching/` or `/ai/`) are cross-references, not
  sources. They don't go in `sources:`, and the checker allows them if they resolve to a post or page on the
  site (it fails if they don't).
- `check-citations.rb` FAILS on a missing or empty `author:`, and WARNS when a news source's `accessed:`
  is more than 7 days before the publication date (style.md §11 target).
- `check-citations.rb` also checks sections and kinds: exactly one valid section, a (retired) subsection warning for
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
- `check-audio.rb --live _posts/FILE.md` answers "is this live post's audio still valid?" after any change to
  a post with audio. It compares only what's narrated (title + body) on main with its `narrated_from`. Use
  it, not the merge gate, after front-matter cleanups or corrections.
- `check-audio.rb TEXT_SHA AUDIO_SHA PATH --branch REF` is the audio merge gate ("Adding audio" C). It passes, as not applicable, on posts without `audio:`.

## Updates (style.md §5)
A dated note for a post-publication change that isn't a correction. It shows at the top of the article, newest
first, in a neutral box labeled "Update". It isn't listed on /corrections/.
- **Only in `updates:`.** Never write an update note as a line in the body.
- **When one is needed:** a briefing is updated with new information; or the sources change (a source is
  added, removed or replaced, or a claim now cites a different source).
- **Not needed:** citation formatting, link-span fixes or typos.
- **Not an update:** a factual error. That's a correction (see Corrections).
```yaml
updates:
  - date: 2026-11-02
    text: "We replaced one source link with the researchers' main write-up; the facts reported are unchanged."
```
`text` takes Markdown. check-citations requires a YYYY-MM-DD date that isn't in the future and non-empty text.
An `updates:` note never invalidates audio and never fails check-link-revision.

## Corrections
Owner: standards-editor.
1. Standards verifies the report against the sources and prepares branch `fix/<slug>`. The body fix and
   the front-matter entry go in the same commit:
```yaml
corrections:
  - date: 2026-11-10
    text: "An earlier version said X. It is Y ([source](https://…))."
```
2. The desk editor is consulted, and the **editor in chief approves the correction wording**.
3. Production-editor merges it. The entry shows at the top of the article and on
   /corrections/ automatically; /corrections/ is never hand-edited. If the post has audio, see Audio → Corrections.
