// src/types/location.d.ts
import { Models } from 'appwrite';

// Basado en la colección 'locations'
export interface LocationDocument extends Models.Document {
    name: string;
    address: string;
    phoneNumber?: string; // Tipo Phone en Appwrite es string
    latitude?: number;
    longitude?: number;
    operatingHours?: string; // Texto descriptivo
    mapUrl?: string; // URL (String)
    // Añade un campo 'isActive' si quieres poder ocultar ubicaciones
    // isActive?: boolean;
    // Añade otros campos si los tienes
}

// No necesitamos un tipo 'WithDetails' por ahora, a menos que enlacemos otros datos.