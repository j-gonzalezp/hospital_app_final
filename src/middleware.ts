// src/middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Por ahora, solo dejamos pasar la solicitud.
  // La protección real se hará en el componente de la página protegida.
  // console.log('Middleware running for:', request.nextUrl.pathname);
  return NextResponse.next();
}

// Configuración del Matcher (IMPORTANTE)
export const config = {
  matcher: [
    /*
     * Coincide con todas las rutas de solicitud excepto las que comienzan con:
     * - api (rutas API)
     * - _next/static (archivos estáticos)
     * - _next/image (archivos de optimización de imágenes)
     * - favicon.ico (archivo favicon)
     * - icons/ (carpeta de iconos PWA en public)
     * - images/ (carpeta de imágenes generales en public)
     * - sw.js (Service Worker)
     * - manifest.json (PWA Manifest)
     * - /login (Página de login) - Evita bucles de redirección
     * - /register (Página de registro) - Evita bucles de redirección
     *
     * Agrega otras rutas públicas o de assets si es necesario.
     */
    '/((?!api|_next/static|_next/image|favicon.ico|icons/|images/|sw.js|manifest.json|login|register).*)',
  ],
};