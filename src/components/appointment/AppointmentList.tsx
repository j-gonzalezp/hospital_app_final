// src/components/appointment/AppointmentList.tsx
import React from 'react';
import AppointmentCard from './AppointmentCard';
// --- USA 'import type' AQUÍ ---
import type { AppointmentWithDetails } from '@/types/appointment.d.ts';

interface AppointmentListProps {
  appointments: AppointmentWithDetails[];
  onCancelClick: (appointment: AppointmentWithDetails) => void;
}

const AppointmentList: React.FC<AppointmentListProps> = ({ appointments, onCancelClick }) => {
  if (!appointments || appointments.length === 0) {
    // El mensaje de 'no appointments' se maneja mejor en la página padre
    return null;
  }

  return (
    <div className="space-y-4">
      {appointments.map((app) => (
        <AppointmentCard
            key={app.$id} // Usa el ID real de Appwrite
            appointment={app}
            onCancelClick={onCancelClick} // Pasa la función al Card
        />
      ))}
    </div>
  );
};

export default AppointmentList;