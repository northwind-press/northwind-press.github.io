---
title: "Compromised eMudhra CA keys: browsers block them, but bundled trust stores and macOS command-line tools lag"
author: "Security Reporter"
description: "Update CA bundles, runtimes, Electron apps and CI images, and on macOS follow Apple's workaround for curl, git and python3 until Apple ships its fix."
categories: [security]
kind: news
date: 2026-11-02 22:40
sources:
  - title: "eMudhra: we have a problem"
    url: https://emudhra.we-have-a-problem.com/
    publisher: "Incident write-up site published by Dennis Jackson"
    date: "2026-10-20"
    accessed: "2026-11-02"
  - title: "Bug 2083449: eMudhra: Private key compromise of Intermediate Certificates"
    url: https://bugzilla.mozilla.org/show_bug.cgi?id=2083449
    publisher: "Mozilla"
    date: "2026-10-18"
    accessed: "2026-11-02"
  - title: "dev-security-policy: eMudhra intermediate key compromise"
    url: https://groups.google.com/a/mozilla.org/g/dev-security-policy/c/0R3XLJL6FuE
    publisher: "Mozilla / Chrome Root Program"
    date: "2026-10-20"
    accessed: "2026-11-02"
  - title: "About the compromised eMudhra intermediate CA certificates"
    url: https://support.apple.com/en-us/149555
    publisher: "Apple"
    accessed: "2026-11-02"
  - title: "Apple's developer tools still trust the compromised certificates"
    url: https://emudhra.we-have-a-problem.com/apple.html
    publisher: "Incident write-up site published by Dennis Jackson"
    date: "2026-10-28"
    accessed: "2026-11-02"
  - title: "GitLab Patch Release and Security Update: 19.5.3, 19.4.5, 19.3.7, 19.2.10, 19.1.10, 19.0.11, 18.11.14"
    url: https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/
    publisher: "GitLab"
    date: "2026-10-29"
    accessed: "2026-11-02"
  - title: "Electron v44.9.1"
    url: https://github.com/electron/electron/releases/tag/v44.9.1
    publisher: "Electron"
    date: "2026-10-20"
    accessed: "2026-11-02"
corrections: []
---

The private keys of eight eMudhra intermediate certificate authority (CA) certificates were compromised, according to Mozilla's [incident report](https://bugzilla.mozilla.org/show_bug.cgi?id=2083449). It says a reporter identified only as Wayne notified the root programs on 2026-10-17 with proof of key control, and that Mozilla independently recovered the keys the same evening, confirming eMudhra's key generation was flawed. Six of the certificates issue TLS certificates, so their keys could be used to create certificates for any website; two are for code signing{% include cite.html n=2 %}.

## Who is protected

Mozilla blocked the certificates in Firefox through OneCRL on 2026-10-17, and the Chrome Root Program blocked all six TLS intermediates by key through CRLSets the same day, which also covers Sectigo's cross-signed copies ([dev-security-policy](https://groups.google.com/a/mozilla.org/g/dev-security-policy/c/0R3XLJL6FuE)). [Apple](https://support.apple.com/en-us/149555) says it has blocked them since 2026-10-19 in Safari, Mail and apps using its networking frameworks. The reporter's [write-up site](https://emudhra.we-have-a-problem.com/) says Microsoft platforms have blocked them since 2026-10-20; we have not found a Microsoft statement. eMudhra revoked all eight on 2026-10-18 and Sectigo revoked its cross-signs afterwards{% include cite.html n=2 %}.

## Who is not

Clients that don't consume revocation data still trust the certificates until they are updated, including apps and libraries that ship their own CA bundle and Electron apps such as Slack and Discord, according to the write-up site{% include cite.html n=1 %}. Electron shipped its mitigation in [44.9.1](https://github.com/electron/electron/releases/tag/v44.9.1){% include cite.html n=7 %}, and the site lists 43.8.1 and 42.11.16 as the matching fixes for older lines; apps are protected only once they ship a build on one of them{% include cite.html n=1 %}.

On macOS, Apple says curl, git, python3, ruby, perl and openssl check certificates against `/etc/ssl/cert.pem`, which ignores Apple's block, and that a future update will fix the file{% include cite.html n=4 %}. The site's [2026-10-28 update](https://emudhra.we-have-a-problem.com/apple.html) says macOS 27.2 did not fix this and undid fixes users had applied by hand{% include cite.html n=5 %}. Apple's page confirms a macOS update can replace the file{% include cite.html n=4 %}.

[GitLab](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/) removed trust in 19.5.3 and its sibling releases (CVE-2026-111943), and says self-hosted Runner must also be updated to 19.5.1.

## What to do

- Update CA bundles and runtimes. The write-up site lists patched versions, including Python certifi 2026.10.19, Node.js 26.12.1, 24.22.1 and 22.23.4, and Oracle JDK; OpenJDK was still pending{% include cite.html n=1 %}.
- Update Electron apps once their vendors ship patched builds{% include cite.html n=1 %}.
- Upgrade GitLab and Runner, and rebuild CI job images that include their own `ca-certificates`{% include cite.html n=6 %}.
- On macOS, follow Apple's workaround of removing the affected root certificates from `/etc/ssl/cert.pem`, and recheck after every macOS update until Apple's fix ships{% include cite.html n=4 %}.

## What is not known

eMudhra's preliminary account blames a flawed key-ceremony script that produced weak keys used by mistake, and says no end-entity certificates were issued from these CAs{% include cite.html n=2 %}. The Chrome Root Program says no certificates from them were logged to Certificate Transparency before its block, so CT-enforcing browsers could not have been fooled{% include cite.html n=3 %}. Nobody has said whether the weak keys were misused against clients that don't enforce CT; the write-up site says this is not known{% include cite.html n=1 %}.
