# Team Drive Conventions

**What this is.** How a team drive holds one folder for each person who works
with a company: how the folder is named, the three folders inside it, and what
happens to it when the person leaves.

**Why it exists.** A person's folder keeps what passes between them and the
company in one place, and shows at a glance which project folders are shared
with them. Client work never lives in it, so nothing of a client's is lost when
a person leaves.

**How it fits.** Everything in [conventions-drive](conventions-drive.md) holds
here too. Client work itself lives in a projects drive, laid out by
[conventions-drive-projects](conventions-drive-projects.md); a team drive only
links to it.

## 1 Person folders

Every person who works with a company, employed, contracted, consultant or
trainee, gets a folder in that company's team drive when their account is
created:

    <company>-per-<nnn>-<name>-drive/

- `<company>` is the company they work with: `acg`, `acl` or `aci`.
- `<nnn>` is the person's three-digit number in the ERP, fixed for good;
  `xxx` for someone who was never in the ERP.
- `<name>` is the first name in param-case, with a second word only where two
  people would otherwise share a name.

## 2 Shape

    <company>-per-<nnn>-<name>-drive/
      org/         the person's HR files
      projects/    every shortcut the person has
      unsorted/    everything else
    archived-team/ folders of people who have left

A person folder holds these three folders and nothing else, with no number
prefixes and no loose files. Apart from the HR files in `org/`, a team drive
keeps no files of its own: work lives in a projects or organisation drive and
is reached by a shortcut in `projects/`. Anything else found in a person folder
goes to `unsorted/`.

| Folder | Holds |
|---|---|
| `org/` | the person's HR files only: contracts, offer and relieving letters, ID, visa and travel papers, payslips and EPF, appraisals, certificates |
| `projects/` | shortcuts only, and every shortcut the person has: to project folders first, and to any other shared folder they need |
| `unsorted/` | everything that is neither: drafts, temporary files, takeout zips and material not yet placed |

## 3 Projects

- A project folder is shared with a person by adding a shortcut to it in their
  `projects/`; access taken away removes the shortcut. `projects/` is
  therefore the record of what each person can open.
- Every shortcut in a person folder sits directly in `projects/`, never in
  `org/` or `unsorted/`, and never in a folder inside `projects/`. A shortcut
  to a client points at its `-prj` or `-biz-ext` half or a `-prj` project
  folder inside one. A client with no `-prj` half, most often a lead, is
  reached through its `-biz` half. The team that runs a venture holds
  shortcuts to both its halves. A shortcut never points at a wrapper
  ([conventions-drive-projects §8](conventions-drive-projects.md#8-sharing)).
  Two shortcuts to one target, one to a folder inside another shortcut's
  target, or one to the person folder itself, are removed.
- A shortcut carries its target's name. When the target is renamed, the
  shortcut is renamed; when the target moves to `.tmp/bin/`, the shortcut is
  replaced by one to the folder that now holds the work.
- Work for a client is kept in the client's folder in a projects drive, not in
  a person folder. Anything for a client found in `org/` or `unsorted/` moves
  there.

## 4 Other accounts

Files a person brings from another account, such as a Google Takeout or the
contents of an earlier company account, are sorted on arrival: what concerns
the person's employment goes to `org/`, client work to the client's folder in
the projects drive, and the rest to `unsorted/`. Takeout zips stay in
`unsorted/` as they came; the files of a Google Drive export are placed like
any others, and the emptied export folder is removed. Files that only live
in a personal My Drive are copied into the shared drive, never linked, since
they go when that account does.

## 5 Leaving

When a person leaves, their `unsorted/` is checked for client work, which moves
to the projects drive, and their folder moves to `archived-team/` unchanged,
ID included. A folder found in `archived-team/` without an ID is named with
`xxx` in its place.
