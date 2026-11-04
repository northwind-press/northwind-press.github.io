---
title: "Google's A2UI adds Express, a compact format agents write instead of UI JSON"
author: "Northwind AI Desk"
description: "A2UI agent builders can switch to the Express inference format with one generator argument and keep their catalogs and renderers, but check which SDK release makes it the default."
categories: [ai]
kind: news
date: 2026-11-04 07:39
sources:
  - title: "Fast, reliable A2UI, with swappable inference formats"
    url: https://developers.googleblog.com/fast-reliable-a2ui/
    publisher: "Google for Developers"
    date: "2026-10-27"
    accessed: "2026-11-04"
  - title: "A2UI: Agent-to-User Interface"
    url: https://github.com/a2ui-project/a2ui
    publisher: "A2UI project, GitHub"
    accessed: "2026-11-04"
  - title: "a2ui-agent-sdk changelog"
    url: https://github.com/a2ui-project/a2ui/blob/main/python/a2ui_agent/CHANGELOG.md
    publisher: "A2UI project, GitHub"
    accessed: "2026-11-04"
  - title: "a2ui_agent"
    url: https://pub.dev/packages/a2ui_agent
    publisher: "pub.dev"
    accessed: "2026-11-04"
corrections: []
---

On 2026-10-27, Google's A2UI project added swappable inference formats and a new format, A2UI Express, according to a [Google for Developers post](https://developers.googleblog.com/fast-reliable-a2ui/). Agents now write Express, a compact text format, and deterministic code in the A2UI Agent SDKs compiles it into standard A2UI JSON messages{% include cite.html n=1 %}.

## What A2UI is

A2UI is an open protocol for agent-generated UI. A client advertises a catalog of trusted components, the agent sends messages describing a UI built from that catalog, and the client's own renderer draws it{% include cite.html n=1 %}. The [project repository](https://github.com/a2ui-project/a2ui) describes it as an early-stage public preview, licensed under Apache 2.0. The current production release is v0.9.1, and v1.0 is a release candidate{% include cite.html n=2 %}.

## What changes for agent builders

You choose the format with one argument, `inference_format_factory`, when you create the generator. The SDK generates the format's prompt instructions and its compiler from your catalog's JSON schema, so a format can't describe a component the catalog lacks{% include cite.html n=1 %}. Express writes one Python-like assignment per line, and Google says catalogs and renderers stay as they are{% include cite.html n=1 %}.

The post calls Express "the new default"{% include cite.html n=1 %}. In the Python SDK's [changelog](https://github.com/a2ui-project/a2ui/blob/main/python/a2ui_agent/CHANGELOG.md), version 0.9.0 (2026-10-17) adds `ExpressFormatFactory`, but the breaking change that makes Express the default for `A2uiGenerator` is listed under "Unreleased"{% include cite.html n=3 %}. Builders on 0.9.0 should pass the factory explicitly, as Google's own example does{% include cite.html n=1 %}.

## SDK coverage

The post lists Express in Python (`a2ui-agent-sdk` 0.9.0), TypeScript (`@a2ui/agent`) and Dart (`a2ui_agent` 0.0.1-wip004){% include cite.html n=1 %}. The repository's package table lists the TypeScript agent SDK as "Not published yet"{% include cite.html n=2 %}. We could not reach its npm page to check. The Dart [package page](https://pub.dev/packages/a2ui_agent) says it supports only protocol v0.9 and only the Express format{% include cite.html n=4 %}.

## Google's speed claims

Google says Express cuts latency by up to 3x and needs up to 3x fewer tokens than Direct JSON. It says decision models such as Jev cut latency by up to 80x{% include cite.html n=1 %}. The post doesn't say how those figures were measured. It describes running four candidate formats through a 51-task eval on gemini-3.5-flash with thinking on and off, but shows the results only as a chart{% include cite.html n=1 %}.

## Decision models for known-shape screens

For screens with a set shape, such as settings or checkout, the post suggests Jev, a model from TypeSafe that answers typed questions with probabilities instead of generating text. In the open-source Apparite (jev2ui) example, Jev picks the layout, code builds the components, and gemini-3.5-flash-lite writes the text{% include cite.html n=1 %}. In one run of 11 prompts, components appeared in 92 to 298 ms and screens finished in 0.8 to 1.7 s. The project calls that a first look from a small sample{% include cite.html n=1 %}. The A2UI SDKs don't yet include a decision-model inference format{% include cite.html n=1 %}.

## What we don't know

We could not confirm which released SDK versions ship Express as the default, or the eval method behind the 3x and 80x figures.
