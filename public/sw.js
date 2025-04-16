// public/sw.js

const CACHE_NAME = 'modern-hospital-cache-v1'; // Cambia 'v1' si actualizas el SW
const STATIC_ASSETS = [
    // Lista de archivos estáticos cruciales para cachear siempre
    // Incluye tus layouts básicos, páginas principales, CSS global, JS chunks importantes
    // ¡TEN CUIDADO! No pongas demasiadas cosas o será lento.
    // Las rutas deben ser relativas a la raíz del sitio.
    '/', // La homepage
    '/manifest.json',
    '/app/globals.css', // O la ruta al CSS compilado si la conoces
    // Añade iconos importantes
    '/icons/icon-192x192.png',
    '/icons/icon-512x512.png',
    // Añade imágenes placeholder si son críticas
    '/images/hospital-hero-placeholder.jpg',
    // Añade fuentes si no vienen de Google Fonts (las de Google se cachean automáticamente por el navegador)
];

// Estrategia Network First (Intenta red, si falla, usa caché)
const networkFirst = async (request) => {
    try {
        // 1. Intenta obtener de la red
        const networkResponse = await fetch(request);
        // 2. Si tiene éxito, actualiza la caché y devuelve la respuesta de red
        if (networkResponse.ok) {
            const cache = await caches.open(CACHE_NAME);
            // Clona la respuesta porque se consume al cachearla y al devolverla
            cache.put(request, networkResponse.clone());
        }
        return networkResponse;
    } catch (error) {
        // 3. Si la red falla, intenta obtener de la caché
        console.warn(`Network request failed for ${request.url}. Trying cache...`);
        const cache = await caches.open(CACHE_NAME);
        const cachedResponse = await cache.match(request);
        // Devuelve la respuesta cacheada o una respuesta de error si no está en caché
        return cachedResponse || Response.error(); // O una página offline personalizada
    }
};

// Estrategia Cache First (Usa caché, si no está, va a la red) - Buena para assets estáticos
const cacheFirst = async (request) => {
    const cache = await caches.open(CACHE_NAME);
    const cachedResponse = await cache.match(request);
    if (cachedResponse) {
        return cachedResponse; // Devuelve desde caché si existe
    }
    // Si no está en caché, ve a la red
    try {
        const networkResponse = await fetch(request);
        if (networkResponse.ok) {
            // Guarda en caché para la próxima vez
             cache.put(request, networkResponse.clone());
        }
        return networkResponse;
    } catch (error) {
         console.error(`Failed to fetch ${request.url} from network after cache miss.`);
         return Response.error();
    }
};


// Evento 'install': Cachear assets estáticos iniciales
self.addEventListener('install', (event) => {
    console.log('Service Worker: Installing...');
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('Service Worker: Caching static assets:', STATIC_ASSETS);
            return cache.addAll(STATIC_ASSETS).catch(error => {
                 console.error('Service Worker: Failed to cache static assets during install:', error);
            });
        }).then(() => self.skipWaiting()) // Activa el nuevo SW inmediatamente
    );
});

// Evento 'activate': Limpiar cachés antiguas
self.addEventListener('activate', (event) => {
    console.log('Service Worker: Activating...');
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('Service Worker: Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => self.clients.claim()) // Toma control de las páginas abiertas
    );
});

// Evento 'fetch': Interceptar peticiones
self.addEventListener('fetch', (event) => {
    const request = event.request;

    // Ignorar peticiones que no sean GET
    if (request.method !== 'GET') {
        return;
    }

    const url = new URL(request.url);

    // Usar Cache First para assets estáticos locales (CSS, JS, imágenes, fuentes locales)
    if (url.origin === self.location.origin && (
         request.destination === 'style' ||
         request.destination === 'script' ||
         request.destination === 'image' ||
         request.destination === 'font' ||
         STATIC_ASSETS.includes(url.pathname) // Cachea explícitamente los assets definidos
        )) {
         event.respondWith(cacheFirst(request));
         return;
     }

    // Usar Network First para peticiones de navegación (HTML) y otras
     if (request.mode === 'navigate') {
        event.respondWith(networkFirst(request));
    }

    // Para otras peticiones (ej. API a Appwrite), podrías dejarlas pasar o aplicar NetworkFirst
    // Por simplicidad, las dejamos pasar (el navegador las manejará)
    // Si quieres cachear llamadas API (cuidado con datos obsoletos), usa networkFirst o stale-while-revalidate.

});