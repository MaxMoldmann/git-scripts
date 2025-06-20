#!/usr/bin/perl
use strict;
use warnings;

# Permanently merge two repositories.
# (Inspired by https://stackoverflow.com/a/3148117)
# You need to run this on the first repository (it contains the new history),
# where you would like to integrate the history from the second repository
# (it contains the old history) - this can also be just one universal root commit.
# This old repo will then continue the history from the first repository 
# where it ends.
# As a preparation you need to git fetch the old history repository into the
# first repository. 
# Then add a branch e.g. "old-history" to mark the history that you fetched in.
# E.g. > git branch genesis d7876
# Then run this script with the following arguments: 

# SYNTAX: git-add-history.pl <new-history-branch> <old-history-branch>

# EXAMPLE: git-add-history.pl master genesis

# Check if the correct number of arguments is provided
if (@ARGV != 2) {
    print "Aborting: This script requires exactly two arguments.\n";
    print "Usage: git-add-history.pl <old-history-branch> <new-history-newest-commit>\n";
    print "(<old-history> is likely your main or master branch)\n";
    exit 1;
}

my $new_history = $ARGV[0];
my $old_history = $ARGV[1];
my $cmd;

# Find the two commits that need to be connected:
# (1/2) Get the oldest commit of the new history branch
print "Getting oldest commit of '$new_history'...\n";
$cmd = "git rev-list $new_history | tail -n 1";
print "Executing: $cmd\n";
my $newinit = `$cmd 2>&1`;
chomp($newinit);
print "$newinit\n";

# (2/2) Get the newest commit of the old history branch
print "Getting newest commit of '$old_history'...\n";
$cmd = "git rev-parse --verify $old_history";
print "Executing: $cmd\n";
my $oldhead = `$cmd 2>&1`;
chomp($oldhead);
print "$oldhead\n";

# Create a fake commit based on $newinit, but with a parent
# (note: at this point, $oldhead must be a full commit ID)
print "Creating fake commit based on $newinit with parent $oldhead...\n";
$cmd = "git cat-file commit \"$newinit\" | perl -pe 's/^(tree [0-9a-f]+)\$/\$1\\nparent $oldhead/' | git hash-object -t commit -w --stdin";
print "Executing: $cmd\n";
my $newfake = `$cmd 2>&1`;
chomp($newfake);
print "New commit hash: $newfake\n";

# Replace the initial commit with the fake one
# git replace <last commit> <first commit>
# git replace <object> <replacement>
print "Replacing $newinit with $newfake...\n";
$cmd = "git replace -f \"$newinit\" \"$newfake\"";
print "Executing: $cmd\n";
my $output = `$cmd 2>&1`;
print "Output: $output\n";
print "Done. Repository history has been extended.\n";

print "\nINFO:\n";
print "If you decide to make the replacement permanent:\n";
print "  (1) use git filter-branch to rewrite all refs\n";
print "  (2) use git replace -d to delete the replacement\n";
print "  (3) push the new history to the remote repository:\n";
print "(make a tar/zip backup of your .git directory first)\n";
print "git filter-branch --tag-name-filter cat -- --all\n";
print "git replace -d $newinit\n";
print "git push -f --tags\n";
print "git push -f origin $new_history\n";
