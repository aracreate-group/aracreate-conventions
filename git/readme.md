# GIT

Git and code-hosting conventions for every araCreate repo. Three documents, in
layers — read the common one, then the one for wherever the repo actually lives.

| Document | Covers | Read it when |
| --- | --- | --- |
| [git-conventions](git-conventions.md) | Ground rules, branching model, commit format, merge method, review principles | **Always.** Nothing in it depends on the host. |
| [gitlab-conventions](gitlab-conventions.md) | Work items, merge requests, labels, milestones, `glab` | The repo is on GitLab |
| [github-conventions](github-conventions.md) | Issues, pull requests, labels, milestones, `gh` | The repo is on GitHub |

The split exists so commit conventions stay in one place. semantic-release reads
commit messages to decide version bumps and write `CHANGELOG.md`, so the format
has to be identical across every repo whatever its host — it is defined once, in
[git-conventions §3](git-conventions.md#3-commits), and neither platform
document repeats it.

The two platform documents are deliberately parallel: same section order, same
rules, different vocabulary and mechanics. Where the process genuinely differs
rather than just renaming — GitHub cannot open a pull request on an empty
branch, and has no scoped labels — it is called out in
[github-conventions § Differences from GitLab](github-conventions.md#differences-from-gitlab).

Repo structure, file headers, naming and versioning are not here; they are in
the [root README](../README.md).
