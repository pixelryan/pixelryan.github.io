#!/usr/bin/env bash
# Create a PRIVATE full-history backup of this GitHub Pages repo.
# Run this from a machine logged into GitHub as pixelryan (gh auth login).
# The Cursor/GitHub App token cannot create repositories, so this step is manual.
set -euo pipefail

OWNER="${OWNER:-pixelryan}"
SOURCE_REPO="${SOURCE_REPO:-${OWNER}/pixelryan.github.io}"
BACKUP_REPO="${BACKUP_REPO:-${OWNER}/pixelryan.github.io-history-backup}"
WORKDIR="${WORKDIR:-$(mktemp -d /tmp/pixelryan-history-backup.XXXXXX)}"

echo "Backup repo: ${BACKUP_REPO}"
echo "Work dir:    ${WORKDIR}"

if gh repo view "${BACKUP_REPO}" >/dev/null 2>&1; then
  echo "Backup repo already exists. Will mirror-push into it."
else
  echo "Creating private repo ${BACKUP_REPO}..."
  gh repo create "${BACKUP_REPO}" \
    --private \
    --description "Private full-history archive of ${SOURCE_REPO}. Do not rewrite." \
    --disable-issues \
    --disable-wiki
fi

echo "Mirroring ${SOURCE_REPO} -> ${BACKUP_REPO} (all branches and tags)..."
git clone --mirror "https://github.com/${SOURCE_REPO}.git" "${WORKDIR}/source.git"
git -C "${WORKDIR}/source.git" push --mirror "https://github.com/${BACKUP_REPO}.git"

echo
echo "Confirming backup is private and has commits:"
gh repo view "${BACKUP_REPO}" --json name,visibility,url,defaultBranchRef
git -C "${WORKDIR}/source.git" rev-list --all --count
echo "Done. Leave ${BACKUP_REPO} as the archive. Do not rewrite it."
