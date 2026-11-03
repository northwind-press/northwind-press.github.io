---
title: "Adobe Commerce and Magento flaw exploited since March, per Sansec; CISA now lists it"
author: "Northwind Security Desk"
description: "Sansec says CVE-2026-48356 was exploited from March, before Adobe's July fix, so apply the update and check every store for compromise."
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
  - title: "deepveindrilling.com: Magento CMS block loader"
    url: https://sansec.io/research/magento-cms-block-loader-deepveindrilling
    publisher: "Sansec"
    date: "2026-10-24"
    accessed: "2026-11-03"
corrections:
  - date: 2026-11-03
    text: "An earlier version said it was not known when exploitation began. Sansec reported on 2026-10-24 that attackers were exploiting the flaw by March 2026, before Adobe's July fix, and that some stores stayed infected after patching ([Sansec](https://sansec.io/research/magento-cms-block-loader-deepveindrilling)). We have also widened our advice to check every store for compromise."
---

The US Cybersecurity and Infrastructure Security Agency (CISA) added CVE-2026-48356, an unrestricted file upload flaw in Adobe Commerce and Magento Open Source, to its [Known Exploited Vulnerabilities catalog](https://github.com/cisagov/kev-data) on 2026-10-27, with a remediation due date of 2026-11-10. CISA's entry says the flaw could result in arbitrary code execution{% include cite.html n=2 %}.

## What is affected

Adobe's [security bulletin APSB26-73](https://www.adobe.com/trust/security/products/commerce/apsb26-73.html), published 2026-07-14 and last updated 2026-08-11, rates the flaw Critical and says no authentication is required to exploit it. It categorizes the impact as privilege escalation. Affected versions are:

- Adobe Commerce 2.4.9, 2.4.8-p5, 2.4.7-p10, 2.4.6-p15, 2.4.5-p17, 2.4.4-p18 and earlier in each line
- Adobe Commerce B2B 1.5.3, 1.5.2-p5, 1.4.2-p10, 1.3.4-p17, 1.3.3-p18 and earlier in each line
- Magento Open Source 2.4.9, 2.4.8-p5, 2.4.7-p10, 2.4.6-p15 and earlier in each line
- Adobe Commerce Events 1.6.0 to 1.20.0{% include cite.html n=1 %}

The fixed builds are the 2026-jul releases of each line (for example 2.4.8-2026-jul, and 1.5.3-2026-jul for B2B) and Commerce Events 1.21.0{% include cite.html n=1 %}.

The scores differ by source. The bulletin gives CVSS 3.1 9.6, per Adobe{% include cite.html n=1 %}. Adobe's own [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-48356) gives CVSS 3.1 9.3, with no availability impact, and says exploitation requires a victim to visit a crafted URL or interact with a compromised page{% include cite.html n=3 %}. [NVD](https://nvd.nist.gov/vuln/detail/CVE-2026-48356) also scores it CVSS 3.1 9.3{% include cite.html n=4 %}.

## What Adobe, CISA and Sansec say about exploitation

As of 2026-11-03, Adobe's bulletin still says Adobe "is not aware of any exploits in the wild" for the issues it fixes, and it has not been updated since 2026-08-11{% include cite.html n=1 %}. CISA lists the flaw as exploited{% include cite.html n=2 %}. Security firm [Sansec reports](https://sansec.io/research/magento-cms-block-loader-deepveindrilling) that attackers were exploiting the flaw, which it calls PolyShell, by March 2026, months before Adobe's July fix, and has published indicators of compromise; it says some stores stayed infected after patching. Sansec does not name the operator{% include cite.html n=5 %}. Neither Adobe nor CISA says who is exploiting the flaw{% include cite.html n=1 %}{% include cite.html n=2 %}. CISA lists known ransomware use as "Unknown"{% include cite.html n=2 %}.

## What to do

- **Apply the July 2026 update or later** for your line, as Adobe recommends updating to the newest version{% include cite.html n=1 %}.
- **Check every store for compromise, patched or not.** That is our advice, based on Sansec's report that exploitation began by March and that some stores stayed infected after patching; Sansec's page lists indicators of compromise and checks{% include cite.html n=5 %}.
- APSB26-73 also fixes 13 other vulnerabilities, several rated Critical, so the update is worth applying for those too{% include cite.html n=1 %}.

## What is not known

Neither Adobe nor CISA has said how many stores are affected, and Adobe has not said whether it will update its bulletin{% include cite.html n=1 %}{% include cite.html n=2 %}.
