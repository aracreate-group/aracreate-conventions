# GIT

Git and code-hosting conventions for every araCreate repo. Read the common one,
then the one for wherever the repo actually lives.

| Document | Covers | Read it when |
| --- | --- | --- |
| [git-conventions](git-conventions.md) | Commit message format, wording, what goes in one commit | **Always.** Nothing in it depends on the host. |
| [gitlab-conventions](gitlab-conventions.md) | Work items, merge requests, labels, milestones, `glab` | The repo is on GitLab |

The split exists so commit conventions stay in one place. semantic-release reads
commit messages to decide version bumps and write `CHANGELOG.md`, so the format
has to be identical across every repo whatever its host — it is defined once, in
[git-conventions](git-conventions.md#1-format), and the platform document does
not repeat it.

Repo structure, file headers, naming and versioning are not here; they are in
[repo](../repo/readme.md).
