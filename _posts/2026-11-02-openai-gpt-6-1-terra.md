---
title: "OpenAI releases GPT-6.1 Terra at $1 input and $5 output per million tokens"
author: "Northwind AI Desk"
description: "GPT-6.1 Terra is OpenAI's new mid-priced model for images, computer use, and writing; tool calls need the Responses API, so test it against GPT-5.6 Terra before switching."
categories: [ai]
kind: news
date: 2026-11-02 22:42
sources:
  - title: "Changelog"
    url: https://platform.openai.com/docs/changelog
    publisher: "OpenAI"
    date: "2026-10-26"
    accessed: "2026-11-02"
  - title: "GPT-6.1 Terra"
    url: https://platform.openai.com/docs/models/gpt-6.1-terra
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "Using GPT-6"
    url: https://platform.openai.com/docs/guides/latest-model
    publisher: "OpenAI"
    accessed: "2026-11-02"
corrections: []
---

OpenAI released GPT-6.1 Terra (`gpt-6.1-terra`) on 2026-10-26 for the Responses and Chat Completions APIs, according to its [API changelog](https://platform.openai.com/docs/changelog). OpenAI describes it as "a fast, efficient model for visual reasoning, precise computer use, and clear, natural writing"{% include cite.html n=1 %}. Those are the vendor's claims. None of the three OpenAI pages we checked publishes a benchmark or evaluation method for Terra.

## Price, context, and limits

As of 2026-11-02, the [model page](https://platform.openai.com/docs/models/gpt-6.1-terra) lists Standard pricing per million tokens of $1.00 input, $0.05 cached input, $1.25 for cache writes with 30-minute retention, and $5.00 output. Cache writes with 12-hour retention cost $2.50{% include cite.html n=2 %}. Prompts over 272,000 input tokens are billed at twice the input and cache rates and 1.5 times the output rate for the whole request{% include cite.html n=2 %}. Batch and Flex cost 50% less than Standard, Fast mode costs twice Standard, and regional processing adds 10% where it is available{% include cite.html n=2 %}.

The model has a 1,050,000-token context window, a 128,000-token output limit, and a knowledge cutoff of 2026-06-01. It takes text and image input and returns text only{% include cite.html n=2 %}. The free tier is not supported. The lowest paid tier, Build, allows 5,000 requests and 1,000,000 tokens per minute{% include cite.html n=2 %}. Fine-tuning is not supported{% include cite.html n=2 %}.

## Where it sits

OpenAI's [GPT-6 guide](https://platform.openai.com/docs/guides/latest-model) lists four models. GPT-6 Astra is labeled "Highest intelligence", GPT-6.1 Sol "Balanced speed, cost, and intelligence", Terra "Fast and efficient", and GPT-6 Luna "Fastest and most cost-effective"{% include cite.html n=3 %}. On price, Terra sits between Sol and Luna. The changelog lists GPT-6.1 Sol at $2 input and $10 output, and GPT-6 Luna at $0.10 input and $0.50 output, per million tokens for prompts up to 272,000 tokens{% include cite.html n=1 %}.

Terra supports reasoning effort `none`, `low`, `medium` (the default), `high`, `xhigh`, and `max`. GPT-6 Astra and GPT-6.1 Sol do not support `none`{% include cite.html n=3 %}.

## Migration notes

The guide gives this advice for moving to Terra{% include cite.html n=3 %}:

- Start at `medium` effort and raise it only if the quality gain is worth the extra time and tokens.
- If you are moving from GPT-5.6 Terra, compare both models on representative images and workflows at the same reasoning effort.
- Terra works in Chat Completions, but tool calling requires the Responses API, so tool-using Chat Completions requests have to move.
- When effort is not `none`, remove `temperature`, `top_p`, and `top_logprobs`. In Chat Completions, also remove `logprobs`.
- Coming from GPT-5.5 or earlier, replace `prompt_cache_retention` with `prompt_cache_options.ttl` set to `"30m"`.

Fast mode for Terra supports EU data residency{% include cite.html n=3 %}.

## What we don't know

OpenAI's pages give no published quality comparison between Terra and GPT-5.6 Terra, Sol or Luna. They also list no dated snapshot other than `gpt-6.1-terra`{% include cite.html n=2 %}. The documents we checked don't say whether GPT-5.6 Terra will be deprecated.
