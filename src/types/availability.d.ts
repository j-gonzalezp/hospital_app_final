// src/types/availability.d.ts
import { Models } from 'appwrite';

export interface AvailabilitySlotDocument extends Models.Document {
    doctorId: string;
    startTime: string; // ISO DateTime string
    endTime: string;   // ISO DateTime string
    status: 'available' | 'booked' | 'unavailable';
    appointmentId?: string | null; // ID de la cita si está 'booked'
}