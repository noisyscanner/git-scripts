# DPP Scripts
This repository contains two scripts to aid the generation of release notes files for DPP repositories.

## `commit-msg.rb`
This automatically adds the `[DATA-xxx]` prefix to commit messages that are on feature branches beginning with `DATA-xxx-` (case insensitive).
It also validates that commit messages are over 20 characters in length in a bid to make the logs more descriptive.

### Usage
Save it as `.git/hooks/commit-msg` in the Git repository. Then make sure it has the execute permission: `chmod +x .git/hooks/commit-msg`.

## `releasenotes.rb`
This script takes two Git tags and lists all commits between them that either have the `[DATA-xxx-]` prefix or are on a feature branch with a `DATA-xxx-` prefix, grouped by the ticket number.

### Usage
`releasenotes.rb -t -u <tag1> <tag2>`

- *-t* - Include the date and time of each commit
- *-u* - Filter out commits with identical messages
