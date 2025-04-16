
// src/types/specialty.d.ts
import { Models } from 'appwrite';

export interface SpecialtyDocument extends Models.Document {
    name: string;
    description: string;
    iconUrl?: string; // URL a icono
    // Añade otros campos si los tienes
}
