---
title: "Mistral releases Voxtral 3 speech models and a Voice Agents SDK in preview"
author: "Northwind AI Desk"
description: "Mistral's four Voxtral 3 transcription and text-to-speech models and its managed Voice Agents pipeline are in Public Preview on its API; no open weights are listed."
categories: [ai]
kind: news
date: 2026-11-03 08:02
sources:
  - title: "Changelog"
    url: https://docs.mistral.ai/getting-started/changelog/
    publisher: "Mistral AI"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "Voxtral 3"
    url: https://mistral.ai/news/voxtral-3/
    publisher: "Mistral AI"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "Voxtral TTS 3"
    url: https://docs.mistral.ai/models/voxtral-mini-tts-3-0
    publisher: "Mistral AI"
    accessed: "2026-11-03"
  - title: "Voxtral Mini Transcribe Realtime 3"
    url: https://docs.mistral.ai/models/voxtral-mini-transcribe-realtime-3-0
    publisher: "Mistral AI"
    accessed: "2026-11-03"
  - title: "Pricing"
    url: https://docs.mistral.ai/inference/pricing
    publisher: "Mistral AI"
    accessed: "2026-11-03"
  - title: "Voice agents overview"
    url: https://docs.mistral.ai/studio/audio/voice-agents/overview
    publisher: "Mistral AI"
    accessed: "2026-11-03"
corrections: []
---

Mistral released four Voxtral 3 speech models on 2026-10-20, all in Public Preview, according to its [changelog](https://docs.mistral.ai/getting-started/changelog/). It also released Voice Agents, a managed real-time pipeline that captures speech, transcribes it, generates a reply with a language model, and speaks it back{% include cite.html n=1 %}.

## The models

- **Voxtral TTS 3** (`voxtral-mini-tts-3-0`) does text-to-speech with zero-shot voice cloning and streaming{% include cite.html n=1 %}. Its [model card](https://docs.mistral.ai/models/voxtral-mini-tts-3-0) also lists `voxtral-mini-tts-realtime-3-0` and professional voice cloning, and gives about 90 ms to first audio, five output formats, and 34 emotion tags.
- **Voxtral Mini Transcribe 3** (`voxtral-mini-transcribe-3-0`) does offline transcription and diarization with timestamps{% include cite.html n=1 %}. Mistral says it has 4B parameters{% include cite.html n=2 %}.
- **Voxtral Mini Transcribe Realtime 3** (`voxtral-mini-transcribe-realtime-3-0`) transcribes in real time{% include cite.html n=1 %}. The [model card](https://docs.mistral.ai/models/voxtral-mini-transcribe-realtime-3-0) lists configurable latency from 80 ms to 2,400 ms, end-of-turn detection, context biasing, and diarization over one WebSocket session.
- **Voxtral Small Transcribe 3** (`voxtral-small-transcribe-3-0`) does offline transcription and diarization with timestamps{% include cite.html n=1 %}.

Mistral's [announcement](https://mistral.ai/news/voxtral-3/) calls the family state-of-the-art and publishes comparisons with other vendors' models, several of them internal evaluations. We haven't verified them.

## Languages

Mistral says the transcription models support 50 languages, including the 24 official EU languages, and that the realtime model covers more than 35{% include cite.html n=2 %}. It says TTS covers more than 35 languages and more than 50 dialects, with preset voices in 18 languages{% include cite.html n=2 %}.

## Pricing, as of 2026-11-03

Mistral's [pricing page](https://docs.mistral.ai/inference/pricing) lists Mini Transcribe 3 at US$0.0035 per minute, Small Transcribe 3 at US$0.004, Realtime 3 at US$0.008, and TTS 3 at US$13 per million characters. Cached input is a tenth of each rate{% include cite.html n=5 %}. Voice Agents cost US$0.04 per minute of conversation with Mistral Small 4, or US$0.08 with larger models{% include cite.html n=5 %}.

## Self-deployment and weights

The announcement says Voxtral 3 is available on Mistral's API and "for self-deployment on your own infrastructure"{% include cite.html n=2 %}. For running the full stack on-premises or in a private cloud, it tells readers to contact Mistral's team{% include cite.html n=2 %}. The pricing page labels models with downloadable weights "Self-hosted · Open weights". The Voxtral 3 models carry no such label, and the model cards list no weights or license{% include cite.html n=5 %}{% include cite.html n=3 %}{% include cite.html n=4 %}. We found no published self-deployment terms.

## Voice Agents interfaces

The changelog lists telephony, browser, and custom-audio interfaces{% include cite.html n=1 %}. According to the [Voice Agents overview](https://docs.mistral.ai/studio/audio/voice-agents/overview), the SDK is built on LiveKit and has Python and Node.js bindings for agents on your own machine or server. A TypeScript build runs in the browser, where your server creates the session so the API key never reaches the page{% include cite.html n=6 %}. Phone agents use SIP and are available only to enterprise customers through their account team at launch. On a phone line, client-side tools fail, so phone agents must use server-side tools{% include cite.html n=6 %}.

## What we don't know

Mistral hasn't said when the preview ends or whether prices will change at general availability{% include cite.html n=1 %}{% include cite.html n=5 %}.
