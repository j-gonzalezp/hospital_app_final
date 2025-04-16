'use client'; // Probablemente necesario si tiene estado o interacción

import React from 'react';
import Link from 'next/link';
// Importa iconos si los usas (ej. lucide-react)

interface SidebarProps {
  // Props para controlar visibilidad en móvil, etc.
}

const Sidebar: React.FC<SidebarProps> = () => {
  // Lógica para estado (abierto/cerrado en móvil), usuario actual, etc.
  const dashboardLinks = [
    { href: '/appointments', label: 'My Appointments' /* icon: CalendarIcon */ },
    { href: '/profile', label: 'My Profile' /* icon: UserIcon */ },
    { href: '/medical-records', label: 'Medical Records' /* icon: FileTextIcon */ }, // Ejemplo
    // Añade más links según sea necesario
  ];

  return (
    <aside className="w-64 bg-gray-50 p-4 border-r h-full hidden md:block"> {/* Oculto en móvil por defecto */}
      <nav>
        <h3 className="text-xs font-semibold uppercase text-gray-500 mb-2">Dashboard</h3>
        <ul className="space-y-1">
          {dashboardLinks.map((link) => (
            <li key={link.href}>
              <Link href={link.href} className="flex items-center px-3 py-2 text-sm font-medium rounded-md text-gray-700 hover:bg-gray-200 hover:text-gray-900 transition-colors">
                  {/* {link.icon && <link.icon className="h-5 w-5 mr-2" />} */}
                  {link.label}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
       {/* Puedes añadir otras secciones al sidebar */}
    </aside>
  );
};

export default Sidebar;
