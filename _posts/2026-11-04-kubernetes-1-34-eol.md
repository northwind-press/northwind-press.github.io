---
title: "Kubernetes 1.34 is end of life, with a final 1.34.13 patch published the day after"
author: "Northwind Infra & Cloud Desk"
description: "If you still run Kubernetes 1.34, move to 1.35, 1.36, or 1.37, and if you pick 1.35, plan for its maintenance mode from 2026-12-28 and end of life on 2027-02-28."
categories: [infra]
kind: news
date: 2026-11-04 08:05
sources:
  - title: "Releases"
    url: https://kubernetes.io/releases/
    publisher: "Kubernetes"
    accessed: "2026-11-04"
  - title: "Patch Releases"
    url: https://kubernetes.io/releases/patch-releases/
    publisher: "Kubernetes"
    accessed: "2026-11-04"
  - title: "kubernetes/kubernetes releases (GitHub REST API release data, with created_at and published_at)"
    url: https://api.github.com/repos/kubernetes/kubernetes/releases
    publisher: "GitHub"
    accessed: "2026-11-04"
  - title: "CHANGELOG-1.34.md"
    url: https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.34.md
    publisher: "Kubernetes project"
    accessed: "2026-11-04"
corrections: []
---

Kubernetes 1.34 reached end of life on 2026-10-27, according to the project's [releases page](https://kubernetes.io/releases/). As of 2026-11-04, the project maintains release branches only for 1.37, 1.36, and 1.35{% include cite.html n=1 %}. End-of-life releases get no security updates or bug fixes, and the project strongly recommends upgrading to a supported version{% include cite.html n=1 %}.

## The final patches, and a gap between sources

The project's [GitHub release data](https://api.github.com/repos/kubernetes/kubernetes/releases) shows v1.34.13, v1.35.10, v1.36.6, and v1.37.2, all created on 2026-10-27 and published on 2026-10-28 (UTC). So v1.34.13 was created on the end-of-life date and published the day after.

The project's own website hadn't caught up as of 2026-11-04. The releases page still lists 1.34.12 as the latest 1.34 release, dated 2026-09-15, and doesn't yet include 1.34 in its end-of-life table{% include cite.html n=1 %}. The [patch-releases page](https://kubernetes.io/releases/patch-releases/) still says the next patch releases are 1.37.2, 1.36.6, and 1.35.10, and its 1.34 history stops at 1.34.12{% include cite.html n=2 %}. That page targeted the October patches for 2026-10-13{% include cite.html n=2 %}. On GitHub, v1.34.12 itself was published on 2026-09-23, not 2026-09-15{% include cite.html n=3 %}.

## What 1.34.13 contains

The [1.34 changelog](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.34.md) lists a rebuild with Go 1.26.10 and four bug fixes:

- Pod `.status.resourceClaimStatuses` no longer flaps between partial lists when a pod uses several claims{% include cite.html n=4 %}.
- kube-scheduler now evaluates pod affinity and anti-affinity namespace selectors with negative operators correctly{% include cite.html n=4 %}.
- The kubelet `/configz` endpoint reports the right `cgroupDriver` when the setting comes from the container runtime{% include cite.html n=4 %}.
- kube-apiserver now accepts up to 16,384 request header values. The changelog says Go 1.27's default of 500 would otherwise reject impersonated or proxied users with about 500 or more groups with HTTP 431, and that releases built with Go 1.26 had no separate limit{% include cite.html n=4 %}.

## The schedule ahead

Patch series get about 14 months of support: 12 standard months, then two months of maintenance mode with fixes only for CVEs, dependency issues, and critical core problems{% include cite.html n=2 %}. As of 2026-11-04, 1.35 enters maintenance mode on 2026-12-28 and reaches end of life on 2027-02-28. For 1.36 those dates are 2027-04-28 and 2027-06-28, and for 1.37, 2027-08-28 and 2027-10-28{% include cite.html n=2 %}. The next monthly patch target is 2026-11-10{% include cite.html n=2 %}.

## What to do

- **Upgrade 1.34 clusters** to 1.35, 1.36, or 1.37. Version 1.34 no longer gets fixes{% include cite.html n=1 %}.
- **If you choose 1.35,** expect only maintenance-mode fixes from 2026-12-28 and plan the next upgrade before 2027-02-28{% include cite.html n=2 %}.
- **If you can't upgrade yet,** take 1.34.13, the newest 1.34 patch on GitHub{% include cite.html n=3 %}.
- **On a managed service,** check your provider's own schedule. The dates here are the Kubernetes project's.
