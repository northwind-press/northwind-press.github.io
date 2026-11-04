---
title: "CISA says WordPress core upgrade-window flaw is exploited; update to 7.1.4"
author: "Northwind Security Desk"
description: "CVE-2026-119977 affects WordPress 4.7 through 7.1.3; update to 7.1.4 or your branch's security release now, and check sites that ran a core upgrade before patching."
categories: [security]
kind: news
date: 2026-11-04 08:02
sources:
  - title: "WordPress 7.1.4 Security Release"
    url: https://wordpress.org/news/2026/10/wordpress-7-1-4
    publisher: "WordPress.org"
    date: "2026-10-28"
    accessed: "2026-11-04"
  - title: "WordPress 7.1.4"
    url: https://wordpress.org/documentation/wordpress-version/version-7-1-4/
    publisher: "WordPress.org HelpHub"
    date: "2026-10-28"
    accessed: "2026-11-04"
  - title: "CISA Known Exploited Vulnerabilities catalog (kev-data)"
    url: https://github.com/cisagov/kev-data
    publisher: "CISA"
    date: "2026-11-03"
    accessed: "2026-11-04"
  - title: "CVE-2026-119977"
    url: https://www.cve.org/CVERecord?id=CVE-2026-119977
    publisher: "CVE Program"
    date: "2026-10-31"
    accessed: "2026-11-04"
corrections: []
---

The US Cybersecurity and Infrastructure Security Agency (CISA) added CVE-2026-119977, a flaw in WordPress core, to its [Known Exploited Vulnerabilities catalog](https://github.com/cisagov/kev-data) on 2026-11-03, with a remediation due date of 2026-11-06, and flags it for forensic triage. CISA describes a time-of-check time-of-use race that could let unauthenticated attackers execute code on the server during the upgrade window, because full-package core upgrades use predictable, web-accessible staging paths{% include cite.html n=3 %}.

## What is affected

The [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-119977), filed by Wordfence as the CVE numbering authority, lists every WordPress branch from 4.7 through 7.1 as affected, up to and including 7.1.3, and scores the flaw CVSS 3.1 8.1, per Wordfence. Its vector rates attack complexity as high and requires no privileges or user interaction{% include cite.html n=4 %}.
## The fix

[WordPress 7.1.4](https://wordpress.org/news/2026/10/wordpress-7-1-4), a security release published on 2026-10-28, fixes "a weakness in the WordPress upgrade process which can lead to remote code execution during the upgrade window", which the project credits to Umut Bayram. WordPress says sites that support automatic background updates will start updating automatically{% include cite.html n=1 %}.

The project's [release notes](https://wordpress.org/documentation/wordpress-version/version-7-1-4/) say the fixes were also released for every older branch back to 4.7, including 7.0.8, 6.9.11, 6.8.12, 6.4.14, 5.9.20, and 4.7.39, and that WordPress 4.6 and earlier no longer receive security updates. Only the latest version is actively supported{% include cite.html n=2 %}. The fixed versions match the CVE record's affected ranges, which end one release earlier on each branch{% include cite.html n=4 %}.

The release also fixes 21 other issues, mostly stored cross-site scripting, and updates WordPress's bundled root certificates after the [eMudhra revocation](/2026/11/02/emudhra-ca-compromise/){% include cite.html n=2 %}.

## What to do

- **Update now** to 7.1.4, or to the latest security release for your branch{% include cite.html n=1 %}{% include cite.html n=2 %}. In our view, check the version each site reports rather than assuming automatic updates ran.
- **Check sites that ran a full core upgrade before patching.** That is our advice: the flaw is exposed only during the upgrade window, and CISA flags it for forensic triage{% include cite.html n=3 %}.
- **Sites on WordPress 4.6 or earlier** are outside the CVE record's affected range{% include cite.html n=4 %}, but they no longer receive any security updates, so they should move to a supported release{% include cite.html n=2 %}.

## What is not known

CISA's entry does not say who is exploiting the flaw or since when, and it lists known ransomware use as "Unknown"{% include cite.html n=3 %}. WordPress's release post and release notes do not mention exploitation{% include cite.html n=1 %}{% include cite.html n=2 %}. We could not open Wordfence's own write-up, so we could not confirm independently whether it reports exploitation details.
