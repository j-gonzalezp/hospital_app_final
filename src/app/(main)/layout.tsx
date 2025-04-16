// src/app/(main)/layout.tsx
import React from 'react';
import Navbar from '@/components/layout/Navbar'; // Ajusta la ruta si es necesario
import Footer from '@/components/layout/Footer'; // Ajusta la ruta si es necesario

export default function MainLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      {/* Añade el ID al main tag */}
      <main id="main-content" className="flex-grow container mx-auto px-4 py-6 md:py-8">
        {children}
      </main>
      <Footer />
    </div>
  );
}