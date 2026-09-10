/* Service worker: the app must open with no network at all.
   Bump CACHE on every file change, otherwise the phone keeps
   serving the old version. */
const CACHE = 'epflfocus-v4-9';
const ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './fonts/fraunces-latin.woff2',
  './fonts/karla-latin.woff2',
  './icons/icon-180.png',
  './icons/icon-512.png',
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;

  // navigation: network first (to pick up updates), then the local copy
  if (req.mode === 'navigate'){
    e.respondWith(
      fetch(req)
        .then(res => { const copy = res.clone(); caches.open(CACHE).then(c => c.put('./index.html', copy)); return res; })
        .catch(() => caches.match('./index.html'))
    );
    return;
  }

  e.respondWith(
    caches.match(req).then(hit => hit || fetch(req).then(res => {
      if (res.ok && new URL(req.url).origin === location.origin){
        const copy = res.clone();
        caches.open(CACHE).then(c => c.put(req, copy));
      }
      return res;
    }).catch(() => new Response('', {status:504, statusText:'offline'})))
  );
});
