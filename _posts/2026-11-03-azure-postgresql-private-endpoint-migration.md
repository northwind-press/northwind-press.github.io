---
title: "Azure Database for PostgreSQL can now move VNet-integrated servers to private endpoints"
author: "Northwind Infra & Cloud Desk"
description: "Flexible servers in a delegated subnet can switch to a private endpoint-capable setup; the move is irreversible and cuts connectivity, so plan a window and restore access right after."
date: 2026-11-03 08:02
categories: [infra]
kind: news
sources:
  - title: "Generally Available: Change from virtual network integration to a private endpoint capable network configuration in Azure Database for PostgreSQL flexible server"
    url: https://azure.microsoft.com/updates?id=574541
    publisher: "Microsoft Azure Updates"
    date: "2026-11-02"
    accessed: "2026-11-03"
  - title: "Change from virtual network integration to a private endpoint-capable network configuration in Azure Database for PostgreSQL flexible server"
    url: https://learn.microsoft.com/azure/postgresql/network/how-to-migrate-vnet-private-endpoint-capable-server
    publisher: "Microsoft Learn"
    date: "2026-10-27"
    accessed: "2026-11-03"
corrections: []
---

Microsoft has made [generally available](https://azure.microsoft.com/updates?id=574541) a way to change existing Azure Database for PostgreSQL flexible servers from virtual network integration to a private endpoint-capable network configuration. Servers moved off delegated-subnet networking in a customer's virtual network (VNet) are then reached over a private IP address through Azure Private Link{% include cite.html n=1 %}. The Azure update is dated 2026-11-02 and lists general availability for November 2026{% include cite.html n=1 %}.

## What the change does

Microsoft's [how-to guide](https://learn.microsoft.com/azure/postgresql/network/how-to-migrate-vnet-private-endpoint-capable-server) sets out the effects:

- **It's one-way.** The operation is irreversible, and the server can't be moved back into a virtual network{% include cite.html n=2 %}.
- **It takes time and cuts connections.** The change "typically takes up to 20 minutes", with the server in the Updating state{% include cite.html n=2 %}. The server "is typically inaccessible for up to 10 minutes", during which existing connections are closed and new ones rejected{% include cite.html n=2 %}.
- **It stays closed afterward.** Public access is disabled by default after the change. The server remains inaccessible until you add a private endpoint, or enable public access and add firewall rules{% include cite.html n=2 %}.
- **Backups survive.** All backups taken before the change, including geo-redundant ones, remain available{% include cite.html n=2 %}.
- **Logical replication can break.** If the server is a publisher, its subscribers may lose their connection, because the private path they had through VNet integration ends when the server leaves its delegated subnet{% include cite.html n=2 %}.
- **Terraform needs editing.** A configuration that still sets `delegated_subnet_id` will plan to replace the server, because that argument forces a new one. The provider also defaults `public_network_access_enabled` to `true`, so leaving it out makes Terraform try to enable public access{% include cite.html n=2 %}.

You start the change in the portal under Networking, by selecting "Public access (allowed IP addresses) and private endpoints", or with `az postgres flexible-server migrate-network`{% include cite.html n=2 %}.

## What to do

- **Schedule a maintenance window** that covers the full change, up to about 20 minutes, plus the time needed to restore connectivity{% include cite.html n=2 %}.
- **Have the private endpoint ready to add immediately afterward.** The guide places this step after the change, not before, and the server takes no traffic until it's done{% include cite.html n=2 %}. The guide doesn't mention DNS settings for the new endpoint{% include cite.html n=2 %}.
- **Check replication subscribers.** Make sure each can reach the new private endpoint, for example from the same VNet, through VNet peering, or over a VPN or ExpressRoute connection{% include cite.html n=2 %}.
- **Update Terraform before your next apply.** Remove `delegated_subnet_id`, set `public_network_access_enabled` to match the server, and confirm that `terraform plan` doesn't replace the server{% include cite.html n=2 %}.
