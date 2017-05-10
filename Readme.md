# Brad's Git Scripts
This repository contains two scripts to aid committing to and generating relase notes for Git repositories, where feature branches are prefixed with JIRA ticket names.

## `commit-msg.rb`
This automatically adds the JIRA ticket prefix to commit messages that are on feature branches prefixed with the ticket number (case insensitive).
It also validates that commit messages are at least a certain length, default 20.

### Usage
Save it as `.git/hooks/commit-msg` in the Git repository. Then make sure it has the execute permission: `chmod +x .git/hooks/commit-msg`.

The default ticket prefix is DATA and minimum length is 20. This can be configured by changing the values in the file.

## `releasenotes.rb`
This script takes two Git tags and lists all commits between them that either have the JIRA prefix or are on a feature branch with a JIRA prefix, grouped by the ticket number.

The ticket prefix is configurable by changing the `PREFIX` variable in the file.

### Usage
`releasenotes.rb -t -u <tag1> <tag2>`

- *-t* - Include the date and time of each commit
- *-u* - Filter out commits with identical messages
