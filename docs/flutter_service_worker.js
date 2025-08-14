'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "0db33dd5b041a7e461c190a4f5e7ba40",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "66b94948f32db0baa94dfe9bbf805b30",
"version.json": "f71c081e3c0236be0be8a60d39fd648f",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js": "a7d569ac9fd44a668c06d8b1bc30320c",
"index.html": "655edd200268cf1116e0d70475b329b7",
"/": "655edd200268cf1116e0d70475b329b7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "51e9dc14c10b983cac84a1ec03c75757",
"assets/NOTICES": "a73595f878e980ab34ac8dfef765f2ed",
"assets/AssetManifest.json": "672fde7e4c37f0a73930635be26e20ad",
"assets/AssetManifest.bin": "8e929f041c0a1a66779c0dbfc9d712c7",
"assets/AssetManifest.bin.json": "c617d3506cd092fc8ccad5412f380d9f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "34db80c9cdee648e4402cb2c899379a0",
"assets/assets/images/tokens/token_success.png": "b07812e5d43e9c161ae244f149363dc8",
"assets/assets/images/tokens/token_fail.png": "0c7960c45d16e91f4088ab033630d7fa",
"assets/assets/images/tokens/token_hidden.png": "7d6797f161c73f08c817feaa4e4cc7e5",
"assets/assets/images/textures/parchment.png": "f5bcfae83085686c437962dc59f54452",
"assets/assets/images/textures/filigree.png": "310d1f35bb2b79a5aef423c9d0c229ce",
"assets/assets/images/textures/border.png": "3e7436afacedae75e3f58df0035377e8",
"assets/assets/images/textures/wood_plank_full.png": "c356fce9758319d94249f149a15387eb",
"assets/assets/images/textures/stone_wall.png": "8a3adeabb01c38f2b1357b5efbe29ec6",
"assets/assets/images/textures/wood_panel.png": "b1914d2e2b636b341de93b85e273c7a7",
"assets/assets/images/roles/role_assassin.png": "5a451f6352b46b6af68b51089303e02d",
"assets/assets/images/roles/role_oberon.png": "b6a50a7c5faf5aad1b48d8f7d5152fc3",
"assets/assets/images/roles/role_mordred.png": "14017e9d1e6e91928f4c106caec31e8e",
"assets/assets/images/roles/role_loyal.png": "4a67fd46ff29946f1cfbc22351a6ffb0",
"assets/assets/images/roles/role_percival.png": "6056096be7329c4094a315c729777607",
"assets/assets/images/roles/role_merlin.png": "d18e7adaf5d79cd4f5d825b82fab6d61",
"assets/assets/images/roles/role_morgana.png": "a399cb8fda8cf8ece9db388cc3f0df21",
"assets/assets/images/roles/role_minion.png": "3deb0f22911881cfe36ab67443fbbade",
"assets/assets/images/icons/home_icon_start.png": "7c3abb8528fc594036a10a0f884dc8f1",
"assets/assets/images/icons/icon_view.png": "1241b1cd818deead945a01d7f60133b2",
"assets/assets/images/icons/avatar_placeholder.png": "84b636e82009b1333ff3eb84e950503a",
"assets/assets/images/icons/home_logo_shield.png": "ab2102d7a6ae3d1c6594e35ae4cbacc0",
"assets/assets/images/icons/home_icon_rules.png": "983eb0b2e14ac77b1d2965f99963aa80",
"assets/assets/images/icons/icon_list.png": "e1221bb4204c220e5584895baf860b24",
"assets/assets/images/icons/home_logo.png": "b76b5a579d083ba7ec78d405db2873d7",
"assets/assets/images/card_fail.png": "7003e0559e31fbcb001d65755f8d1dc9",
"assets/assets/images/buttons/btn_primary_copper.png": "a23ec09f72c704dc3cf23244dc1ff3f8",
"assets/assets/images/buttons/btn_primary_copper_disabled.png": "428e4cd44f6c588bfc57bbe2cba1c97e",
"assets/assets/images/round_tokens/green_5.png": "7b0fe9b4d14b27d47e2a305a5e4f3178",
"assets/assets/images/round_tokens/grey_1.png": "6e96e54f586b462f70211015a499d58a",
"assets/assets/images/round_tokens/grey_4.png": "7b799697d1896f96c65056a841bc2ce0",
"assets/assets/images/round_tokens/green_1.png": "ea9ea6eea0b989cff882efd10560ccdf",
"assets/assets/images/round_tokens/red_5.png": "c0259ff4cbe5a1137f1ccc02ddb63907",
"assets/assets/images/round_tokens/green_3.png": "dbbf389ce5380ec9c24b3a315c9b03b3",
"assets/assets/images/round_tokens/grey_5.png": "8a73d571f66b5f76e9c9f73b30daba7b",
"assets/assets/images/round_tokens/grey_3.png": "21a038412a4a27ce43eb967101423458",
"assets/assets/images/round_tokens/grey_2.png": "eeb3e7b285dee4c3771d6a253f45aaa6",
"assets/assets/images/round_tokens/green_2.png": "61b4667ce7d0030b68396ebe9d036821",
"assets/assets/images/round_tokens/red_3.png": "7d352296be2fdd241217fd6b4fa2b42f",
"assets/assets/images/round_tokens/red_1.png": "59bd2988abfb188b368dfe796ca9ad13",
"assets/assets/images/round_tokens/green_4.png": "5bf74b0462ca6d83a2d17bc21936b2ac",
"assets/assets/images/round_tokens/red_4.png": "2920f9e0a4bcfab554b68fc60cd4ad5b",
"assets/assets/images/round_tokens/red_2.png": "dee8711cd5ed87dc446e75a1f64c10bc",
"assets/assets/images/cards/card_front_placeholder.png": "f75ec03597a0cf609ccea62653a5726a",
"assets/assets/images/cards/card_back.png": "8142ba4861821a0523c45ed2beb449de",
"assets/assets/images/card_success.png": "6188be3b0f7abeadf21c74bcad27f729",
"assets/assets/images/plaques/wood_plaque_light.png": "de2e786f0e26738a23bb9b69f2658062",
"assets/assets/images/plaques/wood_plaque_dark.png": "49d9105aac11fdb08594e5ec51c1ece2",
"assets/assets/images/decor/banner_scroll_small.png": "7794e16c007891acfab0beb7368d1899",
"assets/assets/fonts/MedievalSharp-Regular.ttf": "ab74758f51f45a89eb47d5dca0b3580e",
"assets/assets/fonts/Merriweather-Regular.ttf": "87f9ea30149ce06b186fae508014e267"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
