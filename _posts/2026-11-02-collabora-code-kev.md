---
title: "CISA lists Collabora built-in CODE server flaw in Nextcloud as exploited"
author: "Northwind Security Desk"
description: "CISA says a command injection in Nextcloud's built-in Collabora CODE app is exploited; upgrade the app to 26.4.303 or later, or remove it, since disabling it is not enough."
categories: [security]
kind: news
date: 2026-11-02 22:50
sources:
  - title: "CISA Known Exploited Vulnerabilities catalog (kev-data)"
    url: https://github.com/cisagov/kev-data
    publisher: "CISA"
    date: "2026-10-30"
    accessed: "2026-11-02"
  - title: "Unauthenticated OS command injection in the richdocumentscode proxy (GHSA-g3vx-3m76-fghh)"
    url: https://github.com/CollaboraOnline/online/security/advisories/GHSA-g3vx-3m76-fghh
    publisher: "Collabora"
    date: "2026-10-14"
    accessed: "2026-11-02"
  - title: "CVE-2026-110447"
    url: https://www.cve.org/CVERecord?id=CVE-2026-110447
    publisher: "CVE Program"
    date: "2026-10-14"
    accessed: "2026-11-02"
  - title: "CVE-2026-110447 Detail"
    url: https://nvd.nist.gov/vuln/detail/CVE-2026-110447
    publisher: "NIST National Vulnerability Database"
    accessed: "2026-11-02"
  - title: "Collabora Online - Built-in CODE Server"
    url: https://apps.nextcloud.com/apps/richdocumentscode
    publisher: "Nextcloud App Store"
    accessed: "2026-11-02"
corrections: []
---

The US Cybersecurity and Infrastructure Security Agency (CISA) added CVE-2026-110447, a flaw in Collabora Online's Built-in CODE Server app for Nextcloud, to its [Known Exploited Vulnerabilities (KEV) catalog](https://github.com/cisagov/kev-data) on 2026-10-23. CISA describes it as an OS command injection that allows remote code execution when the CODE server isn't running{% include cite.html n=1 %}. The [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-110447) says it was exploited in the wild in September and October 2026.

## Who is affected

The flaw is in the Nextcloud app `richdocumentscode`, which runs a built-in CODE server as part of Nextcloud rather than a separate Collabora server{% include cite.html n=3 %}. Collabora's [security advisory](https://github.com/CollaboraOnline/online/security/advisories/GHSA-g3vx-3m76-fghh) says all versions before 26.4.303 are affected, and that a request to the app's `proxy.php` can make an operating system command run as the web server user, without authentication. The attack works only while the built-in CODE server is not running, for example after a container restart, an upgrade, or a crash{% include cite.html n=2 %}.

Standalone Collabora Online servers are not affected, according to both the advisory and the CVE record{% include cite.html n=2 %}{% include cite.html n=3 %}. Nextcloud installations that connect to a separate Collabora server, rather than using the built-in app, are therefore outside the advisory's scope{% include cite.html n=2 %}. Collabora says this is a different path from an earlier flaw, CVE-2025-66208, and that the fix for that issue does not prevent it{% include cite.html n=2 %}.

Collabora rates the flaw Critical, with a CVSS 4.0 score of 9.2 (per Collabora's advisory; the CVE record gives the same){% include cite.html n=2 %}{% include cite.html n=3 %}. The [National Vulnerability Database](https://nvd.nist.gov/vuln/detail/CVE-2026-110447) scores it CVSS 3.1 9.8, per NVD.

## What to do

- **Upgrade the app to 26.4.303 or later.** Collabora fixed the bug in that release{% include cite.html n=2 %}. As of 2026-11-02, the [Nextcloud App Store](https://apps.nextcloud.com/apps/richdocumentscode) offers 26.4.502 for Nextcloud 30 through 35.
- **On Nextcloud 29 or older, upgrade Nextcloud or remove the app.** The newest app release the store lists for Nextcloud 25 through 29 is 26.4.104, which is below the fixed version{% include cite.html n=5 %}. Collabora's advice for these end-of-life versions is to upgrade Nextcloud or remove the app{% include cite.html n=2 %}.
- **Don't rely on disabling the app.** Collabora says disabling it is not enough; it must be upgraded or removed{% include cite.html n=2 %}.
- **Check for compromise.** CISA flags the entry for forensic triage under Binding Operational Directive 26-04, and set a remediation due date of 2026-10-26{% include cite.html n=1 %}. Because commands run as the web server user, we suggest reviewing the Nextcloud installation for files you did not put there, and the credentials that user can read.

## What is not known

CISA's entry does not say who is exploiting the flaw or how widely, and lists known ransomware use as "Unknown"{% include cite.html n=1 %}. Neither Collabora's advisory nor the CVE record says how many servers have been compromised{% include cite.html n=2 %}{% include cite.html n=3 %}.
