# pixelryan.github.io — notes for agents

Ryan Dormanesh's personal portfolio: a Jekyll site on the [al-folio](https://github.com/alshedivat/al-folio) theme, published to GitHub Pages. His studio site is a separate repo (`pixelryan/funtownarcade`, funtownarcade.com).

## How it publishes

- Push to `master` → the **Deploy site** workflow builds Jekyll and pushes `_site` to the `gh-pages` branch → GitHub Pages serves it.
- Check runs: `gh api "repos/pixelryan/pixelryan.github.io/actions/runs?per_page=10" --jq '.workflow_runs[] | "\(.name): \(.conclusion // .status)"'`. Expected green: Deploy site, Prettier code formatter, Check for broken links, Check for broken links on site.
- If a link check fails, the failing links are posted as annotations: `gh api repos/pixelryan/pixelryan.github.io/check-runs/<job id>/annotations`.

## Where things are

| Path                                               | What it is                                                                                                                                                                         |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `_pages/about.md`                                  | Home page                                                                                                                                                                          |
| `assets/json/resume.json`                          | CV data (rendered by `_layouts/cv.liquid`; only the sections listed under `jsonresume:` in `_config.yml` show)                                                                     |
| `_projects/*.md`                                   | Project pages and cards. `category: professional` or `indie`; `importance` sets order (lower first); `redirect:` makes a card link elsewhere                                       |
| `_config.yml`                                      | Site settings, social links, `jsonresume` sections                                                                                                                                 |
| `nummerge_privacy_policy.md`, `privacypolicy.html` | App privacy policies linked from the app stores. **Never rename or move them.** NumMerge's official copy is funtownarcade.com/nummergeprivacy; keep this one identical in content. |

## Gotchas

- **`resume.json` must be pure ASCII.** Write it with `json.dumps(..., ensure_ascii=True)` (escapes like `·`). Non-ASCII breaks loading in some environments and the CV renders empty.
- **Prettier:** CI runs Prettier **3.1.1** (pinned in `package.json`) with `@shopify/prettier-plugin-liquid`. Format with that exact version; newer versions format `.liquid` files differently and the check fails.
- **Images:** `jekyll-imagemagick` generates `.webp` variants; the workflows install ImageMagick because `ubuntu-latest` doesn't ship it. Don't remove that step or images break.
- **Ruby:** workflows use `ruby-version: "3.2"` (patch-pinned versions disappear from new runner images).
- **Links:** use absolute URLs (`https://pixelryan.github.io/cv/`) in Markdown; the source link checker can't resolve root-relative links. Template docs (CUSTOMIZE, INSTALL, FAQ, CONTRIBUTING) are excluded from the check.
- **Local build:** `bundle install`, then `bundle exec jekyll build`. The Jupyter plugin needs a `jupyter` command; a stub that prints `<div></div>` is enough locally.

## Rules

- Facts must match Ryan's résumé; don't invent roles, dates, credits, or metrics. Ask him.
- Captions/alt text describe what's actually in each image.
- Contact email shown publicly: contact@funtownarcade.com. Location: Washington State (no city).
- Commit as `Ryan Dormanesh <3446287+pixelryan@users.noreply.github.com>`. This repo is public: keep commit messages and files professional.
