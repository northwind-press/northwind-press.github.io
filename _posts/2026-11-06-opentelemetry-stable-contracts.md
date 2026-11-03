---
title: "OBI 1.0 and OTTL v1: what OpenTelemetry's new stable contracts cover, and what to do"
author: "Northwind Features"
description: "OBI v1.0.0 and OTTL v1 freeze specific surfaces, not everything; here is what each covers, what stays experimental, and the steps to take before you upgrade."
categories: [infra]
kind: feature
sources:
  - title: "OpenTelemetry eBPF Instrumentation reaches 1.0, with Config v2 as its stable contract"
    url: https://northwind-press.github.io/2026/11/02/opentelemetry-obi-1-0/
    publisher: "Northwind Press"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "OpenTelemetry's OTTL reaches v1, freezing its syntax and standard functions for 1.x"
    url: https://northwind-press.github.io/2026/11/02/ottl-v1/
    publisher: "Northwind Press"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "OpenTelemetry eBPF Instrumentation reaches v1.0.0"
    url: https://opentelemetry.io/blog/2026/obi-v1-release/
    publisher: "OpenTelemetry"
    date: "2026-10-30"
    accessed: "2026-11-03"
  - title: "OBI v1.0.0 release notes"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/releases/tag/v1.0.0
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "OBI VERSIONING.md (v1.0.0)"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/VERSIONING.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "OBI TELEMETRY.md (v1.0.0)"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/TELEMETRY.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "OBI Support Matrix (v1.0.0)"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/SUPPORT_MATRIX.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "OBI Config v1 to v2 migration guide (v1.0.0)"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/devdocs/config/version-2.0/migration.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "Privileges and capabilities required by OBI"
    url: https://opentelemetry.io/docs/zero-code/obi/security/
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "OpenTelemetry Transformation Language reaches v1"
    url: https://opentelemetry.io/blog/2026/ottl-v1/
    publisher: "OpenTelemetry"
    date: "2026-10-27"
    accessed: "2026-11-03"
  - title: "opentelemetry-collector-contrib v0.164.0 release notes"
    url: https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/tag/v0.164.0
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "ottl: Feature Gates (pkg/ottl/documentation.md)"
    url: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/b21bf1a21be57988b655aa03ff664dbb250d6a99/pkg/ottl/documentation.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "Experimental OTTL functions (xottl/ottlfuncs/README.md)"
    url: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/b21bf1a21be57988b655aa03ff664dbb250d6a99/pkg/ottl/xottl/ottlfuncs/README.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "OTTL functions (ottlfuncs/README.md)"
    url: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/b21bf1a21be57988b655aa03ff664dbb250d6a99/pkg/ottl/ottlfuncs/README.md
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
  - title: "Epic: Stable OBI 1.0 Release (issue #1133)"
    url: https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/issues/1133
    publisher: "OpenTelemetry"
    accessed: "2026-11-03"
corrections: []
---
OpenTelemetry declared two pieces of its stack stable within a week. [Our news report on OBI v1.0.0](https://northwind-press.github.io/2026/11/02/opentelemetry-obi-1-0/) covers the eBPF instrumentation release. A [second report](https://northwind-press.github.io/2026/11/02/ottl-v1/) covers OTTL, the Collector's transformation language, reaching v1. In both cases "stable" means a written list of surfaces, not the whole project. This piece sets out what each contract covers, what it leaves out, and what to do before upgrading. Versions are as of 2026-11-03.

## OBI v1.0.0: what is stable

The [v1.0.0 release notes](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/releases/tag/v1.0.0) list five stable surfaces:

- the public Go API of the root module `go.opentelemetry.io/obi`, at source level;
- Config v2, its generated schema, and the supported subset of OpenTelemetry declarative configuration;
- documented CLI flags, environment variables, release binaries and container image behavior;
- telemetry classified `stable`, in both OTLP and the built-in Prometheus form;
- the support matrix and the deprecation rules.

Minor releases may only add compatible functionality, patches must preserve compatibility, and any breaking change to a stable surface needs a new major version{% include cite.html n=4 %}. OBI's [versioning policy](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/VERSIONING.md) spells out what counts as breaking for each surface, including stricter validation of a previously valid config, a default change that alters what an unchanged config does, a removed or renamed flag or environment variable, a changed exit-code meaning, and dropping a supported kernel, distribution or architecture. Stable artifacts and semver image tags are never removed, and the `latest` tag is outside the contract{% include cite.html n=5 %}.

One wrinkle: the release notes say the README, the versioning policy and the support matrix at the v1.0.0 tag "retain introductory wording from the pre-v1 Development phase", and that their own stable-surface list governs{% include cite.html n=4 %}. A follow-up is recorded on the project's [v1 epic](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/issues/1133). Read the release notes as the contract.

### Telemetry: only `stable` entries are protected

OBI's [telemetry policy](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/TELEMETRY.md) protects only registry entries classified `stable`. Entries at `development` (the default), `alpha`, `beta` and `release_candidate` "may change or be removed in a v1 minor release"{% include cite.html n=6 %}. Signal and attribute stability are independent, so a stable metric can carry attributes that aren't protected{% include cite.html n=6 %}. For stable entries, the contract covers metric names, instrument kinds, units, aggregation meaning, span names and kinds, and attribute keys, types and meaning, and correctness fixes count as compatible changes{% include cite.html n=6 %}.

Stability covers the shape and meaning of telemetry when it is emitted, not whether it appears, because enabled features, protocols, attribute selection and runtime metadata still decide that{% include cite.html n=4 %}{% include cite.html n=6 %}. The emitted schema URL moves from `0.15.2` to the published `1.0.0` schema with no new rename transformations, and the release notes warn that schema transformations "cannot translate every conditional rename, removal, or Prometheus-specific change"{% include cite.html n=4 %}.

For Go consumers there is no forward ABI guarantee, so recompile against the version you deploy{% include cite.html n=4 %}. The Collector receiver, `go.opentelemetry.io/obi/collector`, stays on its own v0 line, and v1.0.0 pairs with `collector/v0.15.2`{% include cite.html n=4 %}.

### What stays outside OBI's contract

- Network flow attribute names, "pending semantic-convention alignment"{% include cite.html n=4 %}.
- Runtime metrics for Go, Java, .NET, Node.js and Python, which the [release announcement](https://opentelemetry.io/blog/2026/obi-v1-release/) says "remain experimental".
- Full per-process parity with declarative configuration, which is deferred. Config v2 models protocol- and signal-specific filter narrowing, but that "is not yet a supported runtime behavior"{% include cite.html n=4 %}.
- Complete coverage of the telemetry registry, which is planned for v1.1.0, per the project's v1 epic{% include cite.html n=15 %}.
- Known v1.0.0 limitations: application metrics can stay missing after a Pod starts or restarts until OBI restarts, child spans can start before their parents with no known workaround, port-based discovery can pick a helper or port-forwarder process, and service graphs can show `outgoing` or duplicate identities{% include cite.html n=4 %}{% include cite.html n=6 %}.

## Upgrading OBI

**Pin the release.** Deploy `v1.0.0`. Receiver users run `go get go.opentelemetry.io/obi/collector@v0.15.2 go.opentelemetry.io/obi@v1.0.0`{% include cite.html n=4 %}. The release notes give `./scripts/verify-draft-release.sh v1.0.0` to verify artifacts, and point Java dependency inventories to the companion `obi-java-agent-v1.0.0.cyclonedx.json`, because the archive SBOMs list the agent as `UNKNOWN`{% include cite.html n=4 %}.

**Move off Config v1.** Config v1 is still supported but frozen, with no fixes or features{% include cite.html n=4 %}. Before migrating, confirm that every deployed binary and image is at least v0.11.0, because a passing `obi config validate` doesn't prove an older runtime can load v2, according to the [migration guide](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/devdocs/config/version-2.0/migration.md). Then{% include cite.html n=8 %}:

1. Run `obi config migrate [--allow-partial] [--mode=standalone|receiver] <path>`. It writes v2 YAML to stdout and a report to stderr. Failures start with `migration failed:`, and `--allow-partial` exits with code `3` and lists every field it didn't preserve.
2. Rewire environment overrides by hand. The migrator doesn't read `OTEL_EBPF_*`, `OTEL_EXPORTER_OTLP_*` or `OTEL_SERVICE_NAME`, and carrying them over doesn't preserve them.
3. Keep the migration directory private (`umask 077`), because variable substitution can write secrets into the output file.
4. Canary one instance and compare its telemetry before a broad rollout.

Three v2 behaviors are easy to miss. Native v2 capture is on by default (`default_action: include`), whereas a v1 file with no selector captured nothing, so the migrator writes `default_action: exclude` where it needs to{% include cite.html n=8 %}. Don't reorder the generated rules{% include cite.html n=8 %}. A protocol's `enabled.metrics: false` also suppresses its span metrics and service graphs{% include cite.html n=8 %}. If you're coming from a release before v0.15.2, first read that release's changes to span names, `rpc.method`, default metric attributes and Prometheus labels{% include cite.html n=8 %}.

**Check kernels and privileges.** The [support matrix](https://github.com/open-telemetry/opentelemetry-ebpf-instrumentation/blob/v1.0.0/SUPPORT_MATRIX.md) requires Linux 5.8 or later, or 4.18 or later on RHEL 8, CentOS 8, Rocky 8 and Alma 8 with eBPF backports. BTF must be exposed, and only `amd64` and `arm64` are supported{% include cite.html n=7 %}. Don't enable `ebpf.bpf_debug` on 5.8, 5.9 or early or unpatched 5.10 kernels{% include cite.html n=7 %}.

OBI needs root, or the capabilities its enabled features require, according to its [privileges page](https://opentelemetry.io/docs/zero-code/obi/security/). Application observability needs `CAP_BPF`, `CAP_DAC_READ_SEARCH`, `CAP_CHECKPOINT_RESTORE`, `CAP_PERFMON`, `CAP_NET_RAW` and `CAP_SYS_PTRACE`{% include cite.html n=7 %}{% include cite.html n=9 %}. Context propagation adds `CAP_NET_ADMIN`, plus `CAP_SYS_ADMIN` for Go library-level propagation on 5.10 and later{% include cite.html n=7 %}{% include cite.html n=9 %}. By default a missing capability only produces a warning, and the `OTEL_EBPF_ENFORCE_SYS_CAPS` setting makes OBI fail early instead{% include cite.html n=7 %}{% include cite.html n=9 %}. The support matrix and the privileges page show different example values for that setting, so check both before you set it. On kernels 6.6.128+, 6.12.75+, 6.18.14+ and 6.19+, with OBI v0.12.0 or later, mount the host's `/sys/kernel/tracing` into the container, or context propagation is turned off automatically{% include cite.html n=9 %}. The privileges page is unversioned, so these details are as of 2026-11-03.

## OTTL v1: what is frozen

From opentelemetry-collector-contrib v0.164.0, OTTL is stable for traces, metrics and logs, according to the [OTTL v1 announcement](https://opentelemetry.io/blog/2026/ottl-v1/). The [v0.164.0 release notes](https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/tag/v0.164.0) record the change as "Promote traces, metrics, and logs signals from beta to stable".

The guarantee has three parts. Everything in the language reference, including paths, literals, operators, function calls and `where` clauses, is frozen for 1.x: syntax can be added in a minor release but not removed or changed in meaning{% include cite.html n=10 %}. No function in the standard set is removed or has its signature changed incompatibly during 1.x, so a statement that parses on one 1.x release parses and behaves the same on every later one{% include cite.html n=10 %}. The Go API for components built on OTTL also stays compatible{% include cite.html n=10 %}. The [standard functions reference](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/b21bf1a21be57988b655aa03ff664dbb250d6a99/pkg/ottl/ottlfuncs/README.md) adds that standard functions may not do I/O, share information only through parameters and results, and must terminate.

The announcement lists 14 contrib components that accept OTTL, among them the transform, filter and tail sampling processors and the routing and count connectors{% include cite.html n=10 %}. The transform processor itself isn't stable yet, and its promotion is tracked in issue #47306{% include cite.html n=10 %}.

### What stays experimental

New functions start in the `xottl` module, which is on a 0.x version and can change or drop them in any release{% include cite.html n=10 %}. They parse only when the `pkg.ottl.functions.enableExperimental` gate is on, which the [feature-gate table](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/b21bf1a21be57988b655aa03ff664dbb250d6a99/pkg/ottl/documentation.md) lists as alpha from v0.163.0. Components register these functions but leave them off, so enabling the gate is enough and no custom build is needed{% include cite.html n=10 %}. A function is promoted only after at least two minor releases as experimental, complete tests and documentation, no open change proposals, and real user demand{% include cite.html n=10 %}.

The lambda functions `All`, `Any`, `Filter`, `Find`, `MapEach`, `MapKeys`, `Reduce` and `When` are experimental, and the [experimental functions reference](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/b21bf1a21be57988b655aa03ff664dbb250d6a99/pkg/ottl/xottl/ottlfuncs/README.md) says each requires `ottl.functions.enableLambda`. The feature-gate table lists that gate as alpha from v0.155.0{% include cite.html n=12 %}. The pinned docs don't say whether the lambda functions also need `enableExperimental`. The feature-gate table says experimental functions are rejected unless that gate is on, while each lambda entry in the experimental functions reference names only `enableLambda`{% include cite.html n=12 %}{% include cite.html n=13 %}. We checked the full OTTL v1 announcement and feature-gate table, the header and all eight lambda entries in the experimental functions reference, the introduction and contents of the standard functions reference, and the v0.164.0 release notes' breaking-changes and enhancements sections{% include cite.html n=10 %}{% include cite.html n=11 %}{% include cite.html n=12 %}{% include cite.html n=13 %}{% include cite.html n=14 %}. Our advice: test your configuration against v0.164.0 before relying on the lambda functions. Profile support sits in a separate `xprofile` module, still in development{% include cite.html n=10 %}.

## Upgrading the Collector to v0.164.0

**Remove retired gates.** Stop passing `ottl.PanicDuplicateName` and `ottl.contexts.enableOTelColContext`, which were removed before v1, and `ottl.set.allowNil`, which v0.164.0 removes{% include cite.html n=10 %}{% include cite.html n=11 %}. The same release removes the filter processor's `processor.filter.defaultErrorModeIgnore` gate{% include cite.html n=11 %}.

**Audit your statements.** `Base64Decode` and the old profile functions are gone{% include cite.html n=10 %}. Search transform, filter and other OTTL-consuming configs for the eight lambda functions and any other `xottl` function, then enable the matching gate or rewrite the statement{% include cite.html n=10 %}.

**Update transform processor config.** v0.164.0 deprecates `flatten_data` in favor of `flatten: {log: true}`, and the old setting will be removed in a future release{% include cite.html n=11 %}.

**If you skip releases,** read the contrib changelog's `pkg/ottl` entries between your version and v0.164.0{% include cite.html n=10 %}.

**Expect other breaking changes.** The same release makes the Prometheus exporters always preserve leading and consecutive underscores in label names, and switches the Zipkin and Azure logs translators to new semantic-convention attributes by default{% include cite.html n=11 %}. It also removes the `connector.servicegraph.virtualNode` and `receiver.prometheusreceiver.IgnoreScopeInfoMetric` gates{% include cite.html n=11 %}.

## Our view

These are our recommendations, not OpenTelemetry's.

- Build dashboards and alerts on OBI telemetry marked `stable`, and treat everything else, including runtime metrics, as open to change in a minor release.
- Migrate to Config v2 now, while v1 still loads, and canary the result.
- Before upgrading the Collector, search your configs for gated functions and retired gates. A statement that relies on an experimental function isn't covered by OTTL's 1.x promise.
- Watch the transform processor's promotion before treating transform pipelines as fully stable.
