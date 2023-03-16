# Publish to GitHub wiki action

📖 Deploy docs from your source tree to the GitHub wiki

## Features

🌐 Works across repositories (with a [PAT]) \
📚 Pretty interface for Markdown docs \
⤴️ Lets you open PRs for wiki docs

## Usage

❗ Make sure you turn on the GitHub wiki feature in your repo's settings menu.
You'll also need to _manually_ create a dummy page to initialize the git repo
that powers the GitHub wiki. If you don't, when we push to `your-repo.wiki.git`,
your workflow will fail because the wiki doesn't exist.

<div align="center">

![](https://user-images.githubusercontent.com/61068799/225441831-d3587ceb-0462-4591-bf00-ee56b040fe00.png)

</div>

Create a workflow file named something like `.github/workflows/wiki.yml` and add
a job that uses this action to it! 🎉

```yml
name: Publish wiki
on:
  push:
    branches: [main]
    paths: [wiki/**, .github/workflows/publish-wiki.yml]
concurrency:
  group: wiki
  cancel-in-progress: true
permissions:
  contents: write
jobs:
  wiki:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: spenserblack/actions-wiki@v0.1.1
```

⚠️ Make sure you enable the `content: write` permission! GitHub recently
[changed the default permissions granted to jobs] for new repositories.

☁️ If you're pushing to a wiki that's **not the current repository** you'll need
to get a [GitHub PAT] to push to it.

### Options

- **`repository`:** The repository housing the wiki. Use this if you're
  publishing to a wiki that's not the current repository. You _can include a
  domain prefix_ if you have a hosted GitHub instance that you want to push to.
  Default is `${{ github.repository }}` with the implicit `github.com` domain.

- **`token`:** `${{ github.token }}` is the default. This token is used when
  cloning and pushing wiki changes.

- **`wiki-directory`:** The directory to use for your wiki contents. Default:
  `.github/wiki`.

- **`commit-message`:** The message to use when committing new content. Default
  is `Update wiki ${{ github.sha }}`. You probably don't need to change this,
  since this only applies if you look _really closely_ in your wiki.

## Alternatives

There are quite a few GitHub wiki publishing actions on the [GitHub Actions
marketplace]. There are, however, two that stick out. The
[newrelic/wiki-sync-action] is a good choice for if you need bidirectional
synchronization when someone edits the live wiki. This can be beneficial for
less-technical contributors. There's also [Andrew-Chen-Wang/github-wiki-action]
which is a direct competitor to this project. Specifically, it offers more
automagic ✨ features in exchange for more complexity.

📚 If you're interested in more discussion of alternatives, check out [#4].

<!-- prettier-ignore-start -->
[newrelic/wiki-sync-action]: https://github.com/newrelic/wiki-sync-action#readme
[Andrew-Chen-Wang/github-wiki-action]: https://github.com/Andrew-Chen-Wang/github-wiki-action#readme
[#4]: https://github.com/spenserblack/actions-wiki/issues/4
[PAT]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[GitHub PAT]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[changed the default permissions granted to jobs]: https://github.blog/changelog/2023-02-02-github-actions-updating-the-default-github_token-permissions-to-read-only/
<!-- prettier-ignore-end -->
