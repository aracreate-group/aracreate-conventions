# Drive Conventions

**What this is.** The rules that hold in every Google shared drive the group
keeps, whatever it is for: how files and folders are named, how items are
linked, and what never goes in a drive.

**Why it exists.** Shared drives outlive everyone who works in them and are
searched by people who did not create the files. Names and links that follow
one rule are what keep them findable.

**How it fits.** A drive with a particular purpose adds its own layout on top:

| Document | Covers |
| --- | --- |
| conventions-drive (this document) | Naming, linking, code and what stays out, in every shared drive |
| [conventions-drive-projects](conventions-drive-projects.md) | Client folder shape, codes, lifecycle and sharing in a projects drive |
| [conventions-drive-team](conventions-drive-team.md) | Person folders, their three folders and shortcuts in a team drive |

Organisation drives have their own structure and follow only this document.

## 1 Naming

- Every folder name, and the name of every file we create, is param-case: lower
  case, words joined by single hyphens, no spaces, underscores, capitals or
  trailing spaces. That includes Google Docs, Sheets and Slides.
- A file received from someone else keeps the name it arrived with, so it
  still matches the message it came in. Names a tool depends on keep their form
  too, inside a code snapshot or a package ([§3](#3-code)).
- No numbering prefixes on folders such as `1-` or `01-`. A drive's fixed
  folder names give the order.
- A leading `-` lifts an item to the top of its listing, nothing more:
  `-reports/`.
- Dated files and folders lead with the ISO date: `2026-09-12-workshop/`.
- A version is `v<n>`, or `v<n>-<name>` when it has a working name:
  `v2-falcon/`.

## 2 Links

An item needed in two places is kept once and linked from the other with a
Drive shortcut, made in Drive itself with "Add shortcut". A symlink or Finder
alias made in the local Drive folder is not a Drive shortcut, and nobody else
sees it.

Moving or renaming an item keeps its Drive ID, so links and shortcuts to it keep
working. Tidy a name or a location freely; it breaks nothing.

## 3 Code

Source code is developed in a local clone or a git host, never in a drive. A
drive keeps it only as an archive or a copy for someone else, written once per
release:

    <repo>-<version>.bundle           full history in one file, cloneable
    <repo>-<version>/                 plain source snapshot, no .git

A live working tree in a drive churns thousands of small files and can split
one folder into two with the same name. Names inside a snapshot, such as
`README.md` or `Makefile`, stay as the code needs them.

## 4 Sharing

Share a folder, never single files inside it, so access is visible in one
place.

## 5 What stays out

- Copies named `name (1)`: fix the original instead.
- Credentials and secrets: they belong in a password manager.
- Loose files at the drive root, apart from what the drive's own convention
  places there.
