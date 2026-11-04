---
title: "Cloudflare Q3 2026 DDoS report: shorter attacks, CLDAP fades, DNS amplification up 215%"
author: "Northwind Infra & Cloud Desk"
description: "Our advice: check that your DDoS mitigation engages without a human, because Cloudflare says 96% of the 18.2 million network-layer attacks it mitigated in Q3 2026 ended in under 10 minutes."
date: 2026-11-04 08:02
categories: [infra]
kind: news
sources:
  - title: "DDoS threat report for 2026 Q3"
    url: https://blog.cloudflare.com/ddos-threat-report-2026-q3/
    publisher: "Cloudflare"
    date: "2026-10-29"
    accessed: "2026-11-04"
corrections: []
---

Cloudflare mitigated 18.2 million network-layer DDoS attacks and 14.4 trillion HTTP DDoS requests in the third quarter of 2026, according to its [quarterly DDoS threat report](https://blog.cloudflare.com/ddos-threat-report-2026-q3/), published on 2026-10-29. Every figure below is Cloudflare's own, measured on its own network, and covers July to September.

## Many small attacks

Cloudflare puts the network-layer count at about 8,226 attacks an hour, or one every 0.44 seconds{% include cite.html n=1 %}. The report's body says the 18.2 million total is up 208% on Q3 2025. Its summary instead describes 208% as the surge in short-burst attacks under 10 minutes and 1 Gbps{% include cite.html n=1 %}. The body adds that 96% of the quarter's network-layer attacks ended in under 10 minutes, and 98% stayed under 1 Gbps. Cloudflare notes that is still enough to overwhelm a server or website{% include cite.html n=1 %}. It describes short, mid-range, high-count attacks as the signature of DDoS-for-hire "booter" services{% include cite.html n=1 %}.

## Fewer giants

Cloudflare counted 251 hyper-volumetric attacks, above 1 Tbps, in Q3, down from 805 in Q2{% include cite.html n=1 %}. Cloudflare says the drop is "possibly" a reflection of law enforcement action earlier in 2026 against four large Internet of Things (IoT) botnets, and describes it as "coinciding" with that action{% include cite.html n=1 %}. It also says new IoT botnet variants keep emerging{% include cite.html n=1 %}. Mirai-classified traffic accounted for 46.5% of all network-layer bytes Cloudflare mitigated in the quarter, and the longest sustained Mirai attack ran 49.7 hours{% include cite.html n=1 %}.

## Vector shifts

By Cloudflare's measures:

- **CLDAP:** Connectionless LDAP reflection attacks, which abuse public domain controllers on UDP port 389, fell to 0.05% of attacks after a surge in the first half of the year{% include cite.html n=1 %}.
- **DNS amplification:** up 215%, to 3.43% of network-layer attacks. Cloudflare says these attacks exploit open DNS resolvers, using small spoofed queries to direct large replies at the victim{% include cite.html n=1 %}.
- **Other UDP floods:** up from 14.06% to 31.31% of network-layer attacks{% include cite.html n=1 %}.

In Cloudflare's ranking, the United States replaced China as the most-attacked location, and Canada rose from 16th to sixth{% include cite.html n=1 %}.

## What to do

- **Check how fast your mitigation engages.** Cloudflare argues that most attacks "end long before a human analyst could see the alert", which is why its own systems mitigate without human intervention{% include cite.html n=1 %}. In our view, if your protection depends on someone noticing an alert and switching mitigation on, these figures suggest most attacks will be over before it starts.
- **Don't run open resolvers.** Cloudflare says DNS amplification exploits open DNS resolvers{% include cite.html n=1 %}. In our view, operators who run their own resolvers should make sure those resolvers don't answer queries from the whole internet; Cloudflare's report doesn't make that recommendation itself.
- **Service providers:** Cloudflare offers a free DDoS Botnet Threat Feed to help hosting, cloud, and internet providers find and take down abusive IP addresses and accounts. It says more than 800 networks have signed up{% include cite.html n=1 %}.
