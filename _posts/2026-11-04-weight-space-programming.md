---
title: "Weight-space programming: what a new blog post claims about LLMs editing weights"
author: "Northwind Features"
description: "A blog post says an LLM can read and edit neural-network weights directly; here is what the authors report, what critics dispute, and how to inspect the released model and logs."
categories: [curiosities]
kind: feature
date: 2026-11-04 05:31
sources:
  - title: "Sparks of Weight-Space Programming: LLMs can natively read & write neural network weights"
    url: https://rikiyat.github.io/blog/weight-space-programming/
    publisher: "Rikiya Takehi, Jayden Teoh, Alex Zhang, and Omar Khattab"
    date: "2026-11-02"
    accessed: "2026-11-04"
  - title: "RikiyaT/lm_understand-logs"
    url: https://github.com/RikiyaT/lm_understand-logs
    publisher: "Rikiya Takehi"
    accessed: "2026-11-04"
  - title: "RikiyaT/Qwen3.5-0.8B-weight-space-programming"
    url: https://huggingface.co/RikiyaT/Qwen3.5-0.8B-weight-space-programming
    publisher: "Hugging Face"
    accessed: "2026-11-04"
  - title: "The 'Astra can read and write weights to improve Qwen' post is misleading"
    url: https://honnibal.dev/blog/astra-read-write-misleading
    publisher: "Matthew Honnibal"
    accessed: "2026-11-04"
  - title: "LLMs are not superhuman at reading and writing neural network weights"
    url: https://www.seangoedecke.com/llms-are-not-superhuman-at-reading-and-writing-neural-network-weights/
    publisher: "Sean Goedecke"
    accessed: "2026-11-04"
  - title: "Tracr: Compiled Transformers as a Laboratory for Interpretability"
    url: https://arxiv.org/abs/2301.05062
    publisher: "arXiv"
    date: "2023-01-12"
    accessed: "2026-11-04"
  - title: "google-deepmind/tracr"
    url: https://github.com/google-deepmind/tracr
    publisher: "Google DeepMind"
    accessed: "2026-11-04"
  - title: "HyperNetworks"
    url: https://arxiv.org/abs/1609.09106
    publisher: "arXiv"
    accessed: "2026-11-04"
  - title: "Editing Models with Task Arithmetic"
    url: https://arxiv.org/abs/2212.04089
    publisher: "arXiv"
    accessed: "2026-11-04"
  - title: "Equivariant Architectures for Learning in Deep Weight Spaces"
    url: https://arxiv.org/abs/2301.12780
    publisher: "arXiv"
    accessed: "2026-11-04"
corrections: []
audio:
  src: /assets/audio/2026-11-04-weight-space-programming.mp3
  duration: "9:57"
  narrator: "George (ElevenLabs AI voice)"
  narrated_from: 16b29bdaa4d2f1131a0ca34896d4526b4cb0c991
---
Can a language model change what a neural network does by writing its weights directly, with no training loop at all? Four MIT CSAIL researchers say yes, at least sometimes, in a 2026-11-02 [blog post](https://rikiyat.github.io/blog/weight-space-programming/) that calls the idea "weight-space programming". It is a single blog post, not peer-reviewed, and it is only days old. What follows is what the authors report, what two critics dispute, and what you can look at yourself.

## What it is

The post defines the idea this way: "a general-purpose LLM reads and writes a network's weights directly (i.e., not through an optimizer, and in particular not with gradient descent) around some natural language spec"{% include cite.html n=1 %}. The authors are Rikiya Takehi, Jayden Teoh, Alex Zhang, and Omar Khattab, listed as MIT CSAIL in the page's metadata{% include cite.html n=1 %}. The researchers name the idea: "We call this Weight-Space Programming"{% include cite.html n=1 %}.

The model doing the reading and writing is OpenAI's GPT-6 Astra, run through the Codex CLI with its built-in tools switched off, according to the authors' [released logs](https://github.com/RikiyaT/lm_understand-logs).

## What was actually shown

The experiments fall into two groups, and the difference matters.

**Small networks, no tools.** In these runs the model had no Python and didn't run the networks{% include cite.html n=1 %}:

- The authors report that it named the game for each of four small PPO game-playing policies of 17,253 weights each, and named the shape each of three tiny diffusion models generates{% include cite.html n=1 %}.
- The authors report that, in one shot, it fixed a stuck Kinetix car policy of 171,664 weights, taking it from no successes in 256 episodes to 1,024 out of 1,024 by editing 3.5% of the weights{% include cite.html n=1 %}.
- The authors report that it wrote MinAtar game networks from scratch that scored 517.4 in Breakout, 53.1 in Seaquest and 53.2 in Asterix{% include cite.html n=1 %}. Those beat PPO trained for 100 million steps in all three games, but against PPO trained for 500 million steps (25.3, 88.9 and 55.2) they won only Breakout{% include cite.html n=1 %}.

**Larger networks, with Python.** Other runs gave the model a Python sandbox{% include cite.html n=1 %}. The authors report that, without running the networks, it named the training language of three 7.2-million-parameter character models from their middle blocks and found every copying head{% include cite.html n=1 %}. On Go, with 1.5 million weights, they report it won more than half its games against two small PPO networks with no forward passes, and beat an equal-sized PPO network once allowed 50{% include cite.html n=1 %}.

**The Qwen result.** The headline claim is the one with the most help. Here the model had Python and could run up to 50 forward-pass batches on practice problems{% include cite.html n=1 %}. The authors report that it subtracted one direction from 64 output columns in layers 15 and 19 of Qwen3.5-0.8B, changing 131,072 weights, or 0.016%{% include cite.html n=1 %}. They report these changes{% include cite.html n=1 %}:

- MATH-500: 7.9% to 48.1%
- GSM8K: 13.8% to 67.1%
- IFEval: 21.0% to 62.3%
- answers hitting the token limit: 93% to 33%

With only 10 or 25 forward-pass batches, the authors report, the loops barely went away and MATH-500 reached only 12.3% and 14.1%{% include cite.html n=1 %}.

**What didn't work.** The post reports its own failures. The model couldn't spot a sycophantic Gemma 3 270M from its weights alone, though it could once given attention patterns, and it couldn't make Gemma 3 270M better at math{% include cite.html n=1 %}. The authors conclude that editing "could remove an obstacle that hid an ability, but it could not add an ability the model lacked"{% include cite.html n=1 %}.

**What backs it up.** The logs include the prompts, replies, the code that ran and its outputs, and the evaluations, and the README says all 1,125 turns were audited as tool-free{% include cite.html n=2 %}. The edited Qwen checkpoint is public. Its [model card](https://huggingface.co/RikiyaT/Qwen3.5-0.8B-weight-space-programming) says Hugging Face user akhaliq rebuilt it from the logs with hash-verified tensors and re-ran the full MATH-500 benchmark. That re-run scored 51.0%, against the post's 48.1%, with 31.6% of answers hitting the token limit{% include cite.html n=3 %}. That is a partial reproduction from the released logs, not an independent replication of how the edit was found.

## What's contested

Two engineers have published critiques, both as blog posts. Matthew Honnibal, in a post titled ["The 'Astra can read and write weights to improve Qwen' post is misleading"](https://honnibal.dev/blog/astra-read-write-misleading), writes that the "just by looking at the raw weights" setting "only appears in experiments 1, 2 and 4, on networks of 17K–172K weights", and that "every experiment involving a real language model uses Python"{% include cite.html n=4 %}. He reads the Qwen result as showing that the model "can be prompted to devise and perform tasks that a human ML engineer could do", and argues that it and the other Python experiments "don't belong in the same post or paper as the experiments that read the weights directly"{% include cite.html n=4 %}.

Sean Goedecke's [post](https://www.seangoedecke.com/llms-are-not-superhuman-at-reading-and-writing-neural-network-weights/) makes the tools point in passing. Of the game networks, he writes that it's "neat that Astra was able to calculate the norms in its head without executing Python, but not *that* impressive"{% include cite.html n=5 %}. A footnote on the Qwen run adds: "Unlike with the toy game networks, it had access to Python"{% include cite.html n=5 %}. His main argument is about the Qwen fix, which he calls "exactly what a competent human researcher could have and would have done"{% include cite.html n=5 %}.

## What's speculation

The post ends with a "What comes next" section: auditing models without evaluation, one-shot model initialization, zero-data capability steering, recursive self-improvement, and grafting circuits across architectures{% include cite.html n=1 %}. The authors present them as things weight-space programming "may" allow, and call their own results "very early"{% include cite.html n=1 %}. None of them is demonstrated in the post. Treat that section as the authors' speculation.

## How to try it

We haven't run any of these steps ourselves. They come from the projects' own pages.

- **Browser demo.** The model card points to a Hugging Face Space where you "type a problem, watch the base model loop while the edited one solves it"{% include cite.html n=3 %}.
- **Tracr, the settled precursor.** Tracr's [repository](https://github.com/google-deepmind/tracr) says to clone it, run `pip3 install .`, and compile a RASP `reverse` program to a Haiku model, and that running the tests "should take about 60 seconds". The README doesn't state a hardware requirement. More on Tracr below.
- **Run the edited model.** The card's usage loads `RikiyaT/Qwen3.5-0.8B-weight-space-programming` in vLLM in bfloat16 with `max_model_len=34816` and the card's sampling settings{% include cite.html n=3 %}. The card's full MATH-500 evaluation took 51 minutes on one NVIDIA H200{% include cite.html n=3 %}.
- **Inspect the edit.** Browse the per-experiment folders in the logs repository. `exp8_math/code/apply_edit.py` rebuilds the Qwen edit and checks its hashes{% include cite.html n=2 %}{% include cite.html n=3 %}. Re-running the experiments themselves needs `gpt-6-astra` through the Codex CLI{% include cite.html n=2 %}.

## The older lineage

Writing weights without gradient descent isn't new. The post itself cites two earlier approaches{% include cite.html n=1 %}. [Tracr](https://arxiv.org/abs/2301.05062), a 2023 paper with code that its arXiv listing says was presented at NeurIPS 2023, compiles programs written in the RASP language into transformer weights. [HyperNetworks](https://arxiv.org/abs/1609.09106), a 2016 preprint, uses one network to generate another's weights.

Two more strands sit nearby. [Task arithmetic](https://arxiv.org/abs/2212.04089), a peer-reviewed ICLR 2023 paper, edits models by adding and subtracting weight differences. Work on [learning in deep weight spaces](https://arxiv.org/abs/2301.12780), peer-reviewed at ICML 2023, builds networks that take other networks' weights as input.

## Our view

These are our opinions, not the authors'.

- The released logs and a checkpoint that others can rebuild and re-run make this more checkable than most "AI does X" claims.
- The small-network, no-tools results and the Qwen result are different claims. The first group is the strongest support for "native" reading and writing; the Qwen result looks more like a model doing an ML engineer's job with tools and test runs.
- The authors' own conclusion, that editing uncovered abilities rather than adding new ones, is the most useful sentence in the post.
- Wait for a replication of the procedure, not just the checkpoint, before treating any of this as settled.
