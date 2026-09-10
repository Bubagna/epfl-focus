# EPFL Focus

A study timer that builds something from your own course material while you stay on it.

Pick a course, turn the dial, and a specimen starts growing: a silicon unit cell, a five-stage
pipeline, a CMOS inverter layout, a current mirror, an oak. **Every 20 minutes of study adds one
new, named part** — the app tells you which one, so the progress bar doubles as a revision aid.
A specimen is finished after 180–300 minutes and goes to your collection.

Whenever the app is not on screen the clock stops, so there is nothing to gain by leaving.

## Courses

| Code | Course | Specimens |
|---|---|---|
| CS-473 | System programming for SoC | 5-stage pipeline · GECKO5 SoC |
| CS-472 | Design technologies for integrated systems | AND-inverter graph · Binary decision diagram |
| EE-411 | Fundamentals of inference and learning | Central limit theorem · Gradient descent |
| EE-557 | Semiconductor devices I | Silicon crystal · MOSFET cross-section |
| EE-429 | Fundamentals of VLSI design | CMOS inverter layout · Clock H-tree |
| EE-424 | Fundamentals of analog VLSI design | Current mirror · Two-stage OTA |
| HUM-428 | Science, technology and environment | Oak · Wind farm |
| — | Anything else | Bonsai · Fern |

## Install it

Open the page in Safari on iPhone, then **Share → Add to Home Screen**. After the first load a
service worker keeps everything on the phone, so it opens with no network.

For the app to actually stop you leaving, turn on **Guided Access**
(Settings → Accessibility → Guided Access), then triple-click the side button once the session
has started. No app on iOS can block another one by itself.

## What it stores

Everything lives in `localStorage` on your phone and never leaves it. There is no account, no
analytics and no server. Settings → Backup copies the whole thing as JSON.

## Hacking on it

One file, no dependencies, no build step: `index.html`. A species is a function that emits
primitives tagged with the stage they belong to — see `spSiCrystal` for the pattern, and add a
row to `SPECIES`. Bump `CACHE` in `sw.js` whenever a file changes, or phones keep the old copy.
