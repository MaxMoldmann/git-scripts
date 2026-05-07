# Versatile Git scripts

## Diff entire checkouts instead of single files
**gitdiffall** was built before Git learned to diff entire checkouts.
This script still has some usability advantages. E.g. if the comparison is against your current checkout version it will compare against your working folder instead of operating on two temporary folder structures.
Once temporary files have been created it launches a user configured comparison tool like Meld, WinMerge or Beyond Compare.

**gitdiffworktree** is the more advanced comparison script to compare two versions of a repo.
It is using the Git worktree feature, which is the fastest way to checkout the repo at another version.
This is also helpful to quickly compare changes done by an AI agent on a git worktree.

## Prepend a Universal Root Commit or more history to a Git Repo
**git-add-history** allows to permanently merge two repositories. Effectively it adds an older history to your current repository. It is using the git replace mechanism to do this. The changes can also be made permanent so it does not rely on the git replace mechanism anymore (which is not supported by all tools). 
Also see this LinkedIn article: (https://www.linkedin.com/posts/max-moldmann_git-magic-how-to-use-universal-root-commits-activity-7322857806196310016-i_Os)

## Find and list large commits that blow up the repository size
Use **git-find-large-commits** to find large commits so they can be eliminated. 
You can also use a tool like the BFG Repo-Cleaner (https://rtyley.github.io/bfg-repo-cleaner/) to then easily get rid of large files.

## Create fast incremental automatic backups of your local repositories to a network folder
**git-auto-backup** creates backups to a network folder or OneDrive.
It is using rsync and can even create backups of the files that are not yet committed, so you never loose any data.

## Interactive Rebase Helper
Interactive rebase is an indispensable tool to create nicely reviewable change sets.
**gitrbi** automatically detects where your current branch is branching off of another branch
and starts the interactive rebase process, so you don't have to think about at which older commit your interactive rebase session should start.

## Sync with master branch
**gitsync** provides an automatic rebase/sync of your current local branch with your server repository. 
The script fetches the latest changes and then attempts a git pull --rebase on your current branch.

## Git Remove helper script for Windows
When using git status, the file paths in the output contain forward slashes.
This limits the usefulness of the output for copy/paste.
Using **grm** instead of the **del** command will convert the slashes and then delete all the files given as parameter.

## Start a local Git repository server on your PC
**gitdaemon** spawns your own local Git repository server. In the event that a Git repository server can't be used. Your personal server can also be accessed from other people in the network.

## Git support for CoDeSys projects
The **codesys-import** script makes it possible to use the Git Version Control for Codesys projects.
Git stores just a template of an empty project file and all of the exported EXP files of a full project.
This script can auto update a project file with the latest changes from Git,
or it can recreate a full project file by importing all EXP files into the empty project file template.
