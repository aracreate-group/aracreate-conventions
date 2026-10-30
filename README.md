# araCreate Conventions

The canonical reference for every araCreate Group convention: how repos, commits,
work items, shared drives, Claude Code sessions, servers and Cloudflare are set up
and run. Each convention is defined once, here. A repo, drive or server links back
to the convention it follows rather than restating it, and adds only what is
specific to it.

Conventions are grouped by domain, one folder each, and each folder's `readme.md`
is its index. A folder exists only when there is a convention to put in it, so
the folders are the catalogue. A domain with nothing written for it yet has no
folder.

## What lives here

| Folder | Covers |
| --- | --- |
| [repo/](repo/) | Repo structure, the project scaffold in [`repo/template/`](repo/template/), copyright, file headers, naming, Makefile, motd, versioning |
| [git/](git/) | Commit message format, the platform document for GitLab, and templates in [`git/templates/`](git/templates/) |
| [drive/](drive/) | Google shared drives: naming, links and code in every drive, client layout in a projects drive, person folders in a team drive |
| [claude/](claude/) | Running a Claude Code session: ending it, replies, questions, asking before acting, files, evidence, shell |
| [server/](server/) | Servers in the cloud and on site: naming, network, OS, access, apps, motd, checks and alerts, backups, changes; a template servers/ folder |
| [cloudflare/](cloudflare/) | Cloudflare: the account, domain tiers and groups, access, DNS and tokens; static sites on Pages, from creating a project to its checks |

## Notes

- `logs/` is this repo's own log, kept as [repo §5](repo/readme.md#5-logs) asks of
  every repo, not a convention domain.
- Read [`git/git-conventions.md`](git/git-conventions.md) whatever the repo, then
  the platform document for wherever it is hosted.

## License

Proprietary. See [LICENSE](LICENSE).
