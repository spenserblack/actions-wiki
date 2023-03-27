# shellcheck shell=bash

git_exists() (
  set -e

  if git ls-remote -h "$1" &>/dev/null; then
    echo "$1"
    return 0
  else
    echo "$(basename "$0"): $1 is not a Git repository" >&2
    return 1
  fi
)
