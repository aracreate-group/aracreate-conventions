# Toolchain

**What this is.** The technology araCreate builds with, and the tools we work in.
**Reference only** — nothing here is a repo convention, and none of it is carried into
a new project. A project README lists its own stack (see
[repo §1.2](../repo/readme.md#12-writing-the-readme)) and links back here.

A tool listed here gets its own convention folder only once there are conventions to
write for it. Until then this is the whole record of it.

## 1 Tech stack

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
| Task runner | make — the single entry point in every repo (see [repo §4.1](../repo/readme.md#41-makefile)) |
| Release automation | semantic-release, with the `changelog`, `exec`, and `git` plugins |
| Banner | figlet, ANSI Shadow font (see [repo §4.2](../repo/readme.md#42-motd)) |
| Third-party code | git submodules (see [repo §2.2](../repo/readme.md#22-third-party-code)) |

## 2 Productivity tools

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
