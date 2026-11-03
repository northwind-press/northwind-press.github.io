---
title: "Before GitHub blocks pull_request_target: find and migrate your workflows"
author: "Northwind Features"
description: "From 2026-12-02 GitHub blocks pull_request_target in public repos by default; find affected workflows in Insights and move each to pull_request, a workflow_run split, or an allowed policy."
categories: [software]
kind: feature
sources:
  - title: "GitHub Actions to block pull_request_target by default in public repos from 2026-12-02"
    url: https://northwind-press.github.io/2026/11/02/github-pull-request-target-default/
    publisher: "Northwind Press"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "pull_request_target blocked by default December 2"
    url: https://github.blog/changelog/2026-11-02-pull_request_target-blocked-by-default-december-2
    publisher: "GitHub"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "Securely using pull_request_target"
    url: https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target
    publisher: "GitHub Docs"
    accessed: "2026-11-03"
  - title: "Controlling workflow execution"
    url: https://docs.github.com/actions/how-tos/administer/control-workflow-execution
    publisher: "GitHub Docs"
    accessed: "2026-11-03"
  - title: "About Actions policies"
    url: https://docs.github.com/en/actions/concepts/about-actions-policies
    publisher: "GitHub Docs"
    accessed: "2026-11-03"
  - title: "Keeping your GitHub Actions and workflows secure Part 1: Preventing pwn requests"
    url: https://securitylab.github.com/resources/github-actions-preventing-pwn-requests/
    publisher: "GitHub Security Lab"
    accessed: "2026-11-03"
  - title: "actions/checkout"
    url: https://github.com/actions/checkout
    publisher: "GitHub"
    accessed: "2026-11-03"
  - title: "Releases · actions/checkout"
    url: https://github.com/actions/checkout/releases
    publisher: "GitHub"
    accessed: "2026-11-03"
corrections: []
---
On 2026-12-02, GitHub Actions starts blocking `pull_request_target` in public repositories unless a policy allows it. [Our news report](https://northwind-press.github.io/2026/11/02/github-pull-request-target-default/) covers the announcement. This piece explains what the trigger does, why GitHub is turning it off by default, and how to move each affected workflow to something safer before the deadline. Dates and behavior are as of 2026-11-03.

## What changes, and for whom

From 2026-12-02, Actions "will block `pull_request_target` events by default in all public repositories, unless an applicable Actions event policy explicitly allows them", according to GitHub's [changelog post](https://github.blog/changelog/2026-11-02-pull_request_target-blocked-by-default-december-2). Enforcement had previously been scheduled for 2026-11-02{% include cite.html n=2 %}. The changelog says the rule covers public repositories on GitHub Free, GitHub Team and GitHub Enterprise Cloud, and that private and internal repositories and GitHub Enterprise Server aren't affected{% include cite.html n=2 %}.

GitHub's documentation describes the scope differently. Its [guide to securely using `pull_request_target`](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target) says GitHub will enforce the block "for affected repositories that were using the default `pull_request_target` policy before general availability". The same guide says the default policy "does not replace an applicable event policy that you have already configured"{% include cite.html n=3 %}. Rather than rely on either description, check Insights for your own repositories, as described below.

Until enforcement, the rule runs in evaluate mode: runs continue, and policy insights show which ones would be blocked{% include cite.html n=2 %}. There are two brownouts, on 2026-11-09 and 2026-11-16, each from 16:00 to 18:00 UTC{% include cite.html n=2 %}. During them, blocked attempts "create failed runs with an error annotation; the workflows won't execute", and afterwards workflows "run with warnings" again{% include cite.html n=2 %}. A run that an event policy blocks fails with an error that names the event and the workflow file, according to GitHub's [overview of Actions policies](https://docs.github.com/en/actions/concepts/about-actions-policies).

## What the trigger is for

A `pull_request_target` workflow runs "with elevated trust": it gets the base repository's `GITHUB_TOKEN` along with repository and organization secrets{% include cite.html n=3 %}. That makes it useful for pull requests from forks, for "labeling, triage, or for posting authenticated status checks"{% include cite.html n=3 %}. Unlike `pull_request`, it takes the workflow file, and any `actions/checkout` step without a `ref`, from the base repository's default branch, so "no code from the fork is executed by default"{% include cite.html n=3 %}. A `pull_request` workflow instead runs from the pull request's merge commit, and for forks it gets a read-only token, no other secrets, and the fork approval policies{% include cite.html n=3 %}.

GitHub Security Lab's [guide to preventing "pwn requests"](https://securitylab.github.com/resources/github-actions-preventing-pwn-requests/) says the trigger is meant for pull requests "that do not require dangerous processing, say building or running the content of the PR". It was introduced "to enable workflows to label PRs … or to comment on the PR"{% include cite.html n=6 %}.

## How it goes wrong

The danger starts when a workflow overrides that default and runs the fork's code, often because a project wants CI with secrets on fork pull requests, for example to reach a private registry{% include cite.html n=3 %}. Checking out the pull request's head isn't the whole vulnerability. It is "completed by the *next* step that runs code checked out", such as a build or test command, or configuration and dependencies the pull request brings in{% include cite.html n=3 %}. Security Lab notes that package install hooks, such as npm's `preinstall` and `postinstall`, can run before the build itself{% include cite.html n=6 %}.

GitHub calls this a "pwn request" and says the pattern "has been the root cause of multiple supply-chain compromises"{% include cite.html n=3 %}. The same problem applies to any secret-bearing trigger that fetches and runs fork code, including `issue_comment` and `workflow_run`{% include cite.html n=3 %}. Even a workflow that references no secrets holds a read/write token, and with `actions/checkout`'s default `persist-credentials: true`, later steps can read it{% include cite.html n=6 %}.

## Find your affected workflows

GitHub's first step is to "use Insights to see which workflow runs the rule would block" before the first brownout on 2026-11-09{% include cite.html n=2 %}. The Policy insights page sits "directly under the page for GitHub Actions policies" in the repository, organization or enterprise sidebar, according to GitHub's [guide to controlling workflow execution](https://docs.github.com/actions/how-tos/administer/control-workflow-execution). Policies themselves are under **Settings → Actions → Policies** in a repository or organization, and under **Policies → Actions → Policies** in an enterprise{% include cite.html n=4 %}. For evaluate-mode policies, Insights lists the runs that "would have been blocked"{% include cite.html n=4 %}.

The default rule is in evaluate mode on every affected plan{% include cite.html n=2 %}, but creating your own policy with the Evaluate status is "GitHub Enterprise Cloud only"{% include cite.html n=4 %}.

## Decide what each workflow needs

GitHub's guide gives three choices for each affected workflow{% include cite.html n=3 %}:

- If it doesn't need `pull_request_target`, switch to a safer event such as `pull_request`.
- If it must keep the trigger, create or update an Actions event policy that explicitly allows it.
- If you don't want it, leave the default in place and let it block.

### Tests that don't need secrets

Use `pull_request`. It "triggers on the same events" and runs fork pull requests safely{% include cite.html n=3 %}.

### Tests that need secrets, or results posted back

Split the job into two workflows, as Security Lab describes{% include cite.html n=6 %}. An unprivileged `pull_request` workflow builds and tests the code and saves its results as an artifact{% include cite.html n=6 %}. A second workflow, triggered by `workflow_run` when the first completes, gets write permission and secrets, downloads the artifact, and posts the comment or status{% include cite.html n=6 %}. Treat the artifact's contents as untrusted data: never execute them, and don't extract them into the workspace{% include cite.html n=6 %}.

### Labeling, triage and comments

This is the use GitHub names as legitimate for the trigger{% include cite.html n=3 %}. To keep it after 2026-12-02, allow `pull_request_target` in an event policy, using "workflow file targeting to allow specific workflows"{% include cite.html n=2 %}. Policies can be scoped "to specific workflow paths or required workflows"{% include cite.html n=4 %}. GitHub's hardening advice still applies: a least-privilege `GITHUB_TOKEN`, only the secrets the job needs, and isolated, ephemeral runners{% include cite.html n=3 %}. Caches are read-only for `pull_request_target` by default, and GitHub advises against opting into a write-capable `cache-mode`{% include cite.html n=3 %}. For comments, Security Lab's two-workflow example shows posting them from a `workflow_run` workflow instead{% include cite.html n=6 %}.

### Checkout v7 refuses fork checkouts

[actions/checkout](https://github.com/actions/checkout) v7 refuses to check out a fork pull request in `pull_request_target` and `workflow_run` workflows unless you set `allow-unsafe-pr-checkout: true`. The v7.0.0 entry on the [releases page](https://github.com/actions/checkout/releases) lists the change as "block checking out fork pr for pull_request_target and workflow_run". GitHub says to set the option "only after confirming the checked-out code is never executed"{% include cite.html n=3 %}. The check doesn't cover `git fetch`, `gh pr checkout` or downloaded artifacts{% include cite.html n=3 %}.

### Label gates are not a fix

Some projects run `pull_request_target` only after a maintainer adds a "safe to test" label. Security Lab calls this "only … a temporary solution", because it is prone to a race in which an attacker pushes new commits after the label is applied{% include cite.html n=6 %}.

### Open pull requests keep the old workflow

Fixing a workflow doesn't protect pull requests that are already open, because they "will use the version of the workflow as it existed at the time the PR was opened"{% include cite.html n=6 %}. Security Lab advises closing or rebasing them{% include cite.html n=6 %}. GitHub also recommends enabling CodeQL for GitHub Actions to find these patterns{% include cite.html n=3 %}{% include cite.html n=6 %}.

## Our view

These are our recommendations, not GitHub's.

- Run Insights now, not on 2026-11-09. A brownout will also find a workflow you forgot, but only by failing it.
- Treat "let it block" as a real option. If nobody can say why a workflow needs secrets on fork pull requests, the block is the fix.
- Move CI that needs secrets to the `pull_request` and `workflow_run` split rather than allowing `pull_request_target` for it.
- Keep allowed `pull_request_target` workflows to labeling, triage and comments, target them by file, and leave `allow-unsafe-pr-checkout` off unless you have checked that nothing runs the checked-out code.
