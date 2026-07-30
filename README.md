# sethmartinez.com

Source for <https://www.sethmartinez.com> — a single-page holding site for the domain reserved
for **Seth Martinez**.

The page says the domain is reserved and nothing else. There is deliberately no
information about the person on it: no biography, no photos, no links, no social profiles.
It ships `noindex` and a `Disallow: /` robots file. When Seth Martinez wants a real site
here, this gets replaced wholesale — that's the point of it.

One hand-written HTML page with Tailwind-compiled CSS. No framework, no bundler, no
static-site generator, no CMS. It renders fully with JavaScript disabled.

## Requirements

- Node.js 22 or newer

## Getting started

```sh
npm ci
npm run dev
```

`npm run dev` starts the Tailwind CLI in watch mode alongside a static server with live
reload at <http://localhost:3000>.

## Scripts

| Script          | What it does                                                       |
| --------------- | ------------------------------------------------------------------ |
| `npm run dev`   | Watch CSS + serve `src/` with live reload on port 3000             |
| `npm run build` | Compile minified CSS, then assemble `_site/` (the deploy artifact) |
| `npm run clean` | Remove `_site/` and the generated `src/styles.css`                 |

## Layout

Everything under `src/` ships; nothing outside it does. `styles/tailwind.css` is the
Tailwind v4 entry point and stays out of `src/`. `CNAME` binds the custom domain and is
copied into the build artifact.

## Deploying

Pushing to `main` builds and publishes to GitHub Pages via
`.github/workflows/deploy.yml`. Nothing else is needed.

## House rules

See [`AGENTS.md`](AGENTS.md) — it is short, and the constraints in it are the whole reason
this repo stays this small. Generated from
[`reserved-domain-placeholder`](https://github.com/brandonmartinez/reserved-domain-placeholder).
