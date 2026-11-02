---
title: "OpenAI's Decisions API leaves beta with prompt caching and 400 questions per request"
author: "AI Reporter"
description: "OpenAI's v1/decisions endpoint for typed classification, routing, and scoring answers is out of beta on gpt-6-luna, adding prompt caching, JSON input, and up to 400 questions per request."
categories: [ai]
subsection: applied
kind: news
date: 2026-11-02 22:39
sources:
  - title: "Changelog"
    url: https://platform.openai.com/docs/changelog
    publisher: "OpenAI"
    date: "2026-10-22"
    accessed: "2026-11-02"
  - title: "Decisions"
    url: https://platform.openai.com/docs/guides/decisions
    publisher: "OpenAI"
    accessed: "2026-11-02"
corrections: []
---

OpenAI made its Decisions API [generally available](https://platform.openai.com/docs/changelog) on 2026-10-22, after a public beta that began on 2026-10-06. The endpoint is `POST /v1/decisions`, and `gpt-6-luna` is the only model it supports{% include cite.html n=1 %}.

## What it is for

It takes text, images, or JSON as evidence and returns typed answers to questions you define, which an application can use to classify content, route requests, or prioritize work, according to OpenAI's [Decisions guide](https://platform.openai.com/docs/guides/decisions). There are three question types{% include cite.html n=2 %}:

- `predicate` returns a `probability`, from 0 to 1, that a condition is true.
- `choice` picks one value from a set you supply and returns probabilities for each option plus a `confidence` field.
- `score` rates input against 2 to 10 ordered levels and returns a probability-weighted average of the level indices, so a score can fall between levels.

OpenAI says the API answers about 10x faster than its Responses API{% include cite.html n=2 %}. We haven't tested that claim. For generating objects in your own JSON schema, or for tool calls with arguments, the guide points developers to Structured Outputs or function calling instead{% include cite.html n=2 %}.

## What changed since the beta

The GA release added these features{% include cite.html n=1 %}{% include cite.html n=2 %}:

- **Prompt caching.** Requests that share a matching prefix of `input` get discounted cache-read pricing. The reusable prefix must be at least 1,024 tokens, and question content is outside it. By default the API places a cache breakpoint at the end of the shared input, so existing requests can benefit unchanged{% include cite.html n=2 %}.
- **Images in question instructions.** Each question can carry its own images to compare against shared evidence. These images count toward the request's image limits{% include cite.html n=2 %}.
- **`input_json`.** Structured data can be passed as a content part in user messages without first converting it to a string{% include cite.html n=2 %}.
- **400 questions per request**, up from 200 in the beta{% include cite.html n=1 %}.

The guide also lists hosted image URLs alongside base64 data URLs, conversation history with tool calls and outputs, organization usage reporting at `GET /v1/organization/usage/decisions`, native GPT-Live integration, and Private Link{% include cite.html n=2 %}.

## Pricing and limits, as of 2026-11-02

On `/v1/decisions`, uncached input costs US$0.10 per million tokens and output tokens aren't charged{% include cite.html n=2 %}. Cache reads and writes are billed at the standard `gpt-6-luna` caching rates, and regional processing premiums and long-context multipliers apply{% include cite.html n=2 %}. OpenAI lists `gpt-6-luna` cached input at US$0.01 per million tokens{% include cite.html n=1 %}.

A request takes between 1 and 400 questions. Questions that depend on an earlier answer need separate requests{% include cite.html n=2 %}. The endpoint doesn't accept `file_id` inputs, files, audio, or item references{% include cite.html n=2 %}. It supports Zero Data Retention and HIPAA use for eligible customers, and regional processing in the US and Europe{% include cite.html n=2 %}.

## What we don't know

The guide doesn't give request rate limits or per-request image limits for the endpoint, and it doesn't say how OpenAI measured the speed figure{% include cite.html n=2 %}.
