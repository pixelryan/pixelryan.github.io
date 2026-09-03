# Ryan Dormanesh — pixelryan.github.io

Public portfolio for Associate Producer / Production Coordinator work, with QA Lead as the second lane. Live site: [https://pixelryan.github.io/](https://pixelryan.github.io/).

The site still uses [al-folio](https://github.com/alshedivat/al-folio) (Jekyll). Content and styling were rebuilt for hiring managers; the theme was not replaced.

## History backup (do this before any rewrite)

Strangers should not be able to browse years of tiny commits. Before replacing public history, copy **all branches and tags** into a **private** archive repo owned by `pixelryan`.

Suggested name: [`pixelryan/pixelryan.github.io-history-backup`](https://github.com/pixelryan/pixelryan.github.io-history-backup).

```bash
./scripts/backup-history.sh
gh repo view pixelryan/pixelryan.github.io-history-backup
```

That script creates the private repo (if needed) and `git push --mirror`s the full history. Leave the backup repo alone after that. Do not rewrite it.

A Cursor cloud agent **cannot** create that private repo: the GitHub App token is scoped to this site repo and returns `403 createRepository`. Until you run the script while logged in as `pixelryan`, a full `git bundle` of the pre-rebuild history (master + gh-pages, 229 commits, 2026-09-03) is the offline archive.

Restore a bundle later with:

```bash
git clone --mirror pixelryan.github.io-full-history-YYYYMMDD.bundle restored.git
```

## Publish future updates as one commit

Pages source branch is `master`. GitHub Actions builds Jekyll and deploys to `gh-pages` (the branch Pages actually serves). Deploy is configured with `single-commit: true` so `gh-pages` does not accumulate old built trees.

After you are happy with changes on a working branch:

```bash
# 1. Backup must already exist
./scripts/backup-history.sh

# 2. Merge or check out the tree you want live, then:
BACKUP_OK=1 ./scripts/publish.sh
```

`publish.sh` creates an orphan branch from the current tree, commits it once, and force-pushes `master`. It refuses to run unless `BACKUP_OK=1`.

If force-push is blocked on this machine, run the same steps locally:

```bash
git checkout --orphan publish-orphan
git add -A
git commit -m "Publish site"
git branch -M master
git push --force origin master
```

## Keep the live site public

GitHub Pages from a **private** user repo requires GitHub Pro (or higher). This account’s billing plan could not be read from the agent token. Every visible `pixelryan` repo is public, so **do not make `pixelryan.github.io` private** unless you have confirmed Pro and then confirmed [https://pixelryan.github.io/](https://pixelryan.github.io/) still serves. A private repo on Free unpublishes the site.

## Local preview

```bash
docker compose up
# or: bundle exec jekyll serve
```

Then open [http://localhost:8080](http://localhost:8080) (Docker) or the Jekyll port printed by `jekyll serve`.
