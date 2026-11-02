---
title: "Prompt caching on Anthropic and OpenAI: how it works, what it costs, why hits miss"
author: "Staff Writer"
description: "How prompt caching is turned on, priced and invalidated on the Claude and OpenAI APIs, and the common reasons an expected cache hit turns into a miss."
sources:
  - title: "Prompt caching"
    url: https://docs.claude.com/en/docs/build-with-claude/prompt-caching
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Prompt caching"
    url: https://platform.openai.com/docs/guides/prompt-caching
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "Pricing"
    url: https://platform.openai.com/docs/pricing
    publisher: "OpenAI"
    accessed: "2026-11-02"
corrections: []
---
Prompt caching lets a provider reuse its work on a prompt prefix you send repeatedly, such as a system prompt, tool definitions or a document, and bill it at a lower rate. This piece covers the Claude API and the OpenAI API. The two differ on defaults, write costs, lifetimes and what quietly breaks a hit. Everything below comes from each provider's documentation as checked on 2026-11-02.

## The rule that applies everywhere

Both providers match on the prefix. Anthropic says hits "require [100 percent identical](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) prompt segments". OpenAI says "cache reuse requires the [entire rendered prefix to match](https://platform.openai.com/docs/guides/prompt-caching)". In our view, the practical rule is the same on both: stable content first, variable content last.

## Anthropic: opt-in, with breakpoints

Caching on the Claude API is opt-in, and there are two ways to turn it on. You can put a single `cache_control` field at the top level of the request, and the system "automatically applies the cache breakpoint to the last cacheable block and moves it forward as conversations grow"{% include cite.html n=1 %}. Or you can put `cache_control` on individual content blocks, up to 4 breakpoints in total, with the automatic breakpoint taking one of them{% include cite.html n=1 %}.

Prompts shorter than the model's minimum are "processed without caching, and no error is returned"{% include cite.html n=1 %}. The minimum is 512 tokens on newer models including Opus 5.5, Sonnet 5.5, Haiku 5.5 and Fable 5.1, and as high as 4,096 tokens on some older ones such as Opus 4.6 and Haiku 4.5{% include cite.html n=1 %}.

Entries last 5 minutes by default and are refreshed at no cost each time they are used{% include cite.html n=1 %}. You can opt into a 1-hour TTL with `ttl`{% include cite.html n=1 %}. The lifetime is counted from the start of the request, so generation time uses part of it{% include cite.html n=1 %}. The docs give an example: "if a response takes 4 minutes to stream, a follow-up request that reuses the same cached prefix must start within about 1 minute of that response completing."{% include cite.html n=1 %} If you mix TTLs, 1-hour entries must come before 5-minute ones{% include cite.html n=1 %}.

A 5-minute write costs 1.25x the base input price and a 1-hour write costs 2x{% include cite.html n=1 %}. A read costs 10% of base input, except 0.05x on Opus 5.5 and Sonnet 5.5 and 0.025x on Fable 5.1 and Mythos 5.1{% include cite.html n=1 %}. Prices per million tokens as of 2026-11-02{% include cite.html n=1 %}:

| Model | Input | 5m write | 1h write | Hit |
|---|---|---|---|---|
| Opus 5.5 | $4 | $5 | $8 | $0.20 |
| Sonnet 5.5 | $2 | $2.50 | $4 | $0.10 |
| Haiku 5.5 (≤100,000-token prompts) | $0.10 | $0.125 | $0.20 | $0.01 |
| Fable 5.1 | $10 | $12.50 | $20 | $0.25 |

Haiku 5.5 prompts over 100,000 tokens are billed at higher rates{% include cite.html n=1 %}. You can pre-warm the cache with a `max_tokens: 0` request, and cache hits "are not deducted against your rate limit"{% include cite.html n=1 %}.

## OpenAI: on by default, with new controls from GPT-5.6

"Prompt caching is enabled by default for supported OpenAI models."{% include cite.html n=2 %} How it behaves depends on the model generation.

**GPT-5.6 and later.** `prompt_cache_options.mode` chooses between two modes{% include cite.html n=2 %}. In `implicit` mode, OpenAI places a breakpoint "at the end of the latest eligible message"{% include cite.html n=2 %}. In `explicit` mode, only the breakpoints you mark are used, and if you mark none, "the request does not use prompt caching or create cache writes"{% include cite.html n=2 %}. A request can create up to four cache writes, and top-level `instructions` can't hold a breakpoint{% include cite.html n=2 %}. The minimum is 1,024 tokens{% include cite.html n=2 %}. The TTL is `"30m"` by default, or `"12h"` on the Responses API only{% include cite.html n=2 %}. Both are *minimum* lifetimes, and "OpenAI may retain entries longer"{% include cite.html n=2 %}. You can pre-warm with `prompt_cache_options.prewarm: true`, which is billed at the cache-write rate{% include cite.html n=2 %}.

**Earlier models.** These models cache implicitly only, with breakpoints at model-dependent intervals (every 2,048 tokens on GPT-5.5){% include cite.html n=2 %}. Their minimum "varies by request settings", and no fixed number is given{% include cite.html n=2 %}. Retention is set with `prompt_cache_retention`{% include cite.html n=2 %}. `in_memory` means "around 5 to 10 minutes of inactivity, up to one hour"{% include cite.html n=2 %}. `24h` "typically keeps entries available for around 30 minutes and can retain them for up to 24 hours"{% include cite.html n=2 %}. The default depends on whether your org has Zero Data Retention{% include cite.html n=2 %}. These are typical and maximum lifetimes, not the guaranteed minimums of GPT-5.6+, so the two sets of figures can't be compared directly.

On GPT-5.6+, a write costs 1.25x the uncached input rate (30m) or 2.5x (12h){% include cite.html n=2 %}. These are "total write rates, not surcharges"{% include cite.html n=2 %}. A read costs 0.1x on most models and 0.05x on GPT-6.1 Sol and GPT-6.1 Terra{% include cite.html n=2 %}. Earlier models have "No additional cache-write charge"{% include cite.html n=2 %}. [Standard-tier prices](https://platform.openai.com/docs/pricing) per million tokens as of 2026-11-02{% include cite.html n=3 %}:

| Model | Input | Cached input | 30m write | 12h write |
|---|---|---|---|---|
| gpt-6-astra | $10.00 | $1.00 | $12.50 | $25.00 |
| gpt-6.1-sol | $2.00 | $0.10 | $2.50 | $5.00 |
| gpt-6.1-terra | $1.00 | $0.05 | $1.25 | $2.50 |
| gpt-6-luna | $0.10 | $0.01 | $0.125 | $0.25 |

## What it saves

On cost, the models in the tables above charge a tenth of the input price or less for a cached read. OpenAI's pre-5.6 models have a "model-dependent cached-input rate"{% include cite.html n=2 %}. The providers differ on writes. Anthropic and OpenAI GPT-5.6+ charge more than the uncached input price for a write{% include cite.html n=1 %}, and OpenAI's earlier models charge nothing extra{% include cite.html n=2 %}.

OpenAI's guide works through the numbers for a GPT-5.6+ model with a 0.1x read rate and 30m writes. Writing a prefix once and reusing it once "costs 1.35× its ordinary input cost, compared with 2× for processing it twice without caching"{% include cite.html n=2 %}. Over ten requests, "one write and nine full reads cost 2.15× at that rate, compared with 10× without caching."{% include cite.html n=2 %}

On latency, neither source gives a number, so neither do we. Anthropic says caching "significantly reduces processing time"{% include cite.html n=1 %}. OpenAI says it can "Reduce the time spent processing input before the response starts", but warns that the minimum lifetime "does not guarantee that every request reuses stored KV tensors or has lower latency"{% include cite.html n=2 %}.

## Why cache hits miss

- **The prompt is under the minimum.** On Anthropic this fails silently{% include cite.html n=1 %}.
- **Something early in the prompt changed.** On Anthropic the order is `tools` → `system` → `messages`, and a change at any level invalidates that level and every level after it{% include cite.html n=1 %}. Changing tool definitions invalidates everything{% include cite.html n=1 %}. Toggling web search or citations, or the `speed` setting, invalidates the system and messages caches{% include cite.html n=1 %}. Changing `tool_choice`, adding or removing images, or changing thinking parameters or `output_config.effort` invalidates the messages cache{% include cite.html n=1 %}. On OpenAI the prefix can be changed by `model`, `tools` (including their order), `parallel_tool_calls`, `text.format`, `reasoning.effort`, `text.verbosity` and `context_management`{% include cite.html n=2 %}. To change effort on GPT-6 models, append a `configuration_update` item{% include cite.html n=2 %}. To stop using tools, use `tool_choice: "none"` or `allowed_tools` instead of removing them{% include cite.html n=2 %}.
- **Serialization isn't deterministic.** Languages that randomize JSON key order, such as Swift and Go, can break caches{% include cite.html n=1 %}.
- **Breakpoints are in the wrong place.** On a read, Anthropic looks back at most 20 blocks from each breakpoint, and a breakpoint on a block that changes every request never hits{% include cite.html n=1 %}.
- **Requests go out in parallel before the first response.** On Anthropic, an entry is usable only "after the first response starts", so send one request and wait for its response before fanning out{% include cite.html n=1 %}.
- **Traffic is routed elsewhere.** OpenAI: "Cached states live on individual machines, where traffic above 15 requests per minute can lead to overflow routing."{% include cite.html n=2 %}

## Check whether you're actually hitting

- **Anthropic:** `usage` reports `cache_creation_input_tokens` and `cache_read_input_tokens`{% include cite.html n=1 %}. If both are 0, the prompt was not cached{% include cite.html n=1 %}.
- **OpenAI, Responses API:** `usage.input_tokens_details.cached_tokens` and `cache_write_tokens`{% include cite.html n=2 %}. On pre-5.6 models, `cached_tokens` is rounded down to a multiple of 128{% include cite.html n=2 %}.

## Our view

These are our recommendations, not the providers'.

- Put stable content first and variable content last on both providers. It costs nothing and is what both match on.
- Log the cache usage fields from the first request. A cache miss doesn't return an error: on Anthropic, prompts under the minimum are "processed without caching, and no error is returned"{% include cite.html n=1 %}. The usage fields are how you find out.
- On Anthropic and OpenAI GPT-5.6+, a write costs more than sending the same tokens uncached. Cache only prefixes you expect to reuse before they expire.
