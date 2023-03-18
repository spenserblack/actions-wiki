# Publish to GitHub wiki action

📖 Deploy docs from your source tree to the GitHub wiki

## Features

🌐 Works across repositories (with a [PAT]) \
📚 Pretty interface for Markdown docs \
⤴️ Lets you open PRs for wiki docs \
💻 Supports `runs-on: windows-*`

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub wiki](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+wiki&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

Getting started is easy! Just create a GitHub Actions workflow file that uses
spenserblack/actions-wiki and you're good to go! 🚀 Here's a ready-made example
to help you blast off:

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
        with:
          # Whatever directory you choose will be mirrored to the GitHub
          # .wiki.git. The default is .github/wiki.
          wiki-directory: wiki
          # For now, you'll need to manually specify a GitHub token until we
          # solve #2. The x: prefix is a dummy username.
          token: x:${{ secrets.GITHUB_TOKEN }}
```

<img align="right" alt="Screenshot of 'Create the first page' button" src="https://i.imgur.com/ABKIS4h.png" />

❗ Make sure you turn on the GitHub wiki feature in your repo's settings menu.
You'll also need to _manually_ create a dummy page to initialize the git repo
that powers the GitHub wiki. If you don't, when we push to `your-repo.wiki.git`,
your workflow will fail because the wiki doesn't exist.

⚠️ You'll need to remember to enable the `contents: write` permission! GitHub
recently [changed the default permissions granted to jobs] for new repositories.

### Publishing to a different repository

If you're pushing to a wiki that's **not the current repository** you'll need to
get a [GitHub PAT] to push to it. The default `${{ secrets.GITHUB_TOKEN }}`
won't cut it! You can [generate a PAT] in your GitHub Settings.

For example, if you created octocat/gigantic-mega-project-wiki to hold the wiki
and you want to publish it to the GitHub wiki that belongs to _another
repository_ like octocat/gigantic-mega-project, you'd use a step like this in
one of your GitHub Actions workflows.

```yml
- uses: spenserblack/actions-wiki@v0.1.1
  with:
    wiki-directory: .
    # Notice that we use a github.com/ prefix here to support enterprise GitHub
    # deployments on other domains.
    repository: github.com/octocat/gigantic-mega-project
    # Make sure this token has the appropriate push permissions!
    token: x:${{ secrets.GIGANTIC_MEGA_PROJECT_GITHUB_TOKEN }}
```

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
which is a direct competitor to this project. It offers more automatic features,
but has more complex configuration. It also [doesn't support `runs-on:
windows-*`].

📚 If you're interested in more discussion of alternatives, check out [#4].

<!-- prettier-ignore-start -->
[newrelic/wiki-sync-action]: https://github.com/newrelic/wiki-sync-action#readme
[Andrew-Chen-Wang/github-wiki-action]: https://github.com/Andrew-Chen-Wang/github-wiki-action#readme
[#4]: https://github.com/spenserblack/actions-wiki/issues/4
[PAT]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[GitHub PAT]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[changed the default permissions granted to jobs]: https://github.blog/changelog/2023-02-02-github-actions-updating-the-default-github_token-permissions-to-read-only/
[github actions marketplace]: https://github.com/marketplace?type=actions
[generate a pat]: https://github.com/settings/tokens?type=beta
[doesn't support `runs-on: windows-*`]: https://github.com/Andrew-Chen-Wang/github-wiki-action/discussions/28
<!-- prettier-ignore-end -->
