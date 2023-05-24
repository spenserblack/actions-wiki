import { exec } from "@actions/exec";

/**
 * Check if a wiki repository exists for the current repository.
 */
export async function hasWiki(wikiRemote: string): Promise<boolean> {
  // TODO: The repos/OWNER/REPO API endpoint has a `has_wiki` value that might be preferable
  //       to this method.
  const exitCode = await exec("git", ["ls-remote", wikiRemote], {
    ignoreReturnCode: true,
  });
  return exitCode === 0;
}
