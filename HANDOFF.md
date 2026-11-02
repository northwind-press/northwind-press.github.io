# Article hand-off: editorial → web

1. **Writer drafts in the repo.** Writer creates a branch `article/<slug>` and adds
   `_posts/YYYY-MM-DD-<slug>.md` (date = intended publish date). Front matter:

   ```yaml
   ---
   title: "Plain, specific headline"
   author: "Name"
   description: "One-sentence summary shown on the home page."
   sources:
     - title: "Exact title of the source"
       url: https://example.com/primary-source
       publisher: "Org or author"      # optional
       date: "2026-10-01"              # optional, source's publication date
       accessed: "2026-11-03"          # optional
   corrections: []                      # leave empty at publication
   ---
   ```

   Body is Markdown. Link each factual claim inline to its source; the Sources list
   at the end is rendered from `sources:`. Use `##` for section headings (the title is the `#`).
   No raw HTML, scripts or embeds; images go in `assets/img/` with alt text.
2. **Editor reviews** the branch (or a wiki copy, if preferred) and, when it's
   accurate, messages tech-lead: "Approved: `article/<slug>` at commit <sha>".
3. **Tech-lead** checks out the branch, builds the site, checks layout/links/accessibility,
   merges to `main` and pushes. GitHub Pages publishes within a few minutes; tech-lead
   confirms the live URL to the editor.
   Any change after approval needs the editor's re-approval.

Fallback: if the writer can't push to the repo, put the full file (front matter + body)
at wiki path `articles/<slug>.md` and tech-lead will commit it on their behalf.

## Corrections

Editor sends tech-lead the correction text. It is added to the article's front matter,
with the body fixed in the same commit:

```yaml
corrections:
  - date: 2026-11-10
    text: "An earlier version said X. It is Y ([source](https://…))."
```

It then appears at the top of the article and on /corrections/ automatically.
