---
title: <What was done, as a short phrase>
aliases: [<the short name this work gets remembered by>]
type: log
updated: <YYYY-MM-DD, the day the work is committed>
tags: [subject, area]
---

# <Title>

Work of <YYYY-MM-DD, or YYYY-MM-DD to YYYY-MM-DD>, committed <YYYY-MM-DD>.
<One paragraph: what was asked, why it was needed, and what this entry covers.>

## Findings

- <What was found, stated as it was true on the day.>

## Findings that were wrong

- <A finding that later proved wrong, kept rather than edited out, with what
  caused it. Drop this heading if there were none.>

## Changed

- <What was altered, by area, one line each: a folder of the repo, a drive, a
  server. The detail stays in the commits.>

## Decided

- <A call made, with the reasoning, so a later reader does not reopen it.>

## Distilled into

- <Links to the notes or files this work fed. Drop this heading if there were
  none.>

## Still open

- <What was left, and why. This section goes last.>

# Readme

Copy this file to `log-<YYYY-MM-DD>.md`, named for the day of the work, fill
the placeholders, and delete this section. If that day already has a log, add
to it instead. Work that ran over several days without a commit, and cannot be
split cleanly by day, goes into one log named for the day it is committed.
Everything above this section is the log, and it is listed in the folder's
index, `logs.md`.

The rules that hold in every repo are in
[repo §5](https://github.com/aracreate-group/aracreate-conventions/blob/main/repo/readme.md#5-logs):
one file per day of change, written once per push, never edited once pushed.
Until the push, the day's log grows with the work; after it, a correction goes
into a new day's log.

**One effort or several.** A day with one effort uses the headings above as
they are. A day with several gives each effort its own `## <Subject>`, with
Findings, Changed, Decided and Distilled into as `###` beneath it, and ends
with a single `## Still open` for the whole day.

**A data intake.** When the work takes in data, the effort opens with these
sections before Findings, keeping the ones that apply: `Source` (where it came
from, when it was exported, whose account), `Coverage` (what it holds), `Not in
it` (what is missing), `Known defects`, and `Redaction` (what was removed, and
why).

**Keep it short.** Write what a reader needs years later: link rather than
paste, no transcripts, no copies of commit messages, diffs or file contents,
and no commit hashes, which change before a push. `git log --
logs/log-<YYYY-MM-DD>.md` finds the commits a log went out with.

`aliases:` is the short name the work gets referred to by afterwards, so it can
be linked without quoting its full title.
