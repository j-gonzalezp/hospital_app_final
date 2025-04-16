// src/types/testimonial.d.ts
import { Models } from 'appwrite';

export interface TestimonialDocument extends Models.Document {
    patientName: string;
    quote: string;
    rating?: number; // 1-5
    dateReceived?: string; // ISO Date String
    relatedDoctorId?: string;
    relatedServiceId?: string;
    isApproved: boolean; // Importante para filtrar
}