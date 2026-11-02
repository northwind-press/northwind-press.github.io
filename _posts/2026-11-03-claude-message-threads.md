---
title: "Anthropic adds message threads to the Claude Messages API in beta"
author: "AI Reporter"
description: "Message threads let long agent loops send only new messages per turn; keep your own copy of the conversation and handle a 404 by replaying it."
date: 2026-11-03 09:00
categories: [ai]
subsection: applied
kind: news
sources:
  - title: "Claude Platform release notes"
    url: https://docs.claude.com/en/release-notes/api
    publisher: "Anthropic"
    date: "2026-11-02"
    accessed: "2026-11-02"
  - title: "Message threads"
    url: https://docs.claude.com/en/docs/build-with-claude/message-threads
    publisher: "Anthropic"
    accessed: "2026-11-02"
corrections: []
---
Anthropic launched message threads in beta on the Messages API on 2026-11-02, behind the `message-threads-2026-08-12` beta header, according to its [API release notes](https://docs.claude.com/en/release-notes/api). The API holds the conversation on the server, so each later request sends only the new messages, with smaller requests and a lower time to first token{% include cite.html n=1 %}.

## What changed

Without a thread, every turn uploads the whole conversation again, and the API validates and tokenizes all of it again, according to Anthropic's [message threads guide](https://docs.claude.com/en/docs/build-with-claude/message-threads). The guide says threads help most in long agent loops{% include cite.html n=2 %}.

The first request carries the full conversation, `system`, and `tools`, plus `"thread": {"type": "create"}`{% include cite.html n=2 %}. Each later request sends only the new messages and `"thread": {"type": "continue", "previous_message_id": "<id>"}`, using the latest response `id`{% include cite.html n=2 %}. The beta header goes on every request, and the SDKs include a thread helper that builds these requests{% include cite.html n=2 %}.

Threads are available on the Claude API, Claude Platform on AWS, Claude Models on Google Cloud (Anthropic managed), and Claude in Microsoft Foundry{% include cite.html n=1 %}. The beta covers every model{% include cite.html n=2 %}.

## What to do: rules for using it safely

- **Send `system` and `tools` on create only.** Including either on a continue request, even as `null`, returns a 400 error{% include cite.html n=2 %}.
- **Keep fixed fields identical.** Fields such as `model`, `tool_choice`, `thinking`, `output_config`, the top-level `cache_control`, and the set of beta headers must match the create request, or the API returns `thread_fingerprint_mismatch`{% include cite.html n=2 %}. To change one, start a new thread{% include cite.html n=2 %}.
- **Build the replay path first.** Threads are best-effort{% include cite.html n=2 %}: one expires 5 minutes after its last request and is deleted no more than 1 hour after its last use{% include cite.html n=1 %}. A continue request that can't be served returns a 404 with `thread_not_found`, and the fix is to resend the full conversation in a new create request{% include cite.html n=2 %}. No response says whether the turn was stored, so the guide tells you to keep your own copy of every message{% include cite.html n=2 %}.
- **Turn on caching yourself.** Threads don't cache your prompt{% include cite.html n=2 %}. Send a top-level `cache_control` on every request, or place breakpoints yourself, up to 4 per request{% include cite.html n=2 %}.
- **Don't continue after a refusal.** On `stop_reason: "refusal"`, start a new thread that leaves out or rephrases the refused turn{% include cite.html n=2 %}. Each response `id` can be continued only once{% include cite.html n=2 %}.
- **Check what's unsupported.** Message Batches, token counting, compaction on demand, most context editing, and organizations with HIPAA readiness or Inference hooks turned on can't use threads{% include cite.html n=2 %}.

## Pricing and data retention

The docs say threads don't change pricing or rate limits{% include cite.html n=2 %}. They aren't eligible for zero data retention (ZDR){% include cite.html n=2 %}. The API keeps a thread in memory, encrypted under a server-managed key, and never writes it to durable storage{% include cite.html n=2 %}.

## What's still unknown

Anthropic gives no figures for how much time to first token falls, and doesn't say when the beta will end{% include cite.html n=1 %}{% include cite.html n=2 %}. The docs offer no API to list, read, or delete a thread{% include cite.html n=2 %}.
