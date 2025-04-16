// src/app/layout.tsx
import React from 'react';
import type { Metadata, Viewport } from 'next'; // Importa Viewport
import './globals.css';
import { Inter, Source_Serif_4 } from 'next/font/google';
import ServiceWorkerRegistrar from '@/components/common/ServiceWorkerRegistrar'; // Importa el registrador
const inter = Inter({
    subsets: ['latin'],
    variable: '--font-sans',
    display: 'swap',
    weight: ['300', '400', '500', '600', '700', '800'],
});

const sourceSerif = Source_Serif_4({
    subsets: ['latin'],
    variable: '--font-serif',
    display: 'swap',
    weight: 'variable',
    style: ['normal'],
    axes: ['opsz'],
});

// src/app/layout.tsx
// ... (importaciones) ...

export const metadata: Metadata = {
  // ... (title, description) ...
  manifest: '/manifest.json', // <-- Asegúrate que esta línea exista
  icons: {
      apple: '/icons/apple-touch-icon.png', // Enlace para icono de iOS
      // Puedes añadir otros tamaños aquí si quieres
  },
  // ...
};

// ... (viewport y resto del layout) ...

// --- NUEVA EXPORTACIÓN Viewport ---
export const viewport: Viewport = {
  themeColor: [
    { media: '(prefers-color-scheme: light)', color: '#ffffff' },
    { media: '(prefers-color-scheme: dark)', color: '#020617' },
  ],
  width: 'device-width',
  initialScale: 1,
  // puedes añadir más opciones de viewport aquí si las necesitas
};
// --- FIN Viewport ---

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={`${inter.variable} ${sourceSerif.variable}`}>
      <body>
        <a href="#main-content" className="skip-link">Skip to main content</a>
        {children}
        {/* Registra el Service Worker */}
        <ServiceWorkerRegistrar />
      </body>
    </html>
  );
}