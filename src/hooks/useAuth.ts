// src/hooks/useAuth.ts
'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { account } from '@/lib/appwrite';
import { Models, AppwriteException } from 'appwrite'; // Importa AppwriteException

export interface AuthState {
  user: Models.User<Models.Preferences> | null;
  isLoading: boolean;
  error: string | null;
  logout: () => Promise<void>;
}

const useAuth = (): AuthState => {
  const [user, setUser] = useState<Models.User<Models.Preferences> | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true); // Inicializa como true
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  // useCallback para evitar re-creación innecesaria
  const checkSession = useCallback(async () => {
    // --- Asegúrate que isLoading se ponga a true al INICIO de la verificación ---
    // Esto es importante si checkSession se llamara manualmente más tarde
    // aunque con el useEffect actual, ya está true inicialmente.
    // setIsLoading(true); // Puedes añadirlo por robustez, pero ya está true al inicio.
    setError(null); // Limpia errores previos
    console.log('useAuth: checkSession - Verifying session...'); // Log inicio

    try {
      const currentUser = await account.get();
      console.log('useAuth: checkSession - Session found, user:', currentUser.$id); // Log éxito
      setUser(currentUser);
    } catch (err) {
      // Error esperado si no hay sesión
      console.log('useAuth: checkSession - No active session or error fetching.', err instanceof AppwriteException ? err.message : err); // Log error/no sesión
      setUser(null);
      // No establecer error aquí a menos que sea un error inesperado del servidor
      // if (err instanceof AppwriteException && err.code !== 401) { // 401 es "Unauthorized", esperado si no hay sesión
      //   setError("Failed to check session state.");
      // }
    } finally {
      // --- ¡ASEGÚRATE QUE ESTO SIEMPRE SE EJECUTE! ---
      console.log('useAuth: checkSession - Setting isLoading to false.'); // Log finalización
      setIsLoading(false);
      // --- FIN ---
    }
  }, []); // Dependencias vacías, solo se crea una vez

  // Ejecuta checkSession al montar el componente
  useEffect(() => {
    checkSession();
  }, [checkSession]); // La dependencia es estable

  // Logout (sin cambios necesarios aquí, asumiendo que funciona)
  const logout = useCallback(async () => {
    // ... (código de logout) ...
     setIsLoading(true);
        try {
          await account.deleteSession('current');
          setUser(null);
          console.log('Logout successful');
          router.push('/');
        } catch (e) {
          console.error('Logout failed:', e);
          setError('Failed to logout.');
        } finally {
           setIsLoading(false); // Asegúrate que también se ponga a false aquí
        }
  }, [router]);

  // Log antes de devolver el estado (útil para depurar qué devuelve el hook)
  // console.log('useAuth Hook Returning:', { user: user?.$id, isLoading, error: error ? 'Yes' : 'No' });

  return { user, isLoading, error, logout };
};

export default useAuth;