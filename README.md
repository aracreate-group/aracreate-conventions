# araCreate Conventions

The canonical reference for the conventions every araCreate Group repository follows.
New repos are set up to match the structure and standards documented here, and each
project's own README links back to this repo rather than duplicating the rules.

Conventions are grouped by domain, one folder each. A folder exists when there is a
convention to put in it — the set of folders is the catalogue, so a tool with nothing
written for it yet has no folder.

## What lives here

| Folder | Covers |
| --- | --- |
| [repo/](repo/) | Repo structure, the project scaffold in [`repo/template/`](repo/template/), copyright, file headers, naming, Makefile, motd, versioning |
| [git/](git/) | Commit message format, plus the platform document for GitLab |

Read [`git/git-conventions.md`](git/git-conventions.md) whatever the repo, then the
platform document for wherever it is hosted. Commit format is defined there once and
nowhere else, because semantic-release parses it to decide version bumps and write
`CHANGELOG.md`.

## Starting a new repo

Copy [`repo/template/`](repo/template/) and follow
[repo §1](repo/readme.md#1-starting-a-repo). It carries the full folder set, the
`Makefile`, `scripts/motd`, `VERSION`, `LICENSE` and `.gitignore` with placeholders
ready to replace.

## Toolchain

The technology araCreate builds with, and the tools we work in. **Reference only** —
nothing here is a repo convention, and none of it is carried into a new project. A
project README lists its own stack (see
[repo §1.2](repo/readme.md#12-writing-the-readme)) and links back here.

### Tech stack

The default choice per layer. Deviate where a project needs to, and state the
deviation in the project README.

| Layer | Tool |
| --- | --- |
| Web app | Next.js (App Router) + TypeScript |
| Static site | Astro |
| Firmware — RTOS | Zephyr |
| Firmware — bare-metal | C + vendor HAL |
| Embedded Linux | Raspberry Pi OS on Raspberry Pi hardware |
| Hardware design | KiCad |
| Task runner | make — the single entry point in every repo (see [repo §4.1](repo/readme.md#41-makefile)) |
| Release automation | semantic-release, with the `changelog`, `exec`, and `git` plugins |
| Banner | figlet, ANSI Shadow font (see [repo §4.2](repo/readme.md#42-motd)) |
| Third-party code | git submodules (see [repo §2.2](repo/readme.md#22-third-party-code)) |

### Productivity tools

Recommended, not required. Adopt what suits you.

**Shell and terminal**
- [Zim](https://zimfw.sh/) — modular Zsh configuration framework
- [iTerm2](https://iterm2.com/) — terminal replacement for macOS
- [dotfiles](https://dotfiles.github.io/) — keep shell, git, and editor config version-controlled

**Editors**
- [vim](https://www.vim.org/) / [Neovim](https://neovim.io/) — terminal editing
- [VS Code](https://code.visualstudio.com/) — main IDE
- [Sublime Text](https://www.sublimetext.com/) — quick edits

**Window and clipboard**
- [Rectangle](https://rectangleapp.com/) — window management
- [Flycut](https://github.com/TermiT/Flycut) — clipboard history

**Git**
- [SourceTree](https://www.sourcetreeapp.com/) — visual git client for reviewing history and staging hunks

**Automation**
- [Alfred](https://www.alfredapp.com/) — hotkeys, text expansion, workflows
- [DeepL](https://www.deepl.com/) — translation
- [In Your Face](https://www.inyourface.app/) — meeting reminders that cannot be ignored

## License

Proprietary. See [LICENSE](LICENSE).
