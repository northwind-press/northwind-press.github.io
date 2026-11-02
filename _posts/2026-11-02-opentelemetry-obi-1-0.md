---
title: "OpenTelemetry eBPF Instrumentation reaches 1.0, with Config v2 as its stable contract"
author: "Infra & Cloud Reporter"
description: "OBI v1.0.0 sets compatibility guarantees for Config v2, its Go API, deployment interfaces, and stable telemetry; move off frozen Config v1 and check the kernel and privilege requirements."
date: 2026-11-02 22:48
categories: [infra]
kind: news
sources:
  - title: "OpenTelemetry eBPF Instrumentation reaches v1.0.0"
    url: https://opentelemetry.io/blog/2026/obi-v1-release/
    publisher: "OpenTelemetry"
    date: "2026-10-30"
    accessed: "2026-11-02"
  - title: "OBI v1.0.0 release notes"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/releases/tag/v1.0.0
    publisher: "OpenTelemetry on GitHub"
    accessed: "2026-11-02"
  - title: "OBI Support Matrix (v1.0.0)"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/SUPPORT_MATRIX.md
    publisher: "OpenTelemetry on GitHub"
    accessed: "2026-11-02"
corrections: []
---

OpenTelemetry eBPF Instrumentation (OBI) has [reached v1.0.0](https://opentelemetry.io/blog/2026/obi-v1-release/), the project announced on 2026-10-30. OBI uses eBPF, together with runtime-specific instrumentation, to collect metrics and traces from running Linux applications without changes to their source code{% include cite.html n=1 %}.

## What the commitment covers

The [v1.0.0 release notes](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/releases/tag/v1.0.0) list the surfaces that now carry compatibility guarantees:

- the public Go API of the root `go.opentelemetry.io/obi` module, at source level;
- Config v2, its generated schema, and the supported subset of OpenTelemetry declarative configuration;
- documented CLI flags, environment variables, release binaries, and container image behavior;
- telemetry classified as `stable`, in its OTLP and built-in Prometheus forms;
- the supported environments and deprecation rules in the support matrix and versioning policy.

On those surfaces, minor releases may only add backward-compatible functionality, patches preserve compatibility, and breaking changes need a new major version{% include cite.html n=2 %}.

## What it leaves out

Telemetry classified as development, alpha, beta, or release candidate is outside the contract. So are network flow attribute names, pending semantic-convention alignment{% include cite.html n=2 %}. Go consumers get no forward ABI compatibility and should recompile against the version they use{% include cite.html n=2 %}. The Collector receiver, `go.opentelemetry.io/obi/collector`, stays on its own v0 line{% include cite.html n=2 %}. Stability protects the shape and meaning of emitted telemetry, not which signals appear{% include cite.html n=2 %}. The tagged README, `VERSIONING.md`, and support matrix still carry pre-v1 wording; the release notes' list of stable surfaces is what applies{% include cite.html n=2 %}.

For telemetry still evolving, the promise is a migration path. OBI describes its telemetry in a schema registry that works with OpenTelemetry Weaver, publishes schemas for transformations between versions, and documents other changes in release notes and migration guidance{% include cite.html n=1 %}. Schema transformations cannot translate every conditional rename, removal, or Prometheus-specific change{% include cite.html n=2 %}.

On the way to 1.0, OBI added instrumentation for MQTT, NATS, AMQP 1.0, MSSQL, Couchbase, Memcached, and Aerospike, and framework route discovery for Django, FastAPI, Flask, Rails, and .NET{% include cite.html n=1 %}. Known v1.0.0 limitations include application metrics that can stay missing after a pod restart until OBI restarts, and child spans that can start before their parents{% include cite.html n=2 %}.

## What to do

- **Move to Config v2.** It is the 1.0 configuration contract, available since v0.11.0. Config v1 is still supported but frozen, with no bug fixes or new features{% include cite.html n=2 %}. Follow the migration guide, use `obi config validate` and `obi config migrate`, review configuration set through environment variables, and compare telemetry in a canary before a broad rollout{% include cite.html n=1 %}.
- **Check the requirements.** The [support matrix](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/SUPPORT_MATRIX.md) requires Linux 5.8 or later (4.18 or later on RHEL-based distributions with the needed eBPF backports), a kernel that exposes BPF Type Format (BTF) information, `amd64` or `arm64`, and root or the Linux capabilities the enabled features need. By default OBI only warns about missing capabilities; set `OTEL_EBPF_ENFORCE_SYS_CAPS` to `true` to fail early with their names{% include cite.html n=3 %}.
- **Pin to `v1.0.0`.** Receiver users should pair it with `collector/v0.15.2`: `go get go.opentelemetry.io/obi/collector@v0.15.2 go.opentelemetry.io/obi@v1.0.0`{% include cite.html n=2 %}.