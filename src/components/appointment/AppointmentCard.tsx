import React from 'react';
// --- USA 'import type' AQUÍ ---
import type { AppointmentWithDetails } from '@/types/appointment.d.ts';
import Button from '@/components/common/Button';
import { Calendar, Clock, User } from 'lucide-react';

interface AppointmentCardProps {
  appointment: AppointmentWithDetails;
  onCancelClick: (appointment: AppointmentWithDetails) => void;
}
const AppointmentCard: React.FC<AppointmentCardProps> = ({ appointment, onCancelClick }) => {

   // Función simple para formatear fechas (puedes usar librerías como date-fns)
   const formatDate = (dateString: string | undefined) => {
       if (!dateString) return 'N/A';
       try {
           return new Date(dateString).toLocaleDateString(undefined, {
               year: 'numeric', month: 'long', day: 'numeric'
           });
       } catch { return 'Invalid Date'; }
   };

    const formatTime = (timeString: string | undefined) => {
       if (!timeString) return 'N/A';
        try {
           return new Date(timeString).toLocaleTimeString(undefined, {
               hour: '2-digit', minute: '2-digit', hour12: true
           });
       } catch { return 'Invalid Time'; }
   };

   // Determinar el color del estado
   const statusColors = {
       scheduled: 'bg-blue-100 text-blue-800',
       completed: 'bg-green-100 text-green-800',
       cancelled: 'bg-red-100 text-red-800',
       'no-show': 'bg-yellow-100 text-yellow-800',
   };
   const statusColor = statusColors[appointment.status] || 'bg-gray-100 text-gray-800';


  return (
    <div className="border border-gray-200 p-4 rounded-lg shadow-sm mb-4 bg-white">
      <div className="flex justify-between items-start mb-3">
        <h3 className="text-lg font-semibold text-gray-800">Appointment Details</h3>
         <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${statusColor}`}>
            {appointment.status.charAt(0).toUpperCase() + appointment.status.slice(1)}
        </span>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-2 text-sm text-gray-600">
         <div className="flex items-center space-x-2">
             <User size={16} className='text-gray-400'/>
             <span><strong>Doctor:</strong> {appointment.doctorName || 'N/A'}</span>
         </div>
         <div className="flex items-center space-x-2">
              <Calendar size={16} className='text-gray-400'/>
             {/* Idealmente, mostrar la fecha de la cita (slotStartTime) */}
             <span><strong>Date:</strong> {formatDate(appointment.slotStartTime || appointment.bookedAt)}</span>
         </div>
          <div className="flex items-center space-x-2">
              <Clock size={16} className='text-gray-400'/>
             {/* Idealmente, mostrar la hora de la cita (slotStartTime) */}
             <span><strong>Time:</strong> {formatTime(appointment.slotStartTime || appointment.bookedAt)}</span>
         </div>
          {appointment.reason && (
              <div className="flex items-center space-x-2 sm:col-span-2">
                  {/* Puedes usar otro icono si quieres */}
                  <span><strong>Reason:</strong> {appointment.reason}</span>
              </div>
          )}
      </div>


      {/* Acciones (ej. botón de cancelar) */}
      {appointment.status === 'scheduled' && ( // Solo muestra cancelar si está programada
        <div className="mt-4 pt-3 border-t border-gray-100 text-right">
            <Button
                onClick={() => onCancelClick(appointment)} // Llama a la función pasada como prop
                variant="danger"
                size="sm"
            >
                Cancel Appointment
            </Button>
        </div>
      )}
    </div>
  );
};

export default AppointmentCard;