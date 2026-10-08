# Claude Code Conventions

How a Claude Code session, in the VS Code extension or the terminal, is run:
the phrases that end a session and what each does, how replies and questions
are shaped, and the habits every session keeps. It does not cover claude.ai
chats or scheduled cloud agents. It builds on
[repo §5](../repo/readme.md#5-logs) for logs and
[git §5](../git/git-conventions.md#5-publishing) for committing.

Every session starts from this document. Where a project's memory or files
disagree with it, this document wins (§6).

## Contents

| Part | Covers |
| --- | --- |
| [1 Ending a session](#1-ending-a-session) | "stop this session" and "close this session" |
| [2 The todo list](#2-the-todo-list) | `wip/todo.md`, its headings and items |
| [3 Replies](#3-replies) | Numbering, spacing, proposals, plans, reports |
| [4 Questions](#4-questions) | The AskUserQuestion dialog |
| [5 Links and files](#5-links-and-files) | URLs and paths printed to open |
| [6 Asking before acting](#6-asking-before-acting) | What is a go and what is not |
| [7 Changes to live system state](#7-changes-to-live-system-state) | Rehearsing in a throwaway HOME |
| [8 Working with files](#8-working-with-files) | Large files, `wip/`, `.tmp/`, operational docs |
| [9 Evidence](#9-evidence) | Run logs, chat conclusions |
| [10 Shell and harness](#10-shell-and-harness) | zsh `noclobber`, arrays, globbing, attribution |
| [11 Repeated actions](#11-repeated-actions) | Built into the project's tools, not run ad hoc |

## 1 Ending a session

A session ends with one of two phrases. Each is an instruction in its own
right and does what is listed here, nothing more.

| Phrase | Log and todo | Session files | Commit | Afterwards |
|---|---|---|---|---|
| "stop this session" | updated | stay in `wip/` | none | resumable |
| "close this session" | updated | moved to `.tmp/wip/` | the logs | finished |

### 1.1 Stop this session

The work of the day, or of the moment, is done; the effort is not.

1. Write the session's section in that day's `logs/log-YYYY-MM-DD.md` and its
   row in `logs/logs.md`, in each repo the session changed (repo §5).
2. Update `wip/todo.md` (§2).
3. Bring the session's handoff up to date, if it has one, so a fresh session
   can resume from it.
4. Report what was written and what stays uncommitted. Commit nothing.

### 1.2 Close this session

The effort is finished, or handed on through the todo list.

1. Steps 1 and 2 of a stop.
2. Move the session's files in `wip/`, now covered by the logs, to `.tmp/wip/`.
3. Commit the logs: the day's log and `logs/logs.md`, staged by file, as
   `chore(logs): record <session> closed`. Nothing else is staged.
4. Report the commit, name any other uncommitted work left in the repo, and
   say the session is closed. Work asked for after that is a new session.

"Close this session" is the explicit instruction git §5 requires, for that one
commit. It is not an instruction to push, nor to commit any other work.

Where a repo's logs are kept uncommitted, as beside a client's repos, close
does every step but the commit and says so.

### 1.3 Which repo

The log and todo entries go in each repo the session changed. Work that
changed no repo, such as moves in a shared drive, is logged in the repo the
session ran from.

## 2 The todo list

`wip/todo.md` is the local, short list of what is still to be done in a repo.
It is a working file, never committed: where a repo is tracked on GitLab or
GitHub, its work items are the record, and the todo list is the quick local
version.

- One `#` heading per part of the project a session works on as a unit, such
  as an app, a command set or a service, named in param-case as the part is
  named in the repo. Tasks done together sit together.
- A session adds its items under the heading for its part, and adds the
  heading only when there is none.
- Items are task-list lines, `- [ ]`, nested where one breaks down into steps.
- A session ticks, `- [x]`, every item it finished, wherever it sits.
- An item says what to do and, where it matters, the date it waits for, given
  absolute.

## 3 Replies

What Claude writes in the session, never in files, commits or documents.

- Every heading, point and sentence is numbered hierarchically, 1, 1.1, 1.1.1,
  so any of them can be referred to by number.
- Numbering runs on through the session: a reply that ended at 6 is followed
  by one that opens at 7. Sub-numbers restart under each new parent. Code
  blocks and table rows stay unnumbered.
- A heading uses heading syntax with its number inside, `## 7. Scope`, never a
  bare numbered line, which renders as a list item, and never a bold lead-in
  paragraph, which reads as emphasis.
- A blank line separates every sentence, point and paragraph, so nothing
  renders as a packed block.
- One idea per point. What does not change the next decision is cut.
- Bullets for lists, a table only for short parallel points.
- A proposal numbers each decision. What was asked for is one number, with
  sub-steps if it needs them; anything added is the next number.
- A yes agrees with the direction. It is not approval to run the whole list:
  each number is done only when named, reported on, and the next one asked
  for.
- A plan lists numbered Steps first, end to end, then Context.
- A report covers the task in hand. It does not close with a roll-call of
  untouched files, other repos or items deferred earlier; an unrelated item is
  raised only when it blocks the work or would be swept into a commit.

## 4 Questions

- A decision is asked through the AskUserQuestion dialog, one question per
  decision, offering the real alternatives, stopping included.
- What the decision rests on, a draft, a table, a list of names, is printed in
  the reply first with numbered sections. The question names those numbers,
  "Apply 14.1 and 14.2?". Content never goes in the dialog's preview, which is
  too small to read.
- A result asked to be seen, such as a link, is given in the reply, not folded
  into the next question.

## 5 Links and files

- Anything created or posted outside the repo, a work item, a merge request, a
  comment, a document, is followed at once by its full URL in the reply, and
  the URL is repeated at the top of the next question.
- An external page referred to is given as its full URL, so it opens with a
  click.
- A local file is referred to as a link to its path. An image to be looked at
  is opened in the editor with `code -r <path>`.

## 6 Asking before acting

- A question phrased as how, where or what is best asks for a recommendation,
  not for it to be carried out. Answer, lay out the approach, and wait.
- "Look at X to start Y" asks for an inspection and a proposal, not for Y to
  run.
- Before a file is written, its content is shown as text, and the session
  waits.
- A long run, such as a backup, a sync, a bulk rename or a large scan, starts
  only on a go given right before it. Approving a plan that includes the run
  is not that go.
- A long run goes to a background subagent with a self-contained prompt, so
  the session stays free for discussion.
- Writing something for a tracker or another person is not sending it: draft
  it, show it, and post only on an explicit instruction to.
- A tool or MCP server to "look at" is researched, including who hosts it, and
  installed only on a go.
- "Read only, no writes" means no data is created, updated or deleted, not
  that every request is a GET. A POST carrying a filter and returning data is
  a read; confirm it has no side effects and say that it mutates nothing.
  PUT, PATCH, DELETE and any state-changing POST stay off limits.
- If a run stops because the working directory is the wrong repo, that covers
  the whole run, not only the steps that write. Nothing is read, reported or
  drafted from the wrong clone, and the right one is not reached with
  `git -C`. Name the directory to run in, the state the work is in and what
  has to be cleared first, and stop.
- A state of the machine or a repo the user reports is fact; re-check it
  rather than trusting an earlier view, since things move between turns.
- A name given roughly is turned into the naming convention of wherever it
  lands, without asking; the reply states the final name.
- Where a project's memory or files disagree with this document, this document
  wins: say so, and bring the memory in line during that session.

## 7 Changes to live system state

Dotfiles, `$HOME` symlinks, shell startup, and anything a broken result locks
the user out of are rehearsed before they are applied.

- The change is written once as a script taking the target root as an
  argument, so the rehearsal and the real run are the same tested artefact.
- The repo and any supporting state are copied into a scratch folder standing
  in for `$HOME`, the script is run with `HOME` set there, and the outcome is
  asserted.
- Only then is it run against the real target, with symlinks re-pointed at
  once so nothing stays dangling.

## 8 Working with files

- A large file, such as an export, a dump or a log, is inspected by script
  from its path, printing counts and small samples. It is never read into
  context whole. One that has already landed in context is a reason to start
  a fresh session before compaction keeps it there.
- A file for the user to read before the work is finished, such as a handoff,
  a plan, a draft or a review, goes in the repo's `wip/`, named session first:
  `<session>-handoff.md`. It is untracked but not ignored, so `git status`
  keeps it in view, and it is never committed. Once consumed, it is deleted or
  moved to `.tmp/wip/`, a safety copy.
- Code or output Claude writes for its own working, such as a trial script or
  an intermediate listing, goes in `.tmp/`, which is gitignored, and is
  deleted or left there once built into where it is useful.
- `logs/` holds only the dated logs and `logs/logs.md`, all committed.
- A routine, skill or command file states current facts only: what it does,
  when it runs, how to change it. After a fix it reads as if the problem never
  happened; the story goes in the commit message or the conversation. This
  matters most for a prompt pushed into a live trigger, which is read by an
  agent with no context.

## 9 Evidence

- For a fault in a scheduled or automated run, read the run's log before
  proposing a cause. State read now is not evidence of state at run time, and
  an unsupported diagnosis is said to be one.
- A conclusion reached in a chat outside the session is discussion. It is
  recorded as an option or an open question until it is confirmed in the
  session at hand.

## 10 Shell and harness

- Where the Bash tool's shell is zsh with `noclobber` set, `>` onto an
  existing file fails while a loop carries on. Overwrite with `>|`, `perl -i`
  or the Write tool, and read back what a loop created before reporting it.
- In zsh, arrays index from 1. For lists of IDs, use a here-doc or `jq`
  rather than a shell array.
- In zsh, quote `[]` in arguments, such as `-f "ids[]=1"`, or globbing fails.
- A commit carries no attribution trailer, whatever the harness suggests
  (git §3).

## 11 Repeated actions

- An action that will be run more than once, or over many items, is built
  into the project's existing script or tool and run from there, not as a
  one-off command or a script in the scratchpad.
- Where no tool fits, a new one is proposed where the project keeps them,
  such as `apps/` or `scripts/`, and written only on a go.
- A one-off inspection or check can stay a command.
