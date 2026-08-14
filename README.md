# araCreate Conventions

The canonical reference for the conventions every araCreate Group repository follows.
New repos are set up to match the structure and standards documented here, and each
project's own README links back to this repo rather than duplicating the rules.

Conventions are grouped by domain, one folder each. A folder exists when there is a
convention to put in it — the set of folders is the catalogue, so a tool with nothing
written for it yet has no folder. Reference material that is not a convention lives in
[`wiki/`](wiki/).

## What lives here

| Folder | Covers |
| --- | --- |
| [repo/](repo/) | Repo structure, the project scaffold in [`repo/template/`](repo/template/), copyright, file headers, naming, Makefile, motd, versioning |
| [git/](git/) | Commit message format, plus the platform document for GitLab |
| [wiki/](wiki/) | Reference notes that are not conventions — currently the [toolchain](wiki/toolchain.md) |

Read [`git/git-conventions.md`](git/git-conventions.md) whatever the repo, then the
platform document for wherever it is hosted. Commit format is defined there once and
nowhere else, because semantic-release parses it to decide version bumps and write
`CHANGELOG.md`.

## Starting a new repo

Copy [`repo/template/`](repo/template/) and follow
[repo §1](repo/readme.md#1-starting-a-repo). It carries the full folder set, the
`Makefile`, `scripts/motd`, `VERSION`, `LICENSE` and `.gitignore` with placeholders
ready to replace.

## License

Proprietary. See [LICENSE](LICENSE).
