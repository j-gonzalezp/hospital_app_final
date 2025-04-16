// src/components/appointment/SlotSelector.tsx
'use client';

import React from 'react';

interface Slot { // Define una interfaz clara para los slots que recibe este componente
  id: string;
  time: string; // La hora ya formateada
  status: 'available' | 'booked' | 'unavailable';
}

interface SlotSelectorProps {
  slots: Slot[]; // Usa la interfaz Slot
  selectedSlot: string | null;
  onSlotSelect: (slotId: string) => void;
}

const SlotSelector: React.FC<SlotSelectorProps> = ({ slots, selectedSlot, onSlotSelect }) => {
  // Manejo del caso sin slots (antes del return)
  if (!slots || slots.length === 0) {
    // No se muestra nada aquí, la página que lo usa decide mostrar "No slots available..."
    // Basado en la longitud del array `availableSlots` que pasa como prop.
    return null;
  }

  // Asegúrate que el return JSX esté correctamente estructurado
  return (
    <div className="space-y-2">
      <h4 className="font-medium text-sm text-[var(--text-secondary)] mb-1">Available Times:</h4>
      <div className="flex flex-wrap gap-2">
        {slots.map((slot) => (
          <button
            key={slot.id} // Clave única
            onClick={() => onSlotSelect(slot.id)} // Llama a la función al hacer clic
            disabled={slot.status !== 'available'} // Deshabilita si no está disponible
            className={`px-3 py-1.5 border rounded-md text-sm transition-colors duration-150 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-[var(--ring-color)] focus-visible:ring-offset-[var(--bg-primary)]
              ${selectedSlot === slot.id
                ? 'bg-[var(--bg-accent)] text-[var(--text-on-accent)] border-transparent shadow-sm' // Estilo seleccionado
                : 'bg-white dark:bg-slate-800 border-[var(--border-primary)] text-[var(--text-secondary)] dark:text-slate-300' // Estilo normal
              }
              ${slot.status === 'available'
                ? 'hover:bg-blue-50 dark:hover:bg-slate-700 cursor-pointer' // Estilo hover si disponible
                : 'opacity-50 cursor-not-allowed bg-gray-100 dark:bg-slate-700' // Estilo deshabilitado
              }
            `}
          >
            {slot.time} {/* Muestra la hora formateada */}
          </button>
        ))}
      </div>
    </div>
  ); // Asegúrate que el paréntesis de cierre del return esté aquí
}; // Asegúrate que el punto y coma de cierre esté aquí

export default SlotSelector;