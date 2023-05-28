import { exec } from "@actions/exec";
import { describe, expect, jest, test } from "@jest/globals";
import { hasWiki } from "../src/has-wiki";

jest.mock("@actions/exec");
const mockedExec = exec as unknown as jest.Mock<typeof exec>;

describe("hasWiki", () => {
  test("it returns true when the wiki remote exists", async () => {
    mockedExec.mockResolvedValue(0);
    const result = await hasWiki("https://example.com/wiki.git");
    expect(result).toBe(true);
  });

  test("it returns false when the wiki remote does not exist", async () => {
    mockedExec.mockResolvedValue(128);
    const result = await hasWiki("https://example.com/wiki.git");
    expect(result).toBe(false);
  });
});
