---
title: "GitHub Actions to block pull_request_target by default in public repos from 2026-12-02"
author: "Northwind Software & Dev Desk"
description: "Check Insights for blocked pull_request_target runs before the first brownout on 2026-11-09, then keep the block or allow specific workflows in an Actions event policy."
categories: [software]
kind: news
date: 2026-11-02 22:42
placement: top
sources:
  - title: "pull_request_target blocked by default December 2"
    url: https://github.blog/changelog/2026-11-02-pull_request_target-blocked-by-default-december-2
    publisher: "GitHub"
    date: "2026-11-02"
    accessed: "2026-11-02"
  - title: "Controlling workflow execution"
    url: https://docs.github.com/actions/how-tos/administer/control-workflow-execution
    publisher: "GitHub Docs"
    accessed: "2026-11-02"
corrections: []
---

GitHub Actions will block `pull_request_target` events by default in all public repositories from 2026-12-02, unless an Actions event policy explicitly allows them, GitHub said in a [changelog post](https://github.blog/changelog/2026-11-02-pull_request_target-blocked-by-default-december-2) on 2026-11-02. Enforcement had been scheduled for 2026-11-02{% include cite.html n=1 %}.

## Why

A `pull_request_target` workflow runs in the context of the base repository and can access its secrets, so if it executes untrusted code from a fork, that code could compromise the pipeline or steal secrets{% include cite.html n=1 %}.

## Who is affected

The rule applies to public repositories on GitHub Free, GitHub Team, and GitHub Enterprise Cloud{% include cite.html n=1 %}. Private and internal repositories aren't affected, and neither is GitHub Enterprise Server{% include cite.html n=1 %}.

## Brownouts before enforcement

The rule is in evaluate mode now, so you can see which runs it would block before it is enforced{% include cite.html n=1 %}. GitHub will enforce it temporarily during two brownouts, on 2026-11-09 and 2026-11-16, each from 16:00 to 18:00 UTC{% include cite.html n=1 %}. In those windows, blocked workflows won't execute: each attempt creates a failed run with an error annotation{% include cite.html n=1 %}. After each window the rule returns to evaluate mode, and workflows run with warnings{% include cite.html n=1 %}.

## What to do

Before the first brownout on 2026-11-09, use Insights to see which workflow runs the rule would block{% include cite.html n=1 %}. GitHub's [guide to controlling workflow execution](https://docs.github.com/actions/how-tos/administer/control-workflow-execution) puts the Policy insights page under the Actions policies page of a repository, organization, or enterprise. Then pick one of two options: keep the default rule and the block, or, if your workflows depend on the trigger, explicitly allow `pull_request_target` in an applicable Actions event policy, using workflow file targeting to allow only specific workflows{% include cite.html n=1 %}. In a repository or organization, policies are under **Settings**, then **Actions**, then **Policies**{% include cite.html n=2 %}.
