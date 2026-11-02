---
title: "CISA lists GitLab CI/CD regex flaw as exploited; Ruby fixes the underlying bugs"
author: "Security Reporter"
description: "CISA says a critical GitLab CI/CD regex flaw is being exploited; upgrade self-managed GitLab to the latest patch for your series and check for signs of compromise."
categories: [security]
kind: news
date: 2026-11-02 22:36
sources:
  - title: "GitLab Patch Release: 19.4.2, 19.3.5, 19.2.8"
    url: https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-4-2-released/
    publisher: "GitLab"
    date: "2026-10-12"
    accessed: "2026-11-02"
  - title: "CISA Known Exploited Vulnerabilities catalog (kev-data)"
    url: https://github.com/cisagov/kev-data
    publisher: "CISA"
    date: "2026-10-30"
    accessed: "2026-11-02"
  - title: "CVE-2026-97229"
    url: https://www.cve.org/CVERecord?id=CVE-2026-97229
    publisher: "CVE Program"
    date: "2026-10-13"
    accessed: "2026-11-02"
  - title: "Regexp fixes for GitLab CVEs"
    url: https://www.ruby-lang.org/en/news/2026/10/23/regexp-fixes-for-gitlab-cves
    publisher: "Ruby"
    date: "2026-10-23"
    accessed: "2026-11-02"
  - title: "GitLab Patch Release: 19.5.1, 19.4.3, 19.3.6, 19.2.9, 19.1.9, 19.0.10, 18.11.13"
    url: https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-1-released/
    publisher: "GitLab"
    date: "2026-10-21"
    accessed: "2026-11-02"
  - title: "GitLab Patch Release and Security Update: 19.5.3, 19.4.5, 19.3.7, 19.2.10, 19.1.10, 19.0.11, 18.11.14"
    url: https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/
    publisher: "GitLab"
    date: "2026-10-29"
    accessed: "2026-11-02"
corrections: []
---

The US Cybersecurity and Infrastructure Security Agency (CISA) added CVE-2026-97229, a critical flaw in self-managed GitLab, to its [Known Exploited Vulnerabilities catalog](https://github.com/cisagov/kev-data) on 2026-10-29.

## What is affected

GitLab's [19.4.2 patch release](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-4-2-released/) says the flaw could allow an unauthenticated user to execute arbitrary code on the GitLab server via a specially crafted regular expression in a CI/CD configuration. GitLab rates it Critical (CVSS 10.0, per GitLab) and lists GitLab CE and EE as affected in all versions from 19.2 before 19.2.8, 19.3 before 19.3.5, and 19.4 before 19.4.2{% include cite.html n=1 %}. The [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-97229) gives the same ranges{% include cite.html n=3 %}.

The fix shipped on 2026-10-12; GitLab.com and GitLab Dedicated were already patched{% include cite.html n=1 %}.

## The Ruby connection

According to the [Ruby advisory](https://www.ruby-lang.org/en/news/2026/10/23/regexp-fixes-for-gitlab-cves), the root cause is in Onigmo, Ruby's regular expression engine: GitLab compiles user-supplied patterns with `Regexp.new`, and crafted patterns could corrupt memory during compilation. GitLab assigned four CVEs to these bugs, including CVE-2026-97229. Ruby 4.0.9, 3.4.12, and 3.3.13, released on 2026-10-23, contain all the underlying fixes{% include cite.html n=4 %}.

Ruby says any application that compiles a regular expression from attacker-controlled input, for example with `Regexp.new`, `Regexp.union`, or `Regexp.compile`, or by interpolating it into a literal, is exposed, and that `Regexp.timeout` does not protect against these bugs{% include cite.html n=4 %}. CISA's entry also notes that other products can potentially be affected by the same underlying issue{% include cite.html n=2 %}.

A sibling bug, CVE-2026-110264, which GitLab also rates Critical (CVSS 10.0, per GitLab) and exploitable without authentication, affects all versions from 7.0 onwards until the [19.5.1 release](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-1-released/) of 2026-10-21 and its backports. GitLab says installations with their own Ruby runtime, such as self-compiled installs or custom images, must also upgrade Ruby, because that fix ships only in GitLab's official packages and images{% include cite.html n=5 %}.

## What to do

- **Upgrade self-managed GitLab** to the latest patch release for your series, as GitLab recommends{% include cite.html n=1 %}. As of 2026-11-02 the newest are 19.5.3, 19.4.5, 19.3.7, 19.2.10, 19.1.10, 19.0.11, and 18.11.14, from the [2026-10-29 release](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/){% include cite.html n=6 %}.
- **If you run your own Ruby**, upgrade it as well{% include cite.html n=5 %}, to 4.0.9, 3.4.12, 3.3.13, or later{% include cite.html n=4 %}.
- **Look for signs of exploitation.** GitLab has published six threat detections for self-managed instances alongside 19.4.2{% include cite.html n=1 %}. CISA flags the entry for forensic triage and set a remediation due date of 2026-11-01 under Binding Operational Directive 26-04{% include cite.html n=2 %}.
- **Ruby applications that compile untrusted patterns** should upgrade Ruby, or stop compiling regular expressions from untrusted input{% include cite.html n=4 %}.

## What is not known

CISA's entry does not say who is exploiting the flaw or how widely, and it lists known ransomware use as "Unknown"{% include cite.html n=2 %}. GitLab's release notes publish detections for exploitation attempts but do not say whether the flaw has been exploited, and GitLab makes vulnerability issues public 90 days after the fix{% include cite.html n=1 %}. Ruby has not requested CVE identifiers of its own, and asks users to track the issues under GitLab's{% include cite.html n=4 %}.
