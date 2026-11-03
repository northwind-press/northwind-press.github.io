---
title: "PyPI doubles upload limits for organization-owned projects"
author: "Northwind Software & Dev Desk"
description: "PyPI projects owned by an organization now get 200 MB per file and 20 GB per project automatically, and new uploads must keep versions to 128 characters."
categories: [software]
kind: news
date: 2026-11-03 08:05
sources:
  - title: "Higher limits for organization projects"
    url: https://blog.pypi.org/posts/2026-10-26-higher-limits-for-organization-projects/
    publisher: "The Python Package Index Blog"
    date: "2026-10-26"
    accessed: "2026-11-03"
  - title: "PyPI now limits versions to 128 characters"
    url: https://blog.pypi.org/posts/2026-10-23-version-length-limit/
    publisher: "The Python Package Index Blog"
    date: "2026-10-23"
    accessed: "2026-11-03"
corrections: []
---

Projects owned by a PyPI organization now get double the default upload limits, PyPI said in a [blog post on 2026-10-26](https://blog.pypi.org/posts/2026-10-26-higher-limits-for-organization-projects/). As of that date, organization projects can upload files of up to 200 MB and store up to 20 GB per project, against 100 MB and 10 GB for personal projects{% include cite.html n=1 %}.

## Who gets the new limits

There's nothing to turn on: every project owned by a company or community organization gets the limits automatically, including projects moved into an organization later{% include cite.html n=1 %}. A project that leaves an organization goes back to the personal limits{% include cite.html n=1 %}. Increases granted earlier stay in place, and a project always gets whichever limit is higher{% include cite.html n=1 %}. PyPI also reminded organizations that they can create up to 10 new projects per day, more than a personal account can; that allowance isn't new{% include cite.html n=1 %}.

## A cap on version length

Separately, PyPI [announced on 2026-10-23](https://blog.pypi.org/posts/2026-10-23-version-length-limit/) that it now rejects new uploads whose version is longer than 128 characters. PyPI counts the version in its normalized form, so `1.0-RC1` counts as `1.0rc1`{% include cite.html n=2 %}. Releases already on PyPI are unaffected, and PyPI says only 2 of its roughly 9.9 million releases have a version that long{% include cite.html n=2 %}. The limit is a PyPI policy, not a new packaging standard, and pip and uv don't need to change{% include cite.html n=2 %}.

## What to do

If your project is personal and you need more room, moving it into an organization raises its limits with no request needed; otherwise, both kinds of project can still ask for an increase through PyPI's support channels{% include cite.html n=1 %}. If an upload fails with a version-length error, pick a shorter version: PyPI suggests keeping details such as build dates or commit IDs in the changelog or project description instead{% include cite.html n=2 %}.
