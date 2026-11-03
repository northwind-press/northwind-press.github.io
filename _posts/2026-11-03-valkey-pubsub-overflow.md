---
title: "Valkey fixes cluster Pub/Sub heap overflow that may allow code execution"
author: "Northwind Security Desk"
description: "Valkey 9.1.3, 9.0.7, 8.1.11, 8.0.12, and 7.2.15 fix a heap overflow in cluster mode; upgrade clustered servers, and restrict scripting commands with ACLs until you can."
categories: [security]
kind: news
date: 2026-11-03 08:04
sources:
  - title: "Integer truncation in Valkey cluster publish message construction causes a heap buffer overflow (GHSA-f4q9-j22m-xqq9)"
    url: https://github.com/valkey-io/valkey/security/advisories/GHSA-f4q9-j22m-xqq9
    publisher: "Valkey"
    date: "2026-10-26"
    accessed: "2026-11-03"
  - title: "Valkey 9.1.3"
    url: https://github.com/valkey-io/valkey/releases/tag/9.1.3
    publisher: "Valkey"
    date: "2026-10-26"
    accessed: "2026-11-03"
  - title: "Valkey tags"
    url: https://github.com/valkey-io/valkey/tags
    publisher: "Valkey"
    accessed: "2026-11-03"
corrections: []
---

The Valkey project has released fixes for a heap buffer overflow in cluster mode that an authenticated client could use to crash the server, and possibly to run code on it. Valkey published the [security advisory](https://github.com/valkey-io/valkey/security/advisories/GHSA-f4q9-j22m-xqq9), GHSA-f4q9-j22m-xqq9, on 2026-10-26. It rates the flaw High, CVSS 3.1 8.8. As of 2026-11-03, the advisory lists no CVE identifier.

## What is affected

The bug is in how a cluster node builds the message that propagates a `PUBLISH` or `SPUBLISH` to the rest of the cluster. According to the advisory, an authenticated user who can publish to a channel can make the server write attacker-chosen bytes past the end of a heap buffer. Valkey says this reliably crashes the server and may be escalated to remote code execution as the user the server runs as{% include cite.html n=1 %}.

Valkey 7.2, 8.0, 8.1, 9.0, 9.1, and the 9.2 release candidates are affected when running in cluster mode. Valkey says servers without cluster mode enabled are not affected{% include cite.html n=1 %}.

The [9.1.3 release notes](https://github.com/valkey-io/valkey/releases/tag/9.1.3) mark the release "Upgrade urgency SECURITY" and say the fix addresses an overflow "that could allow an authenticated client to potentially execute arbitrary code by publishing an oversized message".

## Fixed versions

The advisory lists these releases as fixed{% include cite.html n=1 %}:

| Branch | Affected up to | Fixed in |
|---|---|---|
| 9.1 | 9.1.2 | 9.1.3 |
| 9.0 | 9.0.6 | 9.0.7 |
| 8.1 | 8.1.10 | 8.1.11 |
| 8.0 | 8.0.11 | 8.0.12 |
| 7.2 | 7.2.14 | 7.2.15 |
| 9.2 (pre-release) | 9.2.0-rc1 | 9.2.0-rc2 |

As of 2026-11-03, the project's [tags](https://github.com/valkey-io/valkey/tags) do not yet include 9.2.0-rc2, so anyone testing 9.2 is still on an affected build.

## What to do

- **Upgrade clustered Valkey servers** to the fixed release for your branch. The release notes recommend applying it as soon as possible{% include cite.html n=2 %}.
- **Until you can upgrade,** Valkey's suggested mitigation is to use ACLs to restrict the scripting commands (`EVAL`, `EVALSHA`, `EVAL_RO`, `EVALSHA_RO`, `FCALL`, `FCALL_RO`, and `FUNCTION`) if your application does not use them, and to leave `proto-max-bulk-len` at its default{% include cite.html n=1 %}.
- **Review who can authenticate and publish.** The flaw needs an authenticated user with publish rights, so in our view tightening ACLs on `PUBLISH` and `SPUBLISH` also narrows exposure{% include cite.html n=1 %}.

## What is not known

The advisory does not say whether the flaw has been exploited{% include cite.html n=1 %}. Valkey credits Nenad Stojanovski, working with Trend Micro's Zero Day Initiative, with reporting it{% include cite.html n=1 %}.
