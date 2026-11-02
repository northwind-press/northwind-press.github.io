---
title: "Go and Python ship emergency releases after eMudhra CA key compromise: what to upgrade"
author: "Northwind Software & Dev Desk"
description: "Rebuild Go binaries with Go 1.27.3 or 1.26.10, and move Python to 3.15.2, 3.14.10, 3.13.18, 3.12.16, or 3.11.18, to reject certificates from the compromised eMudhra keys."
categories: [software]
kind: news
date: 2026-11-02 22:50
sources:
  - title: "Our Response To The eMudhra Key Disclosure Incident"
    url: https://go.dev/blog/emudhra-incident
    publisher: "The Go Blog"
    accessed: "2026-11-02"
  - title: "Release History"
    url: https://go.dev/doc/devel/release
    publisher: "The Go Project"
    accessed: "2026-11-02"
  - title: "Python Release Python 3.15.2"
    url: https://www.python.org/downloads/release/python-3152/
    publisher: "Python Software Foundation"
    date: "2026-10-25"
    accessed: "2026-11-02"
  - title: "Python Release Python 3.14.10"
    url: https://www.python.org/downloads/release/python-31410/
    publisher: "Python Software Foundation"
    date: "2026-10-25"
    accessed: "2026-11-02"
  - title: "Python Release Python 3.13.18"
    url: https://www.python.org/downloads/release/python-31318/
    publisher: "Python Software Foundation"
    date: "2026-10-25"
    accessed: "2026-11-02"
  - title: "Python Release Python 3.12.16"
    url: https://www.python.org/downloads/release/python-31216/
    publisher: "Python Software Foundation"
    date: "2026-10-25"
    accessed: "2026-11-02"
  - title: "Python Release Python 3.11.18"
    url: https://www.python.org/downloads/release/python-31118/
    publisher: "Python Software Foundation"
    date: "2026-10-25"
    accessed: "2026-11-02"
  - title: "Compromised eMudhra CA keys: browsers block them, but bundled trust stores lag"
    url: https://northwind-press.github.io/2026/11/02/emudhra-ca-compromise/
    publisher: "Northwind Press"
    date: "2026-11-02"
    accessed: "2026-11-02"
corrections: []
---

Go and Python have shipped security releases that make their TLS code reject certificates chaining to [compromised eMudhra intermediate CA keys](https://northwind-press.github.io/2026/11/02/emudhra-ca-compromise/), according to the [Go team's account](https://go.dev/blog/emudhra-incident) and the [Python 3.15.2 release page](https://www.python.org/downloads/release/python-3152/). On 2026-10-17, Mozilla added eight eMudhra-issued intermediate certificates, six used for TLS and two for code signing, to OneCRL, blocking their use in Firefox{% include cite.html n=1 %}.

## Go: a first URGENT-track release

The Go team says it was told about the problem on 2026-10-19 and shipped a fix the same day, in its first-ever URGENT-track security release{% include cite.html n=1 %}. Its timeline puts the public announcement at 02:13 UTC on 2026-10-20 (19:13 on 2026-10-19, Pacific time){% include cite.html n=1 %}. The patch blocks certificates that chain to the compromised intermediates{% include cite.html n=1 %}. Go hands certificate checks to the platform on Windows and macOS, but on Linux it uses its own verifier, and Linux has no uniform revocation mechanism; the Go team calls that gap one of its major drivers for an expedited release{% include cite.html n=1 %}. Go's [release history](https://go.dev/doc/devel/release) lists go1.27.3 and go1.26.10, both released 2026-10-19, with security fixes to the `crypto/x509` package.

## Python: the ssl module blocks the keys

Python 3.15.2, released 2026-10-25, is an expedited security release in which the `ssl` module blocks the compromised keys "as a last resort against their use"{% include cite.html n=3 %}. Normal uses of `pip`, including upgrading `pip` itself, are protected from attacks using those keys even before `pip` is updated{% include cite.html n=3 %}.

The release pages for [3.14.10](https://www.python.org/downloads/release/python-31410/), [3.13.18](https://www.python.org/downloads/release/python-31318/), [3.12.16](https://www.python.org/downloads/release/python-31216/), and [3.11.18](https://www.python.org/downloads/release/python-31118/), all dated 2026-10-25, each list the same fix, CVE-2026-115557. For the 3.13, 3.12, and 3.11 series, python.org now publishes source releases only, with no binary installers{% include cite.html n=5 %}{% include cite.html n=6 %}{% include cite.html n=7 %}.

## What to do

Rebuild Go binaries that make TLS connections, whether directly through `net/http` or `crypto/tls` or through a dependency such as gRPC, with Go 1.27.3 or 1.26.10; the Go team says rebuilt binaries reject certificates issued by the compromised intermediates{% include cite.html n=1 %}. To see which Go version built a binary, run `go version -m <binary>`, or check it with `govulncheck -mode=binary`{% include cite.html n=1 %}. On Python, move to 3.15.2, 3.14.10, 3.13.18, 3.12.16, or 3.11.18, whichever matches your series{% include cite.html n=3 %}{% include cite.html n=4 %}{% include cite.html n=5 %}{% include cite.html n=6 %}{% include cite.html n=7 %}.
