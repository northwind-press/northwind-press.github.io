---
title: "Anthropic removes fast mode for Claude Opus 4.8 on 2026-11-30"
author: "AI Reporter"
description: "Requests to claude-opus-4-8 with speed: \"fast\" will fail after 2026-11-30; move fast-mode traffic to Claude Opus 5.5, which thinks on every request and rejects some Opus 4.8 settings."
categories: [ai]
subsection: applied
kind: news
date: 2026-11-02 22:37
sources:
  - title: "Claude Platform release notes"
    url: https://docs.claude.com/en/release-notes/api
    publisher: "Anthropic"
    date: "2026-10-30"
    accessed: "2026-11-02"
  - title: "Fast mode"
    url: https://docs.claude.com/en/docs/build-with-claude/fast-mode
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Claude Opus 5.5 migration guide"
    url: https://docs.claude.com/en/docs/models/opus-5-5/migration-guide
    publisher: "Anthropic"
    accessed: "2026-11-02"
corrections: []
---

Anthropic [deprecated fast mode for Claude Opus 4.8](https://docs.claude.com/en/release-notes/api) on 2026-10-30 and will remove it on 2026-11-30. After that, requests to `claude-opus-4-8` with `speed: "fast"` will return an error. To keep fast mode, Anthropic says to move to Claude Opus 5.5{% include cite.html n=1 %}.

## Who is affected

[Fast mode](https://docs.claude.com/en/docs/build-with-claude/fast-mode) runs the same model with a faster inference configuration. It gives up to 2.5x higher output tokens per second at premium prices. As of 2026-11-02, fast mode on Opus 4.8 is a research preview, offered only on the Claude API, in the Messages API and Managed Agents, and it needs the `fast-mode-2026-02-01` beta header{% include cite.html n=2 %}. The notice sets no date for Opus 4.8 at standard speed{% include cite.html n=1 %}.

## Where fast mode works today

As of 2026-11-02, fast mode is generally available only on Claude Opus 5.5. It runs on the Claude API, Claude Models on Google Cloud (Anthropic managed), and Microsoft Foundry (hosted on Azure). In Managed Agents it runs on the Claude API only{% include cite.html n=2 %}. Claude Opus 5 and Opus 4.8 are research previews on the Claude API, and access to Opus 5 is through an account manager or a waitlist{% include cite.html n=2 %}. Fast mode isn't offered with the Batch API or under a Priority Tier commitment{% include cite.html n=2 %}.

Fast mode on Opus 5.5 costs US$8 per million input tokens and US$40 per million output tokens. On Opus 4.8 and Opus 5 it costs US$10 and US$50{% include cite.html n=2 %}. Opus 5.5 has a default fast mode rate limit in the Start, Build, and Scale usage tiers. Evaluation-tier organizations must move up first{% include cite.html n=2 %}.

## What to change

The [Opus 5.5 migration guide](https://docs.claude.com/en/docs/models/opus-5-5/migration-guide) says code on Opus 4.8 needs the same changes as code on Opus 5, plus a few of its own:

- Change the model ID to `claude-opus-5-5`, or use the platform's own model ID on cloud platforms{% include cite.html n=3 %}.
- Keep `speed: "fast"`. Opus 5.5 doesn't need a beta header{% include cite.html n=3 %}.
- Expect thinking on every request. On Opus 4.8, a request with no `thinking` field runs without thinking. On Opus 5.5 it thinks, `max_tokens` covers thinking plus text, and thinking tokens are billed as output{% include cite.html n=3 %}.
- Read content blocks by `type`, not by position, because responses can start with `thinking` blocks{% include cite.html n=3 %}.
- Remove settings that Opus 5.5 rejects with a 400 error: `thinking: {"type": "disabled"}`, forced tool choice (`any` or `tool`), a prefilled assistant turn, and, on the Claude API, the `computer_20251124` tool. Also omit `temperature`, `top_p`, and `top_k`{% include cite.html n=3 %}.
- Set `effort` explicitly. The default is `medium`, while Opus 4.8 defaults to `high`{% include cite.html n=3 %}.
- Plan Priority Tier capacity separately, because Opus 5.5 doesn't support Priority Tier{% include cite.html n=3 %}.

The guide says Managed Agents users need to change only the model name{% include cite.html n=3 %}. Falling back from fast to standard speed causes a prompt cache miss{% include cite.html n=2 %}.

## What we don't know

Anthropic's documentation doesn't say which HTTP status or error message Opus 4.8 fast-mode requests will get after 2026-11-30{% include cite.html n=1 %}{% include cite.html n=2 %}. It also gives no timeline for the Opus 5 research preview{% include cite.html n=2 %}.
