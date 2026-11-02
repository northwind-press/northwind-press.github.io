---
title: "Cloudflare makes services for private origins generally available, by account-team entitlement"
author: "Infra & Cloud Reporter"
description: "If your origins sit on private IPs behind Cloudflare One connectivity, you can now put Cloudflare's WAF, caching, bot management and Workers in front of them once your account team enables the Private Origins entitlement and you add a return route for Cloudflare's source range."
date: 2026-11-03 14:00
categories: [infra]
kind: news
sources:
  - title: "Cloudflare services for private origins is now generally available"
    url: https://blog.cloudflare.com/private-origins-public-to-private/
    publisher: "Cloudflare"
    date: "2026-10-30"
    accessed: "2026-11-02"
  - title: "Private origins"
    url: https://developers.cloudflare.com/dns/private-origins/
    publisher: "Cloudflare Docs"
    date: "2026-05-07"
    accessed: "2026-11-02"
  - title: "Private network routing"
    url: https://developers.cloudflare.com/dns/private-origins/private-network-routing/
    publisher: "Cloudflare Docs"
    accessed: "2026-11-02"
  - title: "Set up a private origin via Cloudflare WAN"
    url: https://developers.cloudflare.com/dns/private-origins/set-up-via-cloudflare-wan/
    publisher: "Cloudflare Docs"
    accessed: "2026-11-02"
  - title: "Route public traffic to private applications with Cloudflare"
    url: https://blog.cloudflare.com/private-origins-dns-routing/
    publisher: "Cloudflare"
    date: "2026-06-10"
    accessed: "2026-11-02"
corrections: []
---

Cloudflare made its services for private origins [generally available](https://blog.cloudflare.com/private-origins-public-to-private/) on 2026-10-30. A proxied A or AAAA record can now point at a private IP address, and Cloudflare reaches the origin over the customer's existing Cloudflare One connectivity rather than the internet. WAF and managed rules, bot management, rate limiting, caching, transform and rewrite rules, and Workers apply as they do for any other origin, and the origin needs no public IP or inbound firewall exception{% include cite.html n=1 %}.

## Who can use it

General availability here does not mean self-serve. Cloudflare says it is "opening access beyond that beta group"{% include cite.html n=1 %}. Each account still needs the Private Origins entitlement, which the account team turns on{% include cite.html n=1 %}. As of 2026-11-02, Cloudflare's [private origins documentation](https://developers.cloudflare.com/dns/private-origins/), last updated 2026-05-07, still labels the feature "Enterprise-only" and "closed beta"{% include cite.html n=2 %}.

Supported connectivity is IPsec, GRE, Cloudflare Network Interconnect (CNI), Cloudflare Tunnel or Cloudflare Mesh{% include cite.html n=1 %}. With Cloudflare WAN, no connector software runs at the origin; with Mesh, one connector inside the private network can serve several origins{% include cite.html n=1 %}.

## Where private routing is enforced

The **Use private network routing** setting turns on automatically for records pointing at 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10 and fc00::/7, according to the [routing reference](https://developers.cloudflare.com/dns/private-origins/private-network-routing/). For those ranges it can't be turned off: setting `private_routing` to `false` through the API returns an error{% include cite.html n=3 %}. It can be turned on by hand for a public IP that is reachable only through the private network{% include cite.html n=3 %}. It applies per name: if one A or AAAA record on a name uses it, every record on that name does{% include cite.html n=3 %}. The [June closed-beta post](https://blog.cloudflare.com/private-origins-dns-routing/) called the API field `use_private_routing`; the GA post and current docs use `private_routing`{% include cite.html n=1 %}{% include cite.html n=3 %}.

## Limitations

The GA post says Argo Smart Routing and Dedicated CDN Egress IPs aren't supported, and origin health checks require Load Balancing{% include cite.html n=1 %}. The post refers readers to the docs for a full list{% include cite.html n=1 %}, but when we checked on 2026-11-02 the private-origins docs pages listed none of these limitations{% include cite.html n=2 %}.

## What comes next

Cloudflare is targeting a closed beta in early 2027 for private-to-private traffic, where users, services and AI agents on private networks reach applications on other private networks. Participation is through the account team{% include cite.html n=1 %}.

## What to do

1. Ask your account team to enable the Private Origins entitlement{% include cite.html n=1 %}.
2. Have Cloudflare One connectivity in place. Unless you connect over Cloudflare Tunnel, the account also needs Unified Routing, which the account team can enable{% include cite.html n=1 %}.
3. On Cloudflare WAN or Mesh, route Cloudflare's source ranges, 100.64.0.0/12 and 2606:4700:cf1:5000::/64, back to Cloudflare from the origin's network{% include cite.html n=1 %}. Cloudflare says a missing return route was the most common setup failure in the beta{% include cite.html n=1 %}.
4. On WAN, the [setup guide](https://developers.cloudflare.com/dns/private-origins/set-up-via-cloudflare-wan/) also requires a Cloudflare WAN subscription, a private Cloudflare Source IP range (100.64.0.0/12 by default), automatic return routing left off, and two IPsec tunnels with prioritised static routes.
5. Create a proxied A or AAAA record for the private IP, confirm **Use private network routing** is on, and test the hostname from outside your network{% include cite.html n=3 %}{% include cite.html n=4 %}.
