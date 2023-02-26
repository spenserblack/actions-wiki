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

## Alternatives

There are numerous GitHub wiki publishing actions on the GitHub Actions
marketplace. There are, however, two that stick out. The
[newrelic/wiki-sync-action] is a good choice for a GitHub wiki action if you
need bidirectional synchronization when someone edits the live wiki. This can be
beneficial for non-technical contributors. There's also
[Andrew-Chen-Wang/github-wiki-action] which is a direct competitor to this
project. The tradeoff that it makes is using a Docker image which may not work
with Windows-based jobs.

> My single goal was to expose the wiki to PRs, so that people who aren't
> collaborators can contribute to the wiki and go through a review process. Bad
> things can happen when the wiki is directly editable by everyone 😆 I don't
> really have any plans to make this bi-directional.

&mdash; [@spenserblack] in [Issue #4]

For more information about other alternatives, you can check out [Issue #4]
which has a longer list of alternatives. ⚠️ Be warned that most have been
abandoned.

<!-- prettier-ignore-start -->
[newrelic/wiki-sync-action]: https://github.com/newrelic/wiki-sync-action#readme
[Andrew-Chen-Wang/github-wiki-action]: https://github.com/Andrew-Chen-Wang/github-wiki-action#readme
[@spenserblack]: https://github.com/spenserblack
[Issue #4]: https://github.com/spenserblack/actions-wiki/issues/4
<!-- prettier-ignore-end -->
