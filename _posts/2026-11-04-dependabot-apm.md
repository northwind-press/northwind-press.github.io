---
title: "Dependabot version updates now support Agent Package Manager"
author: "Northwind Software & Dev Desk"
description: "Add an apm entry to .github/dependabot.yml to get Dependabot version-update pull requests for git dependencies in apm.yml; security updates aren't included."
categories: [software]
kind: news
date: 2026-11-04 08:05
sources:
  - title: "Dependabot version updates support Agent Package Manager"
    url: https://github.blog/changelog/2026-11-03-dependabot-version-updates-support-agent-package-manager
    publisher: "GitHub"
    date: "2026-11-03"
    accessed: "2026-11-04"
  - title: "APM - Agent Package Manager"
    url: https://microsoft.github.io/apm/
    publisher: "Agent Package Manager"
    accessed: "2026-11-04"
corrections: []
---

Dependabot can now open version-update pull requests for dependencies declared in `apm.yml`, the manifest of Agent Package Manager (APM), GitHub said in a [changelog post](https://github.blog/changelog/2026-11-03-dependabot-version-updates-support-agent-package-manager) on 2026-11-03. APM's [project page](https://microsoft.github.io/apm/) describes it as a dependency manager for AI agents, in which a project declares the skills, prompts, instructions, plugins, and MCP servers it needs in one `apm.yml`.

## What Dependabot does

Dependabot opens pull requests to update supported git dependencies declared in `apm.yml`, and it regenerates the `apm.lock.yaml` lockfile when one is present{% include cite.html n=1 %}. The lockfile pins exact versions and content hashes, so a fresh clone resolves the same package content{% include cite.html n=2 %}. Dependabot's APM support covers version updates, not security updates{% include cite.html n=1 %}.

## Availability

APM support is generally available on github.com for all GitHub plans, and GitHub says it will be available in GitHub Enterprise Server 3.24{% include cite.html n=1 %}.

## What to do

To turn it on, add an `apm` entry to your repository's `.github/dependabot.yml` file, give the directory that contains `apm.yml`, and choose an update schedule{% include cite.html n=1 %}.
