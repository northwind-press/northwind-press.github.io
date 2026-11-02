---
title: "Node.js 26 enters LTS as Node.js 27 opens the first alpha of the annual release schedule"
author: "Software & Dev Reporter"
description: "Keep production on an LTS line and plan your move off Node.js 22 before its 2027-04-30 end of life; library authors should add the 27.0.0 alpha to CI now."
categories: [software]
kind: news
date: 2026-11-04 09:00
sources:
  - title: "Node.js 26 ChangeLog: 2026-10-28, Version 26.13.0 'Lithium' (LTS)"
    url: https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V26.md#26.13.0
    publisher: "Node.js project"
    date: "2026-10-28"
    accessed: "2026-11-02"
  - title: "v27.0.0-alpha.0.0.0"
    url: https://github.com/nodejs/node/releases/tag/v27.0.0-alpha.0.0.0
    publisher: "Node.js project"
    date: "2026-10-29"
    accessed: "2026-11-02"
  - title: "Evolving the Node.js Release Schedule"
    url: https://nodejs.org/en/blog/announcements/evolving-the-nodejs-release-schedule
    publisher: "Node.js Releasers"
    accessed: "2026-11-02"
  - title: "nodejs/Release: Release schedule"
    url: https://github.com/nodejs/release
    publisher: "Node.js Release Working Group"
    accessed: "2026-11-02"
corrections: []
---

Node.js 26 became a Long Term Support (LTS) line on 2026-10-28, and a day later the project shipped the first alpha of Node.js 27, the first line under its new one-major-a-year schedule. For teams planning upgrades, the production choice is unchanged: stay on LTS. The new work is for library authors.

## Node.js 26 'Lithium' is LTS

[Version 26.13.0 'Lithium'](https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V26.md#26.13.0), released 2026-10-28, moves 26.x to LTS with updates through the end of April 2029. Apart from metadata such as the `process.release` object, it contains no changes from 26.12.1, so teams already on 26.12.1 get nothing new but the label{% include cite.html n=1 %}. Teams coming from Node.js 24 or 22 should note that the official Linux binaries have been linked against libatomic since Node.js 25, and some distributions need it installed separately{% include cite.html n=1 %}.

## One major a year, and every line becomes LTS

The project's [announcement of the new schedule](https://nodejs.org/en/blog/announcements/evolving-the-nodejs-release-schedule) replaces two majors a year with one. Each line spends six months in Alpha (October to March), where semver-major changes are allowed, then six months as Current from April, then 30 months as LTS. The odd/even split ends, and every line becomes LTS{% include cite.html n=3 %}. Node.js 26 is the last line on the old model{% include cite.html n=3 %}.

Alpha releases are signed, tagged and tested against popular packages, but their API and ABI may change between releases. The [Release working group's schedule](https://github.com/nodejs/release) says they are for library authors and CI pipelines, not production. The announcement gives `27.0.0-alpha.1` as an example version; the actual first tag is `27.0.0-alpha.0.0.0`{% include cite.html n=2 %}. As of 2026-11-02, the schedule puts 27.x at Current on 2027-04-22, LTS on 2027-10-20 and end of life on 2030-04-30{% include cite.html n=4 %}.

## What library authors should test in the alpha

The [27.0.0-alpha.0.0.0 release notes](https://github.com/nodejs/node/releases/tag/v27.0.0-alpha.0.0.0), dated 2026-10-29, include these changes, among the most likely to affect existing code:

- **V8 15.6**, up from 14.6 in Node.js 26{% include cite.html n=2 %}.
- **A new default heap limit.** Without `--max-old-space-size`, the limit is half of physical memory, clamped between 256 MB and 4 GB, and memory held by `Buffer` and `ArrayBuffer` now counts toward it. The project advises setting the flag explicitly if you relied on the old defaults{% include cite.html n=2 %}.
- **A new serialization format.** Older Node.js releases can't read data from `v8.serialize()`, `structuredClone()` and `postMessage()`, which matters for caches or messages shared across versions{% include cite.html n=2 %}.
- **OpenSSL 3 or later is required** to build, and OpenSSL engine support has ended{% include cite.html n=2 %}.

## What to do

Our recommendation, based on the project's guidance: keep production on an LTS line. As of 2026-11-02, Node.js 26 is Active LTS, Node.js 24 entered Maintenance on 2026-10-20, and Node.js 22 reaches end of life on 2027-04-30, so plan moves off 22 now{% include cite.html n=4 %}. Library authors should add the 27.x alpha to CI; the project warns that if you test only on LTS releases, you can't report bugs before they affect your users{% include cite.html n=3 %}.
