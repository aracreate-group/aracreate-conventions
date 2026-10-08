# WIP

Files to be read before the work they belong to is finished: a session's
handoff, plan, draft or review, named session first, `<session>-handoff.md`,
and the local `todo.md`.

Only this readme is committed. `todo.md` comes with one sample heading and
task to replace, and is never committed in the repo either. Everything else
here stays untracked, so `git status` keeps unfinished work in view. Once what
a file holds is in the logs or wherever it belongs, it is deleted or moved to
`.tmp/wip/`, which is gitignored.
