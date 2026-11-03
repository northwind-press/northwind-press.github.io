---
title: "CISA lists July-patched Adobe Commerce and Magento upload flaw as exploited"
author: "Northwind Security Desk"
description: "Stores that skipped Adobe's July 2026 update for CVE-2026-48356 should apply it now and check for compromise, because CISA says the flaw is being exploited."
categories: [security]
kind: news
date: 2026-11-03 08:09
sources:
  - title: "Security update available for Adobe Commerce | APSB26-73"
    url: https://www.adobe.com/trust/security/products/commerce/apsb26-73.html
    publisher: "Adobe"
    date: "2026-07-14"
    accessed: "2026-11-03"
  - title: "CISA Known Exploited Vulnerabilities catalog (kev-data)"
    url: https://github.com/cisagov/kev-data
    publisher: "CISA"
    accessed: "2026-11-02"
  - title: "CVE-2026-48356"
    url: https://www.cve.org/CVERecord?id=CVE-2026-48356
    publisher: "CVE Program"
    date: "2026-07-14"
    accessed: "2026-11-03"
  - title: "CVE-2026-48356 detail"
    url: https://nvd.nist.gov/vuln/detail/CVE-2026-48356
    publisher: "NIST NVD"
    accessed: "2026-11-03"
corrections: []
---

The US Cybersecurity and Infrastructure Security Agency (CISA) added CVE-2026-48356, an unrestricted file upload flaw in Adobe Commerce and Magento Open Source, to its [Known Exploited Vulnerabilities catalog](https://github.com/cisagov/kev-data) on 2026-10-27, with a remediation due date of 2026-11-10. CISA's entry says the flaw could result in arbitrary code execution{% include cite.html n=2 %}. Adobe fixed it in July, so the stores at risk are those that have not applied that update.

## What is affected

Adobe's [security bulletin APSB26-73](https://www.adobe.com/trust/security/products/commerce/apsb26-73.html), published 2026-07-14 and last updated 2026-08-11, rates the flaw Critical and says no authentication is required to exploit it. It categorizes the impact as privilege escalation. Affected versions are:

- Adobe Commerce 2.4.9, 2.4.8-p5, 2.4.7-p10, 2.4.6-p15, 2.4.5-p17, 2.4.4-p18 and earlier in each line
- Adobe Commerce B2B 1.5.3, 1.5.2-p5, 1.4.2-p10, 1.3.4-p17, 1.3.3-p18 and earlier in each line
- Magento Open Source 2.4.9, 2.4.8-p5, 2.4.7-p10, 2.4.6-p15 and earlier in each line
- Adobe Commerce Events 1.6.0 to 1.20.0{% include cite.html n=1 %}

The fixed builds are the 2026-jul releases of each line (for example 2.4.8-2026-jul, and 1.5.3-2026-jul for B2B) and Commerce Events 1.21.0{% include cite.html n=1 %}.

The scores differ by source. The bulletin gives CVSS 3.1 9.6, per Adobe{% include cite.html n=1 %}. Adobe's own [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-48356) gives CVSS 3.1 9.3, with no availability impact, and says exploitation requires a victim to visit a crafted URL or interact with a compromised page{% include cite.html n=3 %}. [NVD](https://nvd.nist.gov/vuln/detail/CVE-2026-48356) also scores it CVSS 3.1 9.3{% include cite.html n=4 %}.

## What Adobe and CISA say about exploitation

As of 2026-11-03, Adobe's bulletin still says Adobe "is not aware of any exploits in the wild" for the issues it fixes, and it has not been updated since 2026-08-11{% include cite.html n=1 %}. CISA lists the flaw as exploited{% include cite.html n=2 %}. Neither source says who is exploiting it or how, and CISA lists known ransomware use as "Unknown"{% include cite.html n=2 %}.

## What to do

- **Apply the July 2026 update or later** for your line, as Adobe recommends updating to the newest version{% include cite.html n=1 %}.
- **If you could not patch since July**, treat the store as possibly compromised and investigate. That is our advice: neither Adobe nor CISA has published indicators for this flaw{% include cite.html n=1 %}{% include cite.html n=2 %}.
- APSB26-73 also fixes 13 other vulnerabilities, several rated Critical, so the update is worth applying for those too{% include cite.html n=1 %}.

## What is not known

It is not known when exploitation began, how many stores are affected, or whether Adobe will update its bulletin. Neither Adobe nor CISA has said{% include cite.html n=1 %}{% include cite.html n=2 %}.
