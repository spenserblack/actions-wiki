#!/bin/bash
set -e

# shellcheck source=src/git_exists.sh
source "$(dirname "${BASH_SOURCE[0]}")/git_exists.sh"

if ! git_exists "https://$INPUT_TOKEN@$INPUT_REPOSITORY.wiki.git" &>/dev/null; then
  echo "$(basename "$0"): https://$INPUT_REPOSITORY.wiki.git doesn't exist." >&2
  echo 'Did you remember to create the first wiki page manually?' >&2
  echo 'You can find more information on the readme. [1]' >&2
  echo
  echo '[1]: https://github.com/spenserblack/actions-wiki#usage'
  exit 1
fi

cd "$INPUT_PATH"

git init
git config --local user.name github-actions
git config --local user.email github-actions@github.com
git remote add origin "https://$INPUT_TOKEN@$INPUT_REPOSITORY.wiki.git"
git fetch origin
git reset origin/master

git add --all
git commit -m "$INPUT_COMMIT_MESSAGE"

if [[ $INPUT_DRY_RUN == true ]]; then
  git remote show origin
  git show
else
  git push -u origin master
fi

rm -rf ./.git
