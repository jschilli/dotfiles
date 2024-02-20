#!/bin/sh
# If you have it checked out locally
git branch -d $1

# Delete remote branch
git push origin :$1

