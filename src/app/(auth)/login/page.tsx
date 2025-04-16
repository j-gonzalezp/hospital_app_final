// src/app/(auth)/login/page.tsx
'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation'; // Importa useRouter para redirección
import LoginForm from '@/components/auth/LoginForm';
import ErrorMessage from '@/components/common/ErrorMessage';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import { account } from '@/lib/appwrite'; // Importa la instancia de account
import { AppwriteException } from 'appwrite'; // Importa para manejo de errores específico

export default function LoginPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter(); // Hook para manejar la navegación

  const handleLogin = async (credentials: { email: string; password: string }) => {
    setIsLoading(true);
    setError(null);
    try {
      // Llama a la función de Appwrite para crear una sesión
      await account.createEmailPasswordSession(credentials.email, credentials.password);
      console.log('Login successful!');
      // Redirige al dashboard o página principal después del login
      // Usar replace para no añadir la página de login al historial
      router.replace('/appointments'); // O redirige a '/' o '/dashboard'
    } catch (e) {
      console.error('Login failed:', e);
      const appwriteError = e as AppwriteException;
      setError(appwriteError.message || 'An unexpected error occurred during login.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="container mx-auto px-4 py-12 max-w-md">
      {/* Muestra el spinner encima o cerca del formulario si está cargando */}
      {isLoading && (
        <div className="flex justify-center mb-4">
          <LoadingSpinner />
        </div>
      )}
      {/* Muestra el mensaje de error encima del formulario */}
      {error && <ErrorMessage message={error} className="mb-4" />}

      <LoginForm
        onLogin={handleLogin}
        loading={isLoading} // Pasa el estado de carga al componente del formulario
        // El componente LoginForm ahora puede deshabilitar el botón si loading es true
        // error={error} // Podrías pasar el error también si el LoginForm lo maneja internamente
      />
    </div>
  );
}
