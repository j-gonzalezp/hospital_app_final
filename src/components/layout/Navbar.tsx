// src/components/layout/Navbar.tsx
'use client'; // Necesario por el hook useAuth y useState

import React, { useState } from 'react';
import Link from 'next/link';
import { Menu, X } from 'lucide-react';
import Button from '@/components/common/Button';
import useAuth from '@/hooks/useAuth'; // Importa el hook de autenticación
import LoadingSpinner from '../common/LoadingSpinner'; // Para indicar carga inicial

const Navbar: React.FC = () => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { user, isLoading, logout } = useAuth(); // Usa el hook

  const navLinks = [
    { href: '/', label: 'Home' },
    { href: '/doctors', label: 'Find a Doctor' },
    { href: '/services', label: 'Services' },
    { href: '/locations', label: 'Locations' },
    { href: '/resources', label: 'Health Resources' },
    { href: '/about', label: 'About Us' },
    { href: '/contact', label: 'Contact' },
  ];

  const handleLogout = async () => {
    setIsMobileMenuOpen(false); // Cierra el menú móvil si está abierto
    await logout(); // Llama a la función logout del hook
  };

  return (
    <nav className="bg-white shadow-md sticky top-0 z-40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <div className="flex-shrink-0">
            <Link href="/" className="text-2xl font-bold text-blue-600">
              Modern Hospital
            </Link>
          </div>

          {/* Links de Navegación Desktop */}
          <div className="hidden md:flex md:items-center md:space-x-6">
            {navLinks.map((link) => (
              <Link key={link.href} href={link.href} className="text-gray-600 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                  {link.label}
              </Link>
            ))}
             {/* Auth Links Desktop */}
             <div className="ml-4 flex items-center space-x-2">
                {isLoading ? (
                    <LoadingSpinner size="sm" /> // Muestra spinner mientras carga el estado auth
                ) : user ? (
                 <>
                    <Link href="/appointments" className="text-gray-600 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        My Appointments
                    </Link>
                    {/* Añade un saludo si quieres */}
                    {/* <span className='text-sm text-gray-500'>Hi, {user.name}!</span> */}
                    <Button onClick={handleLogout} variant="secondary" size="sm">Logout</Button>
                 </>
               ) : (
                  <>
                     <Link href="/login" passHref legacyBehavior>
                         <a><Button variant="ghost" size="sm">Login</Button></a>
                     </Link>
                     <Link href="/register" passHref legacyBehavior>
                         <a><Button variant="primary" size="sm">Register</Button></a>
                     </Link>
                  </>
               )}
              </div>
          </div>

          {/* Botón Menú Móvil y Auth Móvil Simplificado */}
          <div className="md:hidden flex items-center">
             {/* Mostrar login/register o estado de carga en móvil */}
             {!isMobileMenuOpen && (
                 isLoading ? (
                     <LoadingSpinner size="sm" />
                 ) : !user && (
                     <Link href="/login" passHref legacyBehavior>
                         <a><Button variant="primary" size="sm">Login</Button></a>
                     </Link>
                 )
             )}
            <button
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              className="ml-2 inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-blue-500"
              aria-expanded={isMobileMenuOpen}
            >
              <span className="sr-only">Open main menu</span>
              {isMobileMenuOpen ? <X className="block h-6 w-6" aria-hidden="true" /> : <Menu className="block h-6 w-6" aria-hidden="true" />}
            </button>
          </div>
        </div>
      </div>

      {/* Panel Menú Móvil */}
      {isMobileMenuOpen && (
        <div className="md:hidden absolute top-16 inset-x-0 bg-white shadow-lg z-30">
          <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
            {navLinks.map((link) => (
              <Link key={link.href} href={link.href} className="text-gray-600 hover:bg-gray-50 hover:text-blue-600 block px-3 py-2 rounded-md text-base font-medium transition-colors" onClick={() => setIsMobileMenuOpen(false)}>
                  {link.label}
              </Link>
            ))}
          </div>
           {/* Auth Links Móvil */}
           <div className="pt-4 pb-3 border-t border-gray-200 px-5">
                {isLoading ? (
                     <div className="flex justify-center"><LoadingSpinner size="sm" /></div>
                ) : user ? (
                    <div className="space-y-1">
                         <Link href="/appointments" className="block px-3 py-2 rounded-md text-base font-medium text-gray-600 hover:text-blue-600 hover:bg-gray-50" onClick={() => setIsMobileMenuOpen(false)}>
                             My Appointments
                         </Link>
                         {/* <p className="px-3 py-2 text-sm text-gray-500">Logged in as {user.name}</p> */}
                        <button onClick={handleLogout} className="w-full text-left block px-3 py-2 rounded-md text-base font-medium text-gray-600 hover:text-blue-600 hover:bg-gray-50">
                             Logout
                        </button>
                    </div>
                ) : (
                    <div className="space-y-2">
                         <Link href="/login" passHref legacyBehavior>
                              <a><Button variant="ghost" fullWidth onClick={() => setIsMobileMenuOpen(false)}>Login</Button></a>
                         </Link>
                         <Link href="/register" passHref legacyBehavior>
                             <a><Button variant="primary" fullWidth onClick={() => setIsMobileMenuOpen(false)}>Register</Button></a>
                         </Link>
                     </div>
                )}
            </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;