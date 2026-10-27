# Server Conventions

**What this is.** How a server, in the cloud or on our own premises, is built
and run: where it sits on the network, who logs in and how, what is
installed, how apps are deployed, what the login screen shows, how it raises
alerts and how it is backed up.

**Why it exists.** A server set up by hand drifts. Each one ends up with its
own ports, users, folders and checks, and nobody can say what is on it. One
baseline, kept in a repo and applied by script, makes every server the same
and every server rebuildable.

**How it fits.** The repo that runs the servers keeps one folder per server and
the scripts that apply this baseline, laid out as [repo](../repo/readme.md)
describes. Commits follow [git](../git/git-conventions.md).

## 1 Naming and terms

### 1.1 Names

Every provider resource is named `<code>-<provider>-<type>[-<role>]`, in
param-case. Every type code is three letters, in English.

| Part | Codes |
| --- | --- |
| `<code>` | the owner's short code: a company, venture or project |
| `<provider>` | `htz` Hetzner; for hardware on our own premises, the site's code, such as `acg`; a new provider gets a three-letter code before its first resource |
| `<type>` | one of the types below |
| `<role>` | what the server does, one word, such as `vpn`, `git`, `ops`, `logs`, `db`, `main`. A server holding several apps is named for its main function, not a list of apps. A resource that belongs to one server takes that server's role. An on-site server is named for its hardware instead, one word such as `rpi`, since what it does may change over its life; a second of the same kind takes a counter, `rpi2`. Its role is kept in its settings (§5). |

| `<type>` | Resource | Example |
| --- | --- | --- |
| `prj` | provider project | `<code>-htz-prj` |
| `srv` | server | `<code>-htz-srv-git` |
| `net` | private network | `<code>-htz-net` |
| `fwl` | firewall | `<code>-htz-fwl-vpn`, `<code>-htz-fwl-private` |
| `ip4`, `ip6` | primary IP | `<code>-htz-ip4-vpn` |
| `vol` | volume | `<code>-htz-vol-git` |
| `plg` | placement group | `<code>-htz-plg-spread` |
| `snp` | snapshot | `<code>-htz-snp-git-2026-10-16` |

| Other names | Rule | Example |
| --- | --- | --- |
| SSH key | `<yyyy-mm-dd>-<person>-<device>`, the date it was made | `2026-10-14-<person>-<device>` |
| API token | `<person>-<device>-<ro\|rw>` | `<person>-<device>-rw` |
| WireGuard tunnel | `<code>-<provider>` | `<code>-htz` |
| Hostname | the server's name, unchanged | `<code>-htz-srv-vpn` |
| Labels | `owner=<code>`, `role=<role>`, and `exposure=private` on every server but the vpn (cloud servers only) | |

- One provider project per code. Its servers, network and firewalls stay in
  it, because a private network cannot span projects.

### 1.2 Terms

| Term | Meaning |
| --- | --- |
| code | the owner's short code: a company, venture or project |
| vpn server | the one server with a public IP: the WireGuard entry, and NAT for the rest |
| backend | any server but the vpn server; private address only |
| peer | a device with a tunnel to the vpn server, such as a laptop |
| on-site server | a server on our own premises, on the site's infra network |
| platform | the hardware and image a server runs on, and the script adding to the baseline for it |
| baseline | what every server gets, applied by one idempotent script |
| role | the server's function, and the script adding to the baseline for it |
| bootstrap | the first login, before the tunnel exists, through a temporary SSH rule |
| app | a Docker Compose stack in `/opt/<app>/` |
| job | a systemd unit run by the service user, working in `/opt/<code>/jobs/<job>/` |
| admin | a person's own login, with sudo |
| service user | a login per role that runs jobs, with no sudo |
| check | a test on the server, run every 5 minutes, that alerts when it fails, clears, or keeps failing |
| heartbeat | an alert from the monitoring server when a server goes silent |

## 2 Network

- One server, `<code>-<provider>-srv-vpn`, has a public IP. Its firewall opens
  the WireGuard port, UDP 51820, and nothing else.
- Every other server sits on the project's private network with no public IP,
  and reaches the internet through NAT on the vpn server, by a network route
  for `0.0.0.0/0`.
- A firewall with no inbound rules applies by label to every server but the
  vpn, so a new server is closed from the moment it exists.
- SSH, web interfaces and admin panels are reached only through the tunnel. A
  service that needs traffic from outside connects out for it instead.
- The private range and the tunnel range overlap no other network a peer
  joins, such as an office LAN.
- An on-site server has no public IP and no port forward. It sits on the
  site's infra network, its address reserved on the gateway and its name in
  the site's local domain.
- The gateway's zone firewall lets only the admins' own devices into the infra
  network. The server's host firewall allows SSH from the same sources.
- An on-site server is a peer of the vpn server too, so it is reached through
  the same tunnel as every other server.

## 3 OS

- Debian stable, timezone UTC, a swap file, journald capped.
- The cloud image's extras are purged: filesystem and volume tools the server
  does not use (`btrfs-progs`, `xfsprogs`, `mdadm`, `lvm2`, `cryptsetup`),
  installer leftovers (`os-prober`, `reportbug`, `aptitude`, `tasksel`),
  `inetutils-telnet`, `at` and `locales-all`. The provider's own agents stay,
  such as `cloud-init` and `qemu-guest-agent`.
- On site: Debian stable, or Raspberry Pi OS Lite on a Raspberry Pi, whose
  kernel and firmware come from the board's own archive, included in
  unattended upgrades. Radios, network discovery (`avahi-daemon`), the
  vendor's remote access and desktop packages are switched off or purged. It
  boots from an SSD rather than an SD card.
- Unattended upgrades install security updates. A pending reboot raises an
  alert, and the reboot is done by hand.

## 4 Users and access

- `root` has no SSH login. Its password exists for the provider's console, or
  the physical console on site, only, kept in the password manager: a
  passphrase of lowercase words and digits, since a console takes typing, not
  paste. `su` is limited to group `root`, so the password opens nothing from
  a login session.
- One admin user per person, key only, with sudo. sudo asks for a password,
  except while a server is being set up; the password returns when setup
  ends. Membership of `docker` is root without a password, so where the
  password matters the admin leaves `docker` and runs `sudo docker`.
- A service user per role runs the jobs, with no sudo, no `docker` and no
  other groups.
- sshd: key only, on port 22, or 2200 where an app holds 22. `AllowUsers`,
  `X11Forwarding no`, `MaxAuthTries 3`. Agent forwarding is on only where a
  job clones with it.

## 5 Apps and jobs

- Everything the code's repo writes on a server lives under `/opt/<code>/`:
  `lib/`, the repo copy the baseline runs from and the only folder a sync may
  delete in; `bin/`, its commands, linked into `/usr/local/bin`; `etc/`,
  the settings as installed, which everything running reads, so a failed
  sync leaves them as they were; `secrets/`; `state/`; `apps/`, its own
  apps; `jobs/`; and `system/`, links to the drop-ins the system reads in
  place, such as sshd, sudoers, nftables and systemd units. Third-party apps
  keep `/opt/<app>/`.
- Each server's folder in the repo holds a `server.env` with its settings and
  no secrets: role, swap, SSH users, open ports, what to check. The baseline
  installs it as `/opt/<code>/etc/server.env`.
- Secrets live in `/opt/<code>/secrets/`, one file each, named in the
  server's `server.env` with the group that reads them. The baseline creates
  each empty, mode 600 for root or 640 for that group; a make target sets one
  value, typed and never shown. The repo lists them, never their values; the
  password manager holds every value. A tool that rewrites its own
  credentials, such as rclone refreshing a token, gets a folder of its own
  there, owned by the user it runs as.
- An app runs in Docker Compose in `/opt/<app>/`: `compose.yaml` copied from
  the repo, data in `/opt/<app>/data/`, every service `restart: always`, so a
  reboot needs no manual step.
- `.env` is generated on the server by a setup script, mode 600, owned by
  root, and never enters the repo. `.env.example` lists its keys.
- Make targets carry every action: `setup` writes or tops up `.env`, `deploy`
  copies the config, pulls and runs `up -d`, `ps` and `logs` read.
- Image tags are pinned to a version. Container logs rotate through
  `/etc/docker/daemon.json`. Published ports bind to private addresses only.
  Images are updated by hand, after a snapshot.
- An app with a web interface serves TLS from a reverse proxy in its stack,
  such as Caddy, with its certificate by DNS-01, since no port is public for
  an HTTP challenge. The DNS token may edit that zone only, and is limited to
  the vpn server's NAT address where the provider allows it; it sits in the
  app's `.env`.
- A job runs as a systemd unit, so it outlives the SSH session, in
  `/opt/<code>/jobs/<job>/`, owned by the service user.
- A server that clones over SSH trusts a forge's host key only once it
  matches the forge's published fingerprint; its role writes the checked keys
  into the service user's `known_hosts`.
- Nothing is edited on a server. A change goes through the repo and a deploy.

## 6 motd

The code and role as an ANSI Shadow banner (`figlet -f "ANSI Shadow"`), such
as `<CODE> GIT`, or the code and hardware on site, such as `<CODE> RPI`, since
a full server name is too wide for a terminal. Then the
server name and role, private address, load, disk, memory, upgrades pending, reboot needed, the
next certificate expiry and the state of the containers. The distribution's
licence text is removed.

## 7 Checks and alerts

- One runner in `/opt/<code>/bin/` holds the common checks and runs every 5
  minutes from a systemd timer. Its unit reads the server's `server.env`, so
  thresholds are settings, never edits to the script. A role adds its own
  checks as scripts in `/opt/<code>/etc/checks.d/`, each printing one line and
  exiting 0 for ok.
- Every server checks load, disk over 80%, memory, a pending reboot, upgrades
  waiting, failed units and restarting containers. Where they apply, it also
  checks certificates under 21 days and the age of the last backup. Checks for
  one app are added on its server.
- An alert is sent when a check fails and again when it clears, never on every
  run. A check still failing after 24 hours is sent again as a reminder.
- The motd reads the runner's last results, so a login never waits on a check.
- Each alert goes to the code's one Slack channel, `#<code>-agent`, where its
  jobs report too, from the code's one Slack app: a bot token with
  `chat:write`, the channel set by ID. It also goes by email from the alerts
  mailbox through SMTP on port 587, with an app password per server so each
  can be revoked alone. Both sit in the secrets folder (§5).
- A monitoring server alerts when a server goes silent. Each server's own
  checks keep alerting whatever happens to the monitoring server.

## 8 Backups

- A server holding state takes the provider's daily backups, the disaster copy
  that rolls the whole server back.
- Its apps also dump nightly to `/var/backups/<app>/`, mode 700, kept 14 days,
  for restoring one table or one repo. A dump that comes out empty fails the
  run rather than replacing a good one.
- An on-site server has no provider backup. Its state is kept small, its
  secrets are in the password manager, and its state is copied nightly to the
  site's NAS.

## 9 Changes

- The baseline is one idempotent script with an addition per platform and
  per role, run over SSH from the repo by a make target, on every server
  alike. Cloud-init on a new cloud server, or the image on an on-site one,
  only creates the first login and its sudo, so that first run can log in.
- The baseline, its scripts and the server templates are in
  [template/](template/): copied into a repo as `servers/`, with the code's
  settings in `servers.env`.
- A change to the baseline is rehearsed on a new or rebuilt server before it
  reaches a server holding state.
