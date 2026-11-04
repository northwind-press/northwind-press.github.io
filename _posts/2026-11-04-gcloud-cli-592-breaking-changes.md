---
title: "gcloud 592.0.0 requires Java 25 for two emulators, drops system Python from Docker images"
author: "Northwind Infra & Cloud Desk"
description: "Before bumping CI to gcloud 592.0.0, check Datastore and Firestore emulator jobs for Java 25 and unset CLOUDSDK_PYTHON in the Debian-based Docker images."
date: 2026-11-04 08:06
categories: [infra]
kind: news
sources:
  - title: "Google Cloud CLI release notes: 592.0.0 (2026-11-03)"
    url: https://cloud.google.com/sdk/docs/release-notes
    publisher: "Google Cloud"
    date: "2026-11-03"
    accessed: "2026-11-04"
corrections: []
---

Google released version 592.0.0 of the Google Cloud CLI on 2026-11-03 with [breaking changes](https://cloud.google.com/sdk/docs/release-notes) that can affect CI pipelines and local test setups: the Datastore and Firestore emulators now need Java 25, and the Debian-based Docker images lose their system Python.

## Emulators need Java 25

The Datastore emulator (`gcloud beta emulators datastore start`) and the Firestore emulator (`gcloud emulators firestore start`) no longer run on Java versions before 25{% include cite.html n=1 %}. Google says to upgrade to Java 25 or later, or to stay on an earlier `gcloud` release, which supports Java 21{% include cite.html n=1 %}. The bundled Firestore emulator, v1.23.0, lists Java 25 as its minimum JRE{% include cite.html n=1 %}.

The packaging changed too. The `google-cloud-cli-datastore-emulator`, `google-cloud-cli-firestore-emulator`, `google-cloud-cli-pubsub-emulator`, `google-cloud-cli-app-engine-java`, and `google-cloud-cli-bqms` deb and rpm packages now depend on a headless JRE instead of a full JDK, preferring Java 25. Only the Datastore and Firestore emulator packages require Java 25 or later{% include cite.html n=1 %}.

## Docker images lose system Python and gcc

The Debian-based images no longer ship a system Python or C compiler. On both `linux/amd64` and `linux/arm64`, gcloud, gsutil, and bq now always run on the bundled Python{% include cite.html n=1 %}. What each image loses:

| Image tag | Removed packages |
|---|---|
| `:latest`, `:slim`, `:debian_component_based` | `python3`, `python3-dev`, `python3-pip`, `python3-crcmod`, `gcc` |
| `:emulators` | `python3`, `python3-crcmod` |
| `:stable` (`linux/arm64` only) | `python3-dev`, `python3-crcmod` |

Source: Google Cloud CLI release notes{% include cite.html n=1 %}.

In these images, setting `CLOUDSDK_PYTHON=python3`, `CLOUDSDK_GSUTIL_PYTHON`, or `CLOUDSDK_BQ_PYTHON` now makes every gcloud, gsutil, or bq call fail, because there is no `python3` on `PATH`{% include cite.html n=1 %}.

## What to do

- **Check before you bump.** Look for CI images and emulator jobs that pull `:latest`, `:slim`, `:debian_component_based`, `:emulators`, or `:stable` on arm64, and for jobs that run the Datastore or Firestore emulator on Java older than 25{% include cite.html n=1 %}.
- **Unset the Python variables.** Remove `CLOUDSDK_PYTHON`, `CLOUDSDK_GSUTIL_PYTHON`, and `CLOUDSDK_BQ_PYTHON` from jobs that use these images, so the tools fall back to the bundled Python{% include cite.html n=1 %}.
- **Install what you need on top.** If a workflow needs a system Python, install it on the image, for example with `apt-get install python3`. That doesn't change which Python gcloud uses. To compile C extensions, also install `build-essential python3-dev`{% include cite.html n=1 %}.
- **Or, for the emulators, pin the previous release.** Google's alternative for the emulators is an earlier `gcloud` version; the release before 592.0.0 is 591.0.0, dated 2026-10-27{% include cite.html n=1 %}.
