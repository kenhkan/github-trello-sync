GitHub to Trello Adapter
========================


The Need
--------

GitHub is great for repo-based collaboration, but non-trivial
projects often span multiple repos. Worse, a company's product (or product
line) consist of multiple projects. We need a way to organize all these repos
altogether.


Why not existing tool?
----------------------

Because we need to sync between GitHub and Trello at the
*organization* level. Most tools out there require each repository to be
selected manually for sync. We don't like manual work.


The Solution
------------

Given a Trello and a GitHub credentials, a Trello board name, a GitHub
organization, it maps repos to lists, issues to cards, and issue comments from
GitHub to Trello.

All collaboration and ticket/issue/story creation still happen on GitHub but
organization of these issues from a higher-level, holistic standpoint is
managed within a single board on Trello.


The Methodology
---------------

1. Issues auto-populate Trello in the form of cards in their respective lists
2. Each week (or as needed), go through all issues within the organization in
   one view and label issues to be tackled for that week
3. Closed issues are reflected as a labeled cards on Trello for QA
4. Archive cards that are confirmed complete, or else re-open issue or create
   new related issues
5. Repeat the process


Why this way?
-------------

We want to use GitHub as our primary collaboration tool because virtually all
developers are familiar with it, but we need Trello for high-level planning. In
short:

GitHub Pros

* Developer familiarity
* Tight integration between comment, commit, and code
* Force issues to be relevant to the code repository in question

Trello Pros

* High-level planning with all issues in one view
* Allow arbitrary sorting in order of importance
* Serve as a QA "buffer" after an issue has been closed
