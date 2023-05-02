#!/bin/bash
set -e

# The GitHub CLI (gh) uses $GH_TOKEN. You don't need to do gh auth login with a
# real user if you already have a token.
export GH_TOKEN="$INPUT_TOKEN"
gh auth setup-git

repository_url="$INPUT_GITHUB_SERVER_URL/$INPUT_REPOSITORY.wiki"

cd "$INPUT_PATH"

if ! gh repo clone "$repository_url" .git -- --bare; then
  echo "$(basename "$0"): $repository_url doesn't exist." >&2
  echo 'Did you remember to create the first wiki page manually?' >&2
  echo 'You can find more information on the readme.'
  echo 'https://github.com/spenserblack/actions-wiki#usage' >&2
  exit 1
fi
# https://stackoverflow.com/a/28180781
git config --unset core.bare
git reset

# https://github.com/stefanzweifel/git-auto-commit-action/blob/9cc0a1f55de2aa04a36721ca84463dd520f70f4c/action.yml#L35-L42
git config --local user.name github-actions[bot]
git config --local user.email 41898282+github-actions[bot]@users.noreply.github.com

# https://stackoverflow.com/a/2659808
if git diff-index --quiet HEAD --; then
	echo 'No changes! Will not commit or push.'
	exit 0
fi

git add -A
git commit -m "$INPUT_COMMIT_MESSAGE"

if [[ $INPUT_DRY_RUN == true ]]; then
	git remote show origin
	git show
else
	git push -u origin master
fi
