// src/types/article.d.ts
import { Models } from 'appwrite';

// Basado en la colección 'articles'
export interface ArticleDocument extends Models.Document {
    title: string;
    slug: string; // URL amigable
    content: string; // Contenido principal (Markdown/HTML)
    excerpt?: string; // Resumen corto
    authorDoctorId?: string; // ID del doctor autor (opcional)
    publishDate: string; // ISO DateTime string
    category?: string;
    tags?: string[];
    featuredImageId?: string; // ID de la imagen en Storage
    status: 'draft' | 'published';
    // Añade otros campos si los tienes
}

// Tipo extendido para usar en el frontend
export interface ArticleWithDetails extends ArticleDocument {
    authorName?: string; // Nombre del doctor autor (si se obtiene)
    featuredImageUrl?: string | null; // URL de la imagen desde Storage (si se obtiene)
}