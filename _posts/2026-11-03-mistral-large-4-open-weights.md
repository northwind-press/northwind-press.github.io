---
title: "Mistral publishes open weights for Mistral Large 4 on Hugging Face"
author: "Northwind AI Desk"
description: "Mistral Large 4's weights are downloadable under a modified MIT license; check the Model-as-a-Service clause before you host it for others."
categories: [ai]
kind: news
date: 2026-11-03 08:05
sources:
  - title: "Mistral Large 4 (Le Chonk) is now open weight"
    url: https://mistral.ai/news/mistral-large-4-oss/
    publisher: "Mistral AI"
    date: "2026-10-29"
    accessed: "2026-11-03"
  - title: "mistralai/Mistral-Large-4-1T-A52B model card"
    url: https://huggingface.co/mistralai/Mistral-Large-4-1T-A52B
    publisher: "Mistral AI on Hugging Face"
    accessed: "2026-11-03"
  - title: "Mistral-Large-4-1T-A52B commit history"
    url: https://huggingface.co/api/models/mistralai/Mistral-Large-4-1T-A52B/commits/main
    publisher: "Hugging Face"
    accessed: "2026-11-03"
  - title: "Mistral-Large-4-1T-A52B model metadata"
    url: https://huggingface.co/api/models/mistralai/Mistral-Large-4-1T-A52B
    publisher: "Hugging Face"
    accessed: "2026-11-03"
  - title: "Mistral Ecosystem Open-Weight License"
    url: https://huggingface.co/mistralai/Mistral-Large-4-1T-A52B/blob/main/LICENSE
    publisher: "Mistral AI"
    accessed: "2026-11-03"
  - title: "Changelog"
    url: https://docs.mistral.ai/getting-started/changelog/
    publisher: "Mistral AI"
    accessed: "2026-11-03"
  - title: "Mistral Large 4"
    url: https://docs.mistral.ai/models/mistral-large-4-0
    publisher: "Mistral AI"
    accessed: "2026-11-03"
corrections: []
---
Mistral has released the weights of Mistral Large 4, its flagship model, according to its [announcement](https://mistral.ai/news/mistral-large-4-oss/), which the page's metadata dates 2026-10-29. The model entered public preview earlier in October{% include cite.html n=1 %}. Mistral says the released weights are an improved version, after further reinforcement learning since the preview{% include cite.html n=1 %}.

## What's released

The [Hugging Face model card](https://huggingface.co/mistralai/Mistral-Large-4-1T-A52B) describes a Mixture-of-Experts model of about 1 trillion parameters, with 49 billion active per token, or 52 billion including embeddings and output layers. It has a 1M-token context window and takes text and image input, with text output{% include cite.html n=2 %}. The repository's [commit history](https://huggingface.co/api/models/mistralai/Mistral-Large-4-1T-A52B/commits/main) shows its initial release on 2026-10-29 at 14:11 UTC.

The main checkpoint is quantized to FP8, according to the repository's [model metadata](https://huggingface.co/api/models/mistralai/Mistral-Large-4-1T-A52B). A separate NVFP4 checkpoint has a smaller memory footprint, targets Blackwell GPUs, and supports vLLM and SGLang{% include cite.html n=2 %}. The checkpoint also includes a draft head for speculative decoding{% include cite.html n=2 %}.

## License

The weights use the [Mistral Ecosystem Open-Weight License](https://huggingface.co/mistralai/Mistral-Large-4-1T-A52B/blob/main/LICENSE), a modified MIT license. If you or an affiliate run a "Model as a Service" business, you need a separate commercial license from Mistral before any commercial use{% include cite.html n=5 %}. The license defines that as giving third parties inference or post-training access with "meaningful control over the inputs, parameters, or training data"{% include cite.html n=5 %}. Internal use, end-user products that embed the model in specific features, and relaying requests to models hosted by others are outside that clause{% include cite.html n=5 %}.

## How to run it

The card names vLLM as recommended, plus SGLang, Transformers, and llama.cpp via GGUFs{% include cite.html n=2 %}. Its vLLM and SGLang examples use tensor parallelism across 8 GPUs, and the Transformers example runs on 8 GPUs with `torchrun`{% include cite.html n=2 %}. The card states no minimum hardware. It recommends `temperature=1.0` and `top_p=0.95`, and the Mistral API if local serving is subpar{% include cite.html n=2 %}.

## Relation to the API model

The card says the model is also served on Mistral's API as `mistral-large-4`{% include cite.html n=2 %}. That model entered public preview on 2026-10-06, when the [changelog](https://docs.mistral.ai/getting-started/changelog/) said "open weights are coming soon". Mistral's [API model page](https://docs.mistral.ai/models/mistral-large-4-0) still shows it as a public preview dated 2026-10-06, priced at US$0.70 input, US$0.07 cached input, and US$2.10 output per million tokens, as of 2026-11-03. That page gives the size differently from the card: 52 billion active and 1.05 trillion total parameters, with a 1.6-billion-parameter vision encoder{% include cite.html n=7 %}.

On security, Mistral says the model refuses malicious cyber requests, but that it saw "a potential for uplift to conduct real attacks" and is modifying its guardrails{% include cite.html n=1 %}.

## What's unknown

Neither the changelog nor the API page says whether `mistral-large-4` on the API now serves the improved released weights{% include cite.html n=6 %}{% include cite.html n=7 %}. The changelog has no entry for the weights release{% include cite.html n=6 %}.
