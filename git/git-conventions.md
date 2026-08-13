# Git Conventions

**What this is.** The rules for git itself — how branches are named, what a
commit message looks like, how history is kept — and the ground rules governing
how any of it reaches a shared branch. Nothing here depends on where the repo is
hosted: it holds on GitLab, on GitHub, and on a bare remote with no tracker at
all.

**Why it exists.** Commit format is the one convention that has to be identical
everywhere. semantic-release reads commit messages to decide version bumps and
generate `CHANGELOG.md` ([aracreate-conventions §2.7](../README.md#27-versioning)),
so a repo that phrases its commits differently silently produces different
release notes. The history is also the only record that survives the platform —
issues, boards and review threads live in a host that may be migrated or lost,
while `git log` travels with the code. Keeping it readable is what makes the
work legible in five years.

**How it fits.** The araCreate conventions are three layers, read together and
never duplicating each other:

| Layer | Covers |
| --- | --- |
| [aracreate-conventions](../README.md) | What a repo *contains* — structure, headers, naming, versioning |
| **This document** | How change moves *through git* — branches, commits, merges, review |
| [gitlab-conventions](gitlab-conventions.md) · [github-conventions](github-conventions.md) | How work is *tracked and reviewed* on each host |

Every araCreate repo follows this document whatever its host. Read it with the
platform document for wherever the repo actually lives.

## Terminology

The same concept has a different name on each host. This document uses the
neutral term; each platform document uses its own host's word, because that is
what the UI says.

| Here | GitLab | GitHub |
| --- | --- | --- |
| **Tracked item** | Work item (Issue / Task) | Issue (with sub-issues) |
| **Change request** | Merge request (MR) | Pull request (PR) |
| **Reference number** | iid — `#136` | Issue / PR number — `#136` |
| **Thread** | Discussion | Review thread / comment thread |
| **Pipeline** | Pipeline | Checks / Actions workflow |

Three roles appear throughout:

| Role | Meaning |
| --- | --- |
| **Developer** | The person who writes the change. In review they are the **author**. |
| **Reviewer** | The peer who approves. Never the author ([§5.3](#53-who-approves-and-who-merges)). |
| **Assistant** | Whatever automation drafts, files or commits on the developer's behalf. Every step it takes is proposed and confirmed, never assumed. |

## Contents

| Part | Covers |
| --- | --- |
| [1 Ground rules](#1-ground-rules) | The rules that apply to everything, everywhere |
| [2 Branching](#2-branching) | Model · naming |
| [3 Commits](#3-commits) | Format · reference trailer · scope · rewriting |
| [4 Merging](#4-merging) | Why no squash · what happens after |
| [5 Review](#5-review) | Readiness · feedback · who approves and who merges |
| [6 Quick reference](#6-quick-reference) | The rules in one table |

## 1 Ground rules

Five rules that hold everywhere — in this document and in both platform
documents. The later sections apply them; they are not restated there.

### 1.1 Nothing is published without an explicit instruction

Publishing means anything the team can see or that changes shared state: commit,
push, merge, approve, retitle, or change an item's or change request's status,
labels or assignees — and equally posting a comment, filing an item, or editing
a description that is already live.

Approval to make changes is never approval to publish them. None of the
following is an instruction, however strongly it implies one is coming:

- approving a plan whose steps say the work will be committed, pushed or filed;
- a conditional or permissive remark — "it can be committed", "then the PR can
  be closed", "this should go on branch X";
- being asked to draft or prepare a message, description or commit;
- having been told to publish something earlier in the same session.

Each act needs its own go-ahead, in the user's own words, for that act. Pushing
is separate from committing; merging is separate from both. Prepare the work,
draft the text **to a file** and show it, say what is ready, and wait — a posted
description is already visible to the team, and there is no unsend.

### 1.2 Selections are fetched, not assumed

Labels, milestones, assignees, iterations, epics and projects are **project
data, not convention**. They are defined per project and per client, they differ
between repos in the same group, and they change without notice. Neither the
host nor araCreate fixes their values — araCreate fixes only the *rules* about
them (exactly one type label, always a milestone), never the vocabulary.

An assistant filling them in from what it saw last time will file items that are
quietly wrong: a label that no longer exists, a milestone that closed last
quarter, an assignee who left the project. So before creating or updating any
tracked item or change request, the assistant:

1. **Fetches the repo's current options** — labels, milestones, members. Fetch
   from the repo the item is being filed in, not from the one currently checked
   out.
2. **Proposes a complete draft**: the title, the description, and every
   selectable field, each with the value it suggests and the reason for it.
3. **Waits for the developer to confirm or change each one.** Silence is not
   confirmation, and neither is a value being the only plausible option.

The **title gets the same treatment**. It is the one line that appears in every
board, list and notification, and the branch name is slugified from it
([§2.2](#22-branch-naming)) — a title corrected after filing leaves a branch
named after the wrong version of the work. Propose it, let the developer edit
the wording, then file.

Where no existing option fits, say so and ask. Do not invent a label or
milestone to make the item filable — a gap in the project's vocabulary is worth
seeing, and creating one silently makes the set less trustworthy for everyone
after you.

### 1.3 Investigating is not approval to fix

Reviewing, testing or diagnosing a change request, item or defect is a request
for a finding, not for a change. Report the diagnosis and the proposed fix, then
stop. Do not start editing because the fix looks obvious, small or clearly
correct. Default to read-only on anything review-shaped.

### 1.4 Wording

Applies to every branch name, title and commit subject, on any host.

**Use the project's short forms** for its recurring nouns in every title,
description and comment, and define them in that project's own docs rather than
here. Long forms are for prose aimed at people outside the team; in tracked work
they only pad the line. This does not extend to code — a tool's `--help` output
still spells things out for whoever runs it cold.

**Drop the articles** — `a`, `an`, `the` — from every title and every commit
subject. They carry no information in a summary line, and leaving them out keeps
the phrasing general rather than tied to one instance:

```
add a BLE diagnostics tool based on python   ->  add BLE diagnostics tool based on python
fix the shutdown command over ble            ->  fix shutdown command over ble
update the makefiles for a fresh checkout    ->  update makefiles for fresh checkout
```

This is a summary-line rule, not a prose rule. Descriptions, comments and commit
bodies are written as normal sentences.

**Never name people or credentials.** No emails, usernames, real names, tokens
or account IDs in a title, branch name or commit message. Keep them generic; the
detail belongs in the file. No `Co-Authored-By` trailers — araCreate repos carry
single authorship.

The line is *people, not references*. A project-management reference is exactly
what a commit message should carry — `#136` at the foot of the body
([§3.2](#32-reference-trailer)) points at the work without naming anyone, and it
is the whole reason that trailer is allowed. `@handle` is the one exception on
the other side: it belongs in descriptions and comments, because that is how the
host notifies someone, and it stays out of commit messages, where it notifies no
one and only dates the history.

### 1.5 One record per fact

Every fact lives in exactly one place and is linked from anywhere else that
needs it. A summary kept in two places drifts, and the reader cannot tell which
copy is current.

| Fact | Lives in |
| --- | --- |
| The ask, as originally made | The tracked item's description |
| What is still needed to act on it | The tracked item's description |
| Scope, design and reasoning | The change request's description |
| Why a given change was made | The commit message ([§3.1](#31-format)) |
| Evidence that it works | The change request's **Test** section |

Link across repos with **full URLs**, never a bare `#132` — a reference number
only resolves inside its own repo. Within a repo, `#136` is fine.

## 2 Branching

### 2.1 Model

GitFlow, with two permanent branches:

| Branch | Holds |
| --- | --- |
| `main` | Released code. Tagged, never committed to directly. |
| `develop` | Integration branch. Every feature branch targets it. |
| `<n>-<slug>` | One tracked item's work. Deleted on merge. |

Both permanent branches are protected: no direct pushes, no force-pushes. Branch
off another feature branch only when the work genuinely depends on it, and say
so in the change request's description.

### 2.2 Branch naming

`<reference number>-<slugified title>`, which is exactly what both hosts produce
when the branch is created **from the tracked item**:

```
136-feat-derive-ble-device-name-from-chip-uid
```

Create it that way rather than by hand, so the link between branch and item is
made by the host instead of by convention. A branch typed out locally gets the
same name but not the same provenance.

This fixes the order of operations: **the tracked item exists first**, because
its number is part of the branch name. There is no correct branch name until the
item exists.

## 3 Commits

### 3.1 Format

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
  articles ([§1.4](#14-wording)). Keep it under ~72 characters so `git log
  --oneline` stays readable.
- **Body**: required whenever the reason is not obvious from the diff. It
  explains *why*, not *what* — the diff already says what. Wrap it; write full
  sentences.

### 3.2 Reference trailer

The tracked item reference goes at the foot of the body, on its own last line,
as a bare `#<n>` and nothing else:

```
feat: derive BLE device name from chip uid

Default name collided across units on the same bench, so a scan could not
tell two boards apart.

#136
```

No closing keyword, no URL, no change request number. A closing keyword in a
commit message is acted on when the commit reaches the **default** branch —
under GitFlow that is the release to `main`, long after the work was done — so
closing belongs in the change request's description, where merging triggers it.
The bare `#136` is a pointer for whoever reads the log, short enough that the
message still reads outside the host.

### 3.3 What goes in one commit

**One concern per commit**, and every commit must stand on its own, because
every one of them lands on `develop` verbatim ([§4](#4-merging)).

**Stage deliberately.** Name the paths going into a commit rather than staging
everything present; an unrelated file caught by a blanket `git add` lands on
`develop` under a message that does not describe it.

**Refactoring that is needed to make a fix possible goes in its own commit**, so
the fix is legible on its own.

### 3.4 Rewriting history

**Rework in new commits, not rewritten ones.** Once a change request is under
review, force-pushing over the reviewed commits destroys the diff the reviewer
was reading and silently invalidates their approval.

Rebasing a feature branch onto a moved `develop` is fine before review starts.
After it starts, merge `develop` in or wait.

## 4 Merging

**Do not squash on merge.** Every commit keeps its own conventional message on
`develop`.

Release tooling reads commit messages, not change request titles. Squashing
collapses a change request into one commit with one type, so one carrying a
`fix:` alongside a `test:` loses whichever type the squash does not pick, and
that change never appears in the release notes. Keeping the commits also keeps
the history reviewable: the fix and the tooling that proved it stay separately
identifiable.

This is the obligation behind [§3.3](#33-what-goes-in-one-commit) — no-squash is
only tolerable if each commit was written to stand alone.

On merge: delete the source branch, and let the tracked item be closed by the
change request rather than by hand. The change request keeps the history.

## 5 Review

The mechanics differ per host — draft state, approval, required checks — but
these principles do not.

### 5.1 Before requesting review

The author marks a change request ready only when all of the following hold.
This is the definition of done:

- [ ] The pipeline is green. A red pipeline wastes the reviewer's turn.
- [ ] The author has read their own diff end to end, and left inline comments
      where a decision is not obvious from the code.
- [ ] The description is filled in and current, with **Test** carrying real
      evidence — an observed value, a log line, a before/after, not "verified on
      a bench unit".
- [ ] Every commit stands on its own ([§3](#3-commits)).
- [ ] Documentation affected by the change is updated in the same change request.
- [ ] Label, milestone and assignee are set and match the tracked item.
- [ ] Nothing unresolved is left silently — it is recorded, or filed as its own
      item.

Self-review is the cheapest review there is: most of what a reviewer would find
is visible to the author reading their own diff in the web view rather than in
the editor.

**One change request, one concern.** A small one gets a real review; a large one
gets a skim and an approval. If the work splits into parts that can land
independently, split the tracked item and give each part its own branch.

### 5.2 Giving feedback

Prefix each comment with its kind, so the author knows immediately whether it
blocks:

| Prefix | Means |
| --- | --- |
| `issue:` | Must be addressed before merge |
| `question:` | Blocks only until answered |
| `suggestion:` | A proposed improvement, worth a reply |
| `nit:` | Style or polish, take it or leave it |
| `praise:` | Worth saying out loud |

Mark anything optional `(non-blocking)`. **When only non-blocking comments
remain, approve** — holding a change request open for nits costs more than the
nits.

Review the change, not the author. Say what is wrong and why it matters; offer
an alternative where you have one, and assume the author already considered the
obvious approach. Aim to respond within one working day — a change request
waiting on a reviewer is work that is finished but not delivered.

The author replies to every comment, addresses or pushes back on each, and
re-requests review. Reviewers resolve the threads they opened.

### 5.3 Who approves and who merges

- **At least one peer review before merge.**
- **The author does not approve their own change.** Whoever wrote it does not
  decide it is reviewed.
- **The developer merges, not the assistant** — automation does not decide that
  something ships, and only on an explicit instruction
  ([§1.1](#11-nothing-is-published-without-an-explicit-instruction)).

## 6 Quick reference

| | Rule |
| --- | --- |
| Branch | `<n>-<slug>`, created from the tracked item, off `develop` |
| Commit subject | `<type>: <lowercase imperative>` · no articles · no full stop · ~72 chars |
| Commit body | why, not what · normal sentences · required when the diff is not self-explanatory |
| Commit trailer | bare `#<n>` on the last line · no closing keyword · no URL |
| Never in a message | emails · usernames · real names · tokens · `Co-Authored-By` |
| Commit scope | one concern · staged by path · stands on its own |
| History | new commits, never force-push over a review |
| Merge | no squash · delete source branch · item closed by the change request |
| Review | one peer minimum · author never approves · developer merges |
| Publishing | explicit instruction for each act — see [§1.1](#11-nothing-is-published-without-an-explicit-instruction) |
