#!/bin/bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/git_exists.sh"

if ! git_exists "https://$INPUTS_TOKEN@$INPUTS_REPOSITORY.wiki.git" &>/dev/null; then
  echo "$(basename "$0"): https://$INPUTS_REPOSITORY.wiki.git doesn't exist." >&2
  echo "Did you remember to create the first wiki page manually?" >&2
  exit 1
fi

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
