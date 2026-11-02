---
title: "Batch APIs on Claude and OpenAI: half price, up to a day's wait, and how failures show up"
author: "Staff Writer"
description: "How Anthropic's Message Batches API and OpenAI's Batch API work, what the 50% discount costs you in latency and features, and how errors, cancellations and expiry appear in results."
sources:
  - title: "Batch processing"
    url: https://docs.claude.com/en/docs/build-with-claude/batch-processing
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Prompt caching"
    url: https://docs.claude.com/en/docs/build-with-claude/prompt-caching
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Rate limits"
    url: https://docs.claude.com/en/api/rate-limits
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Batch API"
    url: https://platform.openai.com/docs/guides/batch
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "GPT-6.1 Sol"
    url: https://platform.openai.com/docs/models/gpt-6.1-sol
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "GPT-6 Luna"
    url: https://platform.openai.com/docs/models/gpt-6-luna
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "Prompt caching"
    url: https://platform.openai.com/docs/guides/prompt-caching
    publisher: "OpenAI"
    accessed: "2026-11-02"
corrections: []
---
Anthropic and OpenAI both let you submit a large set of requests at once and collect the results later, at half the normal price. In return you give up immediate answers and some features, and you have to handle results that arrive out of order, fail or expire. Everything below comes from each provider's documentation as checked on 2026-11-02.

## What you get and what you give up

The discount is the same on both. Anthropic says ["All usage is charged at 50 percent of the standard API prices"](https://docs.claude.com/en/docs/build-with-claude/batch-processing). OpenAI's guide promises a ["50% cost discount compared to synchronous APIs"](https://platform.openai.com/docs/guides/batch).

The cost is latency. [Anthropic says "most batches completing within 1 hour", but results are available "when all messages have completed or after 24 hours, whichever comes first".](https://docs.claude.com/en/docs/build-with-claude/batch-processing) [OpenAI's completion window "can only be set to `24h`".](https://platform.openai.com/docs/guides/batch) Streaming is out too. [Anthropic rejects `stream: true` in a batch](https://docs.claude.com/en/docs/build-with-claude/batch-processing), and [OpenAI's moderation batches reject `stream=true`](https://platform.openai.com/docs/guides/batch).

In our view, batches fit work where nobody is waiting on the answer, such as evaluations, backfills, classification or embedding runs, and where a day's delay in the worst case is acceptable.

## Anthropic: Message Batches

**Submitting.** [You send the requests inline in a `requests` list, with no file upload. Each item has a `custom_id` (1–64 characters: letters, digits, `_` and `-`) and a `params` object holding the normal Messages API parameters. One batch can mix different request types.](https://docs.claude.com/en/docs/build-with-claude/batch-processing) [A batch holds at most "100,000 Message requests or 256 MB in size, whichever is reached first". Going over 256 MB may return a 413 `request_too_large`.](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

**Tracking.** [A new batch has `processing_status` `in_progress`, which becomes `ended` when every request has finished. You poll `GET /v1/messages/batches/{message_batch_id}` or watch the Console.](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

**Results.** [Results come back as `.jsonl` from the batch's `results_url`, one line per request. The docs recommend streaming the file. Order isn't guaranteed, so match on `custom_id`. "Batch results use the API version of the request that created the batch."](https://docs.claude.com/en/docs/build-with-claude/batch-processing) [Results can be downloaded for 29 days from `created_at`, not from when the batch ended.](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

**Features.** [Every active model supports batches. You can use vision, tool use (including server tools such as web search, web fetch and code execution), system messages, multi-turn conversations, extended thinking and "most beta features". These return a validation error: `stream: true`, `speed` (fast mode), `fallbacks` and `max_tokens: 0` (cache pre-warming).](https://docs.claude.com/en/docs/build-with-claude/batch-processing)
**Limits.** [Batch rate limits are shared across all models: 1,000 requests per minute to the batch endpoints, 200,000 batch requests in the processing queue, and 100,000 requests per batch.](https://docs.claude.com/en/api/rate-limits) [Batches are scoped to a Workspace and "may go slightly over the spend limit" set for it.](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

**Prices.** Per million tokens, standard and batch, as of 2026-11-02 (standard: [source](https://docs.claude.com/en/docs/build-with-claude/prompt-caching); batch: [source](https://docs.claude.com/en/docs/build-with-claude/batch-processing)):

| Model | Standard in / out | Batch in / out |
|---|---|---|
| Opus 5.5 | $4 / $20 | $2 / $10 |
| Sonnet 5.5 | $2 / $10 | $1 / $5 |
| Haiku 5.5 (prompts ≤100,000 tokens) | $0.10 / $0.50 | $0.05 / $0.25 |
| Haiku 5.5 (prompts >100,000 tokens) | $0.50 / $2.50 | $0.25 / $1.25 |
| Opus 4.5–4.8, Opus 5 | $5 / $25 | $2.50 / $12.50 |
| Haiku 4.5 | $1 / $5 | $0.50 / $2.50 |

**Prompt caching.** [The caching and batch discounts stack. Cache hits in a batch are "best-effort", and users "typically experience cache hit rates ranging from 30 percent to 98 percent". To improve them, use identical `cache_control` blocks across requests and keep a steady stream of requests so entries don't reach their "5-minute lifetime".](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

## OpenAI: Batch API

**Submitting.** [You write a `.jsonl` file with one request per line. Each line has `custom_id`, `method`, `url` and `body`, and the body takes the target endpoint's normal parameters. "Each input file can only include requests to a single model." You upload the file through the Files API with `purpose: "batch"`, then create the batch with `input_file_id`, `endpoint` and `completion_window`.](https://platform.openai.com/docs/guides/batch) [A batch holds "up to 50,000 requests", with an input file "up to 200 MB". Embedding batches are also capped at 50,000 embedding inputs in total.](https://platform.openai.com/docs/guides/batch)

**Endpoints.** [Supported endpoints are `/v1/responses`, `/v1/chat/completions`, `/v1/embeddings`, `/v1/completions`, `/v1/moderations`, `/v1/images/generations` and `/v1/images/edits`. "Most models support the Batch API", so check each model's page.](https://platform.openai.com/docs/guides/batch)

**Tracking.** [A batch moves through `validating`, `in_progress`, `finalizing` and `completed`, or ends in `failed`, `expired`, `cancelling` or `cancelled`.](https://platform.openai.com/docs/guides/batch)

**Results.** [You download the file named in `output_file_id`. Failed requests go to a separate file at `error_file_id`. Output order "may not match" input order, so match on `custom_id`. "The output file will automatically be deleted 30 days after the batch is complete."](https://platform.openai.com/docs/guides/batch)

**Limits.** [Batch has its own rate-limit pool and "will not consume tokens from your standard per-model rate limits". Limits include queued prompt tokens per model and "up to 2,000 batches per hour". "The Batch API currently has no output-token limit."](https://platform.openai.com/docs/guides/batch)

**Prices.** OpenAI's model pages state the batch discount directly. On GPT-6.1 Sol, standard pricing is $2.00 input and $10.00 output per million tokens as of 2026-11-02, and ["Batch and Flex prices are 50% lower than Standard"](https://platform.openai.com/docs/models/gpt-6.1-sol). On GPT-6 Luna, standard pricing is $0.10 input and $0.50 output, and ["Batch and Flex are priced at 50% of Standard rates"](https://platform.openai.com/docs/models/gpt-6-luna).

**Prompt caching.** Neither OpenAI's [batch guide](https://platform.openai.com/docs/guides/batch) nor its [prompt caching guide](https://platform.openai.com/docs/guides/prompt-caching) says how caching behaves inside a batch or whether the two discounts combine.

## How failures, cancellation and expiry show up

**Anthropic.** [Every request ends as `succeeded`, `errored`, `canceled` or `expired`, and only `succeeded` is billed. An errored result carries the standard error shape in `result.error`. "The failure of one request in a batch does not affect the processing of other requests."](https://docs.claude.com/en/docs/build-with-claude/batch-processing) [In `request_counts`, every count except `processing` stays zero "until processing of the entire Message Batch has ended". So you can't watch successes accumulate while a batch runs.](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

[Cancelling moves the batch to `canceling` and then `ended`. It "may contain partial results" from requests processed before the cancel.](https://docs.claude.com/en/docs/build-with-claude/batch-processing) ["Batches expire if processing does not complete within 24 hours", and under heavy demand "you might see more requests expiring after 24 hours".](https://docs.claude.com/en/docs/build-with-claude/batch-processing)

**OpenAI.** [If the input file fails validation, the batch status is `failed`. Errors on individual requests go to the error file.](https://platform.openai.com/docs/guides/batch) [Cancelling moves the batch to `cancelling` "until in-flight requests are complete (up to 10 minutes)", then to `cancelled`.](https://platform.openai.com/docs/guides/batch) The guide doesn't say whether results that finished before the cancel remain in the output file.

On timing, the OpenAI guide makes two statements and we quote both as written. It says ["Each batch completes within 24 hours (and often more quickly)"](https://platform.openai.com/docs/guides/batch). It also describes batches that ["do not complete in time"](https://platform.openai.com/docs/guides/batch) moving to `expired`. [On expiry, unfinished requests are cancelled. Responses that completed still appear in the output file and are charged. Expired requests go to the error file with code `batch_expired`.](https://platform.openai.com/docs/guides/batch)
## Our view

These are our recommendations, not the providers'.

- Use batches for work that can wait a day. Many batches will finish sooner, but design for the 24-hour case.
- Always match results on `custom_id`. Neither provider guarantees input order.
- Read both result files on OpenAI and every result type on Anthropic. Treat `expired` and `errored` as normal outcomes and plan a resubmission path for them.
- On Anthropic, keep shared prompt prefixes identical across a batch to make the stacked caching discount more likely.
- Download results promptly. Anthropic's 29 days run from creation, and OpenAI deletes the output file 30 days after completion.
