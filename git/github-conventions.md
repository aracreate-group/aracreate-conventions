# GitHub Conventions

**What this is.** How work is tracked and reviewed on GitHub: issues, pull
requests, and the process joining them. It covers only what is specific to
GitHub.

**Why it exists.** The tracker is only useful if its state can be trusted — if a
label means one thing, a milestone is always set, and an issue's status matches
reality. That is what lets planning happen from the board rather than from
memory, and it only holds if everyone files work the same way.

**How it fits.** Read this together with:

| Document | Covers |
| --- | --- |
| [aracreate-conventions](../README.md) | What a repo *contains* — structure, headers, naming, versioning |
| [git-conventions](git-conventions.md) | Branches, commits, merges, review — **and the ground rules that govern all of it** |
| **This document** | GitHub's vocabulary and mechanics for the above |

Nothing in [git-conventions](git-conventions.md) is repeated here. In particular
the commit format, the branching model, the no-squash rule and the review
principles live there and apply unchanged on GitHub.

## Terminology

Where GitHub's UI uses a word, GitHub's word wins.

| Term | Meaning |
| --- | --- |
| **Issue** | GitHub's unit of tracked work. A **sub-issue** is a child of another issue ([§2.1](#21-type-and-ownership)). |
| **Number** | The per-repo reference a issue or PR carries — the `136` in `#136`. Issues and PRs share one sequence, so a number is unique across both within a repo. |
| **PR** | Pull request. |
| **Review thread** | A root review comment plus its replies, anchored to a line of the diff. Issue comments are **not** threaded ([§2.7](#27-comments-and-threads)). |

Roles — **developer** / **author**, **reviewer**, **assistant** — are defined in
[git-conventions](git-conventions.md#terminology).

## Differences from GitLab

Where a repo moves between hosts, these are the points the process genuinely
changes rather than just renaming:

| | GitLab | GitHub |
| --- | --- | --- |
| PR/MR on an empty branch | Allowed — MR opens before any commit | **Not allowed** — a PR needs at least one commit, so the branch is created first and the PR opens after the first push ([§1](#1-workflow)) |
| Draft state | `Draft:` title prefix, toggled any time | A first-class flag, set at creation with `--draft` |
| Scoped labels | `key::value`, mutually exclusive | **No equivalent** — prefixes are convention only, nothing enforces exclusivity ([§2.4](#24-labels)) |
| Milestones | Project or group level | **Repo level only** ([§2.5](#25-milestone)) |
| Hierarchy | Issue → Task work item types | Issue → sub-issue, plus optional org-level issue *types* |
| Blocking review | Threads unresolved | *Request changes* review state |
| Ownership routing | Approval rules | `CODEOWNERS` |

## Contents

| Part | Covers |
| --- | --- |
| [1 Workflow](#1-workflow) | The path from a request to a merged change |
| [2 Issues](#2-issues) | Type · title · description · labels · milestone · status · comments |
| [3 Pull requests](#3-pull-requests) | Branch · title · description · draft state |
| [4 Review and merge](#4-review-and-merge) | GitHub's mechanics for approval and merge |
| [5 Repo setup](#5-repo-setup) | Templates, labels, milestones, rulesets and merge settings |
| [6 Quick reference](#6-quick-reference) | The rules in one table |
| [7 gh](#7-gh) | Command-line recipes |

## 1 Workflow

The path a change takes on GitHub, and who does what.

| # | Actor | Step |
| --- | --- | --- |
| 1 | client / developer | The need surfaces as a comment on an existing issue, a chat, a document — or the developer hits a defect directly and investigates it. |
| 2 | developer | Capture the origin: the permalink to that comment, or the finding itself when there is no thread to point at. |
| 3 | assistant | Fetch the target repo's labels, milestones and members, then propose the title, the description, and each field with a suggested value ([ground rule 1.2](git-conventions.md#12-selections-are-fetched-not-assumed)). |
| 4 | developer | Confirm or correct the title and every selection. |
| 5 | assistant | File the issue as confirmed, quoting the ask and linking the origin by full URL. Reply where it came from with one line: `Tracked at <URL>`. |
| 6 | assistant | Create the branch **from the issue** — the *Create a branch* link in the issue's Development panel, or `gh issue develop` ([§7](#7-gh)). |
| 7 | developer | Check the branch out locally and put the work on it — new edits, or changes lifted from a stash. |
| 8 | assistant | Commit and push. |
| 9 | assistant | Open the PR against `develop` **as a draft**, with the description from the template ([§3.3](#33-description)), including **Test** and **Open**. |
| 10 | developer | Self-review, wait for green checks, mark ready for review, request reviewers. |
| 11 | reviewer | Review and approve ([§4](#4-review-and-merge)). |
| 12 | developer | Merge. |
| 13 | assistant | Confirm the issue closed, and reply wherever it was tracked that it is resolved. |

What makes the order matter:

- **The issue comes first**, because its number is part of the branch name
  ([git-conventions §2.2](git-conventions.md#22-branch-naming)). There is no
  correct branch name until the issue exists.
- **The branch comes before the PR, and the first commit between them.** This is
  the one place GitHub's process differs from GitLab's: GitHub will not open a
  PR on a branch with no commits, so steps 6–9 are separate rather than the
  single step GitLab allows. Open the PR on the *first* push, not the last — a
  draft PR opened early is the working record; one opened at the end is a
  wrapper.
- **Draft at creation** (step 9), never a PR that is briefly ready. A PR that is
  briefly non-draft is a PR that can be merged before anyone has looked at it.
- **Nothing is filed before it is confirmed.** Step 3 is a proposal and step 4 is
  the decision.
- **The author does not approve, and the assistant does not merge.** Steps 8, 11
  and 12 are deliberately different actors.

## 2 Issues

### 2.1 Type and ownership

| | Use for |
| --- | --- |
| **Issue** | A standalone piece of work, a discussion, or a collection that spawns children. |
| **Sub-issue** | A child of an issue. Never on its own — a sub-issue always has a parent. |

Break a large issue into sub-issues rather than a checklist in the description,
so each piece carries its own assignee, milestone and PR. A checklist item
cannot be scheduled, assigned or merged; a sub-issue can. Create one with
`--parent` ([§7](#7-gh)).

Where the organisation has **issue types** configured, set one — it is the
closest equivalent to GitLab's work item type, and unlike a label it cannot be
set twice.

File the issue in the repo that owns the **code**, not the repo where it was
noticed. Bench-tooling work goes to the tooling repo even when it surfaced in a
firmware thread.

Where one issue genuinely waits on another, record it with GitHub's **issue
dependencies** (`blocked by` / `blocking`) rather than a sentence in the
description. The link shows up in the issue; the sentence does not.

### 2.2 Title

Conventional-commit prefix, then a lowercase imperative summary — the same shape
as the commit that will land
([git-conventions §3.1](git-conventions.md#31-format)):

```
feat: import hand-edited test profile at runtime from bench tool
fix: shutdown command over ble fails
docs: provide CAN bit timing details
build: update makefiles to build in fresh development environment
```

- No articles ([git-conventions §1.4](git-conventions.md#14-wording)).
- Prefix with `[wip]` when the issue is an open collection still being filled,
  rather than a defined piece of work.
- Do not encode the type in the title (`Discussion: …`) — that is the label's or
  the issue type's job ([§2.4](#24-labels)).
- Keep it a summary, not a sentence. If the title needs a comma to stay
  accurate, it is probably two issues.
- **The developer approves the wording before the issue is filed.** An assistant
  drafting a title is proposing one.

### 2.3 Description

An issue captures **what is known when it is filed** — the ask, and what is
still missing to act on it. Nothing more. The shape that works:

```markdown
Follow-up from [<repo>#<number> (comment)](<full url>) — @author:

> <the ask, quoted as written>

One or two lines of what that means, if the quote does not stand alone.

## Needed from @<person>
- Logs, conditions, or the decision still outstanding.

Scope will be defined once the above is available.
```

- Quote the ask **as written**. A paraphrase loses the detail that turns out to
  matter, and the quote is the one part nobody can reconstruct later.
- Do **not** write scope, design, or acceptance criteria from reading the code at
  filing time. Investigation belongs in development and its output belongs in
  the PR description — an issue padded with a guessed plan reads as decided when
  it is not, and goes stale the moment development starts.
- Where a decision has already been taken, record the decision and who took it.
  That is history, not a plan.
- For a defect, give what the reporter had: what was observed, on which build,
  under what conditions.
- Sections that would be empty are dropped, not left as headings.

### 2.4 Labels

**There is no araCreate label set.** Each repo defines its own, and it evolves
with the project. Read the repo's labels from the repo ([§7](#7-gh)) and have
the developer choose from them
([ground rule 1.2](git-conventions.md#12-selections-are-fetched-not-assumed)).
What follows are the rules that hold whatever the vocabulary is.

- **Exactly one type label per issue.** The type answers "what kind of work is
  this" — the same question the title's conventional prefix answers, so the two
  agree or one of them is wrong. Where org-level **issue types** are available,
  prefer them: GitHub cannot enforce "exactly one label", but it does enforce
  one type.
- **Prefixed labels (`phase:concept`) are convention, not constraint.** GitHub
  has no scoped labels, so nothing stops two values of the same prefix being
  applied at once. Treat a double as a filing error to fix, and do not build
  automation that assumes exclusivity.
- **Never invent a label to fit an issue.** If nothing in the repo's set fits,
  that is a gap in the set — say so and let the developer decide whether to add
  one.

Labels are **per repo** on GitHub. A group-wide vocabulary has to be replicated
into each repo and kept in step deliberately — there is no inheritance.

### 2.5 Milestone

**Every issue carries exactly one, no exceptions** — that is the araCreate rule.
The set of milestones to choose from is the repo's, not this document's: fetch
the open milestones and have the developer pick.

Two conventions shape most of those sets, and are worth adopting where a client
has no scheme of their own:

- A **time-boxed milestone** for planned work — a quarter (`2026-Q3`), a sprint,
  or a release, whichever the client plans in.
- A **catch-all** for work that is real but unscheduled, so nothing sits without
  a milestone waiting to be forgotten. `BACKLOG` is the usual name.

GitHub milestones are **repo-scoped**, with no org-level equivalent. A quarter
that should read across several repos has to be created in each of them under
exactly the same name, or tracked in a GitHub **Project** instead — pick one and
say which in the repo's README.

### 2.6 Status and assignee

Where the repo is on a GitHub **Project**, its Status field tracks reality, not
intent: `todo` → `in progress` → `in review`. Move it when the state actually
changes — a board that lags is a board nobody trusts. The PR merging is what
closes the issue ([§3.3](#33-description)); there is no manual `done` step.

Set the assignee at creation when the owner is already known — an issue filed
from a discussion you are driving is yours. Leave it unassigned only when it
genuinely goes to triage; an unassigned issue in the current milestone is a
planning gap worth seeing.

### 2.7 Comments and threads

**GitHub issue comments are a flat list.** There are no discussions to reply
inside, so the "one topic per thread" discipline that works on GitLab does not
transfer. Consequences:

- **A long collection issue turns into an unreadable log.** Prefer separate
  issues, or GitHub **Discussions** where the repo has them enabled, over one
  issue accumulating unrelated topics.
- **When a comment turns into work**, open an issue in the owning repo and reply
  with a single line: `Tracked at <URL>`. No scope recap — the issue carries the
  detail ([ground rule 1.5](git-conventions.md#15-one-record-per-fact)).
- **Never tick someone else's checkbox.** The link is the record.

**PR review comments *are* threaded.** Reply inside the review thread rather
than as a new PR comment, and resolve a thread when the question it asked is
answered, not when the reply is posted.

## 3 Pull requests

### 3.1 Branch

Create the branch **from the issue** so the link is automatic — the *Create a
branch* link in the issue's Development panel, or `gh issue develop`
([§7](#7-gh)). That gives `<number>-<slugified-title>`
([git-conventions §2.2](git-conventions.md#22-branch-naming)):

```
136-feat-derive-ble-device-name-from-chip-uid
```

A branch created by hand off `develop` gets the same name but not the same
provenance, and the issue then shows no linked branch.

### 3.2 Title and draft state

Same conventional prefix as the commit that will land:

```
feat: derive BLE device name from chip uid
```

- The developer approves the wording as for an issue ([§2.2](#22-title)).
  GitHub pre-fills the title from the first commit — treat that as a draft, not
  a decision.
- **Open every PR with `--draft`.** Unlike GitLab's title prefix this is a
  creation-time flag, and a PR converted back to draft loses its approvals — so
  get it right at creation. Mark ready only when it genuinely is
  ([git-conventions §5.1](git-conventions.md#51-before-requesting-review)).
- **Retitle when the scope grows.** A PR keeps the branch name it was born with,
  so the title is the only place a reviewer scanning the PR list sees what is
  actually inside. If the second change does not belong under the first title,
  that is a signal to split it out rather than rename.

### 3.3 Description

```markdown
Closes #<number>

## Why
The problem, in the reviewer's terms. Link the issue and any related PR.

## What
The change, grouped by concern. `feat` / `fix` subheadings when a PR carries more than one.

## How
The reasoning a reviewer cannot get from the diff — why this approach, what constraint forced it.

## Test
What was actually run, and the observed result. Drop the section for changes with nothing to observe.

## Open
Anything unresolved or deferred. Drop the section when there is nothing.
```

`Closes #<number>` on the first line so the issue closes on merge — this is
where the closing reference lives, not in the commits
([git-conventions §3.2](git-conventions.md#32-reference-trailer)). When a PR
closes more than one issue, list each on its own `Closes` line and say in **Why**
why they land together.

**Caveat specific to GitFlow on GitHub:** a closing keyword only fires when the
PR merges into the repo's **default** branch. If `main` is the default and PRs
target `develop`, `Closes #136` will not close the issue at merge time — set the
default branch to `develop` ([§5](#5-repo-setup)), or close the issue explicitly
as step 13 of the workflow. Decide which, and say so in the repo's README.

**Test** carries the evidence, not the intent — "verified on a bench unit"
proves nothing on its own. A before/after table of observed values, the log line
that settles it, or a screenshot for anything visual is what lets a reviewer
trust a behavioural claim without repeating the work. Say which build it was
measured on.

**Open** is the only record of anything found and deliberately not fixed. Once
the PR merges it is closed and nobody reads it again, so a defect parked there
is a defect nobody tracks — file it as its own issue and link it instead.

Mirror the issue's label and milestone onto the PR, and keep the description
current as the PR changes. A description written against the first commit and
never revisited misleads more than an empty one.

## 4 Review and merge

The principles are in
[git-conventions §5](git-conventions.md#5-review) — readiness, the comment
prefixes, one peer minimum, the author never approving. GitHub's mechanics for
them:

- **Draft state** is the readiness signal. GitHub blocks merge while a PR is a
  draft, which is why it goes on at creation ([§3.2](#32-title-and-draft-state)).
- **Review states**: *Approve*, *Comment*, *Request changes*. Use **Request
  changes** only for something that genuinely blocks — it locks the PR until
  that reviewer returns, so it is the wrong tool for a `nit:`. Everything
  optional goes as *Comment*.
- **`CODEOWNERS`** routes review automatically where the repo has owners
  defined; it is GitHub's equivalent of approval rules.
- **Merge with checks green**, head branch deleted, and using a **merge commit**
  — never *Squash and merge*
  ([git-conventions §4](git-conventions.md#4-merging)).
- **A new push dismisses stale approvals** where that rule is enabled, which is
  the intended behaviour: an approval covers the diff it was given for.

## 5 Repo setup

What a GitHub repo needs in place so the conventions above are enforced by the
tool rather than by memory.

**Templates**, committed to the repo:

```
.github/
├── ISSUE_TEMPLATE/
│   ├── default.md              # §2.3 shape
│   └── config.yml              # disable blank issues
├── pull_request_template.md    # §3.3 shape
└── CODEOWNERS                  # review routing
```

**Labels and milestones** — each repo defines its own set, following the rules
in [§2.4](#24-labels) and [§2.5](#25-milestone), and **documents it in the
repo's own README**. Both are repo-scoped with no inheritance, so a shared
vocabulary is replicated deliberately. This is the one part of the setup left
unspecified: it is the client's and the project's to decide.

**Merge settings**:

| Setting | Value | Why |
| --- | --- | --- |
| Allow squash merging | **Off** | [git-conventions §4](git-conventions.md#4-merging) |
| Allow rebase merging | Off | Rewrites the commits that were reviewed |
| Allow merge commits | On | The only method that preserves each message |
| Automatically delete head branches | On | The PR keeps the history |
| Default branch | `develop` | GitFlow, and it is what makes `Closes #N` fire ([§3.3](#33-description)) |

**Rulesets** on `main` and `develop`: no direct pushes, no force-pushes, PR
required, at least 1 approval, required status checks, and dismiss stale
approvals on push.

## 6 Quick reference

| | Issue | Pull request |
| --- | --- | --- |
| Title | `feat: <lowercase imperative>`, no articles, developer approves the wording | same |
| Body | the ask as filed · what is still needed — no guessed scope | Closes #N · Why / What / How / Test / Open |
| Label | exactly one type label — **values from the repo, chosen by the developer**; prefer issue types where available | mirror the issue |
| Milestone | exactly one, always — **values from the repo, chosen by the developer** | mirror the issue |
| Status | Project field: `todo` → `in progress` → `in review` | draft → ready → approved → merged |
| Links | full URLs across repos | `Closes #N` on the first line |
| Order | exists before the branch — its number names it | branch, then first commit, then draft PR |
| Scope | split into sub-issues, not a checklist | one concern; split rather than rename |
| Merge | closed by the PR, if `develop` is default | merge commit · reviewer approves · developer merges |

Everything about branches, commits and merges is in
[git-conventions §6](git-conventions.md#6-quick-reference).

## 7 gh

Use the authenticated `gh` CLI. Draft descriptions and comments **to a file**
and review them before they are sent
([ground rule 1.1](git-conventions.md#11-nothing-is-published-without-an-explicit-instruction))
— every recipe below reads its body from one.

### Read the repo's options first

Always, before drafting anything.

```sh
gh label list --repo <owner>/<repo>
gh api "repos/<owner>/<repo>/milestones?state=open"
gh api "repos/<owner>/<repo>/collaborators"
```

Milestone numbers, not names, are what the API takes — read the `number` field
from the listing.

### Create an issue

With the title, label and milestone the developer confirmed — the values below
are placeholders, not defaults:

```sh
gh issue create --repo <owner>/<repo> \
  --title "<type>: <confirmed summary>" \
  --label <confirmed label> --milestone "<confirmed milestone>" \
  --assignee <user> \
  --body-file body.md
```

As a sub-issue of an existing parent, and with an issue type where the org has
them:

```sh
gh issue create --repo <owner>/<repo> \
  --title "<type>: <confirmed summary>" \
  --parent <parent number> --type "<issue type>" \
  --body-file body.md
```

### Create the branch from the issue

```sh
gh issue develop <number> --repo <owner>/<repo> --base develop --checkout
```

This is what links branch to issue. Push the first commit before opening the PR
— GitHub will not open one on an empty branch.

### Open the PR as a draft

```sh
gh pr create --draft \
  --base develop --head <number>-<slug> \
  --title "<type>: <confirmed summary>" \
  --assignee <user> --label <confirmed label> --milestone "<confirmed milestone>" \
  --body-file body.md
```

Mark it ready only when it is ([§4](#4-review-and-merge)):

```sh
gh pr ready <number>
```

### Update a description after the fact

```sh
gh pr edit <number> --body-file body.md
```

### Reply inside a PR review thread

Not as a new PR comment ([§2.7](#27-comments-and-threads)):

```sh
gh api --method POST \
  "repos/<owner>/<repo>/pulls/<number>/comments/<comment id>/replies" \
  -f body="$(cat reply.md)"
```

List the review comments to find the id with
`gh api "repos/<owner>/<repo>/pulls/<number>/comments"`. Issue comments are flat
and take a plain `POST` to `repos/<owner>/<repo>/issues/<number>/comments`.

### Merge

Never `--squash` ([git-conventions §4](git-conventions.md#4-merging)):

```sh
gh pr merge <number> --merge --delete-branch
```
