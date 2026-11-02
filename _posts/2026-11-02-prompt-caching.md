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

Caching on the Claude API is opt-in, and there are two ways to turn it on. You can put a single `cache_control` field at the top level of the request, and the system "[automatically applies the cache breakpoint](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) to the last cacheable block and moves it forward as conversations grow". Or you can put `cache_control` on individual content blocks, [up to 4 breakpoints](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) in total, with the automatic breakpoint taking one of them.

Prompts shorter than the model's minimum are "processed without caching, and [no error is returned](https://docs.claude.com/en/docs/build-with-claude/prompt-caching)". The minimum is [512 tokens on newer models](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) including Opus 5.5, Sonnet 5.5, Haiku 5.5 and Fable 5.1, and as high as 4,096 tokens on some older ones such as Opus 4.6 and Haiku 4.5.

Entries last [5 minutes by default](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) and are refreshed at no cost each time they are used. You can opt into a [1-hour TTL](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) with `ttl`. The lifetime is counted [from the start of the request](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), so generation time uses part of it. The docs give an example: "if a response takes 4 minutes to stream, a follow-up request that reuses the same cached prefix must start [within about 1 minute](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) of that response completing." If you mix TTLs, [1-hour entries must come before](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) 5-minute ones.

A 5-minute write costs [1.25x the base input price](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) and a 1-hour write costs 2x. A read costs [10% of base input](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), except 0.05x on Opus 5.5 and Sonnet 5.5 and 0.025x on Fable 5.1 and Mythos 5.1. Prices per million tokens as of 2026-11-02 ([source](https://docs.claude.com/en/docs/build-with-claude/prompt-caching)):

| Model | Input | 5m write | 1h write | Hit |
|---|---|---|---|---|
| Opus 5.5 | $4 | $5 | $8 | $0.20 |
| Sonnet 5.5 | $2 | $2.50 | $4 | $0.10 |
| Haiku 5.5 (≤100,000-token prompts) | $0.10 | $0.125 | $0.20 | $0.01 |
| Fable 5.1 | $10 | $12.50 | $20 | $0.25 |

Haiku 5.5 prompts [over 100,000 tokens](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) are billed at higher rates. You can pre-warm the cache with a [`max_tokens: 0` request](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), and cache hits "are not deducted against your rate limit".

## OpenAI: on by default, with new controls from GPT-5.6

"Prompt caching is [enabled by default](https://platform.openai.com/docs/guides/prompt-caching) for supported OpenAI models." How it behaves depends on the model generation.

**GPT-5.6 and later.** [`prompt_cache_options.mode`](https://platform.openai.com/docs/guides/prompt-caching) chooses between two modes. In `implicit` mode, OpenAI places a breakpoint "at the end of the [latest eligible message](https://platform.openai.com/docs/guides/prompt-caching)". In `explicit` mode, only the breakpoints you mark are used, and if you mark none, "the request [does not use prompt caching](https://platform.openai.com/docs/guides/prompt-caching) or create cache writes". A request can create [up to four cache writes](https://platform.openai.com/docs/guides/prompt-caching), and top-level `instructions` can't hold a breakpoint. The minimum is [1,024 tokens](https://platform.openai.com/docs/guides/prompt-caching). The TTL is [`"30m"` by default](https://platform.openai.com/docs/guides/prompt-caching), or `"12h"` on the Responses API only. Both are [*minimum* lifetimes](https://platform.openai.com/docs/guides/prompt-caching), and "OpenAI may retain entries longer". You can pre-warm with [`prompt_cache_options.prewarm: true`](https://platform.openai.com/docs/guides/prompt-caching), which is billed at the cache-write rate.

**Earlier models.** These models [cache implicitly only](https://platform.openai.com/docs/guides/prompt-caching), with breakpoints at model-dependent intervals (every 2,048 tokens on GPT-5.5). Their minimum "[varies by request settings](https://platform.openai.com/docs/guides/prompt-caching)", and no fixed number is given. Retention is set with [`prompt_cache_retention`](https://platform.openai.com/docs/guides/prompt-caching). `in_memory` means "around [5 to 10 minutes of inactivity](https://platform.openai.com/docs/guides/prompt-caching), up to one hour". `24h` "typically keeps entries available for [around 30 minutes](https://platform.openai.com/docs/guides/prompt-caching) and can retain them for up to 24 hours". The default depends on whether your org has [Zero Data Retention](https://platform.openai.com/docs/guides/prompt-caching). These are typical and maximum lifetimes, not the guaranteed minimums of GPT-5.6+, so the two sets of figures can't be compared directly.

On GPT-5.6+, a write costs [1.25x the uncached input rate](https://platform.openai.com/docs/guides/prompt-caching) (30m) or 2.5x (12h). These are "[total write rates, not surcharges](https://platform.openai.com/docs/guides/prompt-caching)". A read costs [0.1x on most models](https://platform.openai.com/docs/guides/prompt-caching) and 0.05x on GPT-6.1 Sol and GPT-6.1 Terra. Earlier models have "[No additional cache-write charge](https://platform.openai.com/docs/guides/prompt-caching)". Standard-tier prices per million tokens as of 2026-11-02 ([source](https://platform.openai.com/docs/pricing)):

| Model | Input | Cached input | 30m write | 12h write |
|---|---|---|---|---|
| gpt-6-astra | $10.00 | $1.00 | $12.50 | $25.00 |
| gpt-6.1-sol | $2.00 | $0.10 | $2.50 | $5.00 |
| gpt-6.1-terra | $1.00 | $0.05 | $1.25 | $2.50 |
| gpt-6-luna | $0.10 | $0.01 | $0.125 | $0.25 |

## What it saves

On cost, the models in the tables above charge a tenth of the input price or less for a cached read. OpenAI's pre-5.6 models have a "[model-dependent cached-input rate](https://platform.openai.com/docs/guides/prompt-caching)". The providers differ on writes. [Anthropic](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) and [OpenAI GPT-5.6+](https://platform.openai.com/docs/guides/prompt-caching) charge more than the uncached input price for a write, and OpenAI's earlier models charge nothing extra.

OpenAI's guide works through the numbers for a GPT-5.6+ model with a 0.1x read rate and 30m writes. Writing a prefix once and reusing it once "costs [1.35× its ordinary input cost](https://platform.openai.com/docs/guides/prompt-caching), compared with 2× for processing it twice without caching". Over ten requests, "one write and nine full reads [cost 2.15× at that rate](https://platform.openai.com/docs/guides/prompt-caching), compared with 10× without caching."

On latency, neither source gives a number, so neither do we. Anthropic says caching "[significantly reduces processing time](https://docs.claude.com/en/docs/build-with-claude/prompt-caching)". OpenAI says it can "Reduce the time spent processing input before the response starts", but warns that the minimum lifetime "does not guarantee that every request reuses stored KV tensors or has [lower latency](https://platform.openai.com/docs/guides/prompt-caching)".

## Why cache hits miss

- **The prompt is under the minimum.** On Anthropic this [fails silently](https://docs.claude.com/en/docs/build-with-claude/prompt-caching).
- **Something early in the prompt changed.** On Anthropic the order is [`tools` → `system` → `messages`](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), and a change at any level invalidates that level and every level after it. Changing [tool definitions invalidates everything](https://docs.claude.com/en/docs/build-with-claude/prompt-caching). Toggling [web search or citations](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), or the `speed` setting, invalidates the system and messages caches. Changing `tool_choice`, adding or removing images, or changing thinking parameters or `output_config.effort` [invalidates the messages cache](https://docs.claude.com/en/docs/build-with-claude/prompt-caching). On OpenAI the prefix [can be changed by](https://platform.openai.com/docs/guides/prompt-caching) `model`, `tools` (including their order), `parallel_tool_calls`, `text.format`, `reasoning.effort`, `text.verbosity` and `context_management`. To change effort on GPT-6 models, append a [`configuration_update` item](https://platform.openai.com/docs/guides/prompt-caching). To stop using tools, use [`tool_choice: "none"` or `allowed_tools`](https://platform.openai.com/docs/guides/prompt-caching) instead of removing them.
- **Serialization isn't deterministic.** Languages that [randomize JSON key order](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), such as Swift and Go, can break caches.
- **Breakpoints are in the wrong place.** On a read, Anthropic looks back [at most 20 blocks](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) from each breakpoint, and a breakpoint on a block that changes every request never hits.
- **Requests go out in parallel before the first response.** On Anthropic, an entry is usable only "[after the first response starts](https://docs.claude.com/en/docs/build-with-claude/prompt-caching)", so send one request and wait for its response before fanning out.
- **Traffic is routed elsewhere.** OpenAI: "Cached states live on individual machines, where traffic [above 15 requests per minute](https://platform.openai.com/docs/guides/prompt-caching) can lead to overflow routing."

## Check whether you're actually hitting

- **Anthropic:** `usage` reports `cache_creation_input_tokens` and [`cache_read_input_tokens`](https://docs.claude.com/en/docs/build-with-claude/prompt-caching). If [both are 0](https://docs.claude.com/en/docs/build-with-claude/prompt-caching), the prompt was not cached.
- **OpenAI, Responses API:** `usage.input_tokens_details.cached_tokens` and [`cache_write_tokens`](https://platform.openai.com/docs/guides/prompt-caching). On pre-5.6 models, `cached_tokens` is rounded down to [a multiple of 128](https://platform.openai.com/docs/guides/prompt-caching).

## Our view

These are our recommendations, not the providers'.

- Put stable content first and variable content last on both providers. It costs nothing and is what both match on.
- Log the cache usage fields from the first request. A cache miss [doesn't return an error](https://docs.claude.com/en/docs/build-with-claude/prompt-caching): on Anthropic, prompts under the minimum are "processed without caching, and no error is returned". The usage fields are how you find out.
- On Anthropic and OpenAI GPT-5.6+, a write costs more than sending the same tokens uncached. Cache only prefixes you expect to reuse before they expire.
