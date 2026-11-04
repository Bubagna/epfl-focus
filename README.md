# Grove

A focus timer that grows a tree while you stay on it.

Pick a tree, turn the dial, tap Start. The tree grows from a seed (sprout, sapling, trunk,
branches, crown, then flowers or fruit), and when the time is up it is planted in your forest.
The longer the session, the bigger the tree. Stop early, or leave the app, and that session
plants nothing; nothing already in the forest is ever lost.

## Trees

Oak, Pine, Cherry blossom, Birch and Palm are there from the start. Apple tree, Maple, Willow and
Jacaranda cost 300 coins each, and every focused minute is one coin. **Surprise me** picks a
different tree for every session.

## Install it

Open the page in Safari on iPhone, then **Share → Add to Home Screen**. After the first load a
service worker keeps everything on the phone, so it opens with no network.

For the app to actually stop you leaving, turn on **Guided Access**
(Settings → Accessibility → Guided Access), then triple-click the side button once the session
has started. No app on iOS can block another one by itself.

## What it stores

Sessions, the forest, coins and settings live in `localStorage` on your phone and never leave it.
Settings → Backup copies everything as JSON.

## Hacking on it

One file, no dependencies, no build step: `index.html`. A tree is a function that emits
primitives tagged with the stage they belong to — see `trOak` for the pattern, and add a row to
`TREES`. Bump `CACHE` in `sw.js` and `BUILD` in `index.html` whenever a file changes, or phones
keep the old copy.
