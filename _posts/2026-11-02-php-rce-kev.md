---
title: "CISA lists two critical PHP remote code execution flaws as exploited"
author: "Northwind Security Desk"
description: "Update every PHP install that serves web requests to 8.5.12, 8.4.27, 8.3.36, 8.2.35, or your vendor's backport, and rebuild container images."
categories: [security]
kind: news
date: 2026-11-02 22:44
placement: lead
sources:
  - title: "Security advisory: Critical remote code execution vulnerabilities, update now"
    url: https://www.php.net/archive/2026.php#2026-10-21-5
    publisher: "PHP"
    date: "2026-10-21"
    accessed: "2026-11-02"
  - title: "RCE via OOM corruption (GHSA-w8hw-w9fx-j79w)"
    url: https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w
    publisher: "PHP"
    date: "2026-10-21"
    accessed: "2026-11-02"
  - title: "RCE via stale global state (GHSA-6wmf-4rv5-p3rp)"
    url: https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp
    publisher: "PHP"
    date: "2026-10-21"
    accessed: "2026-11-02"
  - title: "CISA Known Exploited Vulnerabilities catalog (kev-data)"
    url: https://github.com/cisagov/kev-data
    publisher: "CISA"
    accessed: "2026-11-02"
  - title: "CVE-2026-109618 detail"
    url: https://nvd.nist.gov/vuln/detail/CVE-2026-109618
    publisher: "NIST NVD"
    accessed: "2026-11-02"
  - title: "CVE-2026-109619 detail"
    url: https://nvd.nist.gov/vuln/detail/CVE-2026-109619
    publisher: "NIST NVD"
    accessed: "2026-11-02"
  - title: "Informational advisory: Session upload progress"
    url: https://www.php.net/archive/2026.php#2026-10-23-1
    publisher: "PHP"
    date: "2026-10-23"
    accessed: "2026-11-02"
  - title: "CVE-2026-109618"
    url: https://ubuntu.com/security/CVE-2026-109618
    publisher: "Canonical"
    accessed: "2026-11-02"
  - title: "CVE-2026-109618"
    url: https://security-tracker.debian.org/tracker/CVE-2026-109618
    publisher: "Debian"
    accessed: "2026-11-02"
corrections: []
---

The PHP project's [2026-10-21 security advisory](https://www.php.net/archive/2026.php#2026-10-21-5) says PHP 8.5.12, 8.4.27, 8.3.36, and 8.2.35 fix two critical vulnerabilities that can allow unauthenticated remote code execution, and urges all users to update immediately. The US Cybersecurity and Infrastructure Security Agency (CISA) added both, CVE-2026-109618 and CVE-2026-109619, to its [Known Exploited Vulnerabilities catalog](https://github.com/cisagov/kev-data) on 2026-10-26{% include cite.html n=4 %}.

## What is affected

PHP says all installations serving web requests are at risk, including PHP-FPM, Apache with mod_php, php-cgi, FrankenPHP, and LiteSpeed. It considers the risk highest for mod_php, where an unauthenticated request can trigger the attack before any application code runs{% include cite.html n=1 %}. In PHP's one-line summaries, CVE-2026-109618 lets out-of-memory handling leave request data partly initialized, and CVE-2026-109619 lets internal state outlive the memory behind it into a later request{% include cite.html n=1 %}.

PHP's advisories for [CVE-2026-109618](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w) and [CVE-2026-109619](https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp) rate both Critical, with a CVSS 4.0 score of 9.2 as scored by PHP{% include cite.html n=2 %}{% include cite.html n=3 %}. NVD, scoring under CVSS 3.1, gives [9.8 for CVE-2026-109618](https://nvd.nist.gov/vuln/detail/CVE-2026-109618){% include cite.html n=5 %} and [8.1 for CVE-2026-109619](https://nvd.nist.gov/vuln/detail/CVE-2026-109619){% include cite.html n=6 %}.

PHP 8.1 and older no longer receive updates from the PHP project, though its security team has published minimal source backports for 7.4, 8.0, and 8.1{% include cite.html n=1 %}.

## What to do

- **Update PHP** to 8.5.12, 8.4.27, 8.3.36, or 8.2.35{% include cite.html n=1 %}. Distribution packages carry backported fixes under their own version numbers, so check your vendor's tracker rather than the upstream version. For example, [Ubuntu](https://ubuntu.com/security/CVE-2026-109618) 24.04 is fixed in php8.3 8.3.6-0ubuntu0.24.04.13{% include cite.html n=8 %}, and [Debian](https://security-tracker.debian.org/tracker/CVE-2026-109618) in php8.4 8.4.27-1~deb13u1 for trixie and php8.2 8.2.35-1~deb12u1 for bookworm{% include cite.html n=9 %}. Rebuild container images so they pick up the fixed packages.
- **Update the kernel too.** CISA's entry for a Linux kernel bug, CVE-2026-46300, added on 2026-10-28, says it can be chained with these PHP flaws to run commands as root{% include cite.html n=4 %}.
- **Disable session upload progress.** PHP's [2026-10-23 informational advisory](https://www.php.net/archive/2026.php#2026-10-23-1) recommends `session.upload_progress.enabled=0` until the next bugfix release, to protect against a related flaw, CVE-2026-115560, that is not yet patched. PHP says it occurs only under an unusual combination of configuration and application code. If you applied this setting after the 2026-10-21 advisory, keep it{% include cite.html n=7 %}.
- PHP says other configuration measures reduce exposure but do not make an installation safe, and updating is the only complete fix{% include cite.html n=1 %}.

## What is not known

CISA has not said who is exploiting the flaws or how widely, and lists known ransomware use as "Unknown" for both{% include cite.html n=4 %}. PHP will publish a full advisory for CVE-2026-115560 with its next release{% include cite.html n=7 %}.
