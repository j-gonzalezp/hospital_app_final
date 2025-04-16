// src/app/(auth)/register/page.tsx
'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import RegisterForm from '@/components/auth/RegisterForm';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import { account, ID } from '@/lib/appwrite';
import { AppwriteException } from 'appwrite';
import Alert from '@/components/common/Alert';

export default function RegisterPage() {
  const [isLoading, setIsLoading] = useState(false);
  // Este error ahora será principalmente para errores del backend (Appwrite)
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const router = useRouter();

  // userData ahora solo contendrá { name, email, password } porque el form ya validó
  const handleRegister = async (userData: { name: string; email: string; password: string }) => {
    setIsLoading(true);
    setError(null); // Limpia errores de Appwrite previos
    setSuccessMessage(null);

    // --- VALIDACIÓN DE CONTRASEÑA REMOVIDA DE AQUÍ ---
    // if (userData.password !== userData.confirmPassword) { ... } // Ya no es necesario

    try {
      // Llama a Appwrite
      await account.create(
        ID.unique(),
        userData.email,
        userData.password,
        userData.name
      );
      console.log('Registration successful!');
      setSuccessMessage('Registration successful! Please log in.');

      setTimeout(() => {
         router.push('/login');
      }, 2000);

    } catch (e) {
      console.error('Registration failed:', e);
       const appwriteError = e as AppwriteException;
       if (appwriteError.code === 409) {
           setError('An account with this email already exists.');
       } else if (appwriteError.code === 400) {
            setError(appwriteError.message || 'Password might be too weak or email format invalid.');
       }
        else {
           setError(appwriteError.message || 'An unexpected error occurred during registration.');
       }
    } finally {
      setIsLoading(false);
    }
  };

  return (
     <div className="container mx-auto px-4 py-12 max-w-md">
      {isLoading && (
        <div className="flex justify-center mb-4">
          <LoadingSpinner />
        </div>
      )}
      {/* El error mostrado aquí viene de Appwrite, el de coincidencia se muestra dentro del form */}
      {/* {error && <ErrorMessage message={error} className="mb-4" />} */}
      {successMessage && <Alert message={successMessage} type="success" className="mb-4" />}

      <RegisterForm
        onRegister={handleRegister}
        loading={isLoading}
        error={error} // Pasa el error de Appwrite al formulario para que lo muestre
      />
    </div>
  );
}
