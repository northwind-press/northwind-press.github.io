---
title: "PostgreSQL 14 reaches end of life on 2026-11-12"
author: "Northwind Infra & Cloud Desk"
description: "If you still run PostgreSQL 14, take its final minor release on 2026-11-12 and plan a major upgrade, because the community stops shipping fixes for it after that."
categories: [infra]
kind: news
date: 2026-11-03 08:05
sources:
  - title: "Versioning Policy"
    url: https://www.postgresql.org/support/versioning/
    publisher: "PostgreSQL Global Development Group"
    accessed: "2026-11-03"
  - title: "Roadmap"
    url: https://www.postgresql.org/developer/roadmap/
    publisher: "PostgreSQL Global Development Group"
    accessed: "2026-11-03"
  - title: "PostgreSQL 19 RC 1 Released!"
    url: https://www.postgresql.org/about/news/postgresql-19-rc-1-released-3409/
    publisher: "PostgreSQL Global Development Group"
    date: "2026-10-15"
    accessed: "2026-11-03"
corrections: []
---

Community support for PostgreSQL 14 ends on 2026-11-12. The PostgreSQL project's [versioning page](https://www.postgresql.org/support/versioning/) lists that date as the final release for version 14. As of 2026-11-03, the current 14 minor is 14.24{% include cite.html n=1 %}.

## What changes

The project supports each major version for five years after its first release. After that it ships a final minor version, and the version becomes unsupported{% include cite.html n=1 %}. PostgreSQL 14 was first released on 2021-09-30{% include cite.html n=1 %}. Supported majors get bug fixes and, when needed, security fixes in minor releases at least once every three months{% include cite.html n=1 %}. Once 14 is end of life, it gets neither.

The 2026-11-12 date is also the next scheduled update release for all supported versions on the project's [release roadmap](https://www.postgresql.org/developer/roadmap/). The minor releases after that are planned for 2027-02-11, 2027-05-13 and 2027-08-12{% include cite.html n=2 %}. Each is made only for supported versions, so 14 won't get them{% include cite.html n=2 %}.

As of 2026-11-03, the supported majors after 14 are 15, 16, 17 and 18. Version 15 reaches end of life on 2027-11-11 and 18 on 2030-11-14{% include cite.html n=1 %}. PostgreSQL 19 is not yet released. The project's [RC 1 announcement](https://www.postgresql.org/about/news/postgresql-19-rc-1-released-3409/) says a second release candidate will arrive on 2026-11-12. General availability is planned for 2026-11-19, unless an issue requires a delay or another release candidate{% include cite.html n=3 %}.

The end-of-life date here is the community's. Managed database providers set their own support timelines for PostgreSQL 14, and this item does not cover them.

## What to do

- **Inventory.** Find every PostgreSQL 14 instance you run, including replicas and test environments.
- **Take the final minor.** The project recommends always running the current minor of your major. Minor upgrades need no dump and restore: stop the server, install the new binaries and restart. Read the release notes first, because some minors need extra steps{% include cite.html n=1 %}.
- **Plan the major upgrade.** Moving to a new major needs a dump and reload, or `pg_upgrade`, because the data directory format changes between majors{% include cite.html n=1 %}. You can jump straight from 14 to any supported major without stopping at the versions in between{% include cite.html n=1 %}.
- **Read the intervening release notes.** If you skip majors, the project recommends reading the release notes of every major in between, plus the upgrading section for your target version{% include cite.html n=1 %}.
- **Check the timing if you're targeting 19.** Its planned GA is 2026-11-19, a week after 14's final release{% include cite.html n=3 %}.
