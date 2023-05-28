import { exec } from "@actions/exec";

/**
 * Check if the repository changes.
 */
export async function isDirty(cwd: string): Promise<boolean> {
  let output = "";
  const options = {
    cwd,
    listeners: {
      stdout: (data: Buffer) => {
        output = data.toString();
      },
    },
  };
  await exec("git", ["status", "--porcelain"], options);
  return output.trim().length > 0;
}
