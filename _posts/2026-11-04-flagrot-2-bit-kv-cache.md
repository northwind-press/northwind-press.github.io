---
title: "FlagRot preprint: 2-bit KV caches with less error, as a vLLM plugin"
author: "Northwind AI Desk"
description: "A new preprint's vLLM plugin stores 2- to 4-bit KV caches with lower error and up to 6.1 times the token capacity, but decodes slower than BF16 at large batch sizes."
categories: [ai]
kind: news
date: 2026-11-04 07:45
sources:
  - title: "FlagRot: Selective Rotation for Low-Bit KV Caches (arXiv:2611.03992)"
    url: https://arxiv.org/abs/2611.03992
    publisher: "arXiv"
    date: "2026-11-02"
    accessed: "2026-11-04"
  - title: "FlagRot: Selective Rotation for Low-Bit KV Caches (HTML, v1)"
    url: https://arxiv.org/html/2611.03992v1
    publisher: "arXiv"
    date: "2026-11-02"
    accessed: "2026-11-04"
  - title: "FlagRot_releaser"
    url: https://github.com/KunmingSHAO/FlagRot_releaser
    publisher: "GitHub"
    accessed: "2026-11-04"
corrections: []
---

A [preprint posted to arXiv](https://arxiv.org/abs/2611.03992) on 2026-11-02, which has not been peer-reviewed, describes FlagRot, a way to store a model's KV cache in 2 to 4 bits per value with less error. The KV cache is the per-token attention state that limits how much context and how many requests fit on a GPU{% include cite.html n=2 %}. The authors ship it as a plugin for vLLM{% include cite.html n=1 %}.

## What a vLLM user gets

Low-bit caches usually rotate every key before quantizing it{% include cite.html n=1 %}. The authors report that rotation can also hurt: it flattens spiky parts of a key but can add a peak to flat ones{% include cite.html n=1 %}. FlagRot chooses per 32-channel piece whether to rotate, and stores the choice in sign bits the cache already has{% include cite.html n=1 %}.

According to the [paper](https://arxiv.org/html/2611.03992v1), at 2.5 bits per value FlagRot cuts the error of KIVI, an existing 2-bit cache that quantizes keys per channel, from 18.7 to 12.4 (KL divergence ×10⁻³, geometric mean over 12 models). In vLLM it adds 2.9 points on RULER, a long-context benchmark, at 128k tokens, which the authors put at about 26% of what KIVI alone loses. On Qwen3-32B, it adds 1.94 LongBench points and isn't separated from the full-precision BF16 baseline{% include cite.html n=2 %}. Gains on two 8B models were smaller, 0.42 and 0.86 points, and on the hybrid Qwen3.8-27B, where 2-bit KIVI already matched BF16, there was nothing to recover{% include cite.html n=2 %}.

The authors report that the 2.5-bit layout holds 6.1 times as many tokens as BF16 on Qwen3-8B. At 32k context, a per-token variant at the same 2.5 bits generates 3.0 times the BF16 token rate, and 1.4 times the FP8 rate, within a 60 ms per-token budget{% include cite.html n=2 %}.

## The costs

The paper reports that at batch 64 the packed cache of the 27B model takes 33% longer per output token than BF16. Deciding per key also costs 5% of prefill throughput, which a fixed per-head mode avoids{% include cite.html n=2 %}.

## What was tested

Task evaluations cover four models from 8B to 32B parameters on NVIDIA H20 and H200 GPUs, with one inference engine. The fidelity study covers 12 to 15 open models{% include cite.html n=2 %}. The authors say the task evaluation includes no mixture-of-experts model and nothing above 32B. Most comparisons with other published low-bit caches are simulated, and served task comparisons cover only KIVI and the authors' own per-token variant{% include cite.html n=2 %}.

## The code

The [repository](https://github.com/KunmingSHAO/FlagRot_releaser) contains a simulator, an out-of-tree plugin for vLLM 0.30, CUDA kernels, and reproduction scripts. Its kernels target Hopper GPUs (`sm_90a`) and need the CUDA 12.9 toolkit to build{% include cite.html n=3 %}. The code is under Apache 2.0, except for evaluation files derived from LongBench and lm-evaluation-harness, which keep their MIT licenses{% include cite.html n=3 %}.

## Who wrote it

Most named authors, including corresponding author Chi Ying Tsui, are at the Hong Kong University of Science and Technology, and the paper says all the work was done there{% include cite.html n=2 %}.

## What we don't know

The paper doesn't test GPUs other than Hopper, models above 32B, or inference engines other than vLLM{% include cite.html n=2 %}. We haven't run the code.
