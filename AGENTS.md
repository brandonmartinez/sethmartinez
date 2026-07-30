# AGENTS.md

## What this is

A **single-page holding site** for <https://www.{{DOMAIN}}> — a domain reserved for
{{FULL_NAME}}. The page says the domain is reserved and nothing else. That is the whole
product.

It is deliberately, permanently small. If you find yourself adding a section, a nav, a
photo, or a second page, stop: that decision belongs to the person the domain is held for,
not to whoever is editing this repo today.

## Hard NOs

- **No content about the person.** No biography, no photos, no birthday, no school, no
  town, no social links. Several of these domains carry the names of minors. The page
  states a name and nothing more, and it ships `noindex` plus a `Disallow: /` robots file.
  Keep both.
- No web framework (React, Next, Astro, Svelte, Vue). No bundler. No static-site
  generator. No CMS. No second page. No analytics. No fonts fetched from a CDN.
- No JavaScript is required to render this page, and none is used. Keep it that way.

## Dependency budget

Three dev dependencies, total:

| Package            | Why                       |
| ------------------ | ------------------------- |
| `@tailwindcss/cli` | compiles the CSS          |
| `concurrently`     | runs the two dev watchers |
| `browser-sync`     | local dev server + reload |

There are no runtime dependencies and there never should be.

## Layout rule

**Everything under `src/` ships. Nothing outside it does.** The build is literally
`cp -R src/. _site/`.

```
.github/workflows/deploy.yml
src/                  <- ships
  index.html
  robots.txt
  styles.css          <- GENERATED, gitignored
styles/tailwind.css   <- Tailwind entry point, does NOT ship
CNAME                 <- stays at the repo root
_site/                <- GENERATED, gitignored
package-lock.json     <- IS committed
```

Never commit `_site/` or `src/styles.css`. Always commit `package-lock.json`.

## Tailwind is v4

`@tailwindcss/cli`, and `styles/tailwind.css` is just `@import "tailwindcss";` plus
`@source` and `@theme`. There is **no `tailwind.config.js`** — theming (colours, fonts)
goes in the `@theme` block. Most tutorials still show the v3 shape; do not copy it.

## Deploys

Pushing to `main` runs `.github/workflows/deploy.yml`, which builds and publishes to
GitHub Pages. The `permissions` block (`pages: write`, `id-token: write`) is load-bearing —
`deploy-pages` needs the OIDC token. The build job is skipped on a repository flagged as a
template, so the template itself never tries to publish.

## CNAME is load-bearing

`CNAME` at the repo root binds the custom domain. The build copies it into `_site/`.
Deleting or editing it unbinds the domain. Leave it alone.

## URLs

`www.{{DOMAIN}}` is canonical; the apex redirects to it. Every absolute URL — canonical
and `og:*` — uses the `www` form and `https://`. See the vault note `Domains & DNS`.

## This repo has siblings

The same page is held on several personal-name domains, all generated from the
[`reserved-domain-placeholder`](https://github.com/brandonmartinez/reserved-domain-placeholder)
template repo. They are intentionally identical apart from a name and a domain.
**Make a shared design change in the template first**, then copy it across, so the next
site generated from it doesn't regress. A change that only makes sense for this one person
is a sign the domain has outgrown a placeholder — which is good, and means it needs a real
site rather than a tweak to this one.

## Working on it

```sh
npm ci        # install
npm run dev   # http://localhost:3000, rebuilds CSS and reloads on save
npm run build # produces _site/
npm run clean # removes _site/ and src/styles.css
```

Before opening a PR: `npm run build`, then confirm `_site/` contains `index.html`,
`styles.css`, `robots.txt`, and `CNAME`; that the page renders with JavaScript disabled;
and that it has no horizontal overflow at 320px.
