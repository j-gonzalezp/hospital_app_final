// src/components/auth/RegisterForm.tsx
'use client';

import React, { useState } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import Link from 'next/link';

interface RegisterFormProps {
    // Define a specific type for registration data
    onRegister: (userData: { name: string; email: string; password: string }) => void;
    loading?: boolean;
    error?: string | null; // Error proveniente de la página padre (ej: email ya existe)
}

const RegisterForm: React.FC<RegisterFormProps> = ({ onRegister, loading, error }) => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  // --- AÑADE ESTADO PARA ERROR LOCAL ---
  const [localError, setLocalError] = useState<string | null>(null);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setLocalError(null); // Limpia errores locales previos

    // --- ¡VALIDACIÓN AQUÍ DENTRO! ---
    if (password !== confirmPassword) {
      setLocalError('Passwords do not match!'); // Muestra el error inmediatamente
      return; // Detiene el envío
    }
    // --- FIN VALIDACIÓN ---

    // Llama a la función de la página padre con los datos necesarios
    // No necesitas pasar confirmPassword si la validación ya se hizo aquí
    onRegister({ name, email, password });
  };

  return (
    // Añade onSubmit al form tag
    <form onSubmit={handleSubmit} className="space-y-4 max-w-md mx-auto p-6 border rounded-lg shadow-sm bg-white">
       <h2 className="text-2xl font-semibold text-center mb-6 text-gray-800">Register</h2>

       {/* Muestra error LOCAL (coincidencia de contraseña) */}
       {localError && <p className="text-red-500 text-sm text-center mb-2">{localError}</p>}
       {/* Muestra error de la PÁGINA PADRE (ej: Appwrite) */}
       {error && <p className="text-red-500 text-sm text-center">{error}</p>}

      <Input
        label="Full Name"
        type="text"
        id="register-name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        required
        autoComplete="name"
        // Añade aria-invalid si hay error para accesibilidad
        aria-invalid={!!error || !!localError}
      />
      <Input
        label="Email"
        type="email"
        id="register-email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        autoComplete="email"
        aria-invalid={!!error || !!localError}
      />
      <Input
        label="Password"
        type="password"
        id="register-password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
        minLength={8} // Appwrite default minimum
        autoComplete="new-password"
        aria-invalid={!!error || !!localError}
      />
       <Input
        label="Confirm Password"
        type="password"
        id="register-confirm-password"
        value={confirmPassword}
        onChange={(e) => setConfirmPassword(e.target.value)}
        required
         minLength={8}
        autoComplete="new-password"
         // Marca este campo como inválido si las contraseñas no coinciden
        aria-invalid={!!localError}
      />
      <Button type="submit" variant="primary" fullWidth disabled={loading}>
        {loading ? 'Registering...' : 'Register'}
      </Button>
       <p className="text-sm text-center text-gray-600">
        Already have an account?{' '}
        <Link href="/login" className="text-blue-600 hover:underline">
          Login here
        </Link>
      </p>
    </form>
  );
};

export default RegisterForm;
