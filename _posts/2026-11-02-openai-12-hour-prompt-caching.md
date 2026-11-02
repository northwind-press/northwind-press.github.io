---
title: "OpenAI adds 12-hour prompt caching to the Responses API, with writes at 2.5x input"
author: "AI Reporter"
description: "On GPT-5.6 and later, set prompt_cache_options.ttl to \"12h\" for prefixes reused across long gaps; by our calculation it pays off from the third request."
categories: [ai]
subsection: applied
kind: news
date: 2026-11-02 22:43
sources:
  - title: "Changelog"
    url: https://platform.openai.com/docs/changelog
    publisher: "OpenAI"
    date: "2026-10-20"
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
OpenAI added a 12-hour prompt-caching option to its API on 2026-10-20, according to its [developer changelog](https://platform.openai.com/docs/changelog). It keeps shared instructions, tools, and context cached when requests are hours apart, and 12-hour cache writes cost 2.5x the input token price{% include cite.html n=1 %}.

## How to turn it on

OpenAI's [prompt caching guide](https://platform.openai.com/docs/guides/prompt-caching) says the option is set with `prompt_cache_options.ttl` in the Responses API. The value `"30m"` is the default, and `"12h"` selects the longer lifetime{% include cite.html n=2 %}. A request-level `ttl` applies to the implicit breakpoint and to explicit breakpoints without their own `ttl`, and `prompt_cache_breakpoint.ttl` overrides it for one explicit breakpoint{% include cite.html n=2 %}. That lets you give stable reference material 12 hours and session context 30 minutes in the same request{% include cite.html n=2 %}.

Both values are minimum lifetimes. OpenAI may keep entries longer, and `"12h"` sets no deletion deadline and doesn't change the maximum data-retention policy{% include cite.html n=2 %}. The guide says the minimum lifetime governs eligibility for cache-read pricing, but doesn't guarantee a cache hit or lower latency{% include cite.html n=2 %}.

## Which models

The `ttl` control applies to GPT-5.6 and later models; earlier models use `prompt_cache_retention` instead, and the new settings don't change it{% include cite.html n=2 %}. `"12h"` is available only in the Responses API{% include cite.html n=2 %}.

## Pricing

On these models, a 30-minute write costs 1.25x the uncached input rate, and a 12-hour write costs 2.5x{% include cite.html n=2 %}. These are total rates, not surcharges, and reads cost the same for both lifetimes: 0.1x input on most models, or 0.05x on GPT-6.1 Sol and GPT-6.1 Terra{% include cite.html n=2 %}. Upgrading valid 30-minute coverage to 12 hours bills a new 12-hour write, with no credit for the earlier write{% include cite.html n=2 %}.

As of 2026-11-02, OpenAI's [price list](https://platform.openai.com/docs/pricing) gives these standard rates per million tokens:

| Model | Input | Cached input | 30m write | 12h write |
|---|---|---|---|---|
| gpt-6-astra | $10.00 | $1.00 | $12.50 | $25.00 |
| gpt-6.1-sol | $2.00 | $0.10 | $2.50 | $5.00 |
| gpt-6.1-terra | $1.00 | $0.05 | $1.25 | $2.50 |
| gpt-6-luna | $0.10 | $0.01 | $0.125 | $0.25 |

## When 12 hours pays off (our calculation)

Our method: take one prefix, fully reused, sent k times within 12 hours, with each gap long enough that a 30-minute entry has expired. With 30-minute caching, every request is a write: 1.25 × k. With 12-hour caching, it's one write and then reads: 2.5 + 0.1 × (k − 1). The two are equal at k ≈ 2.1. Two requests cost slightly less on 30 minutes (2.5x against 2.6x the input price), and from three requests the 12-hour option is cheaper. At the 0.05x read rate the crossover is also just over two. This counts input cost only, and assumes no extra misses.

## What's unclear

The guide doesn't say whether a read under a `"12h"` request restarts the 12-hour clock. It does say a 30-minute read on a 12-hour entry doesn't{% include cite.html n=2 %}.

For how caching works on OpenAI and Anthropic, and why expected hits miss, see our explainer "Prompt caching on Anthropic and OpenAI: how it works, what it costs, why hits miss", published 2026-11-02 in Applied AI.
