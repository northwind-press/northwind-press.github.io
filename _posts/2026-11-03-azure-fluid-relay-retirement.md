---
title: "Microsoft will retire Azure Fluid Relay on 2027-02-02 and points users to self-hosting"
author: "Northwind Infra & Cloud Desk"
description: "Azure Fluid Relay retires on 2027-02-02; inventory the apps that use it now and plan a move to the self-hosted Fluid service, which you run and pay for in your own subscription."
date: 2026-11-03 08:03
categories: [infra]
kind: news
sources:
  - title: "Retirement: Azure Fluid Relay"
    url: https://azure.microsoft.com/updates?id=570498
    publisher: "Microsoft Azure Updates"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "Self-host Fluid Framework on Azure (tools/selfhost/README.md)"
    url: https://github.com/microsoft/FluidFramework/blob/70c621a1c2ee67ccec8ea9ea93311e26911ddc8d/tools/selfhost/README.md
    publisher: "Microsoft FluidFramework on GitHub"
    date: "2026-10-29"
    accessed: "2026-11-03"
corrections: []
---

Microsoft [will retire Azure Fluid Relay](https://azure.microsoft.com/updates?id=570498) on 2027-02-02, according to an Azure update posted on 2026-11-02. Customers can keep using the service until 2027-02-01 while they move, and applications that still depend on it after the retirement date may see disruption{% include cite.html n=1 %}.

The Fluid Framework, an open-source framework for building distributed, real-time collaborative web applications, remains available, and Microsoft names a self-hosted Fluid service in the Fluid Framework repository as the replacement{% include cite.html n=1 %}. Customers who move take on hosting and operating the service themselves. Microsoft says costs will depend on deployment architecture, scale, and operational requirements{% include cite.html n=1 %}.

## What self-hosting involves

The [self-hosted service's README](https://github.com/microsoft/FluidFramework/blob/70c621a1c2ee67ccec8ea9ea93311e26911ddc8d/tools/selfhost/README.md) describes a deployment into your own Azure subscription. It runs the multi-service Routerlicious topology on Azure Kubernetes Service (AKS), with Azure Event Hubs for ordering, Azure Cosmos DB for MongoDB for document data, Azure Managed Redis, and Azure Files for snapshots{% include cite.html n=2 %}. Azure Cache for Redis can be selected as a temporary fallback where Managed Redis can't be created{% include cite.html n=2 %}.

- **Cost:** a cost estimate is listed as "planned". The README notes that AKS nodes, Managed Redis, provisioned-throughput Cosmos DB, Event Hubs, and Front Door bill from the moment they are created, and points to the Azure pricing calculator{% include cite.html n=2 %}.
- **Build and deploy:** you fill in one parameters file, then build a release bundle from a separate, clean Fluid Framework checkout pinned to a reviewed tag or commit. A script then creates the resources and installs the service{% include cite.html n=2 %}.
- **Tenants and tokens:** the deployment starts with one default tenant. A reference token service using Microsoft Entra ID is optional, and the README says to configure a token backend before admitting real users{% include cite.html n=2 %}.
- **Migration:** an optional `copy-data` step inventories selected Fluid Relay tenants, creates destination tenants, and copies reviewed documents{% include cite.html n=2 %}.
- **Production readiness:** the README calls this "a reference deployment". It says you must decide identity and authorization, high-availability topology, backup and restore, capacity validation under real load, and a supported client-version matrix yourself{% include cite.html n=2 %}.

## What to do

- **Find what uses Fluid Relay.** Microsoft says to review your Azure subscriptions and identify the applications that depend on the service{% include cite.html n=1 %}.
- **Plan the move before February.** Complete the transition before 2027-02-02, using the self-hosted solution as the migration path{% include cite.html n=1 %}. Budget time for the README's open production decisions, and run its validation step, which connects two real clients end to end, before cutting over{% include cite.html n=2 %}.
