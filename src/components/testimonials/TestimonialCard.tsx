// src/components/testimonials/TestimonialCard.tsx
import React from 'react';
import type { TestimonialDocument } from '@/types/testimonial';
import { Star, UserCircle } from 'lucide-react'; // Iconos

interface TestimonialCardProps {
    testimonial: TestimonialDocument; // Usa el tipo base por ahora
}

// Componente simple para mostrar estrellas de rating
const RatingStars = ({ rating }: { rating?: number }) => {
    if (typeof rating !== 'number' || rating < 1 || rating > 5) return null;
    return (
        <div className="flex text-yellow-400">
            {Array.from({ length: 5 }, (_, i) => (
                <Star key={i} size={16} fill={i < rating ? 'currentColor' : 'none'} />
            ))}
        </div>
    );
};


const TestimonialCard: React.FC<TestimonialCardProps> = ({ testimonial }) => {
    return (
        <div className="border border-[var(--border-primary)] rounded-lg shadow-sm bg-[var(--bg-primary)] p-6 flex flex-col">
             {/* Rating (Opcional) */}
            {testimonial.rating && (
                <div className="mb-2">
                    <RatingStars rating={testimonial.rating} />
                </div>
            )}

            {/* Cita */}
            <blockquote className="text-[var(--text-secondary)] italic flex-grow mb-4">
                <p className="!mb-0 before:content-['\201C'] after:content-['\201D']"> {/* Comillas estilizadas */}
                    {testimonial.quote}
                </p>
            </blockquote>


            {/* Nombre del Paciente */}
            <div className="flex items-center mt-auto pt-3 border-t border-[var(--border-secondary)]">
                 <UserCircle size={24} className="text-[var(--text-subtle)] mr-2" />
                 <p className="font-semibold text-sm text-[var(--text-primary)] !mb-0"> {/* Quita margen inferior */}
                    {testimonial.patientName}
                </p>
                 {/* Opcional: Mostrar fecha? */}
                 {/* <p className="text-xs text-[var(--text-subtle)] ml-auto !mb-0">{testimonial.dateReceived}</p> */}
            </div>
        </div>
    );
};

export default TestimonialCard;