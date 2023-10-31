import { getExecOutput, ExecOptions } from '@actions/exec';

export async function execWithErrorCheck(
  commandLine: string,
  arguments_?: string[],
  options?: ExecOptions,
  errorWhenMissingUnityBuildResults: boolean = true,
): Promise<number> {
  const result = await getExecOutput(commandLine, arguments_, options);

  if (!errorWhenMissingUnityBuildResults) {
    return result.exitCode;
  }

  // Check for errors in the Build Results section
  const match = result.stdout.match(/^#\s*Build results\s*#(.*)^Size:/ms);

  if (!match) {
    throw new Error(`There was an error building the project. Please read the logs for details.`);
  }

  return result.exitCode;
}
