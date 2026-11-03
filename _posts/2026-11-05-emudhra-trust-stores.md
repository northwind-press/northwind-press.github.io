---
title: "After eMudhra: where Go, Python, Node, Java, macOS, and CI tools get their trusted roots"
author: "Northwind Features"
description: "Browsers blocked the compromised eMudhra intermediates within hours, but many runtimes and tools use other trust stores; here is where each gets its roots and how to check and update it."
categories: [security]
kind: feature
sources:
  - title: "Compromised eMudhra CA keys: browsers block them, but bundled trust stores lag"
    url: https://northwind-press.github.io/2026/11/02/emudhra-ca-compromise/
    publisher: "Northwind Press"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "Go and Python ship emergency releases after eMudhra CA key compromise: what to upgrade"
    url: https://northwind-press.github.io/2026/11/02/go-python-emudhra-releases/
    publisher: "Northwind Press"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "eMudhra Intermediate CA Compromise"
    url: https://emudhra.we-have-a-problem.com/
    publisher: "emudhra.we-have-a-problem.com"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "dev-security-policy: eMudhra intermediate key compromise"
    url: https://groups.google.com/a/mozilla.org/g/dev-security-policy/c/0R3XLJL6FuE
    publisher: "Mozilla dev-security-policy"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "dev-tech-crypto: NSS 3.131.1 release"
    url: https://groups.google.com/a/mozilla.org/g/dev-tech-crypto/c/vSxZxnOMMvs
    publisher: "Mozilla dev-tech-crypto"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "x509 package - crypto/x509"
    url: https://pkg.go.dev/crypto/x509
    publisher: "The Go Project"
    accessed: "2026-11-03"
  - title: "Our Response To The eMudhra Key Disclosure Incident"
    url: https://go.dev/blog/emudhra-incident
    publisher: "The Go Project"
    accessed: "2026-11-03"
  - title: "fallback package - golang.org/x/crypto/x509roots/fallback"
    url: https://pkg.go.dev/golang.org/x/crypto/x509roots/fallback
    publisher: "The Go Project"
    accessed: "2026-11-03"
  - title: "Python Release Python 3.15.2"
    url: https://www.python.org/downloads/release/python-3152/
    publisher: "Python Software Foundation"
    date: "2026-10-25"
    accessed: "2026-11-03"
  - title: "Information for Python users regarding eMudhra / emSign CA certificate security incident"
    url: https://discuss.python.org/t/information-for-python-users-regarding-emudhra-emsign-ca-certificate-security-incident/109576
    publisher: "Python Discourse"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "Removal of emSign root cerificate [sic] (GHSA-6q48-6c7w-9gw2)"
    url: https://github.com/certifi/python-certifi/security/advisories/GHSA-6q48-6c7w-9gw2
    publisher: "certifi"
    accessed: "2026-11-03"
  - title: "Using Python on macOS"
    url: https://docs.python.org/3/using/mac.html
    publisher: "Python Software Foundation"
    accessed: "2026-11-03"
  - title: "Wednesday, October 21, 2026 Security Releases"
    url: https://nodejs.org/en/blog/vulnerability/october-2026-security-releases
    publisher: "Node.js"
    date: "2026-10-21"
    accessed: "2026-11-03"
  - title: "Node.js v24.22.1"
    url: https://nodejs.org/en/blog/release/v24.22.1
    publisher: "Node.js"
    date: "2026-10-21"
    accessed: "2026-11-03"
  - title: "Command-line API (doc/api/cli.md)"
    url: https://raw.githubusercontent.com/nodejs/node/main/doc/api/cli.md
    publisher: "Node.js"
    accessed: "2026-11-03"
  - title: "Compromised Certificates and OpenJDK Java Runtimes"
    url: https://openjdk.org/emudhra
    publisher: "OpenJDK"
    date: "2026-10-24"
    accessed: "2026-11-03"
  - title: "About the compromised eMudhra intermediate CAs"
    url: https://support.apple.com/en-us/149555
    publisher: "Apple"
    date: "2026-10-29"
    accessed: "2026-11-03"
  - title: "Release electron v44.9.1"
    url: https://github.com/electron/electron/releases/tag/v44.9.1
    publisher: "Electron"
    date: "2026-10-20"
    accessed: "2026-11-03"
  - title: "Mitigation for compromised eMudhra intermediate certificates (GHSA-jr5w-w6x2-84p9)"
    url: https://github.com/electron/electron/security/advisories/GHSA-jr5w-w6x2-84p9
    publisher: "Electron"
    accessed: "2026-11-03"
  - title: "GitLab Patch Release and Security Update: 19.5.3, 19.4.5, 19.3.7, 19.2.10, 19.1.10, 19.0.11, 18.11.14"
    url: https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/
    publisher: "GitLab"
    accessed: "2026-11-03"
  - title: "Self-signed certificates or custom Certification Authorities"
    url: https://docs.gitlab.com/runner/configuration/tls-self-signed/
    publisher: "GitLab"
    accessed: "2026-11-03"
  - title: "Install GitLab Runner using the official GitLab repositories"
    url: https://docs.gitlab.com/runner/install/linux-repository/
    publisher: "GitLab"
    accessed: "2026-11-03"
  - title: "update-ca-certificates(8)"
    url: https://manpages.debian.org/trixie/ca-certificates/update-ca-certificates.8.en.html
    publisher: "Debian"
    accessed: "2026-11-03"
  - title: "DSA-6572-1"
    url: https://security-tracker.debian.org/tracker/DSA-6572-1
    publisher: "Debian"
    accessed: "2026-11-03"
  - title: "Bug #2171507 “ca-certificates update tracking bug”"
    url: https://bugs.launchpad.net/ubuntu/+source/ca-certificates/+bug/2171507
    publisher: "Ubuntu (Launchpad)"
    accessed: "2026-11-03"
corrections: []
---
Browsers stopped trusting the compromised eMudhra intermediates within hours of the report. Many programs never ask the browser, though. They check certificates against the operating system's store, a root bundle built into the program, or a list of their own, and each of those got the eMudhra fix on its own schedule. This guide goes stack by stack: where the roots come from, what each vendor changed, and the vendor's own steps to check and update. Versions are as of 2026-11-03.

## The incident in brief

[Our news report](https://northwind-press.github.io/2026/11/02/emudhra-ca-compromise/) covers the compromise of eMudhra's emSign intermediate keys and how browsers responded. A [second piece](https://northwind-press.github.io/2026/11/02/go-python-emudhra-releases/) covers the emergency Go and Python releases that followed. A public [disclosure write-up](https://emudhra.we-have-a-problem.com/) keeps a table of patched versions across vendors, but below we rely on each vendor's own pages.

## Browsers: the baseline

Chrome received the report at 18:05 UTC on 2026-10-17 and blocked the public keys of the six TLS intermediates in a CRLSet update at 19:45 UTC, according to its post in Mozilla's [dev-security-policy forum](https://groups.google.com/a/mozilla.org/g/dev-security-policy/c/0R3XLJL6FuE). Because the block is by key, it also covers the Sectigo cross-certificates{% include cite.html n=4 %}. Mozilla got the report at 20:06 UTC the same day and finished blocking the certificates in Firefox through OneCRL at 22:59 UTC, with no update or restart needed{% include cite.html n=4 %}. Chrome says no TLS certificate under these intermediates had been logged to Certificate Transparency (CT) before its block, and that Chrome Root Store version 43 will remove the upstream eMudhra root{% include cite.html n=4 %}.

Mozilla's [NSS 3.131.1 release](https://groups.google.com/a/mozilla.org/g/dev-tech-crypto/c/vSxZxnOMMvs) removes emSign ECC Root CA - G3, emSign Root CA - C1, and emSign ECC Root CA - C3. Firefox didn't need it: the release is for software that uses the NSS store without getting OneCRL{% include cite.html n=4 %}{% include cite.html n=5 %}. The disclosure write-up says Microsoft platforms have blocked the certificates since 2026-10-20{% include cite.html n=3 %}.

## Go

On macOS and Windows, Go's [`crypto/x509` package](https://pkg.go.dev/crypto/x509) hands certificate verification to the system APIs. On Linux, which "lacks platform APIs", Go uses its own verifier, the [Go blog](https://go.dev/blog/emudhra-incident) explains. A program can also embed a root set with [`x509roots/fallback`](https://pkg.go.dev/golang.org/x/crypto/x509roots/fallback), which keeps it working "even if the operating system does not provide a verifier or system roots pool". That package "must be kept up to date for security and compatibility reasons", only binaries (not libraries) should import it, and govulncheck reports new versions{% include cite.html n=8 %}.

Go 1.27.3 and 1.26.10, released 2026-10-20 (UTC; 2026-10-19 in Pacific time), block "the usage of certificates which chained to the compromised intermediates"{% include cite.html n=7 %}. The Go team says Linux's lack of "a uniform built-in mechanism to handle revocation checking" was one of its main reasons to ship urgently{% include cite.html n=7 %}. Binaries rebuilt with either release "will automatically reject" the certificates{% include cite.html n=7 %}. To check, run `go version` for the toolchain, `go version -m <binary>` to see what built a binary, or `govulncheck -mode=binary <binary>`{% include cite.html n=7 %}.

## Python

[Python 3.15.2](https://www.python.org/downloads/release/python-3152/), released 2026-10-25, is "an expedited security release" (CVE-2026-115557). Its `ssl` module now blocks the compromised eMudhra keys "as a last resort", and normal `pip` use, including upgrading pip itself, is "now safe … even if `pip` hasn't been updated yet"{% include cite.html n=9 %}. The same fix is in 3.14.10, 3.13.18, 3.12.16 and 3.11.18, according to Python's [Discourse announcement](https://discuss.python.org/t/information-for-python-users-regarding-emudhra-emsign-ca-certificate-security-incident/109576). Python 3.10 and older are end-of-life{% include cite.html n=10 %}.

Updating Python isn't enough on its own, because of certifi. [certifi 2026.10.18](https://github.com/certifi/python-certifi/security/advisories/GHSA-6q48-6c7w-9gw2) "removes root certificates from 'emSign'". The Python thread recommends 2026.10.19 instead, "for compatibility with unaffected emSign root certificates"{% include cite.html n=10 %}. A follow-up post in the same thread says that "pip always loads the CA certificates from its vendored certifi in addition to the system trust store, and there is no supported way to disable this"{% include cite.html n=10 %}. So pip older than 26.2.2 keeps trusting the compromised intermediates "regardless of the system trust store"{% include cite.html n=10 %}.

The thread's opening post lists minimum versions to upgrade to, including certifi 2026.10.19, pip 26.2.2, uv 0.13.6, virtualenv 21.14.12, conda 26.9.4, the manylinux and musllinux images 2026.10.26-1, and the Docker official `python` images{% include cite.html n=10 %}. It also says to rebuild container images "with layer caching disabled", and it gives a hash-pinned command for updating pip safely{% include cite.html n=10 %}.

On a Mac with Python from python.org, the installer's last step, Install Certificates.command, "will use the new Python to download and install SSL root certificates", according to [Python's macOS documentation](https://docs.python.org/3/using/mac.html). The thread says that bundle is certifi, and gives the upgrade, run after updating pip: `…/Python.framework/Versions/3.15/bin/python3.15 -m pip install --upgrade certifi`{% include cite.html n=10 %}.

## Node.js

Node's [October 2026 security releases](https://nodejs.org/en/blog/vulnerability/october-2026-security-releases), 26.12.1, 24.22.1 and 22.23.4, update "ca-cert (eMudhra Intermediate CA Compromise)" on all three lines. The [24.22.1 release notes](https://nodejs.org/en/blog/release/v24.22.1), dated 2026-10-21, show two separate changes. The bundled roots move to NSS 3.131.1, and a new check rejects chains that contain blocked public keys{% include cite.html n=14 %}.

By default Node trusts the roots bundled into the binary, and `NODE_EXTRA_CA_CERTS` only adds PEM certificates to them, according to Node's [command-line documentation](https://raw.githubusercontent.com/nodejs/node/main/doc/api/cli.md). Neither set applies when a TLS or HTTPS client passes its own `ca` option, and the variable is read only when the process starts{% include cite.html n=15 %}. Setting `NODE_USE_SYSTEM_CA=1` (added in v24.6.0 and v22.19.0) or the `--use-system-ca` flag makes Node use the system store's trusted certificates "along with" the bundled ones{% include cite.html n=15 %}. In our reading, neither switch removes a bundled root, so updating Node is the fix.

## Java

[OpenJDK's guidance page](https://openjdk.org/emudhra), last updated 2026-10-24 19:24 UTC, tracks the fix as JDK-8395690 (CVE-2026-114820). It tells users to install a vendor runtime whose release notes document that fix "when available", so updated builds depend on each vendor{% include cite.html n=16 %}.

Where the roots live depends on how Java was installed. Standalone runtimes use their own keystore: `$JDK_HOME/lib/security/cacerts` on JDK 11 and later, or `$JDK_HOME/jre/lib/security/cacerts` on JDK 8{% include cite.html n=16 %}. OpenJDK packaged by Arch, Fedora, Gentoo, Oracle Linux, and RHEL "most likely uses the operating system's certificates", so updating those "is likely sufficient"; the FreeBSD and Homebrew packages don't use the OS store{% include cite.html n=16 %}.

For standalone runtimes, OpenJDK's steps are{% include cite.html n=16 %}:

- Check with OpenJDK's `CheckCerts.java` (JDK 8 and later).
- Preferably, update the runtime.
- Otherwise, back up `cacerts`, remove the aliases `emsignrootcag1 [jdk]`, `emsignrootcag2 [jdk]`, `emsigneccrootcag3 [jdk]` and `comodoaaaca [jdk]` with `keytool -delete -cacerts -alias …`, and restart.
- Or turn on revocation checking with `-Dcom.sun.net.ssl.checkRevocation=true -Dcom.sun.security.enableCRLDP=true`.

On Debian and Ubuntu, updating `ca-certificates` and `ca-certificates-java` "is not sufficient" because of a long-standing bug{% include cite.html n=16 %}. OpenJDK's workaround, as root, is to delete `/etc/ssl/certs/java/cacerts` and then run `update-ca-certificates --fresh`{% include cite.html n=16 %}.

## macOS command-line tools

Apple's [support note 149555](https://support.apple.com/en-us/149555) splits macOS software in two. Safari, Mail, and apps that use Apple's networking and security frameworks get Apple's block automatically{% include cite.html n=17 %}. Some command-line tools that ship with macOS or the Xcode Command Line Tools, including curl, git, python3, ruby, perl, and openssl, check against `/etc/ssl/cert.pem` instead, and for chains to roots in that file they check neither Apple's block nor revocation{% include cite.html n=17 %}.

Apple has blocked the 12 affected certificates (the six TLS intermediates and their Sectigo cross-signs) since 2026-10-19 and emSign ECC Root CA - G3 since 2026-10-23, through configuration data rather than a software update{% include cite.html n=17 %}. The fix for `/etc/ssl/cert.pem` itself "will be available in a future software update", and Apple warns that a macOS update can replace the file{% include cite.html n=17 %}.

Until then, Apple's note gives a manual fix that needs an admin account and can be deployed through device management{% include cite.html n=17 %}. In summary, you back up `/etc/ssl/cert.pem`, remove emSign ECC Root CA - G3, and optionally remove AAA Certificate Services as well; without that last step, the tools can still verify the six Sectigo cross-signed certificates{% include cite.html n=17 %}. An `openssl` command in the note then shows whether either root is still present{% include cite.html n=17 %}. The trade-off is that tools relying only on this file may fail to verify some unaffected sites that chain to those roots{% include cite.html n=17 %}. Apple says to re-run the check after every macOS update until its fix ships, and to contact the developer of any app with its own root list{% include cite.html n=17 %}. Use the note itself for the exact commands.

## Electron apps

[Electron 44.9.1](https://github.com/electron/electron/releases/tag/v44.9.1), released 2026-10-20, includes "the mitigation for compromised eMudhra intermediate certificates". The [Electron advisory](https://github.com/electron/electron/security/advisories/GHSA-jr5w-w6x2-84p9) says the update adds the block to both Chromium's networking and Node's `tls`, `https`, and `fetch` inside Electron. The fixed versions are 45.0.0-beta.6, 44.9.1, 43.8.1 and 42.11.16{% include cite.html n=19 %}. For app developers, "there are no app side workarounds, you must update to a patched version of Electron"{% include cite.html n=19 %}.

## GitLab and GitLab Runner

[GitLab 19.5.3](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-3-released/) and the matching patch releases 19.4.5, 19.3.7, 19.2.10, 19.1.10, 19.0.11 and 18.11.14 remove trust in the eight intermediates from the certificate stores GitLab ships (CVE-2026-111943). GitLab.com is already patched{% include cite.html n=20 %}. But GitLab notes that "Upgrading GitLab does not update GitLab Runner", which "verifies certificates on its own", so self-hosted Runner must be updated to 19.5.1{% include cite.html n=20 %}. GitLab also says to rebuild any CI/CD job images that include their own `ca-certificates` package{% include cite.html n=20 %}.

By default Runner reads the system certificate store to verify the GitLab server, or a custom file set with `tls-ca-file` or placed in `/etc/gitlab-runner/certs/`, according to Runner's [TLS documentation](https://docs.gitlab.com/runner/configuration/tls-self-signed/). Job containers have their own store: the user image doesn't get the host's certificates by default, and the helper image installs only a `ca.crt` you map in{% include cite.html n=21 %}. GitLab's [install guide](https://docs.gitlab.com/runner/install/linux-repository/) gives the update as `sudo apt update && sudo apt install gitlab-runner` or `sudo yum update && sudo yum install gitlab-runner`. If you pin a version, install the matching `gitlab-runner-helper-images` too{% include cite.html n=22 %}.

## Debian and Ubuntu `ca-certificates`

On Debian, [`update-ca-certificates`](https://manpages.debian.org/trixie/ca-certificates/update-ca-certificates.8.en.html) builds `/etc/ssl/certs/ca-certificates.crt` from `/etc/ca-certificates.conf`. A `!` at the start of a line in that file deactivates the CA, and `--fresh` first removes the existing symlinks in `/etc/ssl/certs`{% include cite.html n=23 %}. Debian's [DSA-6572-1](https://security-tracker.debian.org/tracker/DSA-6572-1) fixes `ca-certificates` in trixie at version `20250419+deb13u1`, replacing `20250419`{% include cite.html n=24 %}. On Ubuntu, [bug 2171507](https://bugs.launchpad.net/ubuntu/+source/ca-certificates/+bug/2171507) is marked "Fix Released" for releases from Trusty through Tenacious. The update moves to NSS bundle 2.90 and removes "emSign ECC Root CA - G3"{% include cite.html n=25 %}.

## Our view

These are our recommendations, not the vendors'.

- Before assuming the browser fix covers a service, find out which store it actually uses. Go on Linux, Node, pip, standalone Java, Electron apps, and macOS command-line tools each use their own store or their own verifier.
- Update the runtime first, then the bundles that travel with it. For Python that means certifi and pip as well as the interpreter.
- Rebuild container images without the layer cache. Updating a host doesn't change the certificates an image carries.
- On Macs that run curl, git, or the system python3 against production, apply Apple's `cert.pem` steps and re-check after every macOS update.
