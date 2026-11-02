---
title: "Anthropic user profiles let Claude API platforms limit enforcement to one end customer"
author: "AI Reporter"
description: "If you resell Claude API access or run a platform on it, tag each request with a user profile ID so a restriction or ban applies to that end customer, not your whole organization."
categories: [ai]
subsection: applied
kind: news
date: 2026-11-02 22:37
sources:
  - title: "Claude Platform release notes"
    url: https://docs.claude.com/en/release-notes/api
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "User profiles"
    url: https://docs.claude.com/docs/en/manage-claude/user-profiles
    publisher: "Anthropic"
    accessed: "2026-11-02"
  - title: "Organization webhooks"
    url: https://docs.claude.com/docs/en/manage-claude/organization-webhooks
    publisher: "Anthropic"
    accessed: "2026-11-02"
corrections: []
---

Anthropic launched user profiles for the Claude API on 2026-10-20, according to its [platform release notes](https://docs.claude.com/en/release-notes/api). A profile tells Anthropic which end customer a request is for. For platforms, gateways and resellers, that means a safety enforcement action can apply to one end customer instead of the whole organization{% include cite.html n=1 %}. On 2026-10-21, Anthropic added fields that show whether a profile has been restricted or banned{% include cite.html n=1 %}.

## Why it matters

The [user profiles guide](https://docs.claude.com/docs/en/manage-claude/user-profiles) explains the risk. Anthropic runs automated safety classifiers over API traffic, and requests a platform sends for its customers arrive under the platform's organization. Without a profile on the request, one end customer can trigger an action that applies to the whole organization{% include cite.html n=2 %}. Profiles aren't billable and don't affect pricing{% include cite.html n=2 %}.

## What adoption takes

You register each end customer once with `POST /v1/user_profiles` and store the `uprof_` ID it returns. You then send that ID in the `anthropic-user-profile-id` header on every request made for that customer. The SDK and CLI argument is `user_profile_id`{% include cite.html n=2 %}. Creation isn't idempotent and is rate limited, and Anthropic asks you to contact your account team before registering an existing customer base in bulk{% include cite.html n=2 %}.

A profile is either `application`, one per signed-up user of your product and the default, or `passthrough`, one per company you resell access to{% include cite.html n=2 %}. Requests without an ID count as your own usage. Anthropic recommends keeping internal usage in a separate organization, because profiles belong to an organization and separate workspaces aren't enough{% include cite.html n=2 %}. Every descriptive field is optional{% include cite.html n=2 %}.

Coverage varies by platform. Amazon Bedrock and Google-managed Claude Models on Google Cloud don't have the profile endpoints, and they accept any well-formed ID without looking it up. Profiles work on Bedrock only through Claude in Amazon Bedrock, not the earlier `InvokeModel` and `Converse` integration{% include cite.html n=2 %}.

## Seeing enforcement

Every profile response now carries `enforcement_status` (`unrestricted`, `restricted` or `banned`) and `enforcement_actions`. Each action lists a type, a reason, what the customer can do to clear it, and when it opened and expires{% include cite.html n=2 %}. While an action is open, Anthropic refuses some or all inference requests carrying that profile's ID{% include cite.html n=2 %}. The `enforcement_status[]` list filter finds affected profiles. Requests whose `anthropic-beta` header has `user-profiles-2026-09-04` or earlier don't get the fields{% include cite.html n=2 %}. On Claude Platform on AWS, the fields always read `unrestricted` and empty{% include cite.html n=2 %}.

[Organization webhooks](https://docs.claude.com/docs/en/manage-claude/organization-webhooks), in beta, send an event when an action opens or ends. Access is on request through your Anthropic account team, and organizations with HIPAA readiness enabled can't use them{% include cite.html n=3 %}. Events carry only IDs, may arrive late, out of order or more than once, and are dropped if every retry fails. Anthropic says to read the profile's current state and to fall back to the list filter{% include cite.html n=3 %}.

## What we don't know

The documents don't say how Anthropic decides whether an action applies to one profile or to the whole organization when a profile is present. They also give no date for webhooks leaving beta.
