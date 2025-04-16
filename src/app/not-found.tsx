// src/app/not-found.tsx
import React from 'react';
import Link from 'next/link';
import Button from '@/components/common/Button'; // Asegúrate que la ruta al componente Button sea correcta

export default function NotFound() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen text-center px-4 bg-gray-50"> {/* Fondo ligero opcional */}
      {/* Puedes añadir un ícono o imagen aquí si quieres */}
      {/* <SomeNotFoundIcon className="w-16 h-16 text-blue-500 mb-6" /> */}

      <h1 className="text-6xl font-bold text-blue-600 mb-4 drop-shadow-md"> {/* Sombra opcional */}
        404
      </h1>
      <h2 className="text-3xl font-semibold text-gray-800 mb-3">
        Page Not Found
      </h2>
      <p className="text-gray-600 mb-8 max-w-md"> {/* Ancho máximo para mejor lectura */}
        Oops! The page you are looking for doesn&apos;t seem to exist. It might have been moved, deleted, or you might have mistyped the URL.
      </p>
      <Link href="/" passHref legacyBehavior>
        <a>
          <Button variant="primary" size="lg"> {/* Botón un poco más grande */}
            Go Back Home
          </Button>
        </a>
      </Link>
    </div>
  );
}
