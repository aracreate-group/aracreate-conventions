# Cloudflare Pages Conventions

**What this is.** How a static site is hosted on Cloudflare Pages: the
project's settings and how it is created, its addresses, headers and caching, staging sites for
clients, and the checks after a change.

**Why it exists.** Sites set up by hand, or copied from a sibling, drift: a
redirect keeps the old target, a canonical points at a redirect, a dev host
gets indexed. One setup, written down, makes every site the same and every
fault findable.

**How it fits.** The zone follows
[conventions-cloudflare-domains](conventions-cloudflare-domains.md); the repo
follows [repo](../repo/readme.md).

## 1 Setup

| Setting | Value |
| --- | --- |
| Project name | the domain reversed, `<tld>-<name>`; a subdomain site `<tld>-<name>-<sub>` |
| Production branch | `main` |
| Preview branches | all |
| Build command | `make build` |
| Build output directory | `releases/www` |
| Root directory | blank |
| Custom domains | apex, `www`, `dev` |
| DNS | a proxied CNAME per custom domain |
| `dev` CNAME | `dev.<project>.pages.dev`, set by hand |
| Redirect rule | `redirect-www-to-root`: `www` to the apex, 301, path and query kept |

- Before a custom domain is added, the zone is cleared of redirect, page and
  bulk redirect rules that match every request. Pages validates its
  certificate over HTTP, and a catch-all redirect keeps the domain on
  Initializing. A redirect rule names its host, never `true`.
- Pages builds on a push that brings new commits. A branch pushed before the
  project existed gets its first preview with its next commit.
- With the root directory blank, `make build` installs what it needs itself,
  for a Node site `cd $(SRC_DIR) && { [ -d node_modules ] || npm ci; }`,
  because Pages installs dependencies only from a `package.json` at the root.
- Environment variables follow what the build runs. A build using Node sets
  `NODE_VERSION` in both Production and Preview, because Pages reads
  `.node-version` only from the root directory. A build without Node sets
  none.
- `make build` copies the site into `releases/www/`, gitignored, leaving out
  the folder readmes, and Pages serves that, never `src/`. A file in a served
  folder is public, and a redirect returning 404 does not hide a file that
  exists.
- A change is pushed to `dev` first and checked at `dev.<domain>`, then
  merged to `main`.
- Keys and tokens are encrypted variables, never plaintext. Cloudflare never
  returns an encrypted value, so it is kept where the team keeps secrets.

## 2 Creating a project

The repo is in the company's GitHub organisation and has a `dev` branch.
The Cloudflare Workers and Pages GitHub app sees selected repos only, so a
new repo is added to it before the project is created: in GitHub, the
organisation's **Settings**, **GitHub Apps**, **Cloudflare Workers and
Pages**, **Configure**, **Repository access**, **Only select repositories**,
add the repo, **Save**. Only an organisation owner can do this.

1. **Workers & Pages**, **Create**, then the **Pages** tab, not Workers, and
   **Import an existing Git repository**.
2. Choose the GitHub organisation, select the repo, **Begin setup**. A repo
   missing from the list has not been added to the app.
3. Fill in the settings from §1: project name, production branch `main`,
   framework preset **None**, build command `make build`, build output
   directory `releases/www`, root directory blank. Add `NODE_VERSION` only
   for a Node build. **Save and Deploy**.
4. **Settings**, **Builds**, **Branch control**: preview branches set to all
   non-production branches.
5. **Custom domains**, **Set up a custom domain**: add the apex, then `www`,
   then `dev`, each confirmed in turn. Cloudflare creates a proxied CNAME for
   each, pointing at production.
6. In the zone's **DNS**, change the `dev` CNAME to
   `dev.<project>.pages.dev`.
7. In the zone's **Rules**, **Redirect Rules**, **Create rule** from the
   template **Redirect from WWW to root**, named `redirect-www-to-root`:
   `www.<domain>` to `https://<domain>`, 301, path and query kept.
   **Deploy**.
8. Push a commit to `dev` and check `dev.<domain>`; merge to `main` and check
   the apex. Run the checks in §7.
9. Write `docs/cloudflare-hosting.md` in the repo (§8).

One project serves both production and `dev`; there is never a second
project for `dev`. Pages gives every branch a preview alias,
`<branch>.<project>.pages.dev`, and step 6 points `dev.<domain>` at the
`dev` branch's alias.

A site moving from another host keeps the old one serving until every check
in §7 passes on Cloudflare, then the old host is deleted.

## 3 Addresses

- The apex is the site's address. `canonical`, `og:url`, `og:image`,
  structured data, the sitemap and `robots.txt` use it; `www` only redirects
  to it. A page copied from another site has every absolute URL in its
  `<head>` checked against its own domain.
- The site's `_headers` marks every host but the apex `noindex`:

  ```txt
  https://dev.<domain>/*
    X-Robots-Tag: noindex
  https://:project.pages.dev/*
    X-Robots-Tag: noindex
  https://:version.:project.pages.dev/*
    X-Robots-Tag: noindex
  ```

## 4 Headers and caching

- `_headers` sets security headers from the first deploy:
  `X-Content-Type-Options: nosniff`, a strict referrer policy, a closed
  permissions policy, `X-Frame-Options: DENY` and a Content-Security-Policy
  of `'self'`. Fonts are cached a year, immutable; CSS, JS and images for
  shorter.
- A Pages deploy clears neither Cloudflare's edge cache nor the browser's.
  `make build` appends `?v=<commit>` to every local CSS and JS link, from
  `CF_PAGES_COMMIT_SHA` on Pages and `git rev-parse` locally, so each deploy
  is a new URL and assets stay cached between deploys.
- The zone's Browser Cache TTL is set to Respect Existing Headers, so
  `_headers` decides cache lifetimes.
- Web fonts are served from the site, never from a font CDN, with their
  licence files beside them. A typeface whose licence does not allow web
  serving appears only as outlines in SVG.

## 5 Staging sites for clients

- A temporary site for a client sits on the staging domain,
  `<client-code>.<staging-domain>`, in the company's account.
- Its project is named by the same rule, `<tld>-<name>-<client-code>`, with
  that one host as its custom domain: no `www`, no `dev`.
- Its `_headers` marks every host `noindex`.
- It is deleted, project and record, once the client's own site is live.

## 6 Product domains

A product's domain carries that product's deployments only. Anything else,
however close, goes on the staging domain or its own domain.

## 7 Checks

- A rule copied from another zone is checked for the domain in its target
  before it is deployed. After any redirect change:

  ```sh
  curl -s -o /dev/null -w "%{http_code} %{redirect_url}\n" "https://www.<domain>/x?a=1"
  ```

  returns `301 https://<domain>/x?a=1`.
- A missing path returns the site's own 404 page.
- A shared link shows the site's preview. Messaging apps keep a preview for
  a while; Facebook's Sharing Debugger refreshes its copy at once.
- The API's alias list does not show which build a branch domain serves. A
  change pushed to that branch alone does.
- Email Address Obfuscation stays on. It rewrites `mailto:` links, so a check
  that counts or matches addresses in the served HTML reads them in a
  browser, after the decode script runs, not from `curl`.

## 8 Hosting guide

Each site repo keeps `docs/cloudflare-hosting.md`: its project, build
settings, custom domains, DNS records, redirect rule, and a table of
addresses to open with what each should show. The README links to it instead
of repeating it.
