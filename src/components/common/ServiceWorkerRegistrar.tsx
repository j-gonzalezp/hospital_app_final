// src/components/common/ServiceWorkerRegistrar.tsx
'use client';

import { useEffect } from 'react';

const ServiceWorkerRegistrar = () => {
  useEffect(() => {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker
        .register('/sw.js') // Asegúrate que la ruta a tu SW sea correcta
        .then((registration) => {
          console.log('Service Worker registered with scope:', registration.scope);
        })
        .catch((error) => {
          console.error('Service Worker registration failed:', error);
        });
    }
  }, []); // Ejecuta solo una vez al montar

  return null; // Este componente no renderiza nada visible
};

export default ServiceWorkerRegistrar;