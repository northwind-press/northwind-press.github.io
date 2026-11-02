---
title: "Structured outputs on Claude and OpenAI: what's guaranteed, what's not supported, what still breaks"
author: "Staff Writer"
description: "How to get schema-valid JSON from the Claude and OpenAI APIs, what each one actually guarantees, which JSON Schema features each rejects, and the cases that still return output you can't parse."
sources:
  - title: "Structured outputs"
    url: https://docs.claude.com/en/docs/build-with-claude/structured-outputs
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Strict tool use"
    url: https://docs.claude.com/en/docs/agents-and-tools/tool-use/strict-tool-use
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Structured Outputs"
    url: https://platform.openai.com/docs/guides/structured-outputs
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "Function calling"
    url: https://platform.openai.com/docs/guides/function-calling
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "Prompt caching"
    url: https://platform.openai.com/docs/guides/prompt-caching
    publisher: "OpenAI"
    accessed: "2026-11-02"
  - title: "Structured outputs (Markdown version of the docs page)"
    url: https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md
    publisher: "Anthropic"
    accessed: "2026-11-02"
corrections: []
---
Both the Claude API and the OpenAI API can constrain a model to a JSON Schema you supply, either for the response itself or for a tool call's arguments. By the providers' own docs, that still isn't the same as "every response matches". This piece covers how to turn it on, what each provider promises, which schema features each rejects, and the cases where you still get output that doesn't match. Everything below comes from each provider's documentation as checked on 2026-11-02.

## Claude: `output_config.format` and strict tools

For a JSON response, put your schema in [`output_config.format`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) with `type: "json_schema"`. The JSON comes back "in the [response's text content block](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)". For tool calls, set [`"strict": true`](https://docs.claude.com/en/docs/agents-and-tools/tool-use/strict-tool-use) as a top-level property of the tool definition, alongside `name`, `description` and `input_schema`. You can use both "[together in the same request](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)".

If you used the beta, note that `output_format` "[has moved to `output_config.format`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)". The old parameter is deprecated, works only with the [`structured-outputs-2025-11-13` beta header](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) and otherwise returns a 400.

The SDKs include helpers such as Python's [`client.messages.parse()`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md) and TypeScript's `zodOutputFormat()` and `jsonSchemaOutputFormat()`. Some helpers [rewrite your schema](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) before sending it. They [strip unsupported constraints](https://docs.claude.com/en/docs/build-with-claude/structured-outputs), copy them into the field description, add `additionalProperties: false`, and then validate the response locally "if the helper validates responses".

Anthropic says structured outputs "are available on [every model](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)". The feature [isn't available in Managed Agents](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md).

## OpenAI: `text.format`, `response_format` and strict functions

On the Responses API, use [`text: { format: { type: "json_schema", "strict": true, "schema": … } }`](https://platform.openai.com/docs/guides/structured-outputs). On Chat Completions, use [`response_format: { type: "json_schema", json_schema: { name, strict: true, schema } }`](https://platform.openai.com/docs/guides/structured-outputs). The SDKs' `responses.parse()` and `chat.completions.parse()` accept [Pydantic or Zod models](https://platform.openai.com/docs/guides/structured-outputs). For function calling, set [`"strict": true`](https://platform.openai.com/docs/guides/function-calling) on the function definition.

Leaving `strict` out behaves differently on the two APIs. Responses "will attempt to normalize your schema into strict mode when possible, and will [fall back to non-strict, best-effort](https://platform.openai.com/docs/guides/function-calling)", in which case the tool shows `strict: false`. "Chat Completions requests remain [non-strict by default](https://platform.openai.com/docs/guides/function-calling)." JSON mode (`{ "type": "json_object" }`) guarantees [valid JSON only](https://platform.openai.com/docs/guides/structured-outputs), not schema adherence, and errors unless "JSON" appears somewhere in the context.

The `json_schema` format is "only supported with the `gpt-4o-mini`, `gpt-4o-mini-2024-07-18`, and [`gpt-4o-2024-08-06` model snapshots and later](https://platform.openai.com/docs/guides/structured-outputs)". GPT-6 Astra and GPT-6.1 Sol "[require the Responses API](https://platform.openai.com/docs/guides/function-calling) for tool calling".

## What each actually guarantees

Anthropic says "Structured outputs guarantee [schema-compliant responses](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) through constrained decoding". For strict tools, "Tool `input` [strictly follows the `input_schema`](https://docs.claude.com/en/docs/agents-and-tools/tool-use/strict-tool-use)" and "Tool `name` is always valid". The same page qualifies this: compliance is guaranteed "[in most cases](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)", and the exceptions are covered below.

OpenAI says Structured Outputs "ensures the model will [always generate responses that adhere](https://platform.openai.com/docs/guides/structured-outputs) to your supplied JSON Schema", and strict functions "[reliably adhere to the function schema](https://platform.openai.com/docs/guides/function-calling), instead of being best effort". OpenAI also warns that "Structured Outputs [can still contain mistakes](https://platform.openai.com/docs/guides/structured-outputs)". If the input has nothing to do with the schema, the model "will always try to adhere to the provided schema, which [can result in hallucinations](https://platform.openai.com/docs/guides/structured-outputs)".

In our reading, both guarantees cover the shape of the output, not whether its content is right.

## Schema features you can't use

Both providers support a subset of JSON Schema, and the subsets differ ([Anthropic](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md), [OpenAI](https://platform.openai.com/docs/guides/structured-outputs)):

| Feature | Claude | OpenAI |
|---|---|---|
| Recursive schemas | Not supported | Supported |
| `minimum`, `maximum`, `multipleOf` | Not supported | Supported |
| `minItems` | Only 0 or 1 | Supported |
| `maxItems` | Not supported | Supported |
| `allOf` | Supported, except with `$ref` | Not supported |
| Optional fields | Allowed | Every field must be `required`; use a union with `null` |
| `additionalProperties` | Must be `false` | Must be `false` |

On Claude, [`pattern` regexes](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md) can use anchors, `* + ?`, simple `{n,m}`, character classes and groups, but not backreferences, lookaround, `\b`/`\B` or large `{n,m}` ranges. Unsupported features return "[a 400 error with details](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md)". OpenAI requires the [root to be an object](https://platform.openai.com/docs/guides/structured-outputs), not `anyOf`. Its [fine-tuned models reject](https://platform.openai.com/docs/guides/structured-outputs) a longer list of keywords, including `pattern`, `format`, `minimum` and `maximum`. An unsupported schema with `strict: true` [returns an error](https://platform.openai.com/docs/guides/structured-outputs). OpenAI's [strict functions have the same rules](https://platform.openai.com/docs/guides/function-calling): `additionalProperties: false` on every object, every property `required`, and optional fields written as a union with `null`.

There are size limits too. Claude allows [20 strict tools](https://docs.claude.com/en/docs/build-with-claude/structured-outputs), 24 optional parameters and 16 union-typed parameters per request, across all strict schemas. It also has internal grammar-size limits ("Schema is too complex for compilation") and "a [compilation timeout of 180 seconds](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)". OpenAI allows "up to [5000 object properties total](https://platform.openai.com/docs/guides/structured-outputs), with up to 10 levels of nesting" and "up to 1000 enum values", and caps total string length for names, enum values and consts at 120,000 characters.

Key order differs as well. On OpenAI, "outputs will be produced in the same order as the [ordering of keys](https://platform.openai.com/docs/guides/structured-outputs) in the schema". On Claude, "[required properties appear first](https://docs.claude.com/en/docs/build-with-claude/structured-outputs), followed by optional properties".

## Gotchas that still give you bad output

**Refusals.** On Claude, a refusal comes back as [`stop_reason: "refusal"`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) with a 200 status, and you're billed for the tokens. The output "[might not match your schema](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) because the refusal message takes precedence". A schema property asking for step-by-step reasoning "might lead to a [`reasoning_extraction` refusal](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)". On OpenAI, a refusal "[does not necessarily follow the schema](https://platform.openai.com/docs/guides/structured-outputs)". It shows up as a [`type: "refusal"` content item](https://platform.openai.com/docs/guides/structured-outputs) on Responses and as `message.refusal` on Chat Completions.

**Truncation.** On Claude, [`stop_reason: "max_tokens"`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) means the output "might be incomplete and not match your schema", and the fix is to retry with a higher `max_tokens`. On OpenAI, check for `status == "incomplete"` with [`incomplete_details.reason == "max_output_tokens"`](https://platform.openai.com/docs/guides/structured-outputs) on Responses, or `finish_reason == "length"` on Chat Completions. A [`content_filter` reason](https://platform.openai.com/docs/guides/structured-outputs) also exists.

**Enum casing on Claude.** [Capitalization of `enum` and `const` strings](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) isn't guaranteed. The output can differ "[only in capitalization](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)" with no error, strict tools included, so compare case-insensitively.

**First-request latency.** On Claude, the first use of a schema adds "[additional latency while the grammar compiles](https://docs.claude.com/en/docs/build-with-claude/structured-outputs)". Compiled grammars are "[cached for 24 hours](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) from last use". Changing the schema's structure or the set of tools [invalidates that cache](https://docs.claude.com/en/docs/build-with-claude/structured-outputs), but changing only `name` or `description` doesn't. OpenAI's guide contradicts itself here. Under `response_format`, it ties first-schema latency to fine-tuned models and says "Other models [do not have this limitation](https://platform.openai.com/docs/guides/structured-outputs)". Under `text.format`, it says "the first request you make with any schema will have [additional latency](https://platform.openai.com/docs/guides/structured-outputs)". Our advice is to plan for the slower case until OpenAI clarifies.

**Prompt-cache effects.** On Claude, an injected system prompt makes input tokens "slightly higher", and "changing the `output_config.format` parameter will [invalidate any prompt cache](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) for that conversation thread". On OpenAI, `text.format` is one of the settings that [changes the cached prefix](https://platform.openai.com/docs/guides/prompt-caching). On supported GPT-6 and later models, you can switch schemas mid-conversation by appending a [`configuration_update` item](https://platform.openai.com/docs/guides/structured-outputs) and keeping the original top-level `text.format`.

**Features you can't combine on Claude.** [Citations return a 400](https://docs.claude.com/en/docs/build-with-claude/structured-outputs), and message prefilling is incompatible. Strict mode can't be used on `computer_toolset_20260801` or `browser_toolset_20260801`: "a request that sets it on either entry [is rejected](https://docs.claude.com/en/docs/agents-and-tools/tool-use/strict-tool-use)". Grammars "apply only to [Claude's direct output](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md), not to tool use calls, tool results, or thinking tags".

**Schemas are stored.** Claude caches the schema for [up to 24 hours](https://docs.claude.com/en/docs/build-with-claude/structured-outputs), and "PHI must not be included in JSON schema definitions". On OpenAI fine-tuned models, schemas are cached and "[not eligible for zero data retention](https://platform.openai.com/docs/guides/function-calling)". With parallel calls on those models, "[strict mode will be disabled](https://platform.openai.com/docs/guides/function-calling) for those calls".

## Our view

These are our recommendations, not the providers'.

- Use the strict, schema-based mode rather than JSON mode or prompt instructions, and set `strict: true` explicitly on OpenAI rather than relying on defaults that differ between its APIs.
- Before you parse, check the stop or finish reason. Refusals and truncation are the documented ways to get non-conforming output.
- Keep validating locally. Constrained decoding doesn't make the content correct, and Claude's enum casing can still differ.
- Keep schemas stable across a conversation. Changing them costs grammar compilation on Claude and cache hits on both.
