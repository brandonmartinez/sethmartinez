# reserved-domain-placeholder

A GitHub **template repository** for the holding pages that sit on personal-name domains
nobody is using yet — one clean card, centred, that says the domain is reserved for
someone and nothing else.

It exists because there are several of these domains and they should not drift apart. The
sites generated from it are byte-identical apart from a name and a domain.

## What the page is (and isn't)

It **is** a name and a statement of intent. It **isn't** a page about a person: no
biography, no photos, no birthday, no town, no social links. Several of these domains
carry the names of minors, so the page ships `noindex` plus a `Disallow: /` robots file
and stays that way. When the person wants a real site, this gets replaced wholesale.

Built on the house static pattern: one hand-written HTML page, Tailwind v4 compiled by the
CLI, published to GitHub Pages by Actions. No framework, no bundler, no JavaScript.

## Spawning a new site

```sh
gh repo create brandonmartinez/sethmartinez \
  --template brandonmartinez/reserved-domain-placeholder \
  --public --clone \
  --description "Holding site for www.sethmartinez.com"

cd sethmartinez
./scripts/personalize.sh "Seth Martinez" sethmartinez.com
npm install && npm run build

git add -A && git commit -m "Hold sethmartinez.com for Seth Martinez"
git push

gh api -X PUT /repos/brandonmartinez/sethmartinez/pages -f build_type=workflow
```

`personalize.sh` stamps the name and domain into `src/index.html`, `CNAME`,
`package.json`, `AGENTS.md`, and the README, swaps the template README for the site one,
and then deletes itself — a generated site shouldn't carry the template machinery.

Then point DNS at GitHub Pages (`www` CNAME to `brandonmartinez.github.io`, apex to the
four Pages A records) and set the custom domain.

## Changing the design

Change it **here first**, then copy the result into the sibling repos. A change made only
downstream is a change the next generated site silently loses.

## The tokens

| Token           | Example         | Appears in                                            |
| --------------- | --------------- | ----------------------------------------------------- |
| `{{FULL_NAME}}` | `Seth Martinez` | `src/index.html`, `AGENTS.md`, README, `package.json` |
| `{{DOMAIN}}`    | `sethmartinez.com` | `src/index.html`, `CNAME`, `AGENTS.md`, README     |

## House rules

See [`AGENTS.md`](AGENTS.md).
