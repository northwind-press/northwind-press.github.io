---
title: "Compromised eMudhra CA keys: browsers block them, but bundled trust stores lag"
author: "Security Reporter"
description: "Browsers already block eight compromised eMudhra intermediates, but apps with their own CA bundles, Electron apps, GitLab Runner, and macOS command-line tools need updates or Apple's workaround."
categories: [security]
kind: news
date: 2026-11-02 22:43
sources:
  - title: "eMudhra: we have a problem"
    url: https://emudhra.we-have-a-problem.com/
    publisher: "Disclosure write-up, published by Dennis Jackson"
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
    publisher: "Disclosure write-up, published by Dennis Jackson"
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
  - title: "The eMudhra incident"
    url: https://go.dev/blog/emudhra-incident
    publisher: "The Go Blog"
    accessed: "2026-11-02"
  - title: "October 2026 security releases"
    url: https://nodejs.org/en/blog/vulnerability/october-2026-security-releases
    publisher: "Node.js"
    accessed: "2026-11-02"
corrections: []
---

The private keys of eight eMudhra intermediate certificate authority (CA) certificates have been compromised, according to a [disclosure write-up](https://emudhra.we-have-a-problem.com/), which says the original reporter, Wayne, reported this to the root programs on 2026-10-17 with a message signed by each key. Mozilla's [incident report](https://bugzilla.mozilla.org/show_bug.cgi?id=2083449) says it received the report that day and confirmed the proof of key control was valid. Six of the certificates issue TLS certificates and two are for code signing{% include cite.html n=2 %}. The Go team's [account of its response](https://go.dev/blog/emudhra-incident) says researchers found the keys "trivially weak", recoverable in microseconds{% include cite.html n=8 %}.

## Who is protected

Mozilla and the Chrome Root Program describe their 2026-10-17 blocks, through OneCRL and CRLSets, in [Mozilla's policy forum](https://groups.google.com/a/mozilla.org/g/dev-security-policy/c/0R3XLJL6FuE). [Apple's support article](https://support.apple.com/en-us/149555) dates its own block from 2026-10-19. Microsoft platforms have blocked them since 2026-10-20, according to the write-up; Microsoft has not published a notice we could find{% include cite.html n=1 %}. eMudhra marked all eight revoked on 2026-10-18, and Sectigo later revoked its cross-signed copies{% include cite.html n=2 %}{% include cite.html n=4 %}.

## Who is not

The write-up says clients that don't consume revocation information keep trusting the certificates until their software is updated, including apps and libraries that ship their own CA bundle and Electron apps such as Slack and Discord{% include cite.html n=1 %}. Electron shipped its mitigation in [44.9.1](https://github.com/electron/electron/releases/tag/v44.9.1){% include cite.html n=7 %}, and the write-up lists 43.8.1 and 42.11.16 for older lines{% include cite.html n=1 %}. Node.js's [October security releases](https://nodejs.org/en/blog/vulnerability/october-2026-security-releases) update its bundled CA certificates on 26.x, 24.x, and 22.x{% include cite.html n=9 %}; our [Software desk's report](/2026/11/02/go-python-emudhra-releases/) covers the Go and Python releases.

[GitLab](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/) removed trust in 19.5.3 and its sibling releases (CVE-2026-111943). It says self-hosted GitLab Runner, which verifies certificates itself, must also be updated to 19.5.1, and CI job images that include their own `ca-certificates` package rebuilt{% include cite.html n=6 %}.

## macOS command-line tools

Apple says some command-line tools included with macOS or the Xcode Command Line Tools, including curl, git, python3, ruby, perl, and openssl, check certificates against `/etc/ssl/cert.pem` without checking Apple's block or revocation, and that a future macOS update will fix the file{% include cite.html n=4 %}. The write-up's [2026-10-28 update](https://emudhra.we-have-a-problem.com/apple.html) says macOS 27.2 did not fix this and undid fixes users had applied by hand{% include cite.html n=5 %}.

Until Apple's update ships, Apple says administrators can remove the root certificates the blocked intermediates chain to (emSign ECC Root CA - G3 and, optionally, AAA Certificate Services) from that file, accepting that the tools may then fail to verify some unaffected sites, and should recheck after every macOS update because an update can replace the file{% include cite.html n=4 %}.

## What to do

- Update OS CA packages, bundled CA stores, and Electron apps; the write-up keeps a list of patched versions{% include cite.html n=1 %}.
- Upgrade GitLab and Runner, and rebuild CI images{% include cite.html n=6 %}.
- On macOS, apply Apple's workaround or install its update when it ships{% include cite.html n=4 %}.

## What is not known

The write-up says no Certificate Transparency (CT) entries exist for these intermediates, so CT-enforcing browsers could not have been attacked, but that it is not known whether attackers used the keys against clients that don't enforce CT{% include cite.html n=1 %}. The Chrome Root Program says no certificates from them were logged to CT before its block{% include cite.html n=3 %}.
