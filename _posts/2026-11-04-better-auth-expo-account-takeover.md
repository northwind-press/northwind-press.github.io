---
title: "Better Auth Expo plugin flaw allows account takeover; upgrade and rotate the secret"
author: "Northwind Security Desk"
description: "Servers using Better Auth's expo() plugin should upgrade better-auth and @better-auth/expo to 1.7.16, then rotate the application secret; signatures issued before the fix stay valid until then."
categories: [security]
kind: news
date: 2026-11-04 08:07
placement: top
sources:
  - title: "@better-auth/expo: Authorization proxy can sign values it did not issue (GHSA-4wq4-2ppv-q3hg)"
    url: https://github.com/better-auth/better-auth/security/advisories/GHSA-4wq4-2ppv-q3hg
    publisher: "Better Auth"
    date: "2026-11-03"
    accessed: "2026-11-04"
  - title: "v1.7.16"
    url: https://github.com/better-auth/better-auth/releases/tag/v1.7.16
    publisher: "Better Auth"
    date: "2026-11-03"
    accessed: "2026-11-04"
  - title: "CVE-2026-121802"
    url: https://www.cve.org/CVERecord?id=CVE-2026-121802
    publisher: "CVE Program (CNA: MITRE)"
    date: "2026-11-04"
    accessed: "2026-11-04"
corrections: []
---

The Better Auth project has fixed a flaw in its Expo plugin that lets an unauthenticated attacker take over accounts. Its [security advisory](https://github.com/better-auth/better-auth/security/advisories/GHSA-4wq4-2ppv-q3hg), published on 2026-11-03, says an attacker who knows a user's email address can sign in as that user and change the account's email address, with no action from the user. If the session cookie cache is enabled, an attacker who knows a user's ID can also act as that user.

The cause, per the advisory, is a public endpoint that the `expo()` server plugin adds to help start social sign-in from the system browser. It signed a value taken from the request with the application secret, without checking that the server had issued it. Better Auth uses the same secret for email verification links and, when enabled, the session cookie cache. The same endpoint also had an open redirect, and wildcard entries in `trustedOrigins` could match URLs outside their intended scheme, host, or path{% include cite.html n=1 %}.

Better Auth rates the advisory Critical, CVSS 3.1 9.1{% include cite.html n=1 %}. The flaw is tracked as CVE-2026-121802; the [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-121802), assigned by MITRE, gives the same score.

## Who is affected

You are affected if your server registers the `expo()` plugin from `@better-auth/expo` 1.4.0-beta.6 or later; no other setting is needed. The wildcard-origin problem also requires a wildcard entry in `trustedOrigins`{% include cite.html n=1 %}.

The advisory lists both `@better-auth/expo` and the core `better-auth` package as affected before 1.7.16, and on the beta line from 1.8.0-beta.0 before 1.8.0-beta.5{% include cite.html n=1 %}. The CVE record names only `@better-auth/expo` before 1.7.16{% include cite.html n=3 %}.

## What to do

- **Upgrade both packages.** Better Auth says to move `@better-auth/expo` and `better-auth` to 1.7.16, or to 1.8.0-beta.5 on the beta line{% include cite.html n=1 %}. Both fixes shipped in the [v1.7.16 release](https://github.com/better-auth/better-auth/releases/tag/v1.7.16) on 2026-11-03.
- **Then rotate the application secret** if the endpoint was reachable. The advisory says signatures issued before the fix stay valid until the secret changes, but it does not say whether a rotation that keeps the old secret available as a fallback is enough{% include cite.html n=1 %}. In our view, make sure the old secret is no longer accepted.
- **If Expo sign-in through an SSO identity provider fails after upgrading,** add the provider's origin to `trustedOrigins`, as the advisory advises{% include cite.html n=1 %}.
- **If you can't upgrade yet** and don't use Expo social sign-in, remove the `expo()` server plugin. Otherwise the advisory describes a request filter for the plugin's authorization-proxy endpoint, which it says blocks the signing problem only{% include cite.html n=1 %}.

The 1.7.16 release also fixes other authentication bugs in `better-auth`, including email verification and change-email links that worked for accounts other than the one they were issued to, and revoked sessions that stayed usable with secondary storage or the cookie cache{% include cite.html n=2 %}.

## What is not known

Neither Better Auth's advisory nor the CVE record says whether the flaw has been exploited{% include cite.html n=1 %}{% include cite.html n=3 %}. We could not confirm this independently.
