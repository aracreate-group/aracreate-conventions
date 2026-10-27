# Cloudflare Domains Conventions

**What this is.** How the group's domains are held in Cloudflare: one
account, domains sorted into tiers, who can change which, the DNS every zone
keeps right, and the tokens that reach it.

**Why it exists.** Some domains carry the company's mail; others carry
websites the team ships every week. Sorting zones by what breaks when they go
wrong lets the team work freely on sites without being able to touch mail.

**How it fits.** Sites on these domains follow
[conventions-cloudflare-pages](conventions-cloudflare-pages.md).

## 1 Account and terms

- Company and client work lives in the company's Cloudflare account. No zone,
  site or project for company or client work is kept in a personal account;
  one found there is moved in.
- A company of the group with its own owners or billing gets its own account.
- A Pages project cannot move between accounts. One in a personal account
  is created again from its repo in the company's account
  ([pages §2](conventions-cloudflare-pages.md#2-creating-a-project)), its
  domain moved over, and the old project deleted.

| Term | Meaning |
| --- | --- |
| zone | a domain added to Cloudflare: the apex and every subdomain, with its DNS, SSL, rules and analytics |
| tier | what a zone is for, which decides who can change it |
| domain group | a set of zones that a policy is scoped to |
| user group | a set of members that carries policies |
| owner | a member with Super Administrator |

## 2 Tiers

| Tier | Holds | Changed by | Seen by |
| --- | --- | --- | --- |
| primary | the company's main domains and every domain carrying company mail | owners | owners, the team read-only |
| secondary | venture, product and campaign domains | the team | the team |
| client | domains run for a client, one group per client | the team | the team |
| hosted | zones of a company we host, with its own admins | its admins | its admins |

- Every zone is in exactly one domain group. A new zone is placed in its
  group the day it is added; a zone in no group is reachable by owners only.
- A domain left to expire is removed from the account.
- Every Registrar domain is locked, with privacy on.
- Every member signs in with two-factor authentication, enforced on the
  account.

## 3 Names

| Thing | Rule | Example |
| --- | --- | --- |
| domain group, own tiers | `domain-group-<code>-<tier>` | `domain-group-<code>-web` |
| domain group, client or hosted | `domain-group-<code>` | `domain-group-<code>` |
| user group | `<code>-<role>` | `<code>-admin`, `<code>-team` |

The primary tier's group is `domain-group-<code>-admin`, the secondary tier's
`domain-group-<code>-web`.

## 4 Access

- Policies are given to user groups, never to a member. A person gets access
  by joining a group and loses it by leaving.
- Cloudflare requires one direct policy on every member. It is the least that
  person needs: Domain Administrator Read Only on the primary group for the
  team, Minimal Account Access for anyone else.
- Roles by group:

  | User group | Role | Scope |
  | --- | --- | --- |
  | owners | Super Administrator | account |
  | team | Domain Administrator | secondary group and each client group |
  | team | Developer Platform Admin | account |
  | hosted admins | Domain Administrator | their own group |

- Pages and Workers have no role scoped to domains, so Developer Platform
  Admin reaches every project in the account. A project holding something
  the team must not reach goes to another account.
- Roles marked Legacy are not assigned.

## 5 Reserved domains

- One secondary domain is the staging domain. Every temporary site for a
  client sits on a subdomain of it, `<client-code>.<staging-domain>`, never
  on a product domain.
- A product's domain carries that product's deployments only.

## 6 DNS

- SSL/TLS stays on Automatic. A zone is checked by `ssl_automatic_mode`, not
  `ssl`: on Automatic, `ssl` is only what the last scan chose.
- Google Workspace mail on a zone needs MX `smtp.google.com`, SPF
  `v=spf1 include:_spf.google.com ~all`, DMARC at `_dmarc`, and the DKIM key
  as TXT at exactly `google._domainkey`, never `*.google._domainkey`: a
  wildcard does not cover the name it hangs off. After the record resolves,
  **Start authentication** is clicked in the Admin console. DKIM is proved on
  a message sent from the domain.
- A new record is checked over DNS over HTTPS, which no local resolver caches
  or intercepts:

  ```sh
  curl -s -H 'accept: application/dns-json' "https://cloudflare-dns.com/dns-query?name=<host>&type=A"
  curl -s -o /dev/null -w "%{http_code}\n" --resolve <host>:443:<ip> "https://<host>/"
  ```

  An NXDOMAIN from `dig` straight after a change proves nothing on a network
  that intercepts port 53.

## 7 Tokens

- A token is named after what holds it, a server by its name.
- It carries only what its holder does: a server issuing certificates by
  DNS gets DNS Edit on the zones it names, and nothing else.
- A caller with a fixed address is limited to it by the token's IP filter.
- A token, tunnel or build token is deleted with what it served; a local
  login such as `~/.cloudflared/` is deleted once unused.
