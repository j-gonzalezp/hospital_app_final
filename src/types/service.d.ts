// src/types/service.d.ts
import { Models } from 'appwrite';

// Basado en la colección 'services'
export interface ServiceDocument extends Models.Document {
    name: string;
    description: string;
    specialtyId?: string; // ID de la especialidad (opcional)
    costEstimate?: string;
    durationMinutes?: number;
    imageUrl?: string; // Aquí podría ir el ID de la imagen en Storage
    // slug?: string; // Si prefieres usar slugs para las URLs
    // Añade otros campos si los tienes
}

// Tipo extendido para el frontend
export interface ServiceWithDetails extends ServiceDocument {
    specialtyName?: string; // Nombre de la especialidad (si se obtiene)
    imageDisplayUrl?: string | null; // URL de la imagen desde Storage (si se obtiene)
}