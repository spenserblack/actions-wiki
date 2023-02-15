# Wiki

This action takes the contents of a provided directory and synchronizes it with your
repository's wiki. This allows, for example, pull requests for the wiki.

By default, it will use the `.github/wiki` directory.

## Before using this action

You probably want to commit your wiki in its initial state before using this action.
This is because this action will commit *all* differences between the wiki and the
`.github/wiki` (or other specified directory) contents.

```bash
git clone https://github.com/octocat/my-repo.wiki.git .github/wiki
rm -rf .github/wiki/.git
git add .github/wiki
git commit -m "Add wiki to repo"
```

## Usage

Unfortunately, `${{ github.token }}` does not have access to updating wiki
repositories, so it is necessary to create a new PAT.

Start by creating a classic token. If your repository is public, you only need the
`public_repo` scope. Otherwise, you must grant the full `repo` scope. Then, add
the token to your repository secrets so that it can be used in your workflow.

Simple example usage can be found in [this workflow file](./.github/workflows/update-wiki.yml).
