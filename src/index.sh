#!/bin/bash
set -e

cd "$INPUT_WIKI_DIRECTORY"

git init
git config --local user.name github-actions
git config --local user.email github-actions@github.com
git remote add origin https://$INPUT_TOKEN@$INPUT_REPOSITORY.wiki.git
git fetch origin
git reset origin/master

git add --all
git commit -m "$INPUT_COMMIT_MESSAGE"

if [[ $INPUT_DRY_RUN == true ]]; then
  git remote show origin
else
  git push -u origin master
fi

rm -rf ./.git
