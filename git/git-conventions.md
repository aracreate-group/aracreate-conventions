# Git Conventions

**What this is.** How a commit message is written — the format release tooling
parses, and the rules about what may appear in one. Nothing here depends on where
the repo is hosted: it holds on GitLab, on GitHub, and on a bare remote with no
tracker at all.

**Why it exists.** Commit format is the one convention that has to be identical
everywhere. semantic-release reads commit messages to decide version bumps and
generate `CHANGELOG.md` ([repo §4.3](../repo/readme.md#43-versioning)), so a repo
that phrases its commits differently silently produces different release notes.
The history is also the only record that survives the platform — issues, boards
and review threads live in a host that may be migrated or lost, while `git log`
travels with the code. Keeping it readable is what makes the work legible in five
years.

**How it fits.**

| Layer | Covers |
| --- | --- |
| [repo](../repo/readme.md) | What a repo *contains* — structure, headers, naming, versioning |
| **This document** | What a commit message looks like |
| [gitlab-conventions](gitlab-conventions.md) | How work is *tracked and reviewed* on GitLab |

## Contents

| Part | Covers |
| --- | --- |
| [1 Format](#1-format) | Type · subject · body |
| [2 Reference trailer](#2-reference-trailer) | Pointing at the tracked item |
| [3 Wording](#3-wording) | Articles · short forms · what never appears |
| [4 What goes in one commit](#4-what-goes-in-one-commit) | Scope · staging |
| [5 Publishing](#5-publishing) | Committing and pushing need an instruction |
| [6 Quick reference](#6-quick-reference) | The rules in one table |

## 1 Format

Conventional commits. The subject is what release tooling parses, so its shape
is not negotiable:

```
<type>: <lowercase imperative summary>

<body — why, where the diff does not say it. Wrapped, normal sentences.>

#<reference number>
```

- **Types**: `feat` `fix` `refactor` `perf` `docs` `build` `test` `chore`.
  `feat` and `fix` drive version bumps; the rest do not.
- **Subject**: imperative, lowercase after the prefix, no trailing full stop, no
  articles ([§3](#3-wording)). Keep it under ~72 characters so `git log
  --oneline` stays readable.
- **Body**: required whenever the reason is not obvious from the diff. It
  explains *why*, not *what* — the diff already says what. Wrap it; write full
  sentences.

A scope is optional and goes in brackets after the type — `refactor(structure):`.
Use it where the area is not obvious from the subject.

## 2 Reference trailer

Where the work is tracked, the item reference goes at the foot of the body, on
its own last line, as a bare `#<n>` and nothing else:

```
feat: derive BLE device name from chip uid

Default name collided across units on the same bench, so a scan could not
tell two boards apart.

#136
```

No closing keyword, no URL, no change request number. A closing keyword in a
commit message is acted on when the commit reaches the **default** branch, long
after the work was done — so closing belongs in the change request's description,
where merging triggers it. The bare `#136` is a pointer for whoever reads the
log, short enough that the message still reads outside the host.

Omit the trailer where there is no tracked item.

## 3 Wording

**Use the project's short forms** for its recurring nouns, and define them in
that project's own docs rather than here. Long forms are for prose aimed at
people outside the team; in a subject line they only pad it. This does not extend
to code — a tool's `--help` output still spells things out for whoever runs it
cold.

**Drop the articles** — `a`, `an`, `the` — from every commit subject. They carry
no information in a summary line, and leaving them out keeps the phrasing general
rather than tied to one instance:

```
add a BLE diagnostics tool based on python   ->  add BLE diagnostics tool based on python
fix the shutdown command over ble            ->  fix shutdown command over ble
update the makefiles for a fresh checkout    ->  update makefiles for fresh checkout
```

This is a summary-line rule, not a prose rule. Commit bodies are written as
normal sentences.

**Never name people or credentials.** No emails, usernames, real names, tokens or
account IDs in a commit message. Keep them generic; the detail belongs in the
file. **No `Co-Authored-By` trailers** — araCreate repos carry single authorship.

The line is *people, not references*. A project-management reference is exactly
what a commit message should carry — `#136` at the foot of the body
([§2](#2-reference-trailer)) points at the work without naming anyone, and it is
the whole reason that trailer is allowed. `@handle` belongs in descriptions and
comments, because that is how the host notifies someone; it stays out of commit
messages, where it notifies no one and only dates the history.

## 4 What goes in one commit

**One concern per commit**, and every commit must stand on its own.

**Stage deliberately.** Name the paths going into a commit rather than staging
everything present; an unrelated file caught by a blanket `git add` lands under a
message that does not describe it.

**Split a file that spans two concerns** rather than letting the smaller change
ride along. Stage the hunks belonging to this commit and leave the rest —
`git add -p`, or a patch built from `git diff` and applied with
`git apply --cached`. A commit carrying someone else's change is a commit whose
message is wrong.

**A zero-context patch places hunks by line number.** `git diff -U0` gives the
finest split, but `git apply --cached --unidiff-zero` trusts those numbers instead
of matching context, so omitting an earlier hunk silently misplaces every later
one — the file still applies and no longer parses. Either keep context (`-U3`, so
git locates each hunk) or build the intended file content and write it to the
index, and re-diff after every commit so the offsets stay valid.

**Prove the split lost nothing.** Two checks: selecting *all* hunks must reproduce
the working tree byte for byte, and the finished branch must diff identically
against its base to a patch taken before the split started. Keep that patch until
the last commit lands.

**`git mv` stages the rename immediately.** Both paths sit in the index from that
moment, so the next `git add <paths>` and commit sweeps them in although they were
never named. Check `git diff --cached --stat` before committing after a move, and
`git reset -- <path>` anything belonging to a later commit.

**Refactoring that is needed to make a fix possible goes in its own commit**, so
the fix is legible on its own.

## 5 Publishing

Committing and pushing are separate acts, and **each needs its own explicit
instruction** in the user's own words, for that act, given then. Approval to make
changes is never approval to commit them. None of the following is an
instruction, however strongly it implies one is coming:

- approving a plan whose steps say the work will be committed or pushed;
- a conditional or permissive remark — "it can be committed", "this should go on
  branch X";
- being asked to draft or prepare a commit or its message;
- having been told to commit something earlier in the same session.

Prepare the work, draft the message **to a file** and show it, say what is ready,
and wait.

Cutting a release is publishing too: it commits `VERSION` and `CHANGELOG.md`,
tags, and pushes both. **`semantic-release` run outside CI does nothing, loudly** —
with no CI environment detected it falls back to dry-run while still printing
`✔ Published release <version>` and the full notes. From a laptop it needs
`--no-ci`. Either way verify afterwards rather than trusting the output:

```sh
cat VERSION            # bumped?
git tag | head -1      # tag created?
git status -sb         # release commit, and is it pushed?
```

## 6 Quick reference

| | Rule |
| --- | --- |
| Subject | `<type>: <lowercase imperative>` · no articles · no full stop · ~72 chars |
| Types | `feat` `fix` `refactor` `perf` `docs` `build` `test` `chore` |
| Body | why, not what · normal sentences · required when the diff is not self-explanatory |
| Trailer | bare `#<n>` on the last line · no closing keyword · no URL · omitted when untracked |
| Never in a message | emails · usernames · real names · tokens · `Co-Authored-By` |
| Scope | one concern · staged by path · stands on its own |
| Splitting | keep context or build the blob · all-hunks rebuild must match · diff the branch against a pre-split patch |
| Publishing | explicit instruction for each act — see [§5](#5-publishing) |
| Releases | publishing too · `semantic-release` needs `--no-ci` off CI · verify VERSION and the tag |
