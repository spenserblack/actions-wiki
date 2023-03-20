#!/bin/bash
set -e

cd "$INPUTS_WIKI_DIRECTORY"

git init
git config --local user.name github-actions
git config --local user.email github-actions@github.com
git remote add origin https://$INPUTS_TOKEN@$INPUTS_REPOSITORY.wiki.git
git fetch origin
git reset origin/master

git add --all
git commit -m "$INPUTS_COMMIT_MESSAGE"
git push -u origin master

rm -rf ./.git
