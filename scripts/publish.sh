#!/usr/bin/env bash
# Publish the current working tree as ONE commit on the Pages source branch.
# This rewrites public git history on that branch. Only run after:
#   1. A private backup repo exists (see scripts/backup-history.sh)
#   2. You have reviewed the rebuilt site
#
# Usage (from repo root, on the branch you want to publish):
#   BACKUP_OK=1 ./scripts/publish.sh
#
# Optional:
#   SOURCE_BRANCH=master REMOTE=origin BACKUP_OK=1 ./scripts/publish.sh
set -euo pipefail

REMOTE="${REMOTE:-origin}"
SOURCE_BRANCH="${SOURCE_BRANCH:-master}"
MESSAGE="${MESSAGE:-Publish site}"

if [[ "${BACKUP_OK:-}" != "1" ]]; then
  echo "Refusing to rewrite history."
  echo "A private backup of the old commits must already exist."
  echo "Create it with:  ./scripts/backup-history.sh"
  echo "Then confirm and re-run:  BACKUP_OK=1 ./scripts/publish.sh"
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash first."
  git status --porcelain
  exit 1
fi

ROOT="$(git rev-parse --show-toplevel)"
cd "${ROOT}"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
ORPHAN_BRANCH="publish-orphan-$$"

echo "Publishing tree from ${CURRENT_BRANCH} as a single commit on ${SOURCE_BRANCH}..."

git checkout --orphan "${ORPHAN_BRANCH}"
git add -A
git commit -m "${MESSAGE}"
git branch -M "${SOURCE_BRANCH}"
git push --force "${REMOTE}" "${SOURCE_BRANCH}:${SOURCE_BRANCH}"

echo
echo "Force-pushed a single commit to ${REMOTE}/${SOURCE_BRANCH}."
echo "GitHub Actions will rebuild gh-pages from this tree (single-commit deploy)."
echo "Confirm the live site at https://pixelryan.github.io/ after the workflow finishes."
