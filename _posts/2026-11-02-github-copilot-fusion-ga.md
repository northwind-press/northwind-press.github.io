---
title: "GitHub Copilot Fusion, which picks and combines models per task, is generally available"
author: "Software & Dev Reporter"
description: "Copilot admins should check which models Copilot Fusion may use and whether to make it the default; billing is per model used, 30% off on paid plans through 2026-11-30."
categories: [software]
kind: news
date: 2026-11-02 22:40
sources:
  - title: "Route and orchestrate models with GitHub Copilot Fusion"
    url: https://github.blog/changelog/2026-10-28-route-and-orchestrate-models-with-github-copilot-fusion
    publisher: "GitHub Changelog"
    date: "2026-10-28"
    accessed: "2026-11-02"
  - title: "About GitHub Copilot Fusion"
    url: https://docs.github.com/copilot/concepts/models/copilot-fusion
    publisher: "GitHub Docs"
    accessed: "2026-11-02"
corrections: []
---

GitHub made [Copilot Fusion generally available](https://github.blog/changelog/2026-10-28-route-and-orchestrate-models-with-github-copilot-fusion) on 2026-10-28. Instead of choosing a model, users choose Copilot Fusion in the model picker and an effort level, and Copilot decides which models handle each prompt{% include cite.html n=1 %}.

## How it works

There are three user-selectable effort levels: Fusion Standard for everyday coding, Fusion High for harder tasks, and Fusion Max for the most demanding ones{% include cite.html n=1 %}. Per prompt, Fusion uses one of three workflows{% include cite.html n=1 %}. In Single, one model does the task{% include cite.html n=1 %}. In Cascade, an efficient model drafts and a judge accepts the draft or escalates to a stronger model{% include cite.html n=1 %}. In Critique, according to the [Copilot Fusion documentation](https://docs.github.com/copilot/concepts/models/copilot-fusion), one model drafts, several models critique it in parallel, and the first model revises. The documentation warns that if Fusion discards a draft, file edits that draft already made are not undone{% include cite.html n=2 %}.

GitHub says Copilot Fusion Max scored 60 on the Artificial Analysis Coding Agent Index, within two points of Claude Code with Opus 5.5 Max, at about half the average API cost per task{% include cite.html n=1 %}. We have not verified that claim.

## Availability and billing

Fusion works in Visual Studio Code, the GitHub Copilot app, GitHub Copilot CLI, and JetBrains IDEs{% include cite.html n=1 %}. As of 2026-11-02, Fusion Standard is on every plan, but Fusion High and Max require Copilot Pro+, Max, Business, or Enterprise{% include cite.html n=2 %}. Research-preview users who chose auto, HydraFusion, or HydraFusion Max move automatically to the matching Fusion effort levels{% include cite.html n=1 %}.

There is no separate charge: each model Fusion uses is billed at its standard rate{% include cite.html n=1 %}{% include cite.html n=2 %}. High and Max can use more than one model per task, so a task may cost more AI credits than on Standard{% include cite.html n=2 %}. Paid plans get 30% off model costs when using Fusion through 2026-11-30{% include cite.html n=2 %}.

## What to do

Our advice for administrators: review your model policies, because Fusion only uses models your enterprise and organization have enabled{% include cite.html n=1 %}. Enterprise admins can exclude a model from Fusion without disabling it for everyone, and can make Fusion, at any effort level, the default through Enterprise managed settings{% include cite.html n=1 %}. Developers should review workspace changes before committing, as the documentation advises{% include cite.html n=2 %}.
