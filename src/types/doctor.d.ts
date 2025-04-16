
// src/types/doctor.d.ts
import { Models } from 'appwrite';

// Basado en la colección 'doctors' de Appwrite
export interface DoctorDocument extends Models.Document {
    name: string;
    specialtyId: string; // ID de la especialidad
    qualifications: string;
    bio?: string;
    yearsExperience?: number;
    profilePictureId?: string; // ID del archivo en Appwrite Storage
    languages?: string[];
    isActive: boolean;
    // Añade otros campos
}

// Tipo extendido para usar en el frontend
export interface DoctorWithDetails extends DoctorDocument {
    specialtyName?: string; // Nombre de la especialidad (añadido)
    profilePictureUrl?: string | null; // URL de la imagen (añadido)
}
