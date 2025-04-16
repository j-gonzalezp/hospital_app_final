// src/types/appointment.d.ts
import { Models } from 'appwrite'; // Importa tipos base de Appwrite

// Interfaz básica basada en tu colección 'appointments' de Appwrite
export interface AppointmentDocument extends Models.Document {
    patientId: string;
    doctorId: string;
    availabilitySlotId: string;
    reason?: string;
    notes?: string;
    status: 'scheduled' | 'completed' | 'cancelled' | 'no-show';
    cancellationReason?: string;
    bookedAt: string; // ISO DateTime string
    // Añade aquí cualquier otro campo que tengas en la colección 'appointments'
}

// Interfaz extendida para usar en el frontend, incluyendo datos relacionados
export interface AppointmentWithDetails extends AppointmentDocument {
    doctorName?: string; // Nombre del doctor (obtenido por separado o denormalizado)
    slotStartTime?: string; // Hora de inicio del slot (obtenida por separado o denormalizada)
    slotEndTime?: string; // Hora de fin del slot (obtenida por separado o denormalizada)
}