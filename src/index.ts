import * as core from "@actions/core";
import { exec } from "@actions/exec";
import { hasWiki } from "./has-wiki";
import { isDirty } from "./is-dirty";

// TODO: Create (push) commit via the API?
//      https://docs.github.com/en/rest/git/commits?apiVersion=2022-11-28#create-a-commit
async function run() {
  const token = core.getInput("token", { required: true });
  const repository = core.getInput("repository", { required: true });
  const path = core.getInput("path", { required: true });
  const commitMessage = core.getInput("commit-message", { required: true });
  const dryRun = core.getBooleanInput("dry-run", { required: true });
  const user = process.env["GITHUB_ACTOR"] || "github-actions[bot]";
  const wikiRemote = `https://${user}:${token}@${repository}.wiki.git`;
  if (!(await hasWiki(wikiRemote))) {
    core.notice('You must enable the wiki and add an initial page.');
    core.setFailed("Wiki repository not found");
    return;
  }

  const cwd = path;
  const baseOptions = { cwd };
  await exec("git", ['init'], baseOptions);
  await exec('git', ['config', '--local', 'user.name', 'github-actions[bot]'], baseOptions);
  await exec('git', ['config', '--local', 'user.email', 'github-actions[bot]@users.noreply.github.com'], baseOptions);
  await exec('git', ['remote', 'add', 'wiki', wikiRemote], baseOptions);
  await exec('git', ['fetch', 'wiki'], baseOptions);
  await exec('git', ['reset', 'wiki/master'], baseOptions);

  if (!(await isDirty(cwd))) {
    core.info('No changes detected. Will not commit or push.');
    return;
  }

  await exec('git', ['add', '--all'], baseOptions);
  await exec('git', ['commit', '-m', commitMessage], baseOptions);

  if (dryRun) {
    await exec('git', ['remote', 'show', 'wiki'], {
      ...baseOptions,
      listeners: {
        stdout: (data: Buffer) => {
          core.info(data.toString());
        },
      },
    });
    await exec('git', ['show'], {
      ...baseOptions,
      listeners: {
        stdout: (data: Buffer) => {
          core.info(data.toString());
        },
      },
    });
    core.info('Dry run enabled. Will not push.');
    return;
  }

  await exec('git', ['push', 'wiki', 'HEAD:master'], baseOptions);

  // NOTE: Cleanup
  await exec('rm', ['-rf', '.git'], baseOptions);
}

run().catch((error) => {
  core.setFailed(error.message);
});
