---
title: "Cisco ASA and FTD SSL VPN reload flaw is being exploited; Cisco urges update"
author: "Northwind Security Desk"
description: "Cisco says attackers are exploiting a flaw that reloads ASA and FTD firewalls running SSL VPN with secondary authentication; check your configuration and update to a fixed release."
categories: [security]
kind: news
date: 2026-11-03 08:02
sources:
  - title: "Cisco Secure Firewall ASA and Secure Firewall Threat Defense Software Remote Access SSL VPN Tunnel Denial of Service Vulnerability (cisco-sa-asaftd-tunnel-dos-s6mgkb75)"
    url: https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-asaftd-tunnel-dos-s6mgkb75
    publisher: "Cisco"
    date: "2026-10-28"
    accessed: "2026-11-03"
  - title: "CISA Known Exploited Vulnerabilities catalog (kev-data)"
    url: https://github.com/cisagov/kev-data
    publisher: "CISA"
    date: "2026-10-30"
    accessed: "2026-11-03"
  - title: "CVE-2026-76418"
    url: https://www.cve.org/CVERecord?id=CVE-2026-76418
    publisher: "CVE Program (CNA: Cisco)"
    date: "2026-10-28"
    accessed: "2026-11-03"
corrections: []
---

Cisco says attackers are exploiting CVE-2026-76418, a flaw in the Remote Access SSL VPN service of its Secure Firewall Adaptive Security Appliance (ASA) and Secure Firewall Threat Defense (FTD) software. According to Cisco's [security advisory](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-asaftd-tunnel-dos-s6mgkb75), published on 2026-10-28, an unauthenticated, remote attacker can make an affected device reload by sending a crafted request when connecting to the SSL VPN, causing a denial of service. The cause is logic errors when secondary authentication is configured on a tunnel group.

Cisco rates the flaw High, CVSS 3.1 8.6{% include cite.html n=1 %}. The US Cybersecurity and Infrastructure Security Agency (CISA) added it to its [Known Exploited Vulnerabilities (KEV) catalog](https://github.com/cisagov/kev-data) on 2026-10-29.

## Who is affected

A device is affected only when all three conditions hold: it runs a vulnerable ASA or FTD release, its SSL remote access VPN login service is reachable, and secondary authentication is configured in the tunnel-group scope the advisory describes. A successful VPN login is not needed to reach the affected code{% include cite.html n=1 %}.

To check, Cisco says to look for the `webvpn` keyword with SSL VPN enabled on at least one interface. If `tunnel-group-list enable` is configured, check every tunnel group, including the default `DefaultWEBVPNGroup`, for `secondary-authentication-server-group`. If the group list is disabled, check `DefaultWEBVPNGroup` anyway: disabling the list does not remove exposure when that group uses secondary authentication. FTD users should review the deployed remote access VPN policy in Secure Firewall Management Center (FMC) or Device Manager (FDM){% include cite.html n=1 %}.

## Fixed releases

The first fixed releases in Cisco's advisory are{% include cite.html n=1 %}:

- **ASA:** 9.16.4.104 (for 9.16 and earlier), 9.18.4.96, 9.20.4.50, 9.22.3.200, 9.23.1.48, and 9.24.1.27 or 9.24.10.1.
- **FTD:** 7.0.11 (for 7.0 and earlier), 7.2.13, 7.4.9, 7.6.7, 7.7.14, 10.0.3, and 10.1.1.

The table has no row for ASA 9.19, which the [CVE record](https://www.cve.org/CVERecord?id=CVE-2026-76418) lists as affected. Cisco's Software Checker reports the first fixed release for a specific version{% include cite.html n=1 %}.

## What to do

- **Update to a fixed release.** Cisco strongly recommends it, and says there are no workarounds{% include cite.html n=1 %}.
- **If you can't update yet,** Cisco describes a temporary mitigation: if `DefaultWEBVPNGroup` doesn't use secondary authentication, disable the tunnel group list; if it does, remove secondary authentication from it. Cisco warns that both have side effects, and that the second lowers the VPN's security posture{% include cite.html n=1 %}.
- CISA asks organizations to apply Cisco's fix under Binding Operational Directive 26-04, and set a remediation due date of 2026-11-01{% include cite.html n=2 %}.

## What is not known

Cisco says only that its Product Security Incident Response Team became aware of active exploitation in October 2026{% include cite.html n=1 %}. Neither Cisco nor CISA says who is exploiting the flaw or how widely, and CISA lists known ransomware use as "Unknown"{% include cite.html n=1 %}{% include cite.html n=2 %}.
