---
title: "Structured outputs on Claude and OpenAI: what's guaranteed, what's not supported, what still breaks"
author: "Northwind Features"
description: "How to get schema-valid JSON from the Claude and OpenAI APIs, what each one actually guarantees, which JSON Schema features each rejects, and the cases that still return output you can't parse."
categories: [ai]
kind: feature
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
audio:
  src: /assets/audio/2026-11-02-structured-outputs.mp3
  duration: "11:07"
  narrator: "George (ElevenLabs AI voice)"
  narrated_from: a7fdd95ad1644abed522bde37a79165bcfa7e589
---
Both the Claude API and the OpenAI API can constrain a model to a JSON Schema you supply, either for the response itself or for a tool call's arguments. By the providers' own docs, that still isn't the same as "every response matches". This piece covers how to turn it on, what each provider promises, which schema features each rejects, and the cases where you still get output that doesn't match. Everything below comes from each provider's documentation as checked on 2026-11-02.

## Claude: `output_config.format` and strict tools

For a JSON response, put your schema in [`output_config.format`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs) with `type: "json_schema"`. The JSON comes back "in the response's text content block"{% include cite.html n=1 %}. For tool calls, set [`"strict": true`](https://docs.claude.com/en/docs/agents-and-tools/tool-use/strict-tool-use) as a top-level property of the tool definition, alongside `name`, `description` and `input_schema`. You can use both "together in the same request"{% include cite.html n=1 %}.

If you used the beta, note that `output_format` "has moved to `output_config.format`"{% include cite.html n=1 %}. The old parameter is deprecated, works only with the `structured-outputs-2025-11-13` beta header and otherwise returns a 400{% include cite.html n=1 %}.

The SDKs include helpers such as Python's [`client.messages.parse()`](https://docs.claude.com/en/docs/build-with-claude/structured-outputs.md) and TypeScript's `zodOutputFormat()` and `jsonSchemaOutputFormat()`. Some helpers rewrite your schema before sending it{% include cite.html n=1 %}. They strip unsupported constraints, copy them into the field description, add `additionalProperties: false`, and then validate the response locally "if the helper validates responses"{% include cite.html n=1 %}.

Anthropic says structured outputs "are available on every model"{% include cite.html n=1 %}. The feature isn't available in Managed Agents{% include cite.html n=6 %}.

## OpenAI: `text.format`, `response_format` and strict functions

On the Responses API, use [`text: { format: { type: "json_schema", "strict": true, "schema": … } }`](https://platform.openai.com/docs/guides/structured-outputs). On Chat Completions, use `response_format: { type: "json_schema", json_schema: { name, strict: true, schema } }`{% include cite.html n=3 %}. The SDKs' `responses.parse()` and `chat.completions.parse()` accept Pydantic or Zod models{% include cite.html n=3 %}. For function calling, set [`"strict": true`](https://platform.openai.com/docs/guides/function-calling) on the function definition.

Leaving `strict` out behaves differently on the two APIs. Responses "will attempt to normalize your schema into strict mode when possible, and will fall back to non-strict, best-effort", in which case the tool shows `strict: false`{% include cite.html n=4 %}. "Chat Completions requests remain non-strict by default."{% include cite.html n=4 %} JSON mode (`{ "type": "json_object" }`) guarantees valid JSON only, not schema adherence, and errors unless "JSON" appears somewhere in the context{% include cite.html n=3 %}.

The `json_schema` format is "only supported with the `gpt-4o-mini`, `gpt-4o-mini-2024-07-18`, and `gpt-4o-2024-08-06` model snapshots and later"{% include cite.html n=3 %}. GPT-6 Astra and GPT-6.1 Sol "require the Responses API for tool calling"{% include cite.html n=4 %}.

## What each actually guarantees

Anthropic says "Structured outputs guarantee schema-compliant responses through constrained decoding"{% include cite.html n=1 %}. For strict tools, "Tool `input` strictly follows the `input_schema`" and "Tool `name` is always valid"{% include cite.html n=2 %}. The same page qualifies this: compliance is guaranteed "in most cases", and the exceptions are covered below{% include cite.html n=1 %}.

OpenAI says Structured Outputs "ensures the model will always generate responses that adhere to your supplied JSON Schema"{% include cite.html n=3 %}, and strict functions "reliably adhere to the function schema, instead of being best effort"{% include cite.html n=4 %}. OpenAI also warns that "Structured Outputs can still contain mistakes"{% include cite.html n=3 %}. If the input has nothing to do with the schema, the model "will always try to adhere to the provided schema, which can result in hallucinations"{% include cite.html n=3 %}.

In our reading, both guarantees cover the shape of the output, not whether its content is right.

## Schema features you can't use

Both providers support a subset of JSON Schema, and the subsets differ (Anthropic{% include cite.html n=6 %}, OpenAI{% include cite.html n=3 %}):

| Feature | Claude | OpenAI |
|---|---|---|
| Recursive schemas | Not supported | Supported |
| `minimum`, `maximum`, `multipleOf` | Not supported | Supported |
| `minItems` | Only 0 or 1 | Supported |
| `maxItems` | Not supported | Supported |
| `allOf` | Supported, except with `$ref` | Not supported |
| Optional fields | Allowed | Every field must be `required`; use a union with `null` |
| `additionalProperties` | Must be `false` | Must be `false` |

On Claude, `pattern` regexes can use anchors, `* + ?`, simple `{n,m}`, character classes and groups, but not backreferences, lookaround, `\b`/`\B` or large `{n,m}` ranges{% include cite.html n=6 %}. Unsupported features return "a 400 error with details"{% include cite.html n=6 %}. OpenAI requires the root to be an object, not `anyOf`{% include cite.html n=3 %}. Its fine-tuned models reject a longer list of keywords, including `pattern`, `format`, `minimum` and `maximum`{% include cite.html n=3 %}. An unsupported schema with `strict: true` returns an error{% include cite.html n=3 %}. OpenAI's strict functions have the same rules: `additionalProperties: false` on every object, every property `required`, and optional fields written as a union with `null`{% include cite.html n=4 %}.

There are size limits too. Claude allows 20 strict tools, 24 optional parameters and 16 union-typed parameters per request, across all strict schemas{% include cite.html n=1 %}. It also has internal grammar-size limits ("Schema is too complex for compilation") and "a compilation timeout of 180 seconds"{% include cite.html n=1 %}. OpenAI allows "up to 5000 object properties total, with up to 10 levels of nesting" and "up to 1000 enum values", and caps total string length for names, enum values and consts at 120,000 characters{% include cite.html n=3 %}.

Key order differs as well. On OpenAI, "outputs will be produced in the same order as the ordering of keys in the schema"{% include cite.html n=3 %}. On Claude, "required properties appear first, followed by optional properties"{% include cite.html n=1 %}.

## Gotchas that still give you bad output

**Refusals.** On Claude, a refusal comes back as `stop_reason: "refusal"` with a 200 status, and you're billed for the tokens{% include cite.html n=1 %}. The output "might not match your schema because the refusal message takes precedence"{% include cite.html n=1 %}. A schema property asking for step-by-step reasoning "might lead to a `reasoning_extraction` refusal"{% include cite.html n=1 %}. On OpenAI, a refusal "does not necessarily follow the schema"{% include cite.html n=3 %}. It shows up as a `type: "refusal"` content item on Responses and as `message.refusal` on Chat Completions{% include cite.html n=3 %}.

**Truncation.** On Claude, `stop_reason: "max_tokens"` means the output "might be incomplete and not match your schema", and the fix is to retry with a higher `max_tokens`{% include cite.html n=1 %}. On OpenAI, check for `status == "incomplete"` with `incomplete_details.reason == "max_output_tokens"` on Responses, or `finish_reason == "length"` on Chat Completions{% include cite.html n=3 %}. A `content_filter` reason also exists{% include cite.html n=3 %}.

**Enum casing on Claude.** Capitalization of `enum` and `const` strings isn't guaranteed{% include cite.html n=1 %}. The output can differ "only in capitalization" with no error, strict tools included, so compare case-insensitively{% include cite.html n=1 %}.

**First-request latency.** On Claude, the first use of a schema adds "additional latency while the grammar compiles"{% include cite.html n=1 %}. Compiled grammars are "cached for 24 hours from last use"{% include cite.html n=1 %}. Changing the schema's structure or the set of tools invalidates that cache, but changing only `name` or `description` doesn't{% include cite.html n=1 %}. OpenAI's guide contradicts itself here. Under `response_format`, it ties first-schema latency to fine-tuned models and says "Other models do not have this limitation"{% include cite.html n=3 %}. Under `text.format`, it says "the first request you make with any schema will have additional latency"{% include cite.html n=3 %}. Our advice is to plan for the slower case until OpenAI clarifies.

**Prompt-cache effects.** On Claude, an injected system prompt makes input tokens "slightly higher", and "changing the `output_config.format` parameter will invalidate any prompt cache for that conversation thread"{% include cite.html n=1 %}. On OpenAI, `text.format` is one of the settings that [changes the cached prefix](https://platform.openai.com/docs/guides/prompt-caching){% include cite.html n=5 %}. On supported GPT-6 and later models, you can switch schemas mid-conversation by appending a `configuration_update` item and keeping the original top-level `text.format`{% include cite.html n=3 %}.

**Features you can't combine on Claude.** Citations return a 400, and message prefilling is incompatible{% include cite.html n=1 %}. Strict mode can't be used on `computer_toolset_20260801` or `browser_toolset_20260801`: "a request that sets it on either entry is rejected"{% include cite.html n=2 %}. Grammars "apply only to Claude's direct output, not to tool use calls, tool results, or thinking tags"{% include cite.html n=6 %}.

**Schemas are stored.** Claude caches the schema for up to 24 hours, and "PHI must not be included in JSON schema definitions"{% include cite.html n=1 %}. On OpenAI fine-tuned models, schemas are cached and "not eligible for zero data retention"{% include cite.html n=4 %}. With parallel calls on those models, "strict mode will be disabled for those calls"{% include cite.html n=4 %}.

## Our view

These are our recommendations, not the providers'.

- Use the strict, schema-based mode rather than JSON mode or prompt instructions, and set `strict: true` explicitly on OpenAI rather than relying on defaults that differ between its APIs.
- Before you parse, check the stop or finish reason. Refusals and truncation are the documented ways to get non-conforming output.
- Keep validating locally. Constrained decoding doesn't make the content correct, and Claude's enum casing can still differ.
- Keep schemas stable across a conversation. Changing them costs grammar compilation on Claude and cache hits on both.
