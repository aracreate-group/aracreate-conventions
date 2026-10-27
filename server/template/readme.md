# SERVER TEMPLATE

The baseline, its scripts and the server templates that
[conventions-server](../conventions-server.md) describes. Copy this folder
into a repo as `servers/`, fill in `shared.env`, then add one folder per
server from a template. The scripts read every name and path from
`shared.env`, so they are used as they are.

## Layout

    servers/
    ├── readme.md            the code's servers: a table, and its own specifics
    ├── Makefile             banner, baseline, secret, notify-test, sync, setup, deploy, ps, logs; SRV= APP=
    ├── shared.env           CODE, NAME, ADMINS, the ranges, the alert channel and mailboxes
    ├── base/
    │   ├── baseline         idempotent, run over SSH as root
    │   ├── authorized-keys  public keys for every SSH user
    │   ├── platform/        hetzner, rpi: the platform's additions to the baseline
    │   ├── tunnel           an on-site server as a WireGuard peer of the vpn server
    │   ├── setup-env        creates or tops up /opt/<app>/.env, generates <generate:n> secrets
    │   ├── set-secret       sets one key in /opt/<code>/secrets/<name>.env
    │   ├── state-copy       copies /opt/<code>/etc and state to STATE_COPY_TO nightly
    │   ├── notify           Slack and email
    │   ├── install-rclone   rclone from its own releases, for the roles that use it
    │   ├── checks/          the check runner with its .service and .timer
    │   └── motd/            update-motd.d scripts
    ├── vpn/                 the vpn server: WireGuard for the peers, NAT for the private network
    ├── cloud/               a backend server in the cloud
    ├── site/                an on-site server
    └── <code>-<provider>-srv-<role>/
        ├── readme.md        purpose, type, location, private address, state
        ├── server.env       settings, no secrets; read by the baseline and the checks
        ├── banner           motd banner, written by make banner
        ├── cloud-init.yaml  cloud servers only, first boot
        ├── role             the role's additions to the baseline, if any
        ├── checks.d/        the role's own checks, if any
        └── <app>/           compose.yaml, .env.example, app config

The baseline installs the commands, units and motd scripts with `@CODE@` and
`@NAME@` filled in, as `<code>-check`, `<code>-notify` and so on, so a
server's own files need no settings to find their paths.

## Starting

1. Copy this folder into the repo as `servers/`, and fill in `shared.env`.
   Every key, in `base/authorized-keys`, named as conventions-server §1
   gives.
2. The vpn server first: copy `vpn/` to `<code>-htz-srv-vpn/`, fill
   in its `cloud-init.yaml`, create the server with it and a public IP, then
   `make banner` and `make baseline` for it. Add each peer to `peers` and run
   the baseline again.
3. Each backend: copy `cloud/` to `<code>-htz-srv-<role>/`, fill in
   its files, create it on the private network with no public IP, then
   `make banner` and `make baseline`, through the tunnel.
4. Each on-site server: copy `site/` to
   `<code>-<site>-srv-<hardware>/` and follow its readme.
5. On every server: `make secret NAME=slack KEY=SLACK_BOT_TOKEN`, then
   `NAME=smtp KEY=SMTP_PASSWORD` with an app password named after the server,
   `make notify-test`, and a root password for the console, kept in the
   password manager.
