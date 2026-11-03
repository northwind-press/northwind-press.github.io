---
title: "Ai2 study finds LLM novelty judges swing by over 50 points on small prompt changes"
author: "Northwind AI Desk"
description: "If you use an LLM to judge whether ideas are novel, Ai2's benchmark shows one prompt rewording can flip over half its verdicts, so validate judges on the data you actually score."
categories: [ai]
kind: news
date: 2026-11-03 08:01
sources:
  - title: "Old Ideas, Novel Problems: The Instability of LLM-Based Novelty Evaluation"
    url: https://arxiv.org/abs/2610.02022
    publisher: "Sternlicht et al., arXiv"
    date: "2026-10-01"
    accessed: "2026-11-03"
  - title: "Old Ideas, Novel Problems"
    url: https://huggingface.co/blog/allenai/novelty-bench
    publisher: "Ai2"
    accessed: "2026-11-03"
  - title: "novelty-judge-bench"
    url: https://huggingface.co/datasets/allenai/novelty-judge-bench
    publisher: "Ai2"
    accessed: "2026-11-03"
  - title: "allenai/novelty-eval"
    url: https://github.com/allenai/novelty-eval
    publisher: "Ai2"
    accessed: "2026-11-03"
corrections: []
---

LLM judges of research-idea novelty change their verdicts sharply when a prompt is reworded, according to [a paper](https://arxiv.org/abs/2610.02022) from researchers at the Allen Institute for AI (Ai2), the Hebrew University of Jerusalem, and Microsoft. It was first posted to arXiv on 2026-10-01, and the current version, v3, is dated 2026-10-26{% include cite.html n=1 %}.

## What was measured

The authors mined ICLR 2026 peer reviews for passages where reviewers explicitly praised or disputed a paper's originality. They kept only submissions with unanimous signals at the top or bottom decile of their research area{% include cite.html n=1 %}. That gave 154 high-novelty and 145 lower-novelty human ideas, the "Human-Only" setup. A "Human+Generated" setup pairs the same 154 ideas with 154 ideas from Claude Sonnet 4.5, prompted once with no tools, and treats the generated ideas as less novel{% include cite.html n=4 %}. The paper calls these weak labels. It argues that its instability findings don't depend on them, because two setups that disagree on the same pair can't both be right{% include cite.html n=1 %}.

Six judges were tested: GPT-5.1, GPT-5.2, GPT-5.4, Claude Sonnet 4.5, Claude Opus 4.5, and Claude Opus 4.6. Each run changed one factor, such as the prompt, retrieval, or reasoning effort{% include cite.html n=1 %}. These are older models, and in our view the paper's results may not carry over to current ones.

## Key results

- **Prompt wording:** on Human+Generated pairs, dropping a sentence telling GPT-5.4 that reviewers found one idea novel cut its strict accuracy by 52.6 points, below 50%. The two prompts disagreed on 55.8% of identical pairs{% include cite.html n=1 %}. Ai2's [blog post](https://huggingface.co/blog/allenai/novelty-bench) puts that drop at 93.5% to 40.9%.
- **No shared fix:** the same change could help one judge and hurt another{% include cite.html n=1 %}.
- **Reasoning and retrieval:** lowering reasoning effort from high to low cost at most 7 points and was usually neutral. Retrieval gained at most 16 points, and only for some models{% include cite.html n=1 %}. An agentic search judge on GPT-5.6 Sol scored 0.78 macro-F1, 11 points behind Claude Opus 4.6, at 10 times the cost{% include cite.html n=1 %}.
- **Purpose-built judges:** the cheapest prompted setup beat Idea Novelty Checker and AI-Scientist by 8 to 29 macro-F1 points, at up to 32 times lower cost{% include cite.html n=1 %}.

## What it means for LLM-as-judge

When comparing two ideation systems, a prompt change alone flipped a quarter to a third of verdicts and moved the share awarded to the stronger system by up to 29 points{% include cite.html n=1 %}. The authors conclude that validating a judge on human-authored papers says little about how it behaves on generated ideas{% include cite.html n=1 %}.

## What's released

The benchmark is on [Hugging Face](https://huggingface.co/datasets/allenai/novelty-judge-bench){% include cite.html n=3 %}. The [code](https://github.com/allenai/novelty-eval) includes the data-collection pipeline, which can be rerun on a newer conference cycle. The code is licensed under Apache 2.0 and the data under ODC-BY 1.0{% include cite.html n=4 %}.

## What we don't know

The study covers novelty only{% include cite.html n=1 %}. The authors also describe their one-change-at-a-time design as partial coverage of the design space{% include cite.html n=1 %}. The paper and the repository disagree on the expert check. The paper says 25 of its 30 blind-annotated pairs were judge errors{% include cite.html n=1 %}, while the repository says 28{% include cite.html n=4 %}.
