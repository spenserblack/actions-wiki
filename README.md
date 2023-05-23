# Publish to GitHub wiki action

[![Test](https://github.com/spenserblack/actions-wiki/actions/workflows/test.yml/badge.svg)](https://github.com/spenserblack/actions-wiki/actions/workflows/test.yml)

📖 Deploy docs from your source tree to the GitHub wiki

<div align="center">

![](https://user-images.githubusercontent.com/61068799/231881220-2915f956-dbdb-4eee-8807-4eba9537523f.png)

</div>

🌐 Works across repositories (with a [PAT]) \
📚 Pretty interface for Markdown docs \
⤴️ Lets you open PRs for wiki docs \
💻 Supports `runs-on: windows-*`

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

Add a GitHub Actions workflow file to your `.github/workflows/` folder similar
to the example shown below.

```yml
name: Publish wiki
on:
  push:
    branches: [main]
    paths:
      - wiki/**
      - .github/workflows/publish-wiki.yml
concurrency:
  group: publish-wiki
  cancel-in-progress: true
permissions:
  contents: write
jobs:
  publish-wiki:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: spenserblack/actions-wiki@v1
```

☝ This workflow will mirror the `wiki/` folder in your GitHub repository to the
`user/repo.wiki.git` Git repo that houses the wiki documentation! You can use
any of the [supported markup languages] like MediaWiki, Markdown, or AsciiDoc.

🔑 In order to successfully push to the `.wiki.git` Git repository that backs
the wiki tab, we need the `contents: write` permission! Make sure you have
something like shown above either for your entire workflow, or just for one
particular job. This will give the auto-generated `${{ github.token }}` that we
use by default permission to push to the `.wiki.git` repo of the repository that
the action runs on.

<img align="right" alt="Screenshot of 'Create the first page' button" src="https://i.imgur.com/ABKIS4h.png" />

⚠️ You must create a dummy page manually! This is what initially creates the
GitHub wiki Git-based storage backend that we then push to in this Action.

After creating your workflow file, now all you need is to put your Markdown
files in a `wiki/` folder (or whatever you set the `path` option to) and commit
them to your default branch to trigger the workflow (or whatever other trigger
you set up).

💡 Each page has an auto-generated title. It is derived from the filename by
replacing every `-` (dash) character with a space. Name your files accordingly.
The `Home.md` file will automatically become the homepage, not `README.md`. This
is specific to GitHub wikis.

### Options

- **`strategy`:** Select from `clone` or `init` to determine which method to use
  to push changes to the GitHub wiki. `clone` will clone the `.wiki.git` repo
  and add an additional commit. `init` will create a new repo with a single
  commit and force push to the `.wiki.git`. `init` involves a force-push! The
  default is `clone`.

- **`repository`:** The repository housing the wiki. Use this if you're
  publishing to a wiki that's not the current repository. You can change the
  GitHub server with the `github-server-url` input. Default is
  `${{ github.repository }}`.

- **`github-server-url`:** An alternate `https://github.com` URL, usually for
  GitHub Enterprise deployments under your own domain. Default is
  `${{ github.server_url }}` (usually `https://github.com`).

- **`token`:** `${{ github.token }}` is the default. This token is used when
  cloning and pushing wiki changes.

- **`path`:** The directory to use for your wiki contents. Default `wiki/`.

- **`commit-message`:** The message to use when committing new content. Default
  is `Update wiki ${{ github.sha }}`. You probably don't need to change this,
  since this only applies if you look really closely in your wiki.

- **`ignore`:** A multiline list of files that should be ignored when committing
  and pushing to the remote wiki. Each line is a pattern like `.gitignore`. Make
  sure these paths are relative to the path option! The default is none.

- **`dry-run`:** Whether or not to actually attempt to push changes back to the
  wiki itself. If this is set to `true`, we instead print the remote URL and do
  not push to the remote wiki. The default is `false`. This is useful for
  testing.

#### `strategy:` option

There are some specific usecases where using `strategy: init` might be better
than the default `strategy: clone`.

1. **Your wiki is enormous.** And I don't mean in terms of text. Text is nothing
   compared with images. If your wiki has a lot of included images, then you
   probably don't want to store the complete history of those large binary
   files. Instead, you can use `strategy: init` to create a single commit each
   time.

2. **You prefer the "deploy" semantics.** If you just like the feel of having
   your GitHub wiki act more like GitHub Pages, that's great! You can `--force`
   push using `strategy: init` on each wiki deployment and none of that pesky
   history will be saved.

### Preprocessing

You may wish to strip the `[link](page.md)` `.md` suffix from your links to make
them viewable in GitHub source view (with the `.md`) _as well as_ in GitHub wiki
(without the `.md`; pretty URLs!). You can use a preprocessing action like
[Strip MarkDown extensions from links action] to remove those `.md` suffixes
before using this action. Here's an example:

```yml
publish-wiki:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v3
    - uses: impresscms-dev/strip-markdown-extensions-from-links-action@v1.0.0
      with:
        path: wiki
    - uses: spenserblack/actions-wiki@v1
```

❤️ If you have an awesome preprocessor action that you want to add here, let us
know! We'd love to add an example.

### Cross-repo wikis

You _can_ use this action to deploy your octocat/mega-docs repository to the
octocat/mega-project repository's wiki tab! You just need to:

1. Create a custom GitHub Personal Access Token with the permissions to push to
   the octocat/mega-project repository. That's the target repo where your wiki
   pages will be pushed to the `.wiki.git`.
2. In the octocat/mega-docs repo (the source code for the wiki), you need to set
   the `repository:` option to `repository: octocat/mega-project` to tell the
   action to push there.
3. You need to set the `token:` option to the Personal Access Token that you
   created with the ability to push to the wiki Git repo. You can use repository
   secrets for this! Something like `token: ${{ secrets.MY_TOKEN }}` is good!

Here's an example of the octocat/mega-docs repo that will push the contents of
the root folder (`./`) to the octocat/mega-project repo's wiki tab!

```yml
on:
  push:
    branches: [main]
jobs:
  publish-wiki:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: spenserblack/actions-wiki@v1
        with:
          token: ${{ secrets.MEGA_PROJECT_GITHUB_TOKEN }}
          repository: octocat/mega-project
          path: .
```

## Alternatives

There are quite a few GitHub wiki publishing actions on the [GitHub Actions
marketplace]. There are, however, two that stick out. The
[newrelic/wiki-sync-action] is a good choice for if you need bidirectional
synchronization when someone edits the live wiki. This can be beneficial for
less-technical contributors. There's also [Andrew-Chen-Wang/github-wiki-action]
which is a direct competitor to this project.

📚 If you're interested in more discussion of alternatives, check out [#4].

## Development

![YAML](https://img.shields.io/static/v1?style=for-the-badge&message=YAML&color=CB171E&logo=YAML&logoColor=FFFFFF&label=)
![Bash](https://img.shields.io/static/v1?style=for-the-badge&message=Bash&color=4EAA25&logo=GNU+Bash&logoColor=FFFFFF&label=)

This is a GitHub Action, so we inevitably use YAML[^1]. Make sure you quote the
right things! To test 🧪 the action, the current workflow is to open a PR and
then have the [`test.yml`] workflow run a `dry-run: true` iteration to
(hopefully) spot any flaws.

To get a better handle on the contribution process, check out our handy
[contributing guide]. Happy coding! 👋

<!-- prettier-ignore-start -->
[newrelic/wiki-sync-action]: https://github.com/newrelic/wiki-sync-action#readme
[Andrew-Chen-Wang/github-wiki-action]: https://github.com/Andrew-Chen-Wang/github-wiki-action#readme
[#4]: https://github.com/spenserblack/actions-wiki/issues/4
[PAT]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[github actions marketplace]: https://github.com/marketplace?type=actions
[contributing guide]: https://github.com/spenserblack/actions-wiki/blob/main/CONTRIBUTING.md
[`test.yml`]: https://github.com/spenserblack/actions-wiki/blob/main/.github/workflows/test.yml
[^1]: https://earthly.dev/blog/intercal-yaml-and-other-horrible-programming-languages/
[supported markup languages]: https://github.com/github/markup#markups
[Strip MarkDown extensions from links action]: https://github.com/marketplace/actions/strip-markdown-extensions-from-links-action
<!-- prettier-ignore-end -->
