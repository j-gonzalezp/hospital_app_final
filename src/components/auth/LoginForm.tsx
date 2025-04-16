'use client';

import React, { useState } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import Link from 'next/link';

interface LoginFormProps {
    // Define a specific type for login credentials
    onLogin: (credentials: { email: string; password: string }) => void;
    loading?: boolean;
    error?: string | null;
}

const LoginForm: React.FC<LoginFormProps> = ({ onLogin, loading, error }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onLogin({ email, password });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 max-w-md mx-auto p-6 border rounded-lg shadow-sm">
       <h2 className="text-2xl font-semibold text-center mb-6">Login</h2>
      {error && <p className="text-red-500 text-sm text-center">{error}</p>}
      <Input
        label="Email"
        type="email"
        id="login-email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        autoComplete="email"
      />
      <Input
        label="Password"
        type="password"
        id="login-password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
        autoComplete="current-password"
      />
      <Button type="submit" variant="primary" fullWidth disabled={loading}>
        {loading ? 'Logging in...' : 'Login'}
      </Button>
       <p className="text-sm text-center text-gray-600">
        Don&apos;t have an account?{' '}
        <Link href="/register" className="text-blue-600 hover:underline">
          Register here
        </Link>
      </p>
    </form>
  );
};

export default LoginForm;
