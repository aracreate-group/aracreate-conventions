# GitLab Conventions

**What this is.** How work is tracked and reviewed on GitLab: work items, merge
requests, and the process joining them. It covers only what is specific to
GitLab.

**Why it exists.** The tracker is only useful if its state can be trusted — if a
label means one thing, a milestone is always set, and an item's status matches
reality. That is what lets planning happen from the board rather than from
memory, and it only holds if everyone files work the same way.

**How it fits.** Read this together with:

| Document | Covers |
| --- | --- |
| [repo](../repo/readme.md) | What a repo *contains* — structure, headers, naming, versioning |
| [git-conventions](git-conventions.md) | What a commit message looks like |
| **This document** | How work is tracked and reviewed on GitLab |

Nothing in [git-conventions](git-conventions.md) is repeated here. In particular
the commit format applies unchanged on GitLab.

## Terminology

Where GitLab's UI uses a word, GitLab's word wins — these are not new names.

| Term | Meaning |
| --- | --- |
| **Work item** | GitLab's umbrella for tracked work. Two types are in use: **Issue** and **Task** ([§2.1](#21-type-and-ownership)). "Item" alone always means a work item. |
| **iid** | The per-project reference number a work item or MR carries — the `136` in `#136`. Unique within a project, not across projects. |
| **MR** | Merge request. |
| **Thread** | A root comment plus its replies — a GitLab *discussion*, not a loose comment. |

Three roles appear throughout:

| Role | Meaning |
| --- | --- |
| **Developer** | The person who writes the change. In review they are the **author**. |
| **Reviewer** | The peer who approves. Never the author. |
| **Assistant** | Whatever automation drafts, files or commits on the developer's behalf. Every step it takes is proposed and confirmed, never assumed. |

## Mentions

`@handle` notifies. Use it where somebody is being asked for something, and at
most once per person in any one description, comment or note. Everywhere else,
a plain first name: `Martin:`, `Leo:`, `Ara:`.

Tagging the same person in every bullet notifies them on every edit and reads as
though each line were addressed to them. So in a work item the handles live in
[§2.3](#23-description)'s `ACTIONS` and nowhere else; in a meeting note they live
in the attendee line ([§2.8](#28-meeting-notes)); in a merge request they belong
wherever somebody is being asked to look at something.

**Never rewrite a handle inside quoted text.** A quote is reproduced as written,
including the mentions its author chose.

## Contents

| Part | Covers |
| --- | --- |
| [1 Workflow](#1-workflow) | The path from a request to a merged change |
| [2 Work items](#2-work-items) | Type · title · description · labels · milestone · status · threads · meeting notes |
| [3 Merge requests](#3-merge-requests) | Branch · title · description · draft state |
| [4 Review and merge](#4-review-and-merge) | GitLab's mechanics for approval and merge |
| [5 Project setup](#5-project-setup) | Labels, milestones and merge settings a repo needs |
| [6 Quick reference](#6-quick-reference) | The rules in one table |
| [7 glab](#7-glab) | Command-line recipes |

## 1 Workflow

The path a change takes on GitLab, and who does what.

| # | Actor | Step |
| --- | --- | --- |
| 1 | client / developer | The need surfaces as a comment on an existing item, a call, a chat, a document — or the developer hits a defect directly and investigates it. |
| 2 | developer | Capture the origin: the permalink to that comment, or the finding itself when there is no thread to point at. |
| 3 | assistant | Fetch the target project's labels, milestones and members, then propose the title, the description, and each field with a suggested value. |
| 4 | developer | Confirm or correct the title and every selection. |
| 5 | assistant | File the work item as confirmed, quoting the ask and linking the origin by full URL. Reply in the originating thread with one line: `Tracked at <URL>`. |
| 6 | assistant | Open the MR against `develop`, letting GitLab create the source branch, and mark it `Draft:`. Same confirmation as step 4 for its title and fields. |
| 7 | developer | Check the branch out locally and put the work on it — new edits, or changes lifted from a stash. |
| 8 | assistant | Commit and push. The commits attach themselves to the MR opened in step 6. |
| 9 | assistant | Fill in the MR description to the shape in [§3.3](#33-description), including **Test** and **Open**. |
| 10 | developer | Self-review, wait for a green pipeline, clear `Draft:`, request review. |
| 11 | reviewer | Review and approve ([§4](#4-review-and-merge)). |
| 12 | developer | Merge. |
| 13 | assistant | Close the work item and reply wherever it was tracked that it is resolved. |
| 14 | assistant | Leave the clone clean: `git switch <default> && git pull`, then delete the merged local branch. |

What makes the order matter:

- **The work item comes first**, because its iid is part of the branch name. There is no
  correct branch name until the item exists.
- **The MR comes before the code.** It is opened on an empty branch and the
  commits arrive afterwards. This is exactly what the *Create merge request*
  button on a work item does; it is not a workaround. It also means the MR is
  the working record from the first line of code, not a wrapper added at the
  end. GitLab allows this where GitHub does not.
- **`Draft:` from creation** (step 6), not once the code lands. An MR that is
  briefly non-draft is an MR that can be merged before anyone has looked at it.
- **Nothing is filed before it is confirmed.** Step 3 is a proposal and step 4 is
  the decision — they are separate rows because the assistant reads the
  project's options but the developer chooses among them.
- **The author does not approve, and the assistant does not merge.** Steps 8, 11
  and 12 are deliberately different actors.
- **The clone goes back to the default branch when the MR closes.** A merged MR
  leaves a local branch tracking a remote that GitLab has deleted, so the next
  session starts on a dead branch and its first commit lands somewhere nobody is
  watching. `git switch <default> && git pull`, then `git branch -d` the merged
  branch, so the working copy matches what was merged.
- **The plan leads with numbered steps, context after.** When an assistant
  drafts an implementation plan before writing code, it opens with a numbered
  **Steps** list covering the whole piece of work end to end, filing or
  updating the item, opening the MR, the code change, verification, so the
  developer can refer back to a step by number once it's shown. **Context**
  (the why, the background) follows, not before.

## 2 Work items

### 2.1 Type and ownership

| Type | Use for |
| --- | --- |
| **Issue** | A standalone piece of work, a discussion, or a collection that spawns children. |
| **Task** | A child of an issue. Never on its own — a task always has a parent. |

Those two are the whole hierarchy inside a project: an **Issue accepts only Task
children**, and only an **Epic** accepts Issue children. So two items already filed
as issues cannot be nested under a third without converting them into tasks, which
rewrites what the reporter filed. When they belong together, leave them as they are
and let one MR close both, with a `Closes` line each
([§3.3](#33-description)) and a related link between them.

Break a large issue into child tasks rather than a checklist in the description,
so each piece carries its own assignee, milestone and MR. A checklist item
cannot be scheduled, assigned or merged; a task can.

File the item in the repo that owns the **code**, not the repo where it was
noticed. Bench-tooling work goes to the tooling repo even when it surfaced in a
firmware thread.

Where one item genuinely waits on another, record it with GitLab's **linked
items** (`blocks` / `is blocked by`) rather than a sentence in the description.
The link shows up on the board; the sentence does not.

### 2.2 Title

Conventional-commit prefix, then a lowercase imperative summary — the same shape
as the commit that will land
([git-conventions §1](git-conventions.md#1-format)):

```
feat: import hand-edited test profile at runtime from bench tool
fix: shutdown command over ble fails
docs: provide CAN bit timing details
build: update makefiles to build in fresh development environment
```

- No articles ([git-conventions §3](git-conventions.md#3-wording)).
- Prefix with `[wip]` when the item is an open collection still being filled,
  rather than a defined piece of work.
- Do not encode the type in the title (`Discussion: …`) — that is the
  `discussion` label's job ([§2.4](#24-labels)).
- Keep it a summary, not a sentence. If the title needs a comma to stay
  accurate, the item is probably two items.
- **The developer approves the wording before the item is filed.** An assistant
  drafting a title is proposing one.

### 2.3 Description

A work item captures **what is known when it is filed** — the ask, and what is
still missing to act on it. Nothing more. Two shapes cover it.

**A follow-up or direct ask**:

```markdown
Follow-up from [<repo>#<iid> (comment)](<full url>) — @author:

> <the ask, quoted as written>

One or two lines of what that means, if the quote does not stand alone.

## Needed from @<person>
- Logs, conditions, or the decision still outstanding.

Scope will be defined once the above is available.
```

**A defect** — what the reporter had, not a diagnosis:

```markdown
### Summary
### Steps to reproduce
### Build / environment
### Current behaviour
### Expected behaviour
### Logs or screenshots
```

- Quote the ask **as written** in the follow-up shape. A paraphrase loses the
  detail that turns out to matter, and the quote is the one part nobody can
  reconstruct later.
- Do **not** write scope, design, or acceptance criteria from reading the code at
  filing time, in either shape. Investigation belongs in development and its
  output belongs in the MR description — an item padded with a guessed plan
  reads as decided when it is not, and goes stale the moment development
  starts.
- Where a decision has already been taken in the thread, record the decision and
  who took it. That is history, not a plan.
- For a defect, give what the reporter had: what was observed, on which build,
  under what conditions — not a guessed cause. Add `confirmed` once it is
  reproduced ([§2.4](#24-labels)).
- Sections that would be empty are dropped, not left as headings.

### 2.4 Labels

**There is no araCreate label set.** Each project — or each client group —
defines its own, and it evolves with the project. Read the project's labels from
the project ([§7](#7-glab)) and have the developer choose from them.
What follows are the rules that hold whatever the vocabulary is.

- **Exactly one type label per item.** The type answers "what kind of work is
  this" — the same question the title's conventional prefix answers, so the two
  agree or one of them is wrong.
- **Scoped labels (`key::value`) are mutually exclusive within their key**, so
  an item sits in exactly one value per scope. Use them for anything an item can
  only be one of at a time. This is a GitLab feature with no GitHub equivalent.
- **Unscoped labels are flags**, and an item may carry any number of them,
  including none.
- **Never invent a label to fit an item.** If nothing in the project's set fits,
  that is a gap in the set — say so and let the developer decide whether to add
  one.

A project documents its own set in its own README. One project's set, purely to
show the shape:

| Label | Kind | Meaning in that project |
| --- | --- | --- |
| `feat` `fix` `enhancement` `documentation` `discussion` `suggestion` `support` | type | Exactly one, matching the title prefix |
| `phase::concept` · `phase::implementation` · `phase::verification` | scoped | Where the item sits in its lifecycle |
| `level::workpackage` | scoped | A defined workpackage with functional deliverables |
| `fw::v2` | scoped | Targets the v2 firmware line |
| `confirmed` | flag | A reported defect that has been reproduced |
| `critical` | flag | Blocks a milestone or the bench |

Do not copy that table into another project and do not assume it is current for
the project it came from. It illustrates the rules; the project is the source of
truth.

### 2.5 Milestone

**Every item carries exactly one, no exceptions** — that is the araCreate rule.
The set of milestones to choose from is the project's or the group's, not this
document's: fetch the open milestones and have the developer pick.

Two conventions shape most of those sets, and are worth adopting where a client
has no scheme of their own:

- A **time-boxed milestone** for planned work — a quarter (`2026-Q3`), a sprint,
  or a release, whichever the client plans in.
- A **catch-all** for work that is real but unscheduled, so nothing sits without
  a milestone waiting to be forgotten. `BACKLOG` is the usual name.

Where milestones are defined at group level they are shared by every project in
the group, so a period reads across the whole group rather than per repo. Where
they are per project, they do not — check which before assuming a name resolves.

### 2.6 Status and assignee

Status tracks reality, not intent: `planning` → `in-progress` → `review`. A new
item is `planning`, which is what GitLab sets on creation. It has been filed,
not started, and nothing is promised about when it starts. It moves to
`in-progress` only when the developer says work on it is starting, and to
`review` when its MR goes up for review. Move it when the state actually
changes — a board that lags is a board nobody trusts. The MR merging is what
closes the item ([§3.3](#33-description)); there is no manual `done` step.

Set the assignee at creation when the owner is already known — an item filed
from a discussion you are driving is yours. Leave it unassigned only when it
genuinely goes to triage; an unassigned item in the current milestone is a
planning gap worth seeing.

### 2.7 Threads

Long-running collection issues (bench findings, review notes) accumulate one
comment thread per topic. Rules for those:

- **One topic per thread.** A new topic is a new root comment.
- **Reply inside the discussion** (`/discussions/<id>/notes`), not as a new root
  comment, so the context stays attached ([§7](#7-glab)).
- **When a thread turns into work**, open a work item in the owning repo and
  reply in that thread with a single line: `Tracked at <URL>`. No scope recap —
  the item carries the detail.
- **Never tick someone else's checkbox.** The link is the record.
- **Resolve a thread when the question it asked is answered**, not when the
  reply is posted. An unresolved thread is an open question.

### 2.8 Meeting notes

A call reaches the tracker only if someone writes it down. After a call, its
transcript, from whichever notetaker was used, is turned into notes on the items
it touched.

- **One note per item.** A call touching several topics produces one note per
  topic, each on the item or MR that owns it, not one summary parked in one
  place. Post it on the MR when the topic is that MR's work, otherwise on the
  item.
- **Record what was said, nothing else.** No diagnosis, no proposed fix, no code
  findings, no next steps nobody agreed to. Analysis done afterwards by reading
  the code is separate work and is posted separately, if at all. A note that
  mixes the two leaves nobody able to tell what the team actually agreed.
- **Attribute every line, in one form**: `Name: what they said`. Questions
  included.
- **The transcript's speaker label is not proof of who spoke.** People sharing a
  room share a microphone, and the transcript credits the whole room to one
  name. Attribute by who owns the subject, and ask when it is not clear.
- **Shape**: an opening line
  `**Meeting note, <YYYY-MM-DD> (<meeting>: @handles)**`, then bold section
  headings with flat bullets under each. Sections follow the call, not a
  template.
- **Decisions belong on the item they affect**, including the ones that only
  park it. That is history, the same rule as [§2.3](#23-description).
- **A note is not a work item.** Where the call created work, file the item and
  reply with the tracked line ([§2.7](#27-threads)). When the note covered
  several topics, say which one was filed rather than leaving a bare
  `Tracked at <URL>`.
- Each note is proposed and confirmed before it is posted, like anything else
  the assistant files ([§1](#1-workflow)).

## 3 Merge requests

### 3.1 Branch

Create the branch **from the work item** so the link is automatic. That gives
`<iid>-<slugified-title>`:

```
136-feat-derive-ble-device-name-from-chip-uid
```

Let GitLab create the branch as part of opening the MR — either the button on
the work item, or `--create-source-branch` ([§7](#7-glab)). A branch created by
hand off `develop` and pushed separately gets the same name but not the same
provenance, and the MR then has to be attached to it after the fact.

**The source branch is fixed for the life of the MR.** GitLab can retarget an MR
but never re-point it at a different source branch, and with squash off the branch
name is written into the merge commit permanently — `Merge branch 'test' into
'dev'` is forever. So never open an MR from a scratch branch meaning to rename it
later: close it and open a new one from the item.

### 3.2 Title and draft state

Same conventional prefix as the commit that will land:

```
feat: derive BLE device name from chip uid
```

- Replace GitLab's auto-generated `Resolve "…"` title, with the developer
  approving the wording as for a work item ([§2.2](#22-title)).
- **Open every MR as `Draft:`**, at creation, before the first commit lands on
  it. Clear the prefix only when it is genuinely ready for review.
- **Retitle when the scope grows.** An MR keeps the branch name it was born
  with, so the title is the only place a reviewer scanning the MR list sees what
  is actually inside. If the second change does not belong under the first
  title, that is a signal to split it out rather than rename.

### 3.3 Description

```markdown
Closes #<iid>

## Why
The problem, in the reviewer's terms. Link the work item and any related MR.

## What
The change, grouped by concern. `feat` / `fix` subheadings when an MR carries more than one.

## How
The reasoning a reviewer cannot get from the diff — why this approach, what constraint forced it.

## Test
What was actually run, and the observed result. Drop the section for changes with nothing to observe.

## Open
Anything unresolved or deferred. Drop the section when there is nothing.
```

`Closes #<iid>` on the first line so the item closes on merge — this is where
the closing reference lives, not in the commits
([git-conventions §2](git-conventions.md#2-reference-trailer)). When an MR
closes more than one item, list each on its own `Closes` line and say in **Why**
why they land together.

**Why** and **How** carry the reasoning a diff cannot: "fixed the bug" or
"updated the config" tells a future reader nothing they did not already have
from the diff. Say what the problem was, why this is the right approach, and
flag any known shortcoming in **How** rather than leaving it to be found later.

**Test** carries the evidence, not the intent: "verified it works" proves
nothing on its own. A before/after table of observed values, the log line
that settles it, or a screenshot for anything visual is what lets a reviewer
trust a behavioural claim without repeating the work. Say which build it was
measured on. Where testing spans more than one environment, list each tier's
result separately rather than folding them into one line, since a reviewer
needs to know which claim came from which.

**Open** is the only record of anything found and deliberately not fixed. Once
the MR merges it is closed and nobody reads it again, so a defect parked there
is a defect nobody tracks — file it as its own work item and link it instead.

Mirror the work item's label and milestone onto the MR, and keep the description
current as the MR changes. A description written against the first commit and
never revisited misleads more than an empty one.

## 4 Review and merge

One peer review before merge, and the author never approves their own change.
GitLab's mechanics for that:

- **`Draft:` in the title** is the readiness signal. GitLab blocks merge while
  it is there, which is why it goes on at creation.
- **Approval** is the *Approve* button, from someone who is not the author.
  Where the project uses approval rules, they decide who that has to be.
- **Threads must be resolved** before merge — that is a project setting
  ([§5](#5-project-setup)), and it is what stops a review comment being lost in
  a long MR.
- **Merge with the pipeline green**, source branch deleted, no squash.
- The work item closes via `Closes #<iid>`. Reply wherever the work was tracked
  that it is resolved ([§2.7](#27-threads)).

## 5 Project setup

What a GitLab repo needs in place so the conventions above are enforced by the
tool rather than by memory.

**Description shapes** are not committed to the repo. GitLab's own description
templates would need a `.gitlab/` directory in every project, which is a copy of
this document that drifts from it; the shapes in [§2.3](#23-description) and
[§3.3](#33-description) are the source of truth, and descriptions are drafted
from them ([§1](#1-workflow)).

**Labels and milestones** — each project defines its own set, following the
rules in [§2.4](#24-labels) and [§2.5](#25-milestone), and **documents it in the
project's own README**. Define them at group level where a client group shares a
vocabulary across repos, per project where it does not. This is the one part of
the setup deliberately left unspecified: it is the client's and the project's to
decide, and everything downstream reads it from the project rather than from
here.

**Merge request settings**:

| Setting | Value | Why |
| --- | --- | --- |
| Squash commits | *Do not allow* | Every commit keeps its own conventional message |
| Delete source branch | Enabled by default | The MR keeps the history |
| Pipelines must succeed | Required | A red pipeline wastes the reviewer's turn |
| All threads resolved | Required | [§4](#4-review-and-merge) |
| Approvals required | At least 1 | The author does not approve their own change |
| Default target branch | `develop` | GitFlow |

**Protected branches** — `main` and `develop` protected; no direct pushes, no
force-pushes.

## 6 Quick reference

| | Work item | Merge request |
| --- | --- | --- |
| Title | `feat: <lowercase imperative>`, no articles, developer approves the wording | same, `Draft:` from creation until ready |
| Body | the ask as filed · what is still needed — no guessed scope | Closes #N · Why / What / How / Test / Open |
| Label | exactly one type label, plus scoped — **values from the project, chosen by the developer** | mirror the work item |
| Milestone | exactly one, always — **values from the project, chosen by the developer** | mirror the work item |
| Status | `planning` → `in-progress` → `review` | `Draft:` → ready → approved → merged |
| Links | full URLs across projects | `Closes #N` on the first line |
| Order | exists before the branch — its iid names it | opened before the code, on an empty branch |
| Branch | Issue takes Task children only; Epic takes Issues | source branch is permanent — reopen, never rename |
| Scope | split into child tasks, not a checklist | one concern; split rather than rename |
| Merge | closed by the MR | no squash · reviewer approves · developer merges |

Commit message rules are in
[git-conventions §6](git-conventions.md#6-quick-reference).

## 7 glab

When the GitLab MCP server is unavailable, use the authenticated `glab` CLI.
Group settings can block MCP access in ways that surface as an opaque error, so
treat `glab` as the dependable path rather than something to fall back to after
debugging.

Draft descriptions and comments **to a file** and review them before they are
sent ([git-conventions §5](git-conventions.md#5-publishing))
— every recipe below reads its body from one.

### Read the project's options first

Always, before drafting anything. `<path>` is the URL-encoded project path —
`group%2Fproject`.

```sh
# Labels defined on the project, including those inherited from the group
glab label list --repo <group>/<project>

# Open milestones — project-level, then group-level
glab api "projects/<path>/milestones?state=active"
glab api "groups/<group>/milestones?state=active"

# Members who can be assigned
glab api "projects/<path>/members/all"
```

Milestones are the common trap: a project may inherit them from the group,
define its own, or both, and a name that resolves in one project does not
necessarily resolve in its neighbour. Take the `id` from the listing rather than
relying on the name.

### Create a work item

With the title, label and milestone the developer confirmed — the values below
are placeholders, not defaults:

```sh
glab issue create --repo <group>/<project> \
  --title "<type>: <confirmed summary>" \
  --label <confirmed label> --milestone "<confirmed milestone>" --no-editor \
  --description "$(cat body.md)"
```

Group milestones are sometimes rejected by name at creation; set them after,
using the `id` from the listing above:

```sh
glab api --method PUT projects/<id>/issues/<iid> -f milestone_id=<milestone id>
```

### Open the MR and its branch

One step creates both, then a second marks it draft — `mr create` has no
`--draft` that survives an explicit `--title`:

```sh
glab mr create \
  --source-branch <iid>-<slug> --target-branch develop --create-source-branch \
  --title "<type>: <confirmed summary>" \
  --assignee <user> --label <confirmed label> --milestone "<confirmed milestone>" \
  --remove-source-branch --no-editor --yes \
  --description "$(cat body.md)"

glab mr update <mr iid> --draft
```

The MR is created before any commit exists on the branch — the same thing the
button on the work item does ([§1](#1-workflow)), and the commits attach to it
as they are pushed.

### Update a description after the fact

```sh
glab mr update <mr iid> --description "$(cat body.md)"
```

Three ways this bites when scripting from outside the repo:

- **The `:id` placeholder is expanded from the working directory's git remote**, so
  `projects/:id/...` fails with `git: exit status 128` anywhere else. Pass the
  numeric project id when running from a scratch directory.
- **The API needs the content type spelled out** or GitLab answers 415:

  ```sh
  glab api --method PUT "projects/<id>/merge_requests/<iid>" \
    --input body.json -H "Content-Type: application/json"
  ```

- **`-f "description=@file"` does not read the file.** It stores the literal string
  `@/path/to/file` as the description and reports success. Only `--input` and
  `--form` take a file.

### Attach an image to a description

Upload the file first, then paste the returned path into `body.md` before
sending the description. `--field` will not do a file upload, it silently
400s; use `--form` for the multipart request:

```sh
glab api --method POST "projects/<path>/uploads" --form "file=@<path-to-image>"
# -> {"markdown": "![alt](/uploads/<hash>/<file>)", ...}
```

Leave a full **blank line** between any label above the image (`Before:`,
`After:`) and the `![...](...)` line, since a bare newline still renders the
two inline in the same paragraph.

**Paste the returned path exactly, relative.** `/uploads/<hash>/<file>` is what
GitLab resolves against the project. An absolute
`https://gitlab.com/<group>/<project>/uploads/...` is not a path GitLab serves and
renders as a broken image; the real absolute form carries a `/-/project/<id>/`
segment, so there is no reason to build one by hand.

**Verify by asking GitLab to render it**, not with curl:

```sh
glab api "projects/<path>/merge_requests/<iid>?render_html=true"
# -> description_html; count the <img src= entries
```

A `curl` of an upload URL proves nothing: GitLab 302s to object storage and that
hop wants a session cookie, so a `PRIVATE-TOKEN` request ends in 403 whether the
link is right or wrong. A 302 is not evidence the image works.

### Reply inside an existing thread

Not as a new root comment ([§2.7](#27-threads)):

```sh
glab api --method POST \
  "projects/<url-encoded path>/issues/<iid>/discussions/<discussion id>/notes" \
  -f body="Tracked at <url>"
```

Find the discussion id with
`glab api "projects/<path>/issues/<iid>/discussions"` and match on the note id
from the comment's permalink (`#note_<id>`).

### Post a meeting note

Draft each note to its own file ([§2.8](#28-meeting-notes)), then post it to the
item or the MR:

```sh
glab api --method POST "projects/<path>/issues/<iid>/notes" --field body=@note-<iid>.md
glab api --method POST "projects/<path>/merge_requests/<iid>/notes" --field body=@note-mr<iid>.md
```

Read it back afterwards, same as a description.

### Work items through the issues API

`glab work-item` does not exist (there is an experimental `glab work-items` group).
A work item at `/-/work_items/<iid>` is reachable as an issue:

```sh
glab issue view <iid> --repo <group>/<project>
glab api "projects/<id>/issues/<iid>"
glab api "projects/<id>/issues/<iid>/discussions"
```

A work item description is edited the same way, through the issues path:

```sh
python3 -c "import json; print(json.dumps({'description': open('body.md').read()}))" >| body.json
glab api --method PUT "projects/<path>/issues/<iid>" \
  --input body.json -H "Content-Type: application/json"
```

Two things bite here that do not when the body is a short `-f` string:

- **`description` replaces the whole field.** Read the current one to a file
  first, edit that, and send it back — there is no partial update, and nothing
  warns that a section went missing.
- **Write `body.json` with `>|`, not `>`.** Under zsh `noclobber` a rewrite of an
  existing file aborts the whole `&&` chain, so the `glab api` call never runs
  while the previous description reads back unchanged, which looks like a
  silently rejected update.

**Status is not an issue field.** Where a group defines custom statuses
(`WorkItems::Statuses::Custom`), status lives on the work-item GraphQL type and the
available fields differ by GitLab version — `allowedStatuses` is absent on some.
Read the current status over GraphQL before trying to set one, or set it in the UI.

### Find every reference before a rename

Renaming a project leaves its old path in other repos' docs and in item text. GitLab
redirects keep them working, so nothing fails loudly:

```sh
glab api "groups/<group>/search?scope=issues&search=<old-name>"
glab api "groups/<group>/search?scope=merge_requests&search=<old-name>"
```

Search sibling working copies too: committed generated output (Sphinx HTML, search
indexes) carries the old name, where a docs rebuild rather than an edit is the fix.

### Read a description back after posting it

`glab mr update --description` reports success without showing what landed. Read it
back and check the shape survived: `Closes #N` on the first line, the section
headings, and the image count.

