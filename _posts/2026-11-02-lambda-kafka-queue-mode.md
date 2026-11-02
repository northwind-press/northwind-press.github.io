---
title: "AWS Lambda can now read self-managed Kafka topics as queues, using share groups"
author: "Infra & Cloud Reporter"
description: "If your self-managed Kafka brokers run 4.2 or later and your Lambda consumers don't need ordering, set ConsumptionMode to Queue to scale past the topic's partition count."
categories: [infra]
kind: news
date: 2026-11-02 22:49
sources:
  - title: "AWS Lambda now supports queues for Apache Kafka in self-managed Kafka event sources"
    url: https://aws.amazon.com/about-aws/whats-new/2026/11/aws-lambda-queue-kafka-esm/
    publisher: "AWS What's New"
    date: "2026-11-02"
    accessed: "2026-11-02"
  - title: "Polling Kafka topics in Queue mode"
    url: https://docs.aws.amazon.com/lambda/latest/dg/polling-kafka-queue.html
    publisher: "AWS Lambda Developer Guide"
    accessed: "2026-11-02"
  - title: "Apache Kafka 4.2.0 Release Announcement"
    url: https://kafka.apache.org/blog/2026/02/17/apache-kafka-4.2.0-release-announcement/
    publisher: "Apache Kafka"
    date: "2026-02-17"
    accessed: "2026-11-02"
corrections: []
---

AWS Lambda's self-managed Apache Kafka event source mappings can now consume topics in a queue mode, AWS [announced](https://aws.amazon.com/about-aws/whats-new/2026/11/aws-lambda-queue-kafka-esm/) on 2026-11-02. With `ConsumptionMode` set to `Queue`, several event pollers read from the same partition, each running up to 10 concurrent invocations. That lets processing scale past a topic's partition count without adding partitions or changing producers, topic configuration, or function code{% include cite.html n=1 %}.

## What changed

Until now, Lambda's Kafka mappings used the consumer group protocol, which gives each partition to exactly one consumer{% include cite.html n=1 %}. That mode, now called Stream, stays the default and keeps per-partition ordering, with up to 5 concurrent invocations per poller{% include cite.html n=2 %}. Queue mode uses Kafka share groups instead and gives no ordering guarantee{% include cite.html n=2 %}. AWS says a slow or failed event no longer holds up others in the same partition{% include cite.html n=1 %}.

## Who can use it

It works with Kafka clusters customers run themselves and with managed offerings such as Confluent Cloud, in all AWS commercial Regions that offer self-managed Kafka mappings{% include cite.html n=1 %}. The [Lambda developer guide](https://docs.aws.amazon.com/lambda/latest/dg/polling-kafka-queue.html) says Amazon Managed Streaming for Apache Kafka (MSK) does not currently support Queue mode, and AWS will add MSK support once MSK offers Kafka 4.2 or later with share groups enabled.

The cluster must run Apache Kafka 4.2 or later with share groups enabled{% include cite.html n=2 %}. Share groups first appeared in Kafka 4.0, but Lambda's poller needs 4.2{% include cite.html n=2 %}. The [Kafka 4.2 release announcement](https://kafka.apache.org/blog/2026/02/17/apache-kafka-4.2.0-release-announcement/) of 2026-02-17 describes share groups as production-ready. AWS calls them generally available in 4.2{% include cite.html n=1 %}.

## Limits and pricing

As of 2026-11-02, on-demand mode stops at 5 pollers per mapping, or 50 concurrent invocations and 5 MB/s in total; going further needs provisioned mode, which allows up to 2,000 pollers{% include cite.html n=2 %}. Queue mode doesn't support a batching window or a starting position, and its mappings can share Event Poller Units only with other Queue mappings{% include cite.html n=2 %}. Standard Lambda pricing applies, plus Event Poller Unit charges in provisioned mode{% include cite.html n=1 %}.

## What to do

- Use Queue mode only where each record is independent. AWS says it is meant for workloads that don't need partition ordering{% include cite.html n=1 %}. Keep Stream mode for anything that depends on per-key or per-partition order.
- Make your function idempotent. Lambda delivers at least once, and AWS warns that duplicates or out-of-order processing can cause double-counting or inconsistent state{% include cite.html n=2 %}.
- Check your broker version before switching: 4.2 or later, with share groups enabled. Kafka enables `share.version` by default, and you can manage it with `kafka-features.sh`{% include cite.html n=2 %}.
- On MSK, wait. Queue mode isn't available there yet{% include cite.html n=2 %}.
