#!/bin/bash
set -e

# Override the github.* context env vars with the ones that we got from the user
# that may (or may not be) different from the original $GITHUB_* env vars.
export GITHUB_TOKEN="$INPUT_TOKEN"
export GITHUB_SERVER_URL="$INPUT_GITHUB_SERVER_URL"
export GITHUB_REPOSITORY="$INPUT_REPOSITORY"

# This is the default host that gh uses for clones and commands without a repo
# context (a .git folder).
export GH_HOST="${GITHUB_SERVER_URL#*//}"

gh auth setup-git

cd "$INPUT_PATH"

# https://stackoverflow.com/a/28180781
gh repo clone "$GITHUB_REPOSITORY.wiki" .git -- --bare
git config --unset core.bare
git reset

# https://github.com/stefanzweifel/git-auto-commit-action/blob/9cc0a1f55de2aa04a36721ca84463dd520f70f4c/action.yml#L35-L42
git config user.name github-actions[bot]
git config user.email 41898282+github-actions[bot]@users.noreply.github.com

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
