import { exec } from "@actions/exec";
import type { ExecOptions } from "@actions/exec";
import { describe, expect, jest, test } from "@jest/globals";
import { isDirty } from "../src/is-dirty";

jest.mock("@actions/exec", () => {
  const originalModule: object = jest.requireActual("@actions/exec");

  return {
    __esModule: true,
    ...originalModule,
    exec: jest.fn((_commandLine, _args, options: ExecOptions) =>
      options?.listeners?.stdout?.(
        Buffer.from(options?.cwd === "/dirty" ? "?? Foo.md\n" : ""),
      ),
    ),
  };
});

describe("isDirty", () => {
  test("it returns true when there are pending changes", async () => {
    const result = await isDirty("/dirty");
    expect(result).toBe(true);
  });

  test("it returns false when there are no changes", async () => {
    const result = await isDirty("/clean");
    expect(result).toBe(false);
  });
});
