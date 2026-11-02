---
title: "GitHub adds three webhook IP ranges; static allowlists need updating"
author: "Northwind Software & Dev Desk"
description: "If you allowlist GitHub webhook IPs by hand, add 9.234.98.160/28, 9.234.98.176/28, and 9.234.106.48/28, or sync from the Meta API hooks field."
categories: [software]
kind: news
date: 2026-11-02 22:44
sources:
  - title: "Webhook IP ranges added to the Meta API"
    url: https://github.blog/changelog/2026-10-29-webhook-ip-ranges-added-to-the-meta-api
    publisher: "GitHub Changelog"
    date: "2026-10-29"
    accessed: "2026-11-02"
  - title: "REST API endpoints for meta data: Get GitHub meta information"
    url: https://docs.github.com/rest/meta/meta#get-github-meta-information
    publisher: "GitHub Docs"
    accessed: "2026-11-02"
  - title: "GET https://api.github.com/meta (live response)"
    url: https://api.github.com/meta
    publisher: "GitHub REST API"
    accessed: "2026-11-02"
corrections: []
---

GitHub is adding IP ranges for webhook deliveries on github.com, it said in a [changelog post](https://github.blog/changelog/2026-10-29-webhook-ip-ranges-added-to-the-meta-api) on 2026-10-29. Receivers that accept webhooks only from a fixed list of addresses must add the new ranges, or they will reject deliveries{% include cite.html n=1 %}.

## The new ranges

GitHub lists three CIDR prefixes{% include cite.html n=1 %}:

- `9.234.98.160/28`
- `9.234.98.176/28`
- `9.234.106.48/28`

They apply to webhook deliveries on github.com on all plans, including GitHub Enterprise Cloud{% include cite.html n=1 %}. GitHub says they go alongside the existing webhook ranges, not in place of them{% include cite.html n=1 %}.

As of 2026-11-02, the `hooks` field of the [Meta API's live response](https://api.github.com/meta) contains all three prefixes. It also lists `192.30.252.0/22`, `185.199.108.0/22`, `140.82.112.0/20`, `143.55.64.0/20`, `2a0a:a440::/29`, and `2606:50c0::/32`{% include cite.html n=3 %}.

## Who is affected

Teams that keep their allowlist current from the Meta API's `hooks` field need do nothing, GitHub says{% include cite.html n=1 %}. Anyone who maintains a static allowlist for incoming webhook deliveries needs to add the new prefixes{% include cite.html n=1 %}.

## What to do

Our advice: add the three prefixes to every static webhook allowlist now, keeping the existing entries{% include cite.html n=1 %}. Better, generate the list from `GET /meta` instead of hard-coding it: the [API documentation](https://docs.github.com/rest/meta/meta#get-github-meta-information) says its example values are only examples and you must query the API directly for the latest ones. The documentation also notes that the endpoint returns IPv6 addresses but not all features support IPv6, so check each feature's documentation{% include cite.html n=2 %}.
