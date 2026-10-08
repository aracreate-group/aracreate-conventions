# Projects Drive Conventions

**What this is.** How client work is laid out in a projects drive: the folder
shape every client gets, client codes, what goes where, and how a client moves
from lead to archive.

**Why it exists.** A projects drive is shared with team members and clients.
One shape means anyone finds a file without asking, sharing work never exposes
the business side, and the drive can be checked against a written rule instead
of someone's memory.

**How it fits.** Everything in [conventions-drive](conventions-drive.md) holds
here too: naming, links, code and what stays out. This document adds the layout.

## 1 Drives

The group splits its projects drives by the kind of work, `<name>-projects-drive`.
Critical work, such as core engineering and manufacturing for clients, sits in
a drive of its own that is not shared with the rest of the group by default;
other work goes in a drive the whole group can use. What decides the drive is
how critical the work is, not where the client is. A client lives in exactly
one drive; work that was split across two is merged into the one its kind
belongs to. Large media sets live in a separate media drive, reached by
shortcut ([§9](#9-media)).

The projects drives share one sitemap: a Google Sheet named `projects-sitemap`
at the root of one projects drive, with a shortcut to it at the root of each of
the others. It has one row per client and, under it, one row per project, version
or year folder, with the columns CODE, TYPE (client, venture, event or
partner), CLIENT, PROJECT (blank on a client row), STAGE (the folder of
[§3](#3-shape) it sits in), DRIVE and LINK. Every client of every drive is in
it, so it is where a new code is checked, and a client moving between drives
changes only its row.

## 2 Codes

- Every client has a code of two to four letters, lower case. Three letters is
  the default for a new client. Four fit an internal venture, or a name too long
  to shorten well to three. An existing two-letter code stays.
- An internal project that is not a venture takes a code like a client, and
  keeps it if it later takes on clients.
- A lead takes a code when its folder is created, like any client. A lead
  found without one gets its code at the next drive audit.
- A code is unique across the group, fixed once given and never reused. It
  never matches a company short code. The one exception: when a new client
  needs a code held by an archived lead that never had any output from us, the
  code can pass to the new client, and the lead's folders take a new code.
- A file we make is named `<company>-<code>-<title>[-<series>]`, in param-case,
  for example `acg-abc-proposal.pdf` or `acg-abc-posts-2026-09-10-02.png`.
  `<company>` is `acg`, `acl` where araCreate Lanka delivers directly, or
  `aci` where araCreate India does; a venture names its own work with its own
  code, as `xyz`. `<code>` is the client's code, or `<code>-<sub>`
  for work a client subcontracts or a subproject, as
  `aci-abc-def-website-proposal.docx`; it is left out where a venture has no
  client code for the work, as `xyz-<title>`. `<title>` says
  in a few words what the file is.
- `<series>` ends the name of a file that belongs to a series: an ISO date when
  it belongs to a day, a counter when only the order matters, or a date and a
  counter for several on one day. Counters are padded to two digits, three
  where a series runs past 99. A photo or video takes the date it was taken.
- The rule covers every file in `output/` and `pm/`, Google Docs, Sheets and
  Slides included, and whoever creates or uploads a file names it so. Files in
  `input/` keep the sender's words, in param-case, after the client's code:
  `abc-2023-11-21-acme-bms-v0.1-schematics.pdf`. Anything a rename would
  break keeps its names as they are: code (§10), websites, source packages and
  other bundles.
- An export tagged with its time, such as a WhatsApp image, a screenshot or a
  phone photo, is named after its folder with the date and a counter, the
  folder's generic and date words left out:
  `acl-abc-new-year-post-2026-04-13-01.jpeg`.
- A clean name has no copy markers or `untitled`, writes dates as ISO dates,
  keeps versions and decimals with their dots (`v0.1`, `v3.x`, `25.4mm`) and
  spells out umlauts. German stays German, and brand and client names stay
  whole (`aracreate`, `acme`). A name that says nothing of its content, such
  as a bare number or a camera's own name, is renamed when the project is
  distilled.

## 3 Shape

    active-projects/                  clients with work under way
      <code>-<client>/                wrapper, internal, never shared
        <code>-<client>-biz/          the business side, never shared
          input/  output/  pm/
        <code>-<client>-biz-ext/      optional: business material shared with the client
          input/  output/  pm/
        <code>-<client>-prj/          the work, shared with whoever works on it
          input/  output/  pm/
    active-leads/                     prospects we are talking to
      <code>-<client>/                a code from the start (§2)
        <code>-<client>-biz/
          input/  output/  pm/
    archived-projects/                finished clients, moved here unchanged
    archived-leads/                   leads that did not become work, moved here unchanged
    projects-sitemap                  the shared Google Sheet, or a shortcut to it, §1
    .tmp/                             working area for audits, organising and clean-up, §11

The drive root holds these six items and nothing else. Where a client folder
sits records whether it is a lead or a project, and whether it is active. The
wrapper holds the halves and nothing else. Every half carries the client's code
and name identically: `abc-acme/`, `abc-acme-biz/`, `abc-acme-prj/`. The name
is the client's own, spelt as its documents spell it, in param-case.

An internal venture has the same shape, with the venture as the client, and its
many projects as project folders ([§4](#4-projects-versions-and-years)). An
araCreate venture is named `<code>-aracreate-<name>`, halves too:
`xyz-aracreate-labs/`, `xyz-aracreate-labs-biz/`.

## 4 Projects, versions and years

A client with one piece of work keeps `input/ output/ pm/` directly in each
half. When a second arrives, each gets its own folder with its own
`input/ output/ pm/`, and the first one's folders move into it. A project, a
version and a year are all laid out this way:

    <code>-<client>-prj/
      <code>-<project>/    input/  output/  pm/
      <code>-v1-<name>/    input/  output/  pm/
      <code>-2026/         input/  output/  pm/

What decides whether `-biz/` gets the same folders is how the work is agreed:

- Projects agreed separately, each with its own proposal or contract, get a
  folder in both halves, so each project's business papers sit with it.
- Tasks or orders under one engagement, such as the many orders of a product
  venture or the recurring tasks of a service client, get folders in `-prj/`
  only. `-biz/` stays flat, `input/ output/ pm/` for the whole client, since
  the tasks share its agreement.

Input that several versions share stays in the project's own `input/`. A
version gets its own folder only for work we did on it, and holds only what is
its own.

A project, version or year folder carries the client code as a prefix,
`abc-website/`, `abc-v1-cube/`, `abc-2025/`, so a search for the code finds it.
A folder marked to sort first keeps its dash in front, `-abc-curriculum/`.
Projects sit one level deep: a subproject of a project is flattened beside it
as `<code>-<sub>-<project>/`, such as `abc-launch-marketing/`. Every other folder
inside a half is param-case without the code.

Work with a client always starts with a first project, and the NDA and
framework agreement are signed for it. They stay in that project's folders,
even after further projects follow, so no separate folder is needed for them.

Work a client subcontracts to us for its own customer is a project of that
client, not a client of its own.

## 5 What goes where

The same three folders in every half:

| Folder | Holds |
|---|---|
| `input/` | everything the client gives us: requests, briefs, requirements and PRDs, their documents, data and logos, under the names they arrived with |
| `output/` | everything we produce, final: proposals, contracts and legal documents, deliverables, reports, the apps and UIs we build |
| `pm/` | organisation: drafts and source files, plans, minutes, templates, and `-logs/` for every log that is not a development log |

A half holds these three folders and nothing else. A `media/` folder is taken
apart: logs go to `pm/-logs/`, and anything else goes to `input/` or `output/`
by what it is, so a hero image the client supplied goes to `input/`.

There is no `archive/` or `draft/` folder. Older versions and drafts go
straight into `pm/`; when a name clashes, the older file gets its ISO date
appended, `…-proposal-2026-03-26.pdf`.

In `-biz/`, where a document came from decides its folder. What the client
sent, their agreement, purchase order or RFQ, goes to `input/`; so does what a
supplier or subcontractor sent us. What we sent goes to `output/`: the proposal
and the agreement as sent, and signed. `pm/` holds only the source files of what
we sent: the editable proposal, the Google Doc. A lead that needs work done
before it is won keeps that work in `-biz/output/` too. A lead with more than
one effort gets a folder per effort inside `-biz/`, each with its own
`input/ output/ pm/`. Invoices are not kept in the drive.

Archives stay packed unless they hold PDFs or images; then they are unpacked
beside themselves, into a folder of their name, and the archive goes to
`.tmp/bin/`, the same rule applied to archives inside them. Software, binaries
and packages issued as one unit, such as app builds, installers, CAD files,
source projects and fabrication or assembly packages, stay packed, in a
`sources/` folder of the half they belong to, such as `output/sources/`.

`pm/-logs/` carries the leading `-` so it sorts to the top of `pm/`, since it
is opened most.

## 6 Departments

A project delivered across several service departments splits `output/` by
department, each folder named by its bare code:

| Code | Department |
|---|---|
| `id` | industrial design |
| `me` | mechanical engineering |
| `ee` | electrical and electronics engineering |
| `fw` | firmware |
| `sw` | software |
| `scl` | sourcing, certification and logistics |

Other projects organise `output/` by what they deliver: `branding/`,
`social-media/`, `video/`.

## 7 Lifecycle

| Stage | Where | Folders |
|---|---|---|
| New lead | `active-leads/` | `<code>-<client>/` with `<code>-<client>-biz/` |
| Won | moved to `active-projects/` | `<code>-<client>-prj/` added |
| Lost lead | moved to `archived-leads/` | empty folders moved to `.tmp/bin/` |
| Finished | moved to `archived-projects/` | empty folders moved to `.tmp/bin/` |
| Returning client | moved back to `active-projects/` | `input/`, `output/`, `pm/` added again where work resumes |

Only a whole client is archived, never a project inside an active one. A move
never renames anything.

When a client is archived, every folder with nothing in it is moved to
`.tmp/bin/`, placeholders included, down to the client folder and its `-biz`
half, which always stay. A half or project folder left empty goes too. Code
snapshots keep their folders as they are ([§10](#10-code)).

### 7.1 Starting a client

1. Choose a code the `projects-sitemap` does not list.
2. Create `<code>-<client>/` in `active-leads/`, with `<code>-<client>-biz/`
   inside it, and `input/`, `output/` and `pm/` inside that.
3. Add the client's row to the `projects-sitemap`, with the code, linked to
   the wrapper.
4. When the work is won, move the wrapper to `active-projects/` and add
   `<code>-<client>-prj/` with its own three folders.
5. The `input/`, `output/` and `pm/` folders are placeholders: they are created
   with every half and every project folder, and stay while the client is
   active, empty or not.

## 8 Sharing

Only `-prj/` and `-biz-ext/` are shared: with team members, and with the client
when they have a Google account. The wrapper and `-biz/` stay with the company.

## 9 Media

Footage, shoots and other heavy files live in the media drive, under the same
`<code>-<client>` name. Deliverables still belong in `output/`: a heavy one is
a shortcut in `output/` pointing to the media drive.

## 10 Code

A client's code copy goes in `output/sw/`, or the department folder it belongs
to, in the form [conventions-drive §3](conventions-drive.md#3-code) sets.

## 11 Working area

`.tmp/` holds the folders for any drive audit, organising or clean-up, and
nothing else:

| Folder | Holds |
|---|---|
| `todo/` | client folders taken out of their stage folder to be worked on |
| `done/` | client folders finished and waiting for a check, in the four stage folders they will return to |
| `bin/` | anything to be deleted; only the drive owner empties it |
| `unsorted/` | items the drive owner places by hand |

A client folder goes from its stage folder to `todo/`, is changed there, waits
in `done/` until it is checked, and then moves back to its stage folder.
Nothing is deleted during the work: an unwanted item or an emptied folder moves
to `bin/`, and a folder is listed in full before it goes there. Every file is
checked by its Drive ID against a listing taken before the work. When nothing
is in progress, all four folders are empty.

## 12 Personal folders

A person's own projects sit in `active-projects/` or `archived-projects/` as
`<person>-<topic>/`, such as `alex-music/`, and are free inside. They are the
one exception to [§3](#3-shape).
