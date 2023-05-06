#!/bin/bash
set -e

# Override the github.* context env vars with the ones that we got from the user
# that may (or may not be) different from the original $GITHUB_* env vars.
export GITHUB_TOKEN="$INPUT_TOKEN"
export GITHUB_SERVER_URL="$INPUT_GITHUB_SERVER_URL"
export GITHUB_REPOSITORY="$INPUT_REPOSITORY"

# This is the default host that gh uses for clones and commands without a repo
# context (a .git folder). We use Bash string magic to get the github.com part
# from a full origin (no pathname) like https://github.com -> github.com
export GH_HOST="${GITHUB_SERVER_URL#*//}"

echo '🟪 Configuring local Git using gh auth setup-git...'
gh auth setup-git

# https://stackoverflow.com/a/28180781
echo "🟪 Cloning $GITHUB_REPOSITORY.wiki into $INPUT_PATH..."
cd "$INPUT_PATH"
gh repo clone "$GITHUB_REPOSITORY.wiki" .git -- --bare
trap 'rm -rf .git' SIGINT SIGTERM ERR EXIT
git config --unset core.bare
git reset
echo "🟩 Cloned $GITHUB_REPOSITORY.wiki into $INPUT_PATH"

# https://github.com/stefanzweifel/git-auto-commit-action/blob/9cc0a1f55de2aa04a36721ca84463dd520f70f4c/action.yml#L35-L42
echo "🟪 Setting up Git user to be GitHub Actions..."
git config user.name github-actions[bot]
git config user.email 41898282+github-actions[bot]@users.noreply.github.com

# https://stackoverflow.com/a/2659808
echo '🟪 Checking for changes using git diff-index...'
if git diff-index --quiet HEAD -- &>/dev/null; then
	echo '🟨 No changes! Will not commit or push.'
	exit 0
fi

echo '🟪 Committing changes...'
git add -A
git commit -m "$INPUT_COMMIT_MESSAGE"

if [[ $INPUT_DRY_RUN == true ]]; then
	echo '🟨 dry-run is set. Not pushing.'
	git remote show origin
	git show
else
  echo "🟪 Pushing to $GITHUB_REPOSITORY.wiki master..."
	git push -u origin master
fi
