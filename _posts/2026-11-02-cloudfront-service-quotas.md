---
title: "CloudFront adds Service Quotas support, with auto-approved increases on Business Support"
author: "Infra & Cloud Reporter"
description: "Request CloudFront quota increases in Service Quotas, auto-approved within thresholds on Business Support or higher, and alarm on the quotas that publish usage metrics."
categories: [infra]
kind: news
date: 2026-11-02 22:48
sources:
  - title: "Amazon CloudFront now supports self-service increases in AWS Service Quotas"
    url: https://aws.amazon.com/about-aws/whats-new/2026/11/cloudfront-self-service-quotas/
    publisher: "AWS What's New"
    date: "2026-11-02"
    accessed: "2026-11-02"
  - title: "Quotas"
    url: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-limits.html
    publisher: "Amazon CloudFront Developer Guide"
    accessed: "2026-11-02"
  - title: "Requesting a quota increase"
    url: https://docs.aws.amazon.com/servicequotas/latest/userguide/request-quota-increase.html
    publisher: "Service Quotas User Guide"
    accessed: "2026-11-02"
  - title: "Service Quotas and Amazon CloudWatch alarms"
    url: https://docs.aws.amazon.com/servicequotas/latest/userguide/configure-cloudwatch.html
    publisher: "Service Quotas User Guide"
    accessed: "2026-11-02"
corrections: []
---

Amazon CloudFront now supports AWS Service Quotas: 28 CloudFront quotas can be viewed, monitored, and raised from the Service Quotas console or API, AWS [announced](https://aws.amazon.com/about-aws/whats-new/2026/11/cloudfront-self-service-quotas/) on 2026-11-02. Before this, raising a quota on resources such as distributions, cache policies, origins, or alternate domain names meant opening a support case and waiting for a manual review{% include cite.html n=1 %}. The feature is available in all AWS Regions where CloudFront is supported{% include cite.html n=1 %}.

## Who gets automatic approval

For accounts with AWS Business Support or higher, increases within "published thresholds" are now approved automatically{% include cite.html n=1 %}. AWS's examples: distributions per account from 500 to 1,000, and alternate domain names (CNAMEs) per distribution from 100 to 500, with no support case{% include cite.html n=1 %}. As of 2026-11-02, the [CloudFront quotas page](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-limits.html) lists the defaults as 500 distributions per account and 100 alternate domain names per distribution{% include cite.html n=2 %}.

The announcement doesn't say how requests are handled for accounts below Business Support, or for requests above the thresholds{% include cite.html n=1 %}. It also doesn't say where the thresholds are published{% include cite.html n=1 %}. The CloudFront quotas page, checked on 2026-11-02, doesn't mention support plans, automatic approval, or thresholds. It says only that quotas not available in Service Quotas still need a service quota increase case in the Support Center{% include cite.html n=2 %}. Most of its "Request a higher quota" links still lead to that case form{% include cite.html n=2 %}.

The general Service Quotas [guide to requesting increases](https://docs.aws.amazon.com/servicequotas/latest/userguide/request-quota-increase.html) says smaller increases are usually approved automatically, while larger ones are passed to AWS Support for review. Support can approve, deny, or partly approve them{% include cite.html n=3 %}.

## Usage metrics

Some CloudFront quotas publish usage metrics to Amazon CloudWatch every 5 minutes, so you can alarm before you hit a limit{% include cite.html n=1 %}. Neither the announcement nor the CloudFront quotas page says which quotas these are{% include cite.html n=1 %}{% include cite.html n=2 %}.

## What to do

- In the Service Quotas console, open each CloudFront quota you depend on. According to AWS's [CloudWatch alarms guide](https://docs.aws.amazon.com/servicequotas/latest/userguide/configure-cloudwatch.html), utilization shows beneath the quota description if you use it. A CloudWatch alarms section appears only if the quota supports alarms. That is how to find which quotas publish metrics.
- For those quotas, create an alarm at a threshold that leaves time to request an increase{% include cite.html n=4 %}.
- If you have Business Support or higher and need more distributions or alternate domain names, request the increase in Service Quotas before opening a support case{% include cite.html n=1 %}.
- Outside automatic approval, allow time for review: the Service Quotas guide says larger requests go to Support{% include cite.html n=3 %}.
