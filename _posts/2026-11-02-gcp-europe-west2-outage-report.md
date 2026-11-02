---
title: "Google Cloud europe-west2 outage: zone b's generators never got a start signal"
author: "Infra & Cloud Reporter"
description: "Google's report on the 2026-10-20 europe-west2 outage is a prompt to check that zonal workloads can recover in another zone, or region, when capacity there runs short."
categories: [infra]
kind: news
date: 2026-11-02 22:40
sources:
  - title: "Multiple services were experiencing issues in the europe-west2 region (incident report)"
    url: https://status.cloud.google.com/incidents/Xs2XTHzAVC9YnafnPyzj
    publisher: "Google Cloud Service Health"
    date: "2026-10-27"
    accessed: "2026-11-02"
corrections: []
---

A power failure at the facility hosting Google Cloud zone europe-west2-b took the zone offline on 2026-10-20 because its backup generators were never told to start, according to Google's [incident report](https://status.cloud.google.com/incidents/Xs2XTHzAVC9YnafnPyzj) of 2026-10-27. Failover traffic then caused elevated errors across the region, and primary impact lasted 6 hours 8 minutes{% include cite.html n=1 %}.

## What broke

The facility has two utility feeds, A and B, generators started by redundant programmable logic controllers (PLCs), and 5 minutes of UPS battery{% include cite.html n=1 %}. After problems found in a quarterly generator load test on 2026-10-14, the feed-B breaker was opened and locked out for repairs, leaving feed A carrying the whole load{% include cite.html n=1 %}.

At 22:53 PT on 19 Oct (05:53 UTC on 20 Oct), an underground cable fault outside the facility cut feed A{% include cite.html n=1 %}. The PLCs' undervoltage sensing was wired upstream of the open feed-B breaker, where the line was still live, so both PLCs saw a healthy source and never commanded a generator start; Google says the logic didn't also check breaker position{% include cite.html n=1 %}. The PLC blocked a remote load transfer, and the batteries ran out while the onsite team moved the facility to a standby utility source{% include cite.html n=1 %}.

## Impact

Zone b lost power at 23:00 PT (06:00 UTC){% include cite.html n=1 %}. Zonal resources there were unavailable, including Compute Engine VMs, zonal disks, zonal GKE control planes and non-HA Cloud SQL instances{% include cite.html n=1 %}. In zones a and c, failover demand exhausted compute capacity and control-plane calls to the offline zone timed out, causing latency, HTTP 500 and 503 errors, and failed changes to some regional resources{% include cite.html n=1 %}.

Standby power returned at 23:54 PT (06:54 UTC), but storage recovering from unclean shutdowns held back service restoration{% include cite.html n=1 %}. Core platform disruption ended at 04:29 PT (11:29 UTC), and by 05:08 PT (12:08 UTC) over 99% of Compute Engine VMs were healthy{% include cite.html n=1 %}. Google found no impact outside europe-west2{% include cite.html n=1 %}.

## Google's commitments

As stated in the report (all dates 2026){% include cite.html n=1 %}:

- Utility: cable fault located, completed 26 Oct; feed A repaired, estimated 30 Oct; facility back on feeds A and B, estimated 31 Oct.
- Generators: load transfer tests completed 20 and 26 Oct; another with both feeds, estimated 31 Oct.
- PLC: reconfigured and validated, completed 26 Oct; vendor code review and telemetry validation, estimated 31 Oct; checks at all sites with similar topologies and PLC makers, estimated 15 Nov.
- Procedures: emergency procedures updated, completed 26 Oct; drilled twice per shift, completed 24 Oct.
- Change management: maintenance freeze and elevated approvals at similar sites, estimated 30 Oct.
- Cloud services: automated incident communications and wider platform testing, undated.

The report doesn't say whether the 30 and 31 Oct estimates were met.

## What to do

- Google says zonal resources such as VMs need customer-provisioned failover or cross-zone recovery{% include cite.html n=1 %}.
- Don't assume spare capacity in the surviving zones. Here it ran out, and Google prioritised active customer reservations{% include cite.html n=1 %}.
- Multi-zone isn't region-proof: regional services degraded too, so workloads that must ride out such an event need a path to another region{% include cite.html n=1 %}.
